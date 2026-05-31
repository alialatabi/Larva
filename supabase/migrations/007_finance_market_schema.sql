-- 007 — Canonical schema: larva_finance + larva_market
--
-- Part 3 of 4. Depends on 005/006. Additive & idempotent.
--
-- NOTE: the LIVE app currently reads the working-set finance tables in `public`
-- (public.wallets/transactions/loans/deposits, migrations 002–004) because only
-- `public` is API-exposed. The tables below are the CANONICAL `larva_finance`
-- model the public.* set will consolidate into once the schema is exposed.
-- Defined here so the full schema is complete and authoritative. Read-only to
-- the client; all money movement is server-side (atomic, ACID).

-- ════════════════════════════════════════════════════════════════════════════
-- larva_finance
-- ════════════════════════════════════════════════════════════════════════════

-- Personal wallet (one per player) --------------------------------------------
create table if not exists larva_finance.wallets (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null unique references auth.users(id) on delete cascade,
  balance     bigint not null default 0,
  updated_at  timestamptz not null default now()
);

-- Company accounts (separate from personal wallet; owner-draw capped) ----------
create table if not exists larva_finance.company_accounts (
  id              uuid primary key default gen_random_uuid(),
  company_id      uuid not null references larva_economy.companies(id) on delete cascade,
  balance         bigint not null default 0,
  last_net_profit bigint not null default 0,    -- caps owner draw next tick
  updated_at      timestamptz not null default now()
);
create index if not exists company_accounts_company_idx on larva_finance.company_accounts (company_id);

-- Unified ledger (personal + company movements) -------------------------------
create table if not exists larva_finance.transactions (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid references auth.users(id) on delete cascade,
  company_id      uuid references larva_economy.companies(id) on delete cascade,
  cycle           integer not null default 0,
  type            text not null check (type in
                    ('salary','loan','rent','purchase','sale','fee','transfer','dividend','tax','interest','owner_draw','payout')),
  direction       text not null check (direction in ('in','out')),
  label           text not null,
  sub             text not null default '',
  amount          bigint not null check (amount >= 0),
  same_owner_flag boolean not null default false,
  created_at      timestamptz not null default now()
);
create index if not exists fin_tx_user_idx    on larva_finance.transactions (user_id, created_at desc);
create index if not exists fin_tx_company_idx on larva_finance.transactions (company_id, created_at desc);

-- Credit scores (0–1000, start 500) -------------------------------------------
create table if not exists larva_finance.credit_scores (
  user_id       uuid primary key references auth.users(id) on delete cascade,
  score         integer not null default 500 check (score between 0 and 1000),
  on_time_count integer not null default 0,
  missed_count  integer not null default 0,
  updated_at    timestamptz not null default now()
);

-- Loan products / lenders catalog (reference) ---------------------------------
create table if not exists larva_finance.loan_products (
  id          text primary key,    -- slug
  lender      text not null,
  badge       text not null default 'private' check (badge in ('official','private')),
  rate        numeric not null,    -- % per cycle
  max_amount  bigint not null,
  min_term    integer not null,    -- cycles
  max_term    integer not null,
  min_score   integer not null default 0
);
alter table larva_finance.loan_products enable row level security;
drop policy if exists "loan_products_read_all" on larva_finance.loan_products;
create policy "loan_products_read_all" on larva_finance.loan_products for select using (true);

-- Loans -----------------------------------------------------------------------
create table if not exists larva_finance.loans (
  id                uuid primary key default gen_random_uuid(),
  user_id           uuid not null references auth.users(id) on delete cascade,
  product_id        text references larva_finance.loan_products(id),
  loan_ref          text not null,
  lender            text not null,
  original          bigint not null check (original >= 0),
  remaining         bigint not null check (remaining >= 0),
  rate              numeric not null check (rate >= 0),
  payment           bigint not null check (payment >= 0),
  collateral_company uuid references larva_economy.companies(id) on delete set null,
  issued_cycle      integer not null,
  matures_cycle     integer not null,
  payments_made     integer not null default 0,
  payments_on_time  integer not null default 0,
  next_due_label    text not null default '',
  status            text not null default 'active' check (status in ('active','paid','defaulted')),
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);
create index if not exists fin_loans_user_idx on larva_finance.loans (user_id, status);

