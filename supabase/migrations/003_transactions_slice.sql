-- 003 — Transaction ledger vertical slice
--
-- The second screen wired to live, server-authoritative data: Finance →
-- Transactions. The ledger is what moves the wallet (migration 002), so the
-- two slices share one atomic money-movement function.
--
-- Placed in the `public` schema (already API-exposed) so it lights up by
-- running this file alone — no dashboard schema-exposure step required.
-- Production should later consolidate this into `larva_finance`.
--
-- Apply order: run AFTER 002_wallet_slice.sql (depends on public.wallets and
-- public.touch_updated_at).
-- Apply: Supabase Dashboard → SQL Editor → paste & Run. Idempotent.

-- ── Table ─────────────────────────────────────────────────────────────────────
-- One row per money movement. `cycle` is the economy cycle the row settled in,
-- used to group the history; `direction` drives the +/- and emerald/crimson UI.
create table if not exists public.transactions (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users(id) on delete cascade,
  cycle       integer not null default 0,
  type        text not null check (type in ('salary','loan','rent','purchase','fee','transfer')),
  direction   text not null check (direction in ('in','out')),
  label       text not null,
  sub         text not null default '',
  amount      bigint not null check (amount >= 0),
  created_at  timestamptz not null default now()
);

-- Fast per-player history reads, newest first.
create index if not exists transactions_user_created_idx
  on public.transactions (user_id, created_at desc);

-- ── RLS — read-only for the owner ───────────────────────────────────────────
-- No INSERT/UPDATE/DELETE policy: the ledger is append-only and
-- server-authoritative. Rows are written only by record_transaction() /
-- Edge Functions via the service role, never the client. The client can only
-- SELECT its own rows.
alter table public.transactions enable row level security;

drop policy if exists "transactions_select_own" on public.transactions;
create policy "transactions_select_own" on public.transactions
  for select using (user_id = auth.uid());

-- ── Atomic money movement — ledger row + wallet balance in one transaction ───
-- Hard rule (CLAUDE.md #3): every money movement is a single committed
-- transaction. This is the only sanctioned way money moves. Edge Functions
-- call it via the service role; the client never does.
create or replace function public.record_transaction(
  p_user_id   uuid,
  p_cycle     integer,
  p_type      text,
  p_direction text,
  p_label     text,
  p_sub       text,
  p_amount    bigint
)
returns public.transactions
language plpgsql security definer set search_path = public as $$
declare
  v_tx public.transactions;
begin
  if p_direction not in ('in', 'out') then
    raise exception 'direction must be ''in'' or ''out'', got %', p_direction;
  end if;
  if p_amount < 0 then
    raise exception 'amount must be non-negative, got %', p_amount;
  end if;

  insert into public.transactions (user_id, cycle, type, direction, label, sub, amount)
  values (p_user_id, p_cycle, p_type, p_direction, coalesce(p_label, ''), coalesce(p_sub, ''), p_amount)
  returning * into v_tx;

  update public.wallets
     set balance = balance + (case when p_direction = 'in' then p_amount else -p_amount end)
   where user_id = p_user_id;

  return v_tx;
end;
$$;

-- ── Realtime — broadcast new ledger rows to subscribed clients ───────────────
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'transactions'
  ) then
    alter publication supabase_realtime add table public.transactions;
  end if;
end $$;

-- ── Demo seed — illustrative history so the screen isn't empty on first load ──
-- Inserted directly (not via record_transaction) so existing wallet balances
-- are left untouched. Only seeds users who have no transactions yet, so re-runs
-- are safe and won't duplicate.
insert into public.transactions (user_id, cycle, type, direction, label, sub, amount, created_at)
select u.id, v.cycle, v.type, v.direction, v.label, v.sub, v.amount,
       now() - make_interval(mins => v.ago)
from auth.users u
cross join (values
  (47, 'salary',   'in',  'Salary received',             'Horizon Tech',              8000,  90),
  (47, 'loan',     'out', 'Loan payment — Central Bank', 'Auto-deducted cycle settle',1200,  88),
  (47, 'rent',     'out', 'Personal rent',               'Caedoria Apt. #14',         3200,  88),
  (47, 'purchase', 'out', 'Food purchase',               'Volta Café',                400,   60),
  (47, 'fee',      'out', 'Transaction fee',             'Applied on salary',         200,   90),
  (46, 'salary',   'in',  'Salary received',             'Horizon Tech',              8000,  450),
  (46, 'loan',     'out', 'Loan payment — Central Bank', 'Auto-deducted cycle settle',1200,  448),
  (46, 'rent',     'out', 'Personal rent',               'Caedoria Apt. #14',         3200,  448),
  (46, 'purchase', 'out', 'Clothing purchase',           'Caedoria Retail',           2800,  420),
  (46, 'transfer', 'in',  'Dividend — VLTF',             'Stock market',              1000,  448),
  (45, 'salary',   'in',  'Salary received',             'Horizon Tech',              8000,  810),
  (45, 'loan',     'out', 'Loan payment — Central Bank', 'Auto-deducted cycle settle',1200,  808),
  (45, 'rent',     'out', 'Personal rent',               'Caedoria Apt. #14',         3200,  808),
  (45, 'transfer', 'in',  'Contract payment received',   'Meridian Corp',             1800,  780)
) as v(cycle, type, direction, label, sub, amount, ago)
where not exists (
  select 1 from public.transactions t where t.user_id = u.id
);

-- ── Demo: watch a transaction post live (and the wallet count up) ─────────────
-- After signing in, run this in the SQL Editor (replace the email). The new row
-- appears at the top of Finance → Transactions and the wallet hero animates:
--
--   select public.record_transaction(
--     (select id from auth.users where email = 'you@example.com'),
--     48, 'salary', 'in', 'Salary received', 'Horizon Tech', 8000
--   );
