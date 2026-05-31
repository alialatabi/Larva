-- 006 — Canonical schema: larva_economy + larva_logistics
--
-- Part 2 of 4. Depends on 005 (larva_economy.sectors, larva_world.countries,
-- larva_world.properties, larva_core.skills). Additive & idempotent.
-- Companies, employees, the B2B contract/order web, inventory, and the
-- mandatory-logistics transport layer. All economic mutation is performed
-- server-side (Edge Functions / reconciliation) — these tables are read-only
-- to the client. No client INSERT/UPDATE policies.

-- ── Company types (per sector) — see docs/larva_sector_*.md ───────────────────
create table if not exists larva_economy.company_types (
  id          text primary key,    -- slug
  sector_id   text not null references larva_economy.sectors(id),
  name        text not null,
  is_b2b      boolean not null default false,
  description text not null default ''
);
alter table larva_economy.company_types enable row level security;
drop policy if exists "company_types_read_all" on larva_economy.company_types;
create policy "company_types_read_all" on larva_economy.company_types for select using (true);

-- ── Job roles (skill-mapped) — see docs/larva_skills_system.md ────────────────
create table if not exists larva_economy.job_roles (
  id              text primary key,   -- slug
  name            text not null,
  sector_id       text references larva_economy.sectors(id),
  primary_skill   text references larva_core.skills(id),
  secondary_skill text references larva_core.skills(id),
  is_entry_level  boolean not null default false,
  is_admin_role   boolean not null default false   -- only gains real authority when held by a player
);
alter table larva_economy.job_roles enable row level security;
drop policy if exists "job_roles_read_all" on larva_economy.job_roles;
create policy "job_roles_read_all" on larva_economy.job_roles for select using (true);

-- ── Companies ────────────────────────────────────────────────────────────────
-- A company without real transactions has near-zero value (design rule).
create table if not exists larva_economy.companies (
  id              uuid primary key default gen_random_uuid(),
  owner_player    uuid references auth.users(id) on delete set null,   -- null = Central Corporation
  parent_company  uuid references larva_economy.companies(id) on delete set null, -- branch → parent
  company_type_id text not null references larva_economy.company_types(id),
  country_id      text not null references larva_world.countries(id),
  name            text not null,
  is_central_corp boolean not null default false,
  valuation       bigint not null default 0,
  reputation      integer not null default 50 check (reputation between 0 and 100),
  status          text not null default 'active' check (status in ('active','suspended','bankrupt','dissolved')),
  is_listed       boolean not null default false,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);
create index if not exists companies_owner_idx   on larva_economy.companies (owner_player);
create index if not exists companies_country_idx on larva_economy.companies (country_id, company_type_id);
create index if not exists companies_parent_idx  on larva_economy.companies (parent_company);

-- A company operates from one or more properties (branches). -------------------
create table if not exists larva_economy.company_branches (
  id          uuid primary key default gen_random_uuid(),
  company_id  uuid not null references larva_economy.companies(id) on delete cascade,
  property_id uuid references larva_world.properties(id) on delete set null,
  country_id  text not null references larva_world.countries(id),
  is_hq       boolean not null default false,
  created_at  timestamptz not null default now()
);
create index if not exists company_branches_company_idx on larva_economy.company_branches (company_id);

-- ── Employees (NPC or player) ────────────────────────────────────────────────
create table if not exists larva_economy.employees (
  id              uuid primary key default gen_random_uuid(),
  company_id      uuid not null references larva_economy.companies(id) on delete cascade,
  branch_id       uuid references larva_economy.company_branches(id) on delete set null,
  role_id         text references larva_economy.job_roles(id),
  employee_type   text not null check (employee_type in ('npc','player')),
  player_id       uuid references auth.users(id) on delete set null,  -- when employee_type = player
  display_name    text not null,
  salary          bigint not null default 0,        -- per cycle
  efficiency      numeric not null default 1.0,     -- recomputed each tick
  permissions     jsonb not null default '{}'::jsonb,
  status          text not null default 'active' check (status in ('active','on_leave','terminated')),
  hired_cycle     integer,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);
create index if not exists employees_company_idx on larva_economy.employees (company_id, status);
create index if not exists employees_player_idx  on larva_economy.employees (player_id);

