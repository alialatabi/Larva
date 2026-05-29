# Project Larva — Documentation Bundle (for Claude Code)

**What this is:** The complete design + planning knowledge base for **Project Larva**, a massive multiplayer online economic life simulation.

- **Stack:** Flutter (frontend, iOS/Android/Web) + Supabase (backend)
- **Status:** Planning phase — these docs are the ground truth. They define systems to be built; no production code exists yet.
- **The `.jsx` files in `/ui-mockups` are design references only** (built as React artifacts to visualize screens). The real client is Flutter. Use them for layout/copy/flow intent, not as code to port verbatim.

## Hard rules (non-negotiable — enforce in all implementation)

1. No pay-to-win mechanics — ever.
2. No unrealistic money generation.
3. All economic logic runs **server-side only** (Supabase Edge Functions / Postgres). Never trust the client for money, valuations, or balances.
4. Every company must produce real output to have real value.
5. Shell companies must die naturally from operating costs.

## Suggested read order

1. `larva_master.md` — start here. Core systems, cross-sector rules, document index, progress tracker.
2. `larva_vision_philosophy.md` — vision, philosophy, long-term risks.
3. `larva_system_architecture_overview.md` — high-level technical architecture.
4. `larva_system_architecture_impl.md` — full implementation detail: DB schema, Edge Functions, reconciliation pipeline, real-time subscriptions, Flutter structure, infra. **This is the primary engineering reference.**
5. Core systems: `larva_economy_balance.md`, `larva_banking_system.md`, `larva_stock_market.md`, `larva_skills_system.md`, `larva_event_system.md`, `larva_country_definitions.md`, `larva_cross_sector_company_types.md`.
6. Sectors 1–9 (`larva_sector_*.md`) — design each sector's company types as needed.

## File index

| File | Contents |
|------|----------|
| `larva_master.md` | Core systems, cross-sector rules, progress tracker |
| `larva_vision_philosophy.md` | Vision, philosophy, long-term risks, backend philosophy |
| `larva_system_architecture_overview.md` | High-level technical architecture |
| `larva_system_architecture_impl.md` | DB schema, Edge Functions, reconciliation, real-time, Flutter structure, infra |
| `larva_economy_balance.md` | Inflation control, faucets, fees, NPC recycling, tax, emergency levers |
| `larva_banking_system.md` | Wallets, credit scoring, Central Bank lending, loans, deposit insurance, transfers, bankruptcy |
| `larva_stock_market.md` | Listing, IPO, price discovery, trading, dividends, delisting, abuse analysis |
| `larva_skills_system.md` | 25-skill taxonomy, role mappings, prerequisites, NPC ceilings, career paths |
| `larva_event_system.md` | Event categories, natural disasters, geographic hazards, probability + notifications, insurance interaction |
| `larva_country_definitions.md` | 18 fictional countries: modifiers, resources, specializations, strategic profiles |
| `larva_cross_sector_company_types.md` | Cross-sector types (e.g. Holding Company) |
| `larva_sector_1_food_hospitality.md` | Restaurant, Café, Catering, Food Manufacturing, Supermarket |
| `larva_sector_2_logistics_transport.md` | Delivery Company, Trucking/Freight |
| `larva_sector_3_retail.md` | General Store, Electronics, Clothing, Pharmacy |
| `larva_sector_4_construction_real_estate.md` | Construction, Real Estate Agency, Property Mgmt, Storage |
| `larva_sector_5_finance.md` | Private Bank, Investment Firm, Insurance, Accounting Firm |
| `larva_sector_6_professional_services.md` | Legal Firm, Recruitment Agency |
| `larva_sector_7_manufacturing.md` | Electronics, Textile, Pharmaceutical Manufacturers |
| `larva_sector_8_technology.md` | IT Services, Software Firm, Data Analytics |
| `larva_sector_9_education.md` | Skill Training Center, Corporate Training |
| `ui-mockups/*.jsx` | React **design references** for onboarding, company creation wizard, company detail, dashboard |

> Note: filenames were normalized for this bundle (e.g. `larva_master-1-1-1-1-1.md` → `larva_master.md`, `larva_sector_5_finance-1.md` → `larva_sector_5_finance.md`). The document index inside `larva_master.md` references a `larva_system_architecture_v3.md`; that content is split here into `larva_system_architecture_overview.md` + `larva_system_architecture_impl.md`.
