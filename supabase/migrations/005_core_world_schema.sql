-- 005 — Canonical schema: namespaces + larva_core + larva_world
--
-- Part 1 of 4 of the full Project Larva database schema (see also 006–008).
-- Additive & idempotent: creates the canonical `larva_*` schemas alongside the
-- live `public.*` finance tables (002–004) without touching them. These schemas
-- are NOT yet API-exposed (only `public` + `graphql_public` are), so the client
-- can't read them until they're exposed in the dashboard — they are the
-- authoritative model the public.* working set will later consolidate into.
--
-- Reuses `public.touch_updated_at()` (migration 002) for updated_at triggers.
-- Apply: Management API / Dashboard SQL editor.

-- ── Namespaces (all 8) ───────────────────────────────────────────────────────
create schema if not exists larva_core;
create schema if not exists larva_economy;
create schema if not exists larva_finance;
create schema if not exists larva_market;
create schema if not exists larva_world;
create schema if not exists larva_logistics;
create schema if not exists larva_partners;
create schema if not exists larva_admin;

-- ════════════════════════════════════════════════════════════════════════════
-- REFERENCE CATALOGS (read-only game design data)
-- ════════════════════════════════════════════════════════════════════════════

-- Raw-material resource categories (7) ----------------------------------------
create table if not exists larva_world.resources (
  id    text primary key,        -- slug
  name  text not null
);

-- Business sectors (9 + cross-sector) -----------------------------------------
create table if not exists larva_economy.sectors (
  id          text primary key,  -- slug
  name        text not null,
  sort_order  integer not null default 0
);

-- Skills taxonomy (25) — see docs/larva_skills_system.md -----------------------
create table if not exists larva_core.skills (
  id            text primary key,    -- slug
  name          text not null,
  tier          text not null check (tier in ('foundation','free_domain','gated_domain')),
  npc_ceiling   integer not null check (npc_ceiling between 0 and 100),
  prerequisite  text,                -- foundational course required to unlock (gated only)
  description   text not null default ''
);

-- Player needs (7) — see docs/larva_master.md ---------------------------------
create table if not exists larva_core.needs (
  id             text primary key,   -- slug
  name           text not null,
  sector_demand  text not null default ''
);

-- ── Reference RLS: world-readable ────────────────────────────────────────────
do $$
declare t text;
begin
  foreach t in array array[
    'larva_world.resources','larva_economy.sectors','larva_core.skills','larva_core.needs'
  ] loop
    execute format('alter table %s enable row level security', t);
    execute format($f$drop policy if exists "%s_read_all" on %s$f$, replace(t,'.','_'), t);
    execute format($f$create policy "%s_read_all" on %s for select using (true)$f$, replace(t,'.','_'), t);
  end loop;
end $$;

-- ════════════════════════════════════════════════════════════════════════════
-- larva_world — countries, geography, properties, events
-- ════════════════════════════════════════════════════════════════════════════

-- Countries (18) — single-market economies with modifier profiles --------------
create table if not exists larva_world.countries (
  id                  text primary key,   -- slug
  name                text not null,
  tier                text not null check (tier in ('developed','emerging','developing')),
  tax_rate            numeric not null,    -- base % for progressive brackets
  labor_cost          numeric not null,    -- salary multiplier (0.7–1.4)
  real_estate_cost    numeric not null,    -- property multiplier (0.6–1.5)
  spending_power      text not null check (spending_power in ('low','medium','high')),
  infrastructure      text not null check (infrastructure in ('low','medium','high')),
  created_at          timestamptz not null default now()
);

create table if not exists larva_world.country_resources (
  country_id   text not null references larva_world.countries(id) on delete cascade,
  resource_id  text not null references larva_world.resources(id) on delete cascade,
  primary key (country_id, resource_id)
);

create table if not exists larva_world.country_specializations (
  country_id  text not null references larva_world.countries(id) on delete cascade,
  sector_id   text not null references larva_economy.sectors(id) on delete cascade,
  bonus_pct   integer not null,           -- output efficiency bonus (10–20)
  primary key (country_id, sector_id)
);