-- Open positions / job listings players can apply to. -------------------------
create table if not exists larva_economy.job_listings (
  id           uuid primary key default gen_random_uuid(),
  company_id   uuid not null references larva_economy.companies(id) on delete cascade,
  role_id      text references larva_economy.job_roles(id),
  country_id   text not null references larva_world.countries(id),
  salary       bigint not null default 0,
  min_skill    integer not null default 0,
  is_open      boolean not null default true,
  created_at   timestamptz not null default now()
);
create index if not exists job_listings_open_idx on larva_economy.job_listings (country_id, is_open);

create table if not exists larva_economy.job_applications (
  id           uuid primary key default gen_random_uuid(),
  listing_id   uuid not null references larva_economy.job_listings(id) on delete cascade,
  player_id    uuid not null references auth.users(id) on delete cascade,
  status       text not null default 'pending' check (status in ('pending','accepted','rejected','withdrawn')),
  created_at   timestamptz not null default now()
);
create index if not exists job_applications_player_idx on larva_economy.job_applications (player_id);

-- ── Products / catalog a company produces or sells ───────────────────────────
create table if not exists larva_economy.products (
  id            uuid primary key default gen_random_uuid(),
  company_id    uuid not null references larva_economy.companies(id) on delete cascade,
  name          text not null,
  quality_tier  text not null default 'standard' check (quality_tier in ('basic','standard','premium','luxury')),
  unit_price    bigint not null default 0,
  created_at    timestamptz not null default now()
);
create index if not exists products_company_idx on larva_economy.products (company_id);

-- ── Inventory (stock held at a company/branch) ───────────────────────────────
create table if not exists larva_economy.inventory (
  id            uuid primary key default gen_random_uuid(),
  company_id    uuid not null references larva_economy.companies(id) on delete cascade,
  branch_id     uuid references larva_economy.company_branches(id) on delete set null,
  product_id    uuid references larva_economy.products(id) on delete set null,
  resource_id   text references larva_world.resources(id),    -- raw materials
  quantity      numeric not null default 0,
  quality_tier  text not null default 'standard' check (quality_tier in ('basic','standard','premium','luxury')),
  spoilage_at   timestamptz,                                  -- perishable expiry
  updated_at    timestamptz not null default now()
);
create index if not exists inventory_company_idx on larva_economy.inventory (company_id);

-- ── Contracts (B2B supplier/client agreements) ───────────────────────────────
create table if not exists larva_economy.contracts (
  id              uuid primary key default gen_random_uuid(),
  seller_company  uuid references larva_economy.companies(id) on delete set null,
  buyer_company   uuid references larva_economy.companies(id) on delete set null,
  product_id      uuid references larva_economy.products(id) on delete set null,
  resource_id     text references larva_world.resources(id),
  contract_type   text not null default 'short_term' check (contract_type in ('long_term','short_term')),
  quantity        numeric not null default 0,
  unit_price      bigint not null default 0,
  total_value     bigint not null default 0,
  status          text not null default 'pending' check (status in ('pending','active','fulfilled','cancelled','defaulted')),
  start_cycle     integer,
  end_cycle       integer,
  same_owner_flag boolean not null default false,   -- circular-transaction detection
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);
create index if not exists contracts_seller_idx on larva_economy.contracts (seller_company, status);
create index if not exists contracts_buyer_idx  on larva_economy.contracts (buyer_company, status);

-- ── Orders (B2C / discrete fulfilment units processed each tick) ─────────────
create table if not exists larva_economy.orders (
  id              uuid primary key default gen_random_uuid(),
  company_id      uuid not null references larva_economy.companies(id) on delete cascade,
  contract_id     uuid references larva_economy.contracts(id) on delete set null,
  buyer_player    uuid references auth.users(id) on delete set null,  -- B2C customer
  product_id      uuid references larva_economy.products(id) on delete set null,
  quantity        numeric not null default 0,
  unit_price      bigint not null default 0,
  total_amount    bigint not null default 0,
  status          text not null default 'placed' check (status in ('placed','assigned','in_progress','fulfilled','cancelled')),
  placed_cycle    integer,
  fulfilled_cycle integer,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);
