-- 002 — Wallet vertical slice
--
-- Goal: the first screen wired to live, server-authoritative data.
-- Placed in the `public` schema (already API-exposed) so it lights up by
-- running this file alone — no dashboard schema-exposure step required.
-- Production should later consolidate this into `larva_finance` once that
-- schema is added to the project's exposed schemas.
--
-- Apply: Supabase Dashboard → SQL Editor → paste & Run. Idempotent.

-- ── Table ─────────────────────────────────────────────────────────────────────
create table if not exists public.wallets (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null unique references auth.users(id) on delete cascade,
  balance     bigint not null default 84200,
  updated_at  timestamptz not null default now()
);

-- ── RLS — read-only for the owner ───────────────────────────────────────────
-- No INSERT/UPDATE policy: balance is server-authoritative. Mutations happen
-- only via SECURITY DEFINER functions / the service role (Edge Functions),
-- never the client. The client can only SELECT its own wallet.
alter table public.wallets enable row level security;

drop policy if exists "wallet_select_own" on public.wallets;
create policy "wallet_select_own" on public.wallets
  for select using (user_id = auth.uid());

-- ── Auto-create a wallet for every new auth user ─────────────────────────────
create or replace function public.handle_new_user_wallet()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.wallets (user_id) values (new.id)
  on conflict (user_id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created_wallet on auth.users;
create trigger on_auth_user_created_wallet
  after insert on auth.users
  for each row execute procedure public.handle_new_user_wallet();

-- Backfill wallets for users who signed up before this migration
insert into public.wallets (user_id)
select id from auth.users
on conflict (user_id) do nothing;

-- ── updated_at touch ──────────────────────────────────────────────────────────
create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end;
$$;

drop trigger if exists wallets_updated_at on public.wallets;
create trigger wallets_updated_at before update on public.wallets
  for each row execute procedure public.touch_updated_at();

-- ── Realtime — broadcast balance changes to subscribed clients ───────────────
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'wallets'
  ) then
    alter publication supabase_realtime add table public.wallets;
  end if;
end $$;

-- ── Demo: watch the wallet animate live ──────────────────────────────────────
-- After signing in, run this in the SQL Editor to see the balance count up in
-- the app in real time (replace the email with your account's):
--
--   update public.wallets set balance = balance + 1200
--   where user_id = (select id from auth.users where email = 'you@example.com');
