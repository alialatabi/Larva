-- 004 — Loans + Deposits vertical slice
--
-- Wires the remaining two Finance detail screens (My Loans, My Deposits) to
-- live, server-authoritative data, same pattern as wallets (002) and the
-- transaction ledger (003).
--
-- Placed in the `public` schema (already API-exposed). Production should later
-- consolidate into `larva_finance`.
--
-- Apply order: run AFTER 002_wallet_slice.sql (reuses public.touch_updated_at).
-- Apply: Supabase Dashboard → SQL Editor, or the Management API. Idempotent.

-- ── Loans ─────────────────────────────────────────────────────────────────────
-- One row per active loan. Economic mutations (issuance, per-cycle repayment,
-- credit-score effects) happen server-side via the loan-apply Edge Function and
-- the reconciliation cycle — never the client.
create table if not exists public.loans (
  id                uuid primary key default gen_random_uuid(),
  user_id           uuid not null references auth.users(id) on delete cascade,
  loan_ref          text not null,                 -- display id, e.g. 'L-001'
  lender            text not null,
  original          bigint  not null check (original  >= 0),
  remaining         bigint  not null check (remaining >= 0),
  rate              numeric not null check (rate >= 0),  -- % per cycle
  payment           bigint  not null check (payment >= 0), -- per cycle
  issued_cycle      integer not null,
  matures_cycle     integer not null,
  payments_made     integer not null default 0 check (payments_made >= 0),
  payments_on_time  integer not null default 0 check (payments_on_time >= 0),
  next_due_label    text not null default '',      -- display countdown, e.g. '1h 42m'
  status            text not null default 'active' check (status in ('active','paid','defaulted')),
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);

create index if not exists loans_user_idx on public.loans (user_id, created_at desc);

-- ── Deposits ──────────────────────────────────────────────────────────────────
create table if not exists public.deposits (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references auth.users(id) on delete cascade,
  deposit_ref  text not null,                      -- display id, e.g. 'D-001'
  bank         text not null,
  amount       bigint  not null check (amount >= 0),  -- principal
  rate         numeric not null check (rate >= 0),    -- % per cycle
  cycles       integer not null check (cycles > 0),   -- total term
  remaining    integer not null check (remaining >= 0), -- cycles left
  status       text not null default 'active' check (status in ('active','matured','withdrawn')),
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

create index if not exists deposits_user_idx on public.deposits (user_id, created_at desc);

-- ── RLS — read-only for the owner ───────────────────────────────────────────
alter table public.loans    enable row level security;
alter table public.deposits enable row level security;

drop policy if exists "loans_select_own" on public.loans;
create policy "loans_select_own" on public.loans
  for select using (user_id = auth.uid());

drop policy if exists "deposits_select_own" on public.deposits;
create policy "deposits_select_own" on public.deposits
  for select using (user_id = auth.uid());

-- ── updated_at touch (reuses public.touch_updated_at from migration 002) ─────
drop trigger if exists loans_updated_at on public.loans;
create trigger loans_updated_at before update on public.loans
  for each row execute procedure public.touch_updated_at();

drop trigger if exists deposits_updated_at on public.deposits;
create trigger deposits_updated_at before update on public.deposits
  for each row execute procedure public.touch_updated_at();

-- ── Realtime — broadcast repayment / accrual changes to subscribed clients ───
do $$
begin
  if not exists (select 1 from pg_publication_tables
    where pubname='supabase_realtime' and schemaname='public' and tablename='loans') then
    alter publication supabase_realtime add table public.loans;
  end if;
  if not exists (select 1 from pg_publication_tables
    where pubname='supabase_realtime' and schemaname='public' and tablename='deposits') then
    alter publication supabase_realtime add table public.deposits;
  end if;
end $$;

-- ── Demo seed — only users who have none yet, so re-runs are safe ─────────────
insert into public.loans (user_id, loan_ref, lender, original, remaining, rate, payment, issued_cycle, matures_cycle, payments_made, payments_on_time, next_due_label)
select u.id, 'L-001', 'Central Bank', 50000, 38000, 12, 1200, 30, 70, 9, 9, '1h 42m'
from auth.users u
where not exists (select 1 from public.loans l where l.user_id = u.id);

insert into public.deposits (user_id, deposit_ref, bank, amount, rate, cycles, remaining)
select u.id, v.deposit_ref, v.bank, v.amount, v.rate, v.cycles, v.remaining
from auth.users u
cross join (values
  ('D-001', 'Central Bank',    12000, 8.4, 10, 6),
  ('D-002', 'Ventrex Savings',  8000, 9.1, 20, 14)
) as v(deposit_ref, bank, amount, rate, cycles, remaining)
where not exists (select 1 from public.deposits d where d.user_id = u.id);

-- ── Demo: watch a repayment land live ─────────────────────────────────────────
-- After signing in, run this in the SQL Editor (replace the email). The loan's
-- remaining balance drops and the progress bar advances in real time:
--
--   update public.loans
--     set remaining = remaining - 1200, payments_made = payments_made + 1,
--         payments_on_time = payments_on_time + 1
--   where user_id = (select id from auth.users where email = 'you@example.com')
--     and loan_ref = 'L-001';
