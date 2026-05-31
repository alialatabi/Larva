-- 008 — Canonical schema: larva_partners + larva_admin
--
-- Part 4 of 4. Depends on 005–007. Additive & idempotent.
-- Partner Program (real-money payouts, 20% platform cut, isolated from the game
-- economy) and the admin/observability layer (cycle tracking, config, economy
-- metrics, audit log).

-- ════════════════════════════════════════════════════════════════════════════
-- larva_partners
-- ════════════════════════════════════════════════════════════════════════════

-- Tier definitions (reference) — gross amounts; net = gross × 0.80 -------------
create table if not exists larva_partners.partner_tiers (
  id              text primary key,   -- slug
  name            text not null,
  rank            integer not null,
  requirements    text not null,
  gross_payout    integer not null,   -- USD/month
  net_payout      integer not null,   -- after 20% platform cut
  invite_only     boolean not null default false,
  max_active      integer             -- hard cap (Legend = 5)
);
alter table larva_partners.partner_tiers enable row level security;
drop policy if exists "partner_tiers_read_all" on larva_partners.partner_tiers;
create policy "partner_tiers_read_all" on larva_partners.partner_tiers for select using (true);

-- Partner enrollment + live qualification metrics -----------------------------
create table if not exists larva_partners.partners (
  id                 uuid primary key default gen_random_uuid(),
  user_id            uuid not null unique references auth.users(id) on delete cascade,
  tier_id            text references larva_partners.partner_tiers(id),
  status             text not null default 'applied' check (status in
                       ('applied','kyc_pending','active','suspended','revoked')),
  kyc_verified       boolean not null default false,
  active_companies   integer not null default 0,
  listed_companies   integer not null default 0,
  revenue_30d        bigint not null default 0,    -- circular txns discounted 50%
  empire_market_cap  bigint not null default 0,
  flagged_for_review boolean not null default false,
  approved_cycle     integer,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now()
);

-- Monthly payouts (audited before execution) ----------------------------------
create table if not exists larva_partners.partner_payouts (
  id            uuid primary key default gen_random_uuid(),
  partner_id    uuid not null references larva_partners.partners(id) on delete cascade,
  tier_id       text references larva_partners.partner_tiers(id),
  gross_amount  integer not null,
  platform_cut  integer not null,    -- 20%
  net_amount    integer not null,    -- 80% to partner
  period        text not null,       -- e.g. '2026-05'
  status        text not null default 'pending' check (status in ('pending','approved','paid','rejected')),
  stripe_payout_id text,
  created_at    timestamptz not null default now()
);
create index if not exists payouts_partner_idx on larva_partners.partner_payouts (partner_id, period);

-- Real-money platform inflows that fund the payout wallet ----------------------
create table if not exists larva_partners.platform_revenue_log (
  id            uuid primary key default gen_random_uuid(),
  source        text not null check (source in ('subscription','cosmetic','transfer_fee','marketing')),
  amount_usd    numeric not null,
  reference     text,                -- Stripe payment id, etc.
  user_id       uuid references auth.users(id) on delete set null,
  created_at    timestamptz not null default now()
);
create index if not exists platform_rev_source_idx on larva_partners.platform_revenue_log (source, created_at desc);

-- ════════════════════════════════════════════════════════════════════════════
-- larva_admin — system config, cycle engine state, metrics, audit
-- ════════════════════════════════════════════════════════════════════════════

-- Key/value system configuration ----------------------------------------------
create table if not exists larva_admin.system_config (
  key         text primary key,
  value       jsonb not null,
  description text not null default '',
  updated_at  timestamptz not null default now()
);

-- The economy cycle tracker (drives the 6-hour reconciliation + UI countdown) --
create table if not exists larva_admin.cycles (
  id            bigint generated always as identity primary key,
  cycle_number  integer not null unique,
  started_at    timestamptz not null default now(),
  settles_at    timestamptz not null,                  -- started_at + 6h
  status        text not null default 'open' check (status in ('open','reconciling','settled')),
  settled_at    timestamptz,
  created_at    timestamptz not null default now()
);
create index if not exists cycles_status_idx on larva_admin.cycles (status);

-- Per-cycle global economic indicators (public transparency dashboard) ---------
create table if not exists larva_admin.economy_metrics (
  id                     bigint generated always as identity primary key,
  cycle_number           integer not null unique,
  currency_in_circulation bigint not null default 0,
  fees_destroyed         bigint not null default 0,
  cc_injection           bigint not null default 0,
  cc_surplus_destroyed   bigint not null default 0,
  active_players         integer not null default 0,
  active_companies       integer not null default 0,
  platform_revenue_month numeric not null default 0,
  created_at             timestamptz not null default now()
);

