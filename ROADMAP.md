# Project Larva — Build Checklist & Roadmap

> Living document. Update the checkboxes and the **Changelog** as work lands.
> Ground truth for technical scope lives in `CLAUDE.md` and `docs/`.

**Last updated:** 2026-05-31
**Legend:** `[x]` done · `[ ]` todo · `[~]` in progress

---

## Status summary

- All 28 screens exist as UI (most still on mock data)
- Foundation done: theme, router, Supabase client, bottom nav
- **Finance feature fully live** (wallet, transactions, loans, deposits)
- Migrations applied: `001` players · `002` wallets · `003` transactions · `004` loans+deposits
- Dev account + debug auto-login + Management-API migration workflow in place
- **No Edge Functions yet** → no write path / no economy logic. Everything live today is read-only seeded data.

---

## 1. Read-data wiring — remaining screens
Repeatable slice: `table → RLS → realtime → StreamProvider → ConsumerWidget` (+ seed, + live/preview/loading/empty/error states).

- [x] Finance — Wallet
- [x] Finance — Transactions
- [x] Finance — Loans
- [x] Finance — Deposits
- [x] Profile hub — `larva_core.players` (name, country, cycles), + live company count & wallet net worth
- [x] Needs Detail — `larva_core.player_needs`
- [x] Skills Map (25 skills, 3 tiers) — `larva_core.skills` + `player_skills`
- [ ] Jobs — Find Work + My Career (still mock; needs `larva_economy` job listings + employment, populated by §3–4)
- [x] Dashboard — live name (`players`), net-worth hero (wallet-driven count-up + glow), needs (`player_needs`), companies (`larva_economy`), events (`larva_world`), portfolio (`larva_market`). Cycle countdown still a local timer (needs the cycle engine, §4); notification badge + cycle salary/rent figures still mock.
- [ ] Empire — Company List
- [ ] Company Detail — Overview tab
- [ ] Company Detail — Employees tab
- [ ] Company Detail — Orders tab
- [ ] Company Detail — Inventory tab
- [ ] Company Detail — Finances tab
- [ ] Stock Market — listings, holdings, price history, dividends
- [ ] World — Events Feed
- [ ] World — Country Browser
- [ ] Notification Center (+ realtime)

## 2. Database schema completion (8 schemas)

