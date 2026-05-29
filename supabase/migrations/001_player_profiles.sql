-- Phase 3 Foundation — Player profiles + auth trigger
-- Schema: larva_core
-- Trigger: auto-create player profile when auth user is created

create schema if not exists larva_core;

-- ── Players ──────────────────────────────────────────────────────────────────

create table if not exists larva_core.players (
  id             uuid primary key default gen_random_uuid(),
  auth_user_id   uuid not null unique references auth.users(id) on delete cascade,
  display_name   text not null,
  country_id     text not null default 'nova',
  cycle_count    integer not null default 0,
  credit_score   integer not null default 500,
  is_partner     boolean not null default false,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now()
);

-- ── RLS ──────────────────────────────────────────────────────────────────────

alter table larva_core.players enable row level security;

create policy "Players can read own profile"
  on larva_core.players for select
  using (auth_user_id = auth.uid());

create policy "Players can update own profile"
  on larva_core.players for update
  using (auth_user_id = auth.uid());

-- ── Trigger: create player on signup ─────────────────────────────────────────

create or replace function larva_core.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into larva_core.players (
    auth_user_id,
    display_name,
    country_id
  ) values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'display_name', 'Player'),
    coalesce(new.raw_user_meta_data ->> 'country_id', 'nova')
  );
  return new;
end;
$$;

-- Drop and recreate trigger to avoid conflicts on re-runs
drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure larva_core.handle_new_user();

-- ── Updated-at trigger ────────────────────────────────────────────────────────

create or replace function larva_core.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger players_updated_at
  before update on larva_core.players
  for each row execute procedure larva_core.set_updated_at();