-- Real estate / properties (commercial + residential) -------------------------
create table if not exists larva_world.properties (
  id            uuid primary key default gen_random_uuid(),
  country_id    text not null references larva_world.countries(id),
  kind          text not null check (kind in ('commercial','residential','industrial','storage')),
  size_tier     text not null default 'standard' check (size_tier in ('small','standard','large','premium')),
  base_rent     bigint not null default 0,    -- per cycle, pre country modifier
  base_price    bigint not null default 0,    -- purchase, pre country modifier
  owner_player  uuid references auth.users(id) on delete set null,   -- null = available / CC-owned
  tenant_player uuid references auth.users(id) on delete set null,
  status        text not null default 'available' check (status in ('available','leased','owned')),
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);
create index if not exists properties_country_idx on larva_world.properties (country_id, status);
create index if not exists properties_owner_idx   on larva_world.properties (owner_player);

-- Economic events — see docs/larva_event_system.md ----------------------------
create table if not exists larva_world.events (
  id            uuid primary key default gen_random_uuid(),
  category      text not null check (category in
                  ('technology','health','fashion','supply_chain','financial','labor','natural_infrastructure','regulatory')),
  scope         text not null check (scope in ('global','regional','country','sector')),
  severity      text not null check (severity in ('minor','major','crisis')),
  title         text not null,
  body          text not null default '',
  country_id    text references larva_world.countries(id),   -- when scope = country
  sector_id     text references larva_economy.sectors(id),   -- when scope = sector
  effect        jsonb not null default '{}'::jsonb,          -- structured modifiers applied by the engine
  started_cycle integer,
  ends_cycle    integer,
  status        text not null default 'active' check (status in ('active','resolved','expired')),
  created_at    timestamptz not null default now()
);
create index if not exists events_status_idx on larva_world.events (status, category);

-- ════════════════════════════════════════════════════════════════════════════
-- larva_core — player-owned needs + skills
-- ════════════════════════════════════════════════════════════════════════════

-- One row per player; the 7 needs each 0–100. ---------------------------------
create table if not exists larva_core.player_needs (
  player_id        uuid primary key references auth.users(id) on delete cascade,
  hunger           integer not null default 100 check (hunger between 0 and 100),
  energy           integer not null default 100 check (energy between 0 and 100),
  health           integer not null default 100 check (health between 0 and 100),
  happiness        integer not null default 100 check (happiness between 0 and 100),
  housing          integer not null default 100 check (housing between 0 and 100),
  transportation   integer not null default 100 check (transportation between 0 and 100),
  drive            integer not null default 100 check (drive between 0 and 100),
  updated_at       timestamptz not null default now()
);

-- Per-player skill levels (0–100). Gated skills start locked. ------------------
create table if not exists larva_core.player_skills (
  player_id  uuid not null references auth.users(id) on delete cascade,
  skill_id   text not null references larva_core.skills(id),
  level      integer not null default 0 check (level between 0 and 100),
  xp         numeric not null default 0,
  unlocked   boolean not null default true,   -- false for gated skills pre-course
  updated_at timestamptz not null default now(),
  primary key (player_id, skill_id)
);

-- ── Player-owned RLS (read own) ──────────────────────────────────────────────
alter table larva_core.player_needs  enable row level security;
alter table larva_core.player_skills enable row level security;
alter table larva_world.properties   enable row level security;
alter table larva_world.events       enable row level security;

drop policy if exists "player_needs_own" on larva_core.player_needs;
create policy "player_needs_own" on larva_core.player_needs for select using (player_id = auth.uid());

drop policy if exists "player_skills_own" on larva_core.player_skills;
create policy "player_skills_own" on larva_core.player_skills for select using (player_id = auth.uid());

-- Properties + events are world-readable
drop policy if exists "properties_read_all" on larva_world.properties;
create policy "properties_read_all" on larva_world.properties for select using (true);
drop policy if exists "events_read_all" on larva_world.events;
create policy "events_read_all" on larva_world.events for select using (true);