create index if not exists orders_company_idx on larva_economy.orders (company_id, status);

-- ════════════════════════════════════════════════════════════════════════════
-- larva_logistics — mandatory transport for physical B2B goods
-- ════════════════════════════════════════════════════════════════════════════

create table if not exists larva_logistics.transport_contracts (
  id                  uuid primary key default gen_random_uuid(),
  source_contract     uuid references larva_economy.contracts(id) on delete cascade,
  origin_country      text references larva_world.countries(id),
  dest_country        text references larva_world.countries(id),
  buyer_company       uuid references larva_economy.companies(id) on delete set null,
  primary_carrier     uuid references larva_economy.companies(id) on delete set null, -- logistics company
  subcontractor       uuid references larva_economy.companies(id) on delete set null,
  offered_price       bigint not null default 0,
  agreed_price        bigint,
  is_international     boolean not null default false,
  status              text not null default 'open' check (status in ('open','accepted','in_transit','delivered','failed','cancelled')),
  penalty             bigint not null default 0,        -- paid by carrier on failed delivery
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now()
);
create index if not exists transport_status_idx on larva_logistics.transport_contracts (status);

create table if not exists larva_logistics.shipments (
  id                  uuid primary key default gen_random_uuid(),
  transport_contract  uuid not null references larva_logistics.transport_contracts(id) on delete cascade,
  leg                 text not null default 'delivery' check (leg in ('freight','delivery')),
  spoilage_modifier   numeric not null default 1.0,
  damage_pct          numeric not null default 0,
  dispatched_cycle    integer,
  arrived_cycle       integer,
  status              text not null default 'pending' check (status in ('pending','in_transit','arrived','lost')),
  created_at          timestamptz not null default now()
);
create index if not exists shipments_contract_idx on larva_logistics.shipments (transport_contract);

-- ── RLS — read-only; world/company tables readable, ownership-scoped where personal
do $$
declare t text;
begin
  foreach t in array array[
    'larva_economy.companies','larva_economy.company_branches','larva_economy.employees',
    'larva_economy.job_listings','larva_economy.job_applications','larva_economy.products',
    'larva_economy.inventory','larva_economy.contracts','larva_economy.orders',
    'larva_logistics.transport_contracts','larva_logistics.shipments'
  ] loop
    execute format('alter table %s enable row level security', t);
  end loop;
end $$;

-- Companies + public market data: world-readable (valuations, listings drive the economy UI)
drop policy if exists "companies_read_all" on larva_economy.companies;
create policy "companies_read_all" on larva_economy.companies for select using (true);
drop policy if exists "branches_read_all" on larva_economy.company_branches;
create policy "branches_read_all" on larva_economy.company_branches for select using (true);
drop policy if exists "products_read_all" on larva_economy.products;
create policy "products_read_all" on larva_economy.products for select using (true);
drop policy if exists "job_listings_read_all" on larva_economy.job_listings;
create policy "job_listings_read_all" on larva_economy.job_listings for select using (true);

-- Owner/employee-scoped reads for operational detail
drop policy if exists "employees_visible" on larva_economy.employees;
create policy "employees_visible" on larva_economy.employees for select using (
  player_id = auth.uid()
  or exists (select 1 from larva_economy.companies c where c.id = company_id and c.owner_player = auth.uid())
);
drop policy if exists "inventory_owner" on larva_economy.inventory;
create policy "inventory_owner" on larva_economy.inventory for select using (
  exists (select 1 from larva_economy.companies c where c.id = company_id and c.owner_player = auth.uid())
);
drop policy if exists "orders_owner" on larva_economy.orders;
create policy "orders_owner" on larva_economy.orders for select using (
  buyer_player = auth.uid()
  or exists (select 1 from larva_economy.companies c where c.id = company_id and c.owner_player = auth.uid())
);
drop policy if exists "job_apps_own" on larva_economy.job_applications;
create policy "job_apps_own" on larva_economy.job_applications for select using (player_id = auth.uid());
drop policy if exists "contracts_party" on larva_economy.contracts;
create policy "contracts_party" on larva_economy.contracts for select using (
  exists (select 1 from larva_economy.companies c where c.id in (seller_company, buyer_company) and c.owner_player = auth.uid())
);
drop policy if exists "transport_read_all" on larva_logistics.transport_contracts;
create policy "transport_read_all" on larva_logistics.transport_contracts for select using (true);
drop policy if exists "shipments_read_all" on larva_logistics.shipments;
create policy "shipments_read_all" on larva_logistics.shipments for select using (true);