-- Deposits (insured up to 50,000 per player per bank) --------------------------
create table if not exists larva_finance.deposits (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references auth.users(id) on delete cascade,
  deposit_ref  text not null,
  bank         text not null,
  amount       bigint not null check (amount >= 0),
  rate         numeric not null check (rate >= 0),
  cycles       integer not null check (cycles > 0),
  remaining    integer not null check (remaining >= 0),
  insured      boolean not null default true,
  status       text not null default 'active' check (status in ('active','matured','withdrawn')),
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
create index if not exists fin_deposits_user_idx on larva_finance.deposits (user_id, status);

-- Insurance policies ----------------------------------------------------------
create table if not exists larva_finance.insurance_policies (
  id            uuid primary key default gen_random_uuid(),
  holder_player uuid references auth.users(id) on delete cascade,
  company_id    uuid references larva_economy.companies(id) on delete cascade,
  insurer       uuid references larva_economy.companies(id) on delete set null,  -- insurance company
  policy_type   text not null check (policy_type in ('property','cargo','liability','business_interruption')),
  premium       bigint not null default 0,    -- per cycle
  coverage      bigint not null default 0,
  status        text not null default 'active' check (status in ('active','lapsed','cancelled')),
  created_at    timestamptz not null default now()
);
create index if not exists insurance_holder_idx on larva_finance.insurance_policies (holder_player);

create table if not exists larva_finance.insurance_claims (
  id            uuid primary key default gen_random_uuid(),
  policy_id     uuid not null references larva_finance.insurance_policies(id) on delete cascade,
  event_id      uuid references larva_world.events(id) on delete set null,
  amount        bigint not null default 0,
  status        text not null default 'filed' check (status in ('filed','approved','paid','rejected')),
  created_at    timestamptz not null default now()
);

-- ════════════════════════════════════════════════════════════════════════════
-- larva_market — stock market (10,000 shares/company, IPO 10–49%, 0.75% fee)
-- ════════════════════════════════════════════════════════════════════════════

create table if not exists larva_market.listings (
  id                uuid primary key default gen_random_uuid(),
  company_id        uuid not null unique references larva_economy.companies(id) on delete cascade,
  ticker            text not null unique,
  total_shares      integer not null default 10000,
  float_shares      integer not null default 0,     -- shares offered to the market (≤49%)
  fair_value        bigint not null default 0,      -- algorithm reference per share
  last_price        bigint not null default 0,
  founder_locked_until_cycle integer,               -- 40-tick founder lock-up
  status            text not null default 'listed' check (status in ('pending','listed','suspended','delisted')),
  listed_cycle      integer,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);
create index if not exists listings_status_idx on larva_market.listings (status);

-- Share holdings per player per listing ---------------------------------------
create table if not exists larva_market.holdings (
  id           uuid primary key default gen_random_uuid(),
  listing_id   uuid not null references larva_market.listings(id) on delete cascade,
  holder       uuid not null references auth.users(id) on delete cascade,
  shares       integer not null default 0 check (shares >= 0),
  avg_cost     bigint not null default 0,
  is_founder   boolean not null default false,
  updated_at   timestamptz not null default now(),
  unique (listing_id, holder)
);
create index if not exists holdings_holder_idx on larva_market.holdings (holder);

-- Trade ledger (0.75% transaction fee applied server-side) ---------------------
create table if not exists larva_market.trades (
  id           uuid primary key default gen_random_uuid(),
  listing_id   uuid not null references larva_market.listings(id) on delete cascade,
  player_id    uuid not null references auth.users(id) on delete cascade,
  side         text not null check (side in ('buy','sell')),
  shares       integer not null check (shares > 0),
  price        bigint not null,
  fee          bigint not null default 0,
  cycle        integer,
  created_at   timestamptz not null default now()
);
create index if not exists trades_listing_idx on larva_market.trades (listing_id, created_at desc);
create index if not exists trades_player_idx  on larva_market.trades (player_id);

-- Per-cycle price history (sparklines / charts) -------------------------------
create table if not exists larva_market.price_history (
  id           uuid primary key default gen_random_uuid(),
  listing_id   uuid not null references larva_market.listings(id) on delete cascade,
  cycle        integer not null,
  open_price   bigint not null default 0,
  close_price  bigint not null default 0,
  high_price   bigint not null default 0,
  low_price    bigint not null default 0,
  volume       integer not null default 0,
  created_at   timestamptz not null default now(),
  unique (listing_id, cycle)
);

create table if not exists larva_market.dividends (
  id            uuid primary key default gen_random_uuid(),
  listing_id    uuid not null references larva_market.listings(id) on delete cascade,
  per_share     bigint not null default 0,
  declared_cycle integer,
  paid_cycle    integer,
  status        text not null default 'declared' check (status in ('declared','paid')),
  created_at    timestamptz not null default now()
);

-- ── RLS ──────────────────────────────────────────────────────────────────────
-- Player-owned finance: read own. Market public data: world-readable.
do $$
declare t text;
begin
  foreach t in array array[
    'larva_finance.wallets','larva_finance.company_accounts','larva_finance.transactions',
    'larva_finance.credit_scores','larva_finance.loans','larva_finance.deposits',
    'larva_finance.insurance_policies','larva_finance.insurance_claims',
    'larva_market.listings','larva_market.holdings','larva_market.trades',
    'larva_market.price_history','larva_market.dividends'
  ] loop
    execute format('alter table %s enable row level security', t);
  end loop;
end $$;

drop policy if exists "fin_wallets_own" on larva_finance.wallets;
create policy "fin_wallets_own" on larva_finance.wallets for select using (user_id = auth.uid());
drop policy if exists "fin_tx_own" on larva_finance.transactions;
create policy "fin_tx_own" on larva_finance.transactions for select using (
  user_id = auth.uid()
  or exists (select 1 from larva_economy.companies c where c.id = company_id and c.owner_player = auth.uid())
);
drop policy if exists "fin_credit_own" on larva_finance.credit_scores;
create policy "fin_credit_own" on larva_finance.credit_scores for select using (user_id = auth.uid());
drop policy if exists "fin_loans_own" on larva_finance.loans;
create policy "fin_loans_own" on larva_finance.loans for select using (user_id = auth.uid());
drop policy if exists "fin_deposits_own" on larva_finance.deposits;
create policy "fin_deposits_own" on larva_finance.deposits for select using (user_id = auth.uid());
drop policy if exists "fin_company_accounts_owner" on larva_finance.company_accounts;
create policy "fin_company_accounts_owner" on larva_finance.company_accounts for select using (
  exists (select 1 from larva_economy.companies c where c.id = company_id and c.owner_player = auth.uid())
);
drop policy if exists "fin_insurance_own" on larva_finance.insurance_policies;
create policy "fin_insurance_own" on larva_finance.insurance_policies for select using (
  holder_player = auth.uid()
  or exists (select 1 from larva_economy.companies c where c.id = company_id and c.owner_player = auth.uid())
);
drop policy if exists "fin_claims_own" on larva_finance.insurance_claims;
create policy "fin_claims_own" on larva_finance.insurance_claims for select using (
  exists (select 1 from larva_finance.insurance_policies p where p.id = policy_id and p.holder_player = auth.uid())
);

-- Market: holdings/trades are owner-scoped; listings/prices/dividends public
drop policy if exists "mkt_listings_read_all" on larva_market.listings;
create policy "mkt_listings_read_all" on larva_market.listings for select using (true);
drop policy if exists "mkt_prices_read_all" on larva_market.price_history;
create policy "mkt_prices_read_all" on larva_market.price_history for select using (true);
drop policy if exists "mkt_dividends_read_all" on larva_market.dividends;
create policy "mkt_dividends_read_all" on larva_market.dividends for select using (true);
drop policy if exists "mkt_holdings_own" on larva_market.holdings;
create policy "mkt_holdings_own" on larva_market.holdings for select using (holder = auth.uid());
drop policy if exists "mkt_trades_own" on larva_market.trades;
create policy "mkt_trades_own" on larva_market.trades for select using (player_id = auth.uid());

-- ── updated_at triggers ──────────────────────────────────────────────────────
do $$
declare t text;
begin
  foreach t in array array[
    'larva_finance.wallets','larva_finance.company_accounts','larva_finance.credit_scores',
    'larva_finance.loans','larva_finance.deposits','larva_market.listings','larva_market.holdings'
  ] loop
    execute format('drop trigger if exists set_updated_at on %s', t);
    execute format('create trigger set_updated_at before update on %s for each row execute procedure public.touch_updated_at()', t);
  end loop;
end $$;

-- ── SEED — loan products / lenders (mirrors the loan wizard catalog) ──────────
insert into larva_finance.loan_products (id, lender, badge, rate, max_amount, min_term, max_term, min_score) values
  ('cb',  'Central Bank',    'official', 12.0, 100000, 20, 60, 500),
  ('vnx', 'Ventrex Savings', 'private',   9.5,  60000, 15, 40, 680),
  ('mfi', 'Morrath Finance', 'private',  16.0, 200000, 10, 80, 400)
on conflict (id) do nothing;