Full canonical schema written + applied (migrations `005`–`008`, 47 tables, reference data seeded). Structure only — not yet API-exposed, not yet populated by gameplay (that's §3–4).

- [x] `larva_core` — players, skills (+25 seed), needs (+7 seed), player_skills, player_needs
- [x] `larva_world` — resources, countries (+18 seed), country_resources, specializations, properties, events
- [x] `larva_economy` — sectors (+10), company_types (+30), job_roles, companies, branches, employees, products, inventory, contracts, orders, job listings/applications
- [x] `larva_logistics` — transport_contracts, shipments (spoilage/damage modifiers)
- [x] `larva_finance` (canonical) — wallets, company_accounts, transactions, credit_scores, loans, loan_products (+3), deposits, insurance
- [x] `larva_market` — listings, holdings, trades, price_history, dividends
- [x] `larva_partners` — partner_tiers (+5), partners, payouts, platform_revenue_log
- [x] `larva_admin` — system_config (+12 keys), cycles, economy_metrics, audit_log
- [x] Schema exposure — all 8 `larva_*` schemas exposed to PostgREST (`009` grants + config patch). Client reads via `supabase.schema('larva_world').from('countries')`; reference tables read-all, owner tables RLS-scoped, admin/config tables locked. Realtime tables still need adding to `supabase_realtime` publication when wired.
- [~] `larva_finance` consolidation — live app still reads `public.wallets/transactions/loans/deposits` (002–004); migrate Finance providers onto canonical `larva_finance.*` next

## 3. Write path — Edge Functions (server-authoritative) — **none exist yet**
Each also needs Flutter optimistic-UI wiring (action → function → confirm / rollback toast).

- [ ] `company-create`
- [ ] `order-place`
- [ ] `stock-trade`
- [ ] `contract-sign`
- [ ] `transfer-money`
- [ ] `loan-apply`
- [ ] `hire-employee`
- [ ] `fire-employee`
- [ ] `buy-property`
- [ ] `company-list-stock`
- [ ] `insurance-claim`
- [ ] `partner-apply`

## 4. Economy engine — the 6-hour cycle

- [ ] `pg_cron` schedule + `reconciliation-coordinator`
- [ ] `reconciliation-country-worker`
- [ ] `reconciliation-global`
- [ ] `event-roller`
- [ ] `valuation-engine`
- [ ] `economy-metrics`
- [ ] Economic math per `docs/larva_economy_balance.md`: salaries, rent, loan installments, needs decay, skill XP, valuations, stock fair value, partner tiers, currency injection

## 5. Real auth & onboarding (replace debug bypass)

- [ ] Real sign-up / sign-in / email-confirmation flow
- [ ] Onboarding: country select + "first day"
- [ ] Session persistence + release route guards
- [ ] Remove hardcoded dev auto-login + `kDebugMode` bypass (`main.dart`, `auth_provider.dart`)

## 6. "Alive" mechanics & per-screen polish (CLAUDE.md "Done" criteria)

- [x] Wallet count-up + gold glow on increase
- [ ] Real `Timer.periodic` cycle countdown bound to `larva_admin` cycle row (amber pulse < 30 min)
- [ ] Company-card status states (operating / issue / critical)
- [ ] Loading skeletons, error toasts, empty states on every screen
- [ ] Offline cache (Hive) + "Last synced X ago" banner

## 7. Monetization (legal model)

- [ ] Premium subscription ($9.99/mo, analytics only)
- [ ] Cosmetic marketplace
- [ ] Partner program payouts (20% cut)
- [ ] $250 company transfer fee
- [ ] Enforce closed-currency / no-pay-to-win guarantees

## 8. Productionization & quality

- [ ] Move Supabase keys out of source → `--dart-define` / build flavors (dev/prod)
- [ ] Tests: unit (economy math), widget (screens), integration (action flows)
- [ ] CI pipeline
- [ ] Clean up pre-existing `withOpacity` → `withValues` lint debt across codebase
- [ ] App icons, splash, store listings, privacy policy
- [ ] Security pass: RLS audit on every table, Edge Function authz, rate limiting, `larva_admin` audit logging

---

## Recommended sequencing

1. **Sections 1–2** — fast, repeatable read slices (same pattern done 4×). Knock out screen-by-screen.
2. **Sections 3–4** — the real engineering: server-authoritative economy. Until these exist, the app is a read-only viewer.
3. **Section 5** — required before any real users.
4. **Sections 6–8** — polish + productionization.

---

## Changelog

- **2026-06-01** — Wired **Dashboard** to live data across 4 schemas: header name (`larva_core.players`), net-worth hero driven by the live wallet (count-up + gold glow on increase, replacing the fake repeating timer), needs (`player_needs`), companies (`larva_economy.companies` + type embed), events (`larva_world.events`), portfolio (`larva_market.holdings` × last price). Honest live empty states for the (still-empty) economy tables; mock kept as no-session preview. Cycle card left as a local timer (needs the engine). `dart analyze` clean; provider queries (incl. cross-FK embeds) verified 200/0-rows via REST.
- **2026-05-31** — Wired **Profile** to live `larva_core` data (first slice against a canonical exposed schema): hub identity/cycles/company-count/net-worth, Needs Detail (`player_needs`), Skills Map (`skills` + `player_skills`, embed query). `FutureProvider`s via `supabase.schema('larva_core')` (larva_* not in realtime publication, and profile data only changes per cycle). Dev user seeded (cycle 47, 7 needs, 25 skills). Jobs tab still mock. `dart analyze` clean.
- **2026-05-31** — Exposed all 8 `larva_*` schemas to the API: migration `009` grants USAGE/SELECT to anon+authenticated (+ default privileges) and hardens RLS on the country reference tables; PostgREST `db_schema` config patched via Management API. Verified: reference tables readable, `larva_admin` locked tables return 0 rows to anon. Client must use `.schema('<name>')` to query non-public schemas.
- **2026-05-31** — Full canonical database schema written + applied (`005`–`008`): all 8 `larva_*` namespaces, 47 tables, with reference data seeded (18 countries + modifiers/resources/specializations, 25 skills, 9+1 sectors, 30 company types, partner tiers, loan products, 12 config keys). Structure-only — not API-exposed, not yet gameplay-populated. §2 complete.
- **2026-05-31** — Finance feature fully wired to live data: wallet (`002`), transaction ledger + atomic `record_transaction` (`003`), loans + deposits (`004`). Migrations applied to remote DB via Management API; dev account + debug auto-login added. Created this roadmap.