-- Append-only audit log (money movement, transfers, partner actions) ----------
create table if not exists larva_admin.audit_log (
  id          bigint generated always as identity primary key,
  actor       uuid references auth.users(id) on delete set null,
  action      text not null,
  entity      text,
  entity_id   text,
  detail      jsonb not null default '{}'::jsonb,
  created_at  timestamptz not null default now()
);
create index if not exists audit_actor_idx on larva_admin.audit_log (actor, created_at desc);

-- ── RLS ──────────────────────────────────────────────────────────────────────
-- partner_tiers, cycles, economy_metrics: public (transparency dashboard).
-- partners/payouts: read own. admin config + audit: no client policy (locked).
alter table larva_partners.partners            enable row level security;
alter table larva_partners.partner_payouts     enable row level security;
alter table larva_partners.platform_revenue_log enable row level security;
alter table larva_admin.system_config          enable row level security;
alter table larva_admin.cycles                 enable row level security;
alter table larva_admin.economy_metrics        enable row level security;
alter table larva_admin.audit_log              enable row level security;

drop policy if exists "partners_own" on larva_partners.partners;
create policy "partners_own" on larva_partners.partners for select using (user_id = auth.uid());
drop policy if exists "payouts_own" on larva_partners.partner_payouts;
create policy "payouts_own" on larva_partners.partner_payouts for select using (
  exists (select 1 from larva_partners.partners p where p.id = partner_id and p.user_id = auth.uid())
);
drop policy if exists "cycles_read_all" on larva_admin.cycles;
create policy "cycles_read_all" on larva_admin.cycles for select using (true);
drop policy if exists "metrics_read_all" on larva_admin.economy_metrics;
create policy "metrics_read_all" on larva_admin.economy_metrics for select using (true);
-- system_config, audit_log, platform_revenue_log: RLS enabled with NO policy →
-- denied to all client roles; service role (Edge Functions) bypasses RLS.

-- ── updated_at triggers ──────────────────────────────────────────────────────
do $$
declare t text;
begin
  foreach t in array array['larva_partners.partners','larva_admin.system_config'] loop
    execute format('drop trigger if exists set_updated_at on %s', t);
    execute format('create trigger set_updated_at before update on %s for each row execute procedure public.touch_updated_at()', t);
  end loop;
end $$;

-- ── SEED — partner tiers + baseline system config ────────────────────────────
insert into larva_partners.partner_tiers (id, name, rank, requirements, gross_payout, net_payout, invite_only, max_active) values
  ('contributor','Contributor',1,'1 active company, 30-day revenue > ₳50K',25,20,false,null),
  ('builder','Builder',2,'3+ companies, 30-day revenue > ₳500K',100,80,false,null),
  ('entrepreneur','Entrepreneur',3,'5+ companies, 1 listed, market cap > ₳5M',500,400,false,null),
  ('mogul','Mogul',4,'10+ companies, 3+ listed, revenue > ₳50M',2500,2000,false,null),
  ('legend','Legend',5,'Invitation only, max 5 active',7500,6000,true,5)
on conflict (id) do nothing;

insert into larva_admin.system_config (key, value, description) values
  ('cycle_hours', '6', 'Real hours per in-game day / reconciliation cycle'),
  ('starting_wallet', '84200', 'Default new-player wallet balance'),
  ('starting_credit_score', '500', 'Default new-player credit score (0–1000)'),
  ('stock_shares_per_company', '10000', 'Fixed total shares issued per listed company'),
  ('stock_txn_fee_pct', '0.75', 'Per-trade transaction fee percent'),
  ('founder_min_stake_pct', '51', 'Minimum permanent founder ownership'),
  ('founder_lockup_cycles', '40', 'Founder share lock-up after IPO'),
  ('deposit_insurance_cap', '50000', 'Insured deposit cap per player per bank'),
  ('cross_country_transfer_surcharge_pct', '0.5', 'Surcharge on cross-country transfers'),
  ('tax_bracket_ceiling_pct', '40', 'Maximum effective progressive tax rate'),
  ('partner_platform_cut_pct', '20', 'Platform cut on gross partner payouts'),
  ('company_transfer_fee_usd', '250', 'Real-money fee per private company transfer')
on conflict (key) do nothing;