-- ── updated_at triggers ──────────────────────────────────────────────────────
do $$
declare t text;
begin
  foreach t in array array[
    'larva_world.properties','larva_core.player_needs','larva_core.player_skills'
  ] loop
    execute format('drop trigger if exists set_updated_at on %s', t);
    execute format('create trigger set_updated_at before update on %s for each row execute procedure public.touch_updated_at()', t);
  end loop;
end $$;

-- ════════════════════════════════════════════════════════════════════════════
-- SEED — reference data
-- ════════════════════════════════════════════════════════════════════════════

insert into larva_world.resources (id, name) values
  ('agricultural_products','Agricultural Products'),
  ('metals_minerals','Metals & Minerals'),
  ('petroleum_synthetics','Petroleum & Synthetics'),
  ('natural_fibers','Natural Fibers'),
  ('chemical_compounds','Chemical Compounds'),
  ('timber_wood','Timber & Wood'),
  ('stone_aggregate','Stone & Aggregate')
on conflict (id) do nothing;

insert into larva_economy.sectors (id, name, sort_order) values
  ('food_hospitality','Food & Hospitality',1),
  ('logistics_transport','Logistics & Transport',2),
  ('retail','Retail',3),
  ('construction_real_estate','Construction & Real Estate',4),
  ('finance','Finance',5),
  ('professional_services','Professional Services',6),
  ('manufacturing','Manufacturing',7),
  ('technology','Technology',8),
  ('education_training','Education & Training',9),
  ('cross_sector','Cross-Sector',10)
on conflict (id) do nothing;

insert into larva_core.needs (id, name, sector_demand) values
  ('hunger','Hunger','Food & Hospitality'),
  ('energy','Energy','Food, work-life balance'),
  ('health','Health','Pharmacy, Healthcare'),
  ('happiness','Happiness','Clothing, Entertainment'),
  ('housing','Housing','Real Estate'),
  ('transportation','Transportation','Logistics'),
  ('drive','Drive & Ambition','Education & Training')
on conflict (id) do nothing;

-- 25 skills: 8 foundation, 9 free-domain, 8 gated
insert into larva_core.skills (id, name, tier, npc_ceiling, prerequisite) values
  ('management','Management','foundation',40,null),
  ('sales','Sales','foundation',45,null),
  ('finance','Finance','foundation',40,null),
  ('negotiation','Negotiation','foundation',35,null),
  ('organization','Organization','foundation',50,null),
  ('customer_service','Customer Service','foundation',45,null),
  ('marketing','Marketing','foundation',30,null),
  ('quality_assessment','Quality Assessment','foundation',45,null),
  ('culinary_arts','Culinary Arts','free_domain',45,null),
  ('driving','Driving','free_domain',50,null),
  ('mechanical_repair','Mechanical Repair','free_domain',50,null),
  ('construction','Construction','free_domain',48,null),
  ('information_technology','Information Technology','free_domain',45,null),
  ('real_estate','Real Estate','free_domain',45,null),
  ('design_aesthetics','Design & Aesthetics','free_domain',40,null),
  ('healthcare_basics','Healthcare Basics','free_domain',45,null),
  ('manufacturing_production','Manufacturing & Production','free_domain',50,null),
  ('pharmaceutical_science','Pharmaceutical Science','gated_domain',42,'Foundational Science'),
  ('architecture','Architecture','gated_domain',40,'Foundational Engineering'),
  ('software_engineering','Software Engineering','gated_domain',40,'Foundational Computing'),
  ('data_analytics','Data Analytics','gated_domain',38,'Foundational Computing'),
  ('financial_modeling','Financial Modeling','gated_domain',35,'Foundational Finance'),
  ('legal_practice','Legal Practice','gated_domain',38,'Foundational Law'),
  ('accounting','Accounting','gated_domain',35,'Foundational Finance'),
  ('electronics_engineering','Electronics Engineering','gated_domain',38,'Foundational Engineering')