-- ── updated_at triggers ──────────────────────────────────────────────────────
do $$
declare t text;
begin
  foreach t in array array[
    'larva_economy.companies','larva_economy.employees','larva_economy.inventory',
    'larva_economy.contracts','larva_economy.orders','larva_logistics.transport_contracts'
  ] loop
    execute format('drop trigger if exists set_updated_at on %s', t);
    execute format('create trigger set_updated_at before update on %s for each row execute procedure public.touch_updated_at()', t);
  end loop;
end $$;

-- ── SEED — company types per sector ──────────────────────────────────────────
insert into larva_economy.company_types (id, sector_id, name, is_b2b) values
  -- Sector 1: Food & Hospitality
  ('restaurant','food_hospitality','Restaurant',false),
  ('cafe','food_hospitality','Café',false),
  ('catering','food_hospitality','Catering',true),
  ('food_manufacturing','food_hospitality','Food Manufacturing',true),
  ('supermarket','food_hospitality','Supermarket',false),
  -- Sector 2: Logistics & Transport
  ('delivery_company','logistics_transport','Delivery Company',true),
  ('trucking_freight','logistics_transport','Trucking / Freight',true),
  -- Sector 3: Retail
  ('general_store','retail','General Store',false),
  ('electronics_store','retail','Electronics Store',false),
  ('clothing_store','retail','Clothing Store',false),
  ('pharmacy','retail','Pharmacy',false),
  -- Sector 4: Construction & Real Estate
  ('construction_company','construction_real_estate','Construction Company',true),
  ('real_estate_agency','construction_real_estate','Real Estate Agency',false),
  ('property_management','construction_real_estate','Property Management',false),
  ('storage_facility','construction_real_estate','Storage Facility',false),
  -- Sector 5: Finance
  ('private_bank','finance','Private Bank',false),
  ('investment_firm','finance','Investment Firm',false),
  ('insurance_company','finance','Insurance Company',false),
  ('accounting_firm','finance','Accounting Firm',true),
  -- Sector 6: Professional Services
  ('legal_firm','professional_services','Legal Firm',true),
  ('recruitment_agency','professional_services','Recruitment Agency',true),
  -- Sector 7: Manufacturing
  ('electronics_manufacturer','manufacturing','Electronics Manufacturer',true),
  ('textile_manufacturer','manufacturing','Textile & Apparel Manufacturer',true),
  ('pharmaceutical_manufacturer','manufacturing','Pharmaceutical Manufacturer',true),
  -- Sector 8: Technology
  ('it_services','technology','IT Services Company',true),
  ('software_firm','technology','Software Firm',true),
  ('data_analytics_firm','technology','Data Analytics Firm',true),
  -- Sector 9: Education & Training
  ('skill_training_center','education_training','Skill Training Center',false),
  ('corporate_training','education_training','Corporate Training Company',true),
  -- Cross-sector
  ('holding_company','cross_sector','Holding Company',false)
on conflict (id) do nothing;

-- ── SEED — entry-level job roles (the on-ramp set) ───────────────────────────
insert into larva_economy.job_roles (id, name, sector_id, primary_skill, secondary_skill, is_entry_level) values
  ('cleaner','Cleaner',null,'organization',null,true),
  ('restaurant_worker','Restaurant Worker','food_hospitality','customer_service','organization',true),
  ('car_wash_worker','Car Wash Worker',null,'customer_service','organization',true),
  ('warehouse_laborer','Warehouse Laborer',null,'organization','manufacturing_production',true),
  ('delivery_worker','Delivery Worker','logistics_transport','driving','organization',true),
  ('supermarket_stock_worker','Supermarket Stock Worker','food_hospitality','organization','customer_service',true),
  ('construction_helper','Construction Helper','construction_real_estate','construction','organization',true),
  ('kiosk_worker','Kiosk Worker','retail','sales','customer_service',true)
on conflict (id) do nothing;
