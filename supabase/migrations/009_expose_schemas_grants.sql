-- 009 — Expose the larva_* schemas to the API (grants + RLS hardening)
--
-- Companion to the PostgREST config change that adds these schemas to the
-- "Exposed schemas" list. Exposing a schema only makes it visible to PostgREST;
-- the API roles (anon, authenticated) still need USAGE on the schema and SELECT
-- on its tables. RLS then filters which rows each role actually sees.
--
-- Security model: every larva_* table has RLS enabled. Owner-scoped tables only
-- return the caller's own rows; reference/market/public tables are read-all;
-- locked tables (larva_admin.system_config/audit_log, partners.platform_revenue_log)
-- have RLS enabled with NO select policy, so these grants expose nothing —
-- the service role (Edge Functions) bypasses RLS for server-side work.
--
-- Idempotent. Apply BEFORE flipping the PostgREST exposed-schemas config.

-- ── Fix: reference tables in 005 that missed RLS ─────────────────────────────
alter table larva_world.countries               enable row level security;
alter table larva_world.country_resources       enable row level security;
alter table larva_world.country_specializations enable row level security;

drop policy if exists "countries_read_all" on larva_world.countries;
create policy "countries_read_all" on larva_world.countries for select using (true);
drop policy if exists "country_resources_read_all" on larva_world.country_resources;
create policy "country_resources_read_all" on larva_world.country_resources for select using (true);
drop policy if exists "country_specializations_read_all" on larva_world.country_specializations;
create policy "country_specializations_read_all" on larva_world.country_specializations for select using (true);

-- ── Schema USAGE for the API roles ───────────────────────────────────────────
grant usage on schema
  larva_core, larva_economy, larva_finance, larva_market,
  larva_world, larva_logistics, larva_partners, larva_admin
to anon, authenticated;

-- ── SELECT on all existing tables (RLS still gates rows) ─────────────────────
grant select on all tables in schema
  larva_core, larva_economy, larva_finance, larva_market,
  larva_world, larva_logistics, larva_partners, larva_admin
to anon, authenticated;

-- ── Default privileges so future tables in these schemas are readable too ────
-- Applies to objects created by the role running migrations (postgres).
alter default privileges in schema
  larva_core, larva_economy, larva_finance, larva_market,
  larva_world, larva_logistics, larva_partners, larva_admin
grant select on tables to anon, authenticated;