on conflict (id) do nothing;

-- 18 countries with full modifier profiles
insert into larva_world.countries (id, name, tier, tax_rate, labor_cost, real_estate_cost, spending_power, infrastructure) values
  ('valen','Valen','developed',22,1.35,1.5,'high','high'),
  ('korr','Korr','emerging',12,0.75,0.85,'medium','high'),
  ('meris','Meris','emerging',10,0.9,0.8,'medium','medium'),
  ('thorn','Thorn','developed',20,1.3,1.3,'high','high'),
  ('cassen','Cassen','emerging',14,1.0,1.0,'medium','high'),
  ('dravel','Dravel','emerging',5,0.85,0.7,'low','medium'),
  ('lorren','Lorren','emerging',13,0.8,0.9,'medium','medium'),
  ('vesk','Vesk','developing',7,0.7,0.6,'low','low'),
  ('aurel','Aurel','developed',25,1.4,1.5,'high','high'),
  ('nova','Nova','emerging',13,1.0,1.0,'medium','medium'),
  ('kethos','Kethos','developing',8,0.75,0.7,'low','low'),
  ('solven','Solven','emerging',15,1.1,1.0,'medium','medium'),
  ('rynna','Rynna','emerging',11,0.9,0.85,'medium','medium'),
  ('bren','Bren','developed',18,1.2,1.1,'high','medium'),
  ('zara','Zara','developing',6,0.7,0.6,'low','low'),
  ('orval','Orval','developing',9,0.8,0.75,'low','low'),
  ('pella','Pella','developed',16,1.05,1.1,'high','high'),
  ('tyrn','Tyrn','developing',5,0.75,0.6,'low','low')
on conflict (id) do nothing;

-- Country → resources
insert into larva_world.country_resources (country_id, resource_id) values
  ('meris','agricultural_products'),('vesk','agricultural_products'),('nova','agricultural_products'),('rynna','agricultural_products'),('zara','agricultural_products'),
  ('korr','metals_minerals'),('thorn','metals_minerals'),('kethos','metals_minerals'),('orval','metals_minerals'),('pella','metals_minerals'),
  ('korr','petroleum_synthetics'),('dravel','petroleum_synthetics'),('solven','petroleum_synthetics'),('rynna','petroleum_synthetics'),
  ('meris','natural_fibers'),('vesk','natural_fibers'),('zara','natural_fibers'),('tyrn','natural_fibers'),
  ('valen','chemical_compounds'),('thorn','chemical_compounds'),('solven','chemical_compounds'),
  ('cassen','timber_wood'),('lorren','timber_wood'),('nova','timber_wood'),('bren','timber_wood'),('tyrn','timber_wood'),
  ('lorren','stone_aggregate'),('aurel','stone_aggregate'),('kethos','stone_aggregate'),('orval','stone_aggregate'),('tyrn','stone_aggregate')
on conflict do nothing;

-- Country → sector specialization bonuses
insert into larva_world.country_specializations (country_id, sector_id, bonus_pct) values
  ('meris','food_hospitality',20),('zara','food_hospitality',15),('nova','food_hospitality',10),
  ('cassen','logistics_transport',20),('rynna','logistics_transport',15),('korr','logistics_transport',10),
  ('aurel','retail',20),('pella','retail',15),('cassen','retail',10),
  ('lorren','construction_real_estate',20),('orval','construction_real_estate',15),('tyrn','construction_real_estate',10),
  ('valen','finance',15),('dravel','finance',15),
  ('valen','professional_services',15),('bren','professional_services',15),('solven','professional_services',10),
  ('korr','manufacturing',20),('vesk','manufacturing',15),('kethos','manufacturing',15),('solven','manufacturing',15),
  ('thorn','technology',20),('pella','technology',15),
  ('bren','education_training',20),('nova','education_training',15),('thorn','education_training',10),('aurel','education_training',10)
on conflict do nothing;
