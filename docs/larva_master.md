# Project Larva — Master Knowledge Base

## Overview

**Project Name:** Project Larva  
**Type:** Massive Multiplayer Online Economic Life Simulation  
**Platforms:** Mobile (iOS, Android) + Web  
**Stack:** Flutter (frontend) + Supabase (backend)  
**Status:** Planning Phase — no code written yet  
**Goal:** Design every system in full detail before any development begins

---

## Document Structure

This knowledge base is split across multiple files for faster editing and easier reference. The master file contains all core systems, cross-sector rules, and indexes. Each sector has its own dedicated file.

| File | Contents |
|------|----------|
| `larva_master.md` | Core systems, cross-sector rules, progress tracker (this file) |
| `larva_system_architecture_v3.md` | Full technical architecture: database schema, Edge Functions, reconciliation pipeline, Partner Program mechanics, real-time subscriptions, Flutter structure, infrastructure |
| `larva_sector_1_food_hospitality.md` | Sector 1: Restaurant, Café, Catering, Food Manufacturing, Supermarket |
| `larva_sector_2_logistics_transport.md` | Sector 2: Delivery Company, Trucking/Freight |
| `larva_sector_3_retail.md` | Sector 3: General Store, Electronics Store, Clothing Store, Pharmacy |
| `larva_sector_4_construction_real_estate.md` | Sector 4: Construction Company, Real Estate Agency, Property Management, Storage Facility |
| `larva_sector_5_finance.md` | Sector 5: Private Bank, Investment Firm, Insurance Company, Accounting Firm |
| `larva_sector_6_professional_services.md` | Sector 6: Legal Firm, Recruitment Agency |
| `larva_sector_7_manufacturing.md` | Sector 7: Electronics Manufacturer, Textile Manufacturer, Pharmaceutical Manufacturer |
| `larva_sector_8_technology.md` | Sector 8: IT Services Company, Software Firm, Data Analytics Firm |
| `larva_sector_9_education.md` | Sector 9: Skill Training Center, Corporate Training Company |
| `larva_skills_system.md` | Skills System: Full taxonomy, 25 skills, role mappings, prerequisite gates, NPC ceilings, career paths |
| `larva_economy_balance.md` | Economy Balance & Inflation Control: Hybrid faucet, tiered fees, NPC recycling, progressive tax, scaling, emergency levers |
| `larva_country_definitions.md` | Country Definitions: All 18 fictional countries with modifiers, resources, specializations, strategic profiles |
| `larva_stock_market.md` | Stock Market: Listing requirements, share structure, IPO process, price discovery, trading mechanics, dividends, delisting, abuse analysis |
| `larva_cross_sector_company_types.md` | Cross-Sector Company Types: Holding Company |
| `larva_banking_system.md` | Banking System Details: Wallet structure, credit scoring, Central Bank lending, private bank loan mechanics, deposit insurance, transfers, bankruptcy, savings, rate adjustments, banking UI |
| `larva_event_system.md` | Event System: All event categories (technology, health, fashion, supply chain, financial, labor, natural/infrastructure, regulatory), natural disaster sub-system with geographic hazard profiles, probability system, notification system, insurance interaction |
| `larva_vision_philosophy.md` | Expanded vision, philosophy, long-term risks, backend philosophy |

### How to Use These Files

- **Designing a new sector or company type:** Open the relevant sector file + this master file for cross-sector rules
- **Checking cross-sector dependencies:** This master file contains all cross-sector rules that apply universally
- **Updating a finalized sector:** Edit only the sector file — do not duplicate content into the master
- **Adding a new system (stock market, banking details, etc.):** Add to the master file or create a new dedicated file and update the index above
- **After any design work:** Update the Planning Progress Tracker at the bottom of this master file

---

## Core Vision

A persistent, player-driven economy where players start from absolute zero and build their financial life through work, skill development, business ownership, investment, and economic decision-making.

The game simulates capitalism, career growth, investment, and financial risk as realistically as possible.

**This is NOT:**
- A casual idle game
- A city builder
- A clicker game
- An open-world RPG

**This IS:**
- A persistent economic simulation
- A player-driven economy
- A multiplayer business ecosystem
- A career and financial life simulation

---

## Core Design Philosophy

- No level system — progression is based on wealth, skills, reputation, assets, company ownership, and investment performance
- The game must feel harsh and realistic — players can lose everything
- Failure is meaningful but not permanently destructive — skills and experience always remain
- Play-to-earn is secondary — fun and simulation depth come first
- The economy must feel difficult and encourage careful decision-making
- All economic logic runs server-side — the system is fully server-authoritative

---

## Time System

| Real Time | In-Game Time |
|-----------|-------------|
| 6 hours | 1 in-game day |

Every 6 hours (1 in-game day) the system processes:
- Salaries
- Business profits and losses
- Loan interest
- Stock price updates
- Contract fulfillment progress
- Economic events
- Player need updates (hunger, energy, etc.)

This means 4 in-game days pass per real day. The economy ticks 4 times per real day.

Implementation: Supabase Edge Functions + scheduled cron execution

---

## Monetization (Finalized)

### Revenue Streams

Four real-money streams. All are pay-to-win safe — no real-money purchase ever grants in-game economic capacity, currency, or advantage.

| Stream | Description | Amount |
|--------|-------------|--------|
| Premium Subscription | Enhanced analytics, market intelligence tools, portfolio dashboards, priority support, cosmetic perks. No in-game economic effect. | $9.99/month |
| Cosmetic Marketplace | Company branding, player avatars, office themes, prestige badges. Zero economic effect. | One-time purchases |
| Partner Program Cut | Platform retains 20% of gross partner payouts. Partners receive 80% of published tier amounts. Self-funding — scales with partner program growth. | 20% of gross payouts |
| Company Transfer Fee | $250 USD real-money legal processing fee paid by the buyer on every private company ownership transfer. Transfer processed through CC Legal Firm in company's country. Listed companies excluded — they transfer via stock market. | $250 per transfer |

**Pay-to-win hard rule:** No purchase ever grants a player more in-game currency, companies, employees, faster skills, cheaper loans, better equipment, or any form of economic capacity. Building from scratch is always free and always viable. Every future revenue idea is tested against this rule before it is added.

### Partner Program (Core Player Incentive)

Players who achieve demonstrable economic success receive monthly real-money payouts. This is the primary incentive for top players to build and maintain the economy. Payouts are skill-based performance rewards — deterministic, measurable, achievable through strategy alone. Not gambling, not investment returns.

| Tier | Requirements | Gross Payout | Net to Partner |
|------|-------------|--------------|----------------|
| Contributor | 1 active company, 30-day revenue > ₳50K | $25/month | $20/month |
| Builder | 3+ companies, 30-day revenue > ₳500K | $100/month | $80/month |
| Entrepreneur | 5+ companies, 1 listed, market cap > ₳5M | $500/month | $400/month |
| Mogul | 10+ companies, 3+ listed, revenue > ₳50M | $2,500/month | $2,000/month |
| Legend | Invitation only, max 5 active at any time | $5,000–10,000/month | $4,000–8,000/month |

**Partner payout wallet** is funded exclusively from real-money platform inflows (subscriptions + cosmetic marketplace revenue). Fully isolated from the in-game economy. Every inflow is recorded in `platform_revenue_log`.

**Partner program launch posture:** Starts conservative with manual approvals while the player base grows. The 5× coverage target (revenue ≥ 5× payout obligations) is a scale milestone, not a launch target. New revenue streams and marketing will be developed in parallel.

### Currency System

- Game-native currency (₳) — no real-money exchange rate
- Players cannot buy or sell in-game currency for real money
- Currency is created by the Central Corporation injection mechanism and circulates through economic activity
- Deflationary pressure maintained by: transaction fees (destroyed), loan interest (destroyed), Central Corporation surplus (destroyed)
- No reserve system — no real-money backing required

### Company Ownership Transfers

- Private company transfers between players require a **$250 USD** real-money processing fee paid by the buyer
- Transfer executed exclusively through the Central Corporation Legal Firm in the company's country
- The company's in-game purchase price is paid separately in ₳ through normal game mechanics
- Listed companies transfer ownership via stock market share trading — the $250 fee does not apply
- New owner faces a 10-cycle cooldown before relisting

### Marketing System (Finalized)

- Any company can purchase marketing to boost visibility in its sector
- Available for **real money** or **in-game currency** (in-game currency costs more to maintain fairness)
- Real money marketing fees are **platform revenue** — they flow into the platform operating fund alongside subscription and cosmetic revenue, fully isolated from the in-game economy
- Marketing only influences approximately **20% of customer flow** — the remaining 80%+ is determined by organic factors: product/service quality, pricing, reputation, and location
- A well-run business without marketing will always outperform a poorly-run business with marketing
- Marketing provides temporary visibility boosts (e.g., top placement on sector pages, recommendations to players)
- This system applies across **all company sectors**, not just Food & Hospitality

---

## Anti-Abuse & Legal (Finalized)

### One Account Per Identity
Enforced through combination of:
- Phone number
- Email address
- IP address + device fingerprint
- KYC verification (at partner application)

### KYC (Know Your Customer)
- Required only at **partner program application** — not at account creation or first play
- Player submits: government-issued ID + selfie + tax document (W-9 or W-8BEN)
- Automated via Sumsub or Stripe Identity
- Account permanently marked as KYC-verified after completion
- Naturally enforces one-account rule — two accounts requires two real identities
- Partner applicants also complete phone verification + 30-day account age check before application is accepted

### Anti-Gaming Protections
- **Circular transaction detection:** Revenue from transactions between a player's own companies is discounted 50% for partner qualification purposes
- **Same-owner flag:** All transactions between related entities are flagged in the transaction ledger
- **Unusual pattern detection:** Revenue spikes >5× rolling average trigger manual review before payout is approved
- **Account selling detection:** Device fingerprint + IP + country changes flag for review
- **Wash trading disqualification:** Stock wash trading detected by market anti-abuse system automatically suspends partner status

### Company Transfer Abuse Prevention
- Each transfer creates a full audit trail (Stripe payment ID + in-game transaction ID + CC Legal Firm record)
- $250 real-money cost is a strong deterrent against fake transfers between alt accounts
- Same-owner detection flags any transfer where buyer and seller share device, IP, or identity signals

---

## Trust & Transparency Framework (Finalized)

Players must trust that the platform is not pay-to-win and that the partner program rewards genuine economic achievement. This framework makes the system verifiable, not just promised.

### Pillar 1: No Real-Money Economic Advantage

No purchase of any kind gives a player more in-game currency, companies, employees, faster skills, cheaper loans, or better equipment. The only real-money transactions are:
- Premium subscription (analytics tools — no economic effect)
- Cosmetic marketplace (appearance — no economic effect)
- Company transfer fee (a service fee for a legal process — the company's value was built through gameplay)

### Pillar 2: Public Real-Time Economic Dashboard

Every player sees a live economic dashboard displaying:
- Total game currency in circulation
- Fees destroyed this cycle (by tier)
- CC injection amount this cycle
- CC surplus destroyed
- Active player count by country
- Active company count by sector
- Partner count by tier
- Platform revenue this month (subscription + cosmetics + transfer fees)

### Pillar 3: Partner Program Integrity

- Partner qualifications are fully deterministic — every metric is visible to the partner in real time
- Tier thresholds are public — anyone can verify what it takes to qualify
- Payouts are audited by admin before execution — no automatic large-scale fraud
- Revenue circularity detection: same-owner transactions discounted 50% for qualification purposes
- Partner count at Legend tier is hard-capped at 5

### Pillar 4: Server-Authoritative Economy

All economic calculations run inside PostgreSQL and Edge Functions. The client displays state and submits intentions — it never calculates outcomes. Players cannot manipulate economic results from the client side.

---

## Country System (Finalized)

18 fictional countries, each a single market. Players choose at account creation; employment, shopping, and business operations are local. Cross-country trade requires international logistics surcharge and extended delivery time. No hard player caps — economic pressure distributes players naturally. Progressive tax (6 brackets, 40% ceiling) redistributes to infrastructure and poor players.

→ **Full design in `larva_country_definitions.md`** (all 18 countries with full modifier profiles)

---

## The Central Corporation (Game-Owned Entity)

The game world does not start empty. At launch a central game-owned corporation acts as the economic backbone.

### Role
- Primary employer at game launch
- Economic stabilizer
- Initial job provider
- Lender / starter bank
- Demand engine — issues contracts that player companies can bid for

### What It Owns at Launch
- At least one of **every company type** in the game across all sectors
- Restaurants, cafés, catering companies, food manufacturers, supermarkets
- Delivery companies, warehouses, logistics operations
- Retail stores, construction companies, real estate agencies
- Banks, investment firms, consulting firms
- Factories, tech companies, training centers
- Entry-level businesses that provide beginner jobs

### What It Provides
- Beginner jobs with beginner salaries
- Small starter loans
- Contracts for player companies to fulfill
- Basic economic stability during early game

### Long-Term
- Its market share decreases as the player economy grows
- Assets can be privatized or sold to players over time
- Players can eventually buy shares of the Central Corporation
- Acts as anti-collapse mechanism — never disappears entirely but becomes less dominant

---

## Career & Skills System (Finalized)

Players can remain employees forever. Progression through skill levels, experience, reputation, and track record — no level system. 25 skills across Tier 1 (Foundation, 8 skills) and Tier 2 (Domain — 9 freely accessible + 8 prerequisite-gated). NPC employees plateau at natural ceilings; only Corporate Training breaks past them. Skills are permanent and survive bankruptcy.

→ **Full design in `larva_skills_system.md`** (complete taxonomy, NPC ceilings, role mappings, career paths)

---

## Player Needs System (Finalized)

7 needs processed each tick. Neglect reduces work efficiency; severe neglect causes job loss. Creates guaranteed organic demand across sectors.

| Need | Sector Demand |
|------|--------------|
| Hunger | Food & Hospitality |
| Energy | Food, work-life balance |
| Health | Pharmacy, Healthcare |
| Happiness | Clothing, Entertainment |
| Housing | Real Estate |
| Transportation | Logistics |
| Drive & Ambition | Education & Training |

---

## Company System (Core Design)

### Fundamental Rule
**A company without a real product or service cannot have real value.**

Every company must actively produce or deliver something to generate revenue. Shell companies with no transactions die naturally from operating costs.

### Company Creation Requirements
When a player creates a company they must:
1. Choose a business sector
2. Meet minimum operational requirements (employees, costs)
3. Begin generating real transactions to establish value

### Work Mechanic (Finalized)

```
Order / Contract Arrives
        ↓
Owner Assigns Employees to Fulfill It
        ↓
Tick Processes Output (every 6 real hours):
Output = Employee Skill Level × Hours Worked × Efficiency Rating
        ↓
Contract Fulfilled → Revenue Earned → Valuation Updated
```

### Employee Efficiency Variables
- Skill level in the relevant role
- Experience in that position
- Salary satisfaction (underpaid = efficiency drops)
- Workload level (overworked = efficiency drops)

### Company Valuation Algorithm (Real-Time)

The algorithm calculates company value based on:
- Verified revenue from actual transactions
- Net profit margin
- Total assets owned
- Active employee count and skill levels
- Debt levels
- Growth rate over time
- Market share in sector
- Customer retention metrics
- Reputation score
- Stock performance (if listed)

**Zero transactions = near-zero valuation. No exceptions.**

Players can also negotiate freely in the open market — the algorithm provides a fair value reference point, not a hard price.

---

## Company Sectors (All Designed)

| # | Sector | Company Types | File |
|---|--------|--------------|------|
| 1 | Food & Hospitality | Restaurant, Café, Catering, Food Manufacturing, Supermarket | `larva_sector_1_food_hospitality.md` |
| 2 | Logistics & Transport | Delivery Company, Trucking/Freight | `larva_sector_2_logistics_transport.md` |
| 3 | Retail | General Store, Electronics Store, Clothing Store, Pharmacy | `larva_sector_3_retail.md` |
| 4 | Construction & Real Estate | Construction Company, Real Estate Agency, Property Management, Storage Facility | `larva_sector_4_construction_real_estate.md` |
| 5 | Finance | Private Bank, Investment Firm, Insurance Company, Accounting Firm | `larva_sector_5_finance.md` |
| 6 | Professional Services | Legal Firm, Recruitment Agency | `larva_sector_6_professional_services.md` |
| 7 | Manufacturing | Electronics Mfr, Textile & Apparel Mfr, Pharmaceutical Mfr | `larva_sector_7_manufacturing.md` |
| 8 | Technology | IT Services, Software Firm, Data Analytics Firm | `larva_sector_8_technology.md` |
| 9 | Education & Training | Skill Training Center, Corporate Training Company | `larva_sector_9_education.md` |
| — | Cross-Sector | Holding Company | `larva_cross_sector_company_types.md` |

---

## Cross-Sector Rules (Apply to All Sectors)

### General Principles (All Sectors)
- Each company type has a realistic business model mirroring real-world operations
- Mechanics are streamlined for dashboard/menu-based play — no micromanagement
- Owners make strategic decisions; employees execute automatically each tick
- All companies require real estate (rented or owned) to operate
- Expansion to new branches requires acquiring additional commercial property through the real estate sector
- All branches of a business operate under one parent company (the first branch)
- Companies can negotiate **long-term or short-term contracts** with suppliers
  - Long-term: locked-in price for a set period, stable costs, less flexibility
  - Short-term: flexibility to switch suppliers, but vulnerable to price changes and shortages

### Mandatory Logistics (Cross-Sector Rule)
- All B2B transactions involving physical goods **require** a logistics company to transport them
- Goods do not transfer automatically — a transport contract must be fulfilled by a delivery company or trucking/freight company
- Two contract flows exist:
  - **Buyer-initiated purchase:** Buyer contracts to buy goods → transport contract auto-generated → buyer sets transport price → logistics companies accept/reject/counter-offer
  - **Seller-listed goods:** Seller posts sell contract → buyer purchases → buyer creates transport contract with purchase details → sends to logistics companies → they accept/reject/counter-offer
- All transport contracts are visible to both delivery companies and freight companies
- Either type can accept as **primary contractor** and subcontract the other type when needed
- Primary contractor pays the subcontractor from their own revenue and keeps the margin
- Buyer only deals with the primary contractor
- Large/heavy shipments require both freight (bulk haul) and delivery (last mile) — the primary contractor arranges the subcontract
- Failed deliveries incur **financial penalties** paid by the primary contractor to the buyer

### Spoilage & Damage During Transport (Cross-Sector Rule)
- Spoilage timer starts at production and runs continuously
- During transport, spoilage rate is modified by the logistics company's **Spoilage Modifier**
- `Spoilage Modifier = Base Rate × (1 / Avg Driver Skill) × (1 / Avg Handler Skill) × Equipment Factor`
- Low-skill workers + poor equipment = modifier above 1.0 (goods decay faster in transit)
- High-skill workers + good equipment = modifier below 1.0 (goods preserved better than sitting on a shelf)
- Premium quality goods amplify penalties for low skill — bad handling ruins premium ingredients faster
- Non-perishable heavy goods use a **Damage System** instead — goods arrive partially damaged based on crew skill and equipment quality
- If both freight and delivery are involved, spoilage/damage modifiers stack across both legs

### Employee & Delegation System (Cross-Sector Rule)
- Companies can hire **NPC employees** or **real player employees**
- **NPC employees:**
  - Can fill any role to keep the company operational
  - Zero decision-making — all decisions fall back to the company owner
  - Can sit in administrative positions but function with no authority
  - Significantly cheaper than real players
  - Fixed baseline efficiency, no growth
- **Real player employees:**
  - Fill roles AND make decisions within their granted authority
  - A real player manager can approve contracts, handle suppliers, assign staff
  - More expensive but enable the company to run without the owner being present
  - Their skills grow over time, increasing their value
  - Can eventually leave and start their own companies
- **Administrative roles** (manager, dispatcher, etc.) only gain real decision-making power when filled by real players
- **Customizable permissions:** Owners define what each role or individual employee is allowed to do (e.g., approve contracts up to $X value, hire/fire NPCs, adjust pricing within a range, negotiate supplier deals)
- Permissions can be expanded or restricted at any time by the owner
- Activity logs allow owners to review decisions made by their employees
- This creates mutual dependency: owners need player employees to scale, players need jobs to earn and progress

### Charisma (Composite Stat — Cross-Sector Rule)

Charisma is **not a skill** — it is a dynamic composite modifier recalculated each tick based on four factors:

| Factor | Source |
|--------|--------|
| Happiness | Player need — affected by quality of life, job satisfaction, success |
| Clothing Tier | Current clothing worn — purchased from Clothing Stores (Sector 3) |
| Energy | Player need — depletes from work, restored by rest and food |
| Account Balance | Current wealth — higher balance = higher Charisma contribution |

**What Charisma Affects:**
- Negotiation outcomes (supplier contracts, salary negotiations, company acquisitions)
- Sales performance (customer-facing job efficiency)
- Contract bidding success (competing for contracts against other companies)
- Hiring and salary negotiations (both as employer and employee)

**Design Logic:**
- Skills (Negotiation, Sales, etc.) set the performance ceiling
- Charisma determines how close the player gets to that ceiling on any given tick
- A skilled negotiator with tanked Charisma still underperforms their potential
- An unskilled player with high Charisma still can't exceed a low skill ceiling

**Virtuous Cycle:** Good clothes + money + rest + happiness → high Charisma → better deals → more money → cycle reinforces

**Vicious Cycle:** Broke + overworked + unhappy + bad clothes → low Charisma → worse outcomes → less money → harder to recover

**Not a dead end:** Raw skills are permanent. A skilled player in a bad stretch still outperforms an unskilled player having a good day. Charisma is a modifier, not a replacement.

---

## Supply Chain System

Companies across sectors interact through B2B transactions, creating a natural economic web.

### Example Supply Chain
```
Central Corporation (raw materials)
      ↓ (sells materials — transported by Trucking/Freight)
Food Manufacturing Company
      ↓ (sells products — transported by Delivery Company)
Supermarket / Grocery Store
      ↓ (sells to players)
End Customer (Player)
```

Every arrow in the chain is a real financial transaction. Every company earns revenue. Every employee contributes to output.

---

## Stock Market System

Fully designed. See `larva_stock_market.md` for complete details.

**Key parameters:** 10,000 shares per company, 10–49% IPO offering, founder retains 51% minimum and permanent control, algorithm-driven fair value with ±30% demand modifier, 0.75% transaction fee per trade, 40-tick founder lock-up, IPO funds restricted to company account, manual listing approval with auto-qualify thresholds, no short selling at launch, Central Corporation not listed.

---

## Banking & Loans System

Fully designed. See `larva_banking_system.md` for complete details.

**Key parameters:** Personal wallet + company account separation, owner draw mechanic (capped at prior tick net profit, 50% cap if loans outstanding), credit score 0–1000 (starting 500), Central Bank direct lending (4 products, simple interest, auto/manual approval), private bank loan terms (5–80 ticks, collateral system, early repayment allowed), deposit insurance cap 50,000 per player per bank, cross-country transfer surcharge 0.5%, bankruptcy trigger requires sustained insolvency (all four conditions simultaneously), post-bankruptcy restrictions (20-tick loan ban, 10-tick company ban), Central Bank rate adjustment with 28-tick notice and hard bounds.

---

## Failure & Bankruptcy (Finalized)

Fully designed. See `larva_banking_system.md` Section 7 for complete mechanics.

**Key parameters:** Requires all four conditions simultaneously (zero wallet, no positive company accounts, 3+ tick overdue loans, debt exceeds assets by 50%+). 4-tick liquidation. Assets sold: stocks → companies (60%) → real estate (70%). Credit score -200. Post-bankruptcy: keep skills, employment, account. No loans for 20 ticks, no companies for 10 ticks.

---

## Event System

Fully designed. See `larva_event_system.md` for complete details.

**Key parameters:** 8 event categories (Technology, Health, Fashion, Supply Chain, Financial, Labor, Natural/Infrastructure, Regulatory). 4 scopes (Global, Regional, Country, Sector). 3 severity tiers (Minor/Major/Crisis). Probability = base rate × condition multipliers (loaded by world state, never purely random). Cooldowns per event type prevent stacking. Max 3 simultaneous Tier 2+ events globally. 5 natural disaster types (Earthquake, Coastal Storm, Drought, Flood, Wildfire) mapped to specific countries via Geographic Hazard Profiles. Infrastructure level modifies disaster probability and severity. All events generate automatic insurance claims where applicable. Data Analytics subscribers get leading indicators 1–2 ticks early for economic events.

---

## Technical Architecture (Finalized)

**Model:** Hybrid — real-time transactions (instant, Edge Functions) + periodic reconciliation (every 6 hours, pg_cron).
**Stack:** Flutter + Supabase (PostgreSQL, Edge Functions/Deno, Realtime, Stripe, Sumsub/Stripe Identity).
**Schema namespaces:** `larva_core`, `larva_economy`, `larva_finance`, `larva_market`, `larva_world`, `larva_logistics`, `larva_partners`, `larva_admin`.

→ **Full design in `larva_system_architecture_v3.md`** (complete schema, Edge Function catalog, reconciliation pipeline, Partner Program mechanics, Flutter structure, infrastructure)

---

## Design Priorities

1. Realistic economy
2. Meaningful progression
3. Real consequences for decisions
4. Player-driven systems
5. Scalability
6. Long-term retention
7. Deep simulation
8. Strong multiplayer interaction

### Hard Rules
- No pay-to-win systems — ever. No real-money purchase gives economic capacity, currency, or in-game advantage
- No unrealistic money generation
- No over-simplified idle mechanics
- No artificial progression systems
- All economic logic runs server-side only
- Every new revenue stream is tested against the pay-to-win rule before being added
- Company ownership transfers are processed exclusively through the CC Legal Firm — no direct player-to-player transfers
- Partner payouts are performance rewards, not gambling or investment returns

---

## Key Design Patterns

→ **Full pattern reference in `larva-design` skill `references/design-dna.md`** (all 16 patterns in lookup-table format)

---

## Planning Progress Tracker

| Area | Status |
|------|--------|
| Core Vision & Philosophy | ✅ Complete |
| Time System | ✅ Complete (6 real hours = 1 in-game day) |
| Monetization | ✅ Complete (updated: four-stream model — subscription, cosmetics, partner cut, transfer fee) |
| Currency System | ✅ Complete (updated: no real-money exchange, no reserve system) |
| Partner Program | ✅ Complete (5 tiers, 20% platform cut, hysteresis demotion, Legend cap = 5) |
| Company Transfer Fee | ✅ Complete ($250 USD, CC Legal Firm, 10-cycle cooldown, dual-layer flow) |
| Anti-Abuse & KYC | ✅ Complete (updated: KYC at partner application, not cashout) |
| Trust & Transparency Framework | ✅ Complete (updated: no reserve pillars, replaced with partner integrity and P2W pillars) |
| Central Corporation | ✅ Complete |
| Career System | ✅ Complete |
| Skills System | ✅ Complete (full taxonomy in `larva_skills_system.md`) |
| Player Needs System | ✅ Complete (needs identified, detailed balancing pending) |
| Marketing System | ✅ Complete |
| Company Work Mechanic | ✅ Complete |
| Company Valuation Model | ✅ Complete |
| Company Sectors (identified) | ✅ Complete |
| Branch & Expansion Model | ✅ Complete |
| Supplier Contract System | ✅ Complete |
| Food & Hospitality — Restaurant | ✅ Design Complete |
| Food & Hospitality — Café | ✅ Design Complete |
| Food & Hospitality — Catering | ✅ Design Complete |
| Food & Hospitality — Food Manufacturing | ✅ Design Complete |
| Food & Hospitality — Supermarket/Grocery | ✅ Design Complete |
| Logistics & Transport — Delivery Company | ✅ Design Complete |
| Logistics & Transport — Trucking/Freight | ✅ Design Complete |
| Logistics & Transport — Warehouse/Storage | ↗️ Moved to Construction & Real Estate |
| Mandatory Logistics (cross-sector rule) | ✅ Complete |
| Spoilage & Damage During Transport (cross-sector rule) | ✅ Complete |
| Employee & Delegation System (cross-sector rule) | ✅ Complete |
| Charisma Composite Stat (cross-sector rule) | ✅ Complete |
| Country System (framework) | ✅ Complete |
| Retail — General Store | ✅ Design Complete |
| Retail — Electronics Store | ✅ Design Complete |
| Retail — Clothing Store | ✅ Design Complete |
| Retail — Pharmacy | ✅ Design Complete |
| Central Bank Regulatory Fee (cross-finance rule) | ✅ Complete |
| Finance — Private Bank | ✅ Design Complete |
| Finance — Investment Firm | ✅ Design Complete |
| Finance — Insurance Company | ✅ Design Complete |
| Finance — Accounting Firm | ✅ Design Complete |
| Country Definitions (18 individual countries) | ✅ Complete (see `larva_country_definitions.md`) |
| Construction & Real Estate — Construction Company | ✅ Design Complete |
| Construction & Real Estate — Real Estate Agency | ✅ Design Complete |
| Construction & Real Estate — Property Management Company | ✅ Design Complete |
| Construction & Real Estate — Storage Facility | ✅ Design Complete |
| Professional Services — Legal Firm | ✅ Design Complete |
| Professional Services — Recruitment Agency | ✅ Design Complete |
| Raw Materials Framework (cross-sector rule) | ✅ Complete |
| Manufacturing — Electronics Manufacturer | ✅ Design Complete |
| Manufacturing — Textile & Apparel Manufacturer | ✅ Design Complete |
| Manufacturing — Pharmaceutical Manufacturer | ✅ Design Complete |
| Technology — IT Services Company | ✅ Design Complete |
| Technology — Software Firm | ✅ Design Complete |
| Technology — Data Analytics Firm | ✅ Design Complete |
| Education & Training — Skill Training Center | ✅ Design Complete |
| Education & Training — Corporate Training Company | ✅ Design Complete |
| Cross-Sector — Holding Company | ✅ Design Complete |
| Skills System Full Taxonomy | ✅ Complete |
| Economy Balance & Inflation Control | ✅ Complete (see `larva_economy_balance.md`) |
| Stock Market Details | ✅ Complete (see `larva_stock_market.md`) |
| Banking System Details | ✅ Complete (see `larva_banking_system.md`) |
| Event System | ✅ Complete (see `larva_event_system.md`) |
| System Architecture | ✅ Complete (see `larva_system_architecture_v3.md`) |
| Database Schema | ✅ Complete (see `larva_system_architecture_v3.md` Section 2) |
| API Architecture | ✅ Complete (see `larva_system_architecture_v3.md` Section 6) |
| Frontend Design | 🔜 Pending |

---

*Last updated: May 27, 2026 — Master file slimmed: redundant prose sections replaced with compact pointers. Country System, Career/Skills, Player Needs, Company Sectors, Technical Architecture, and Key Design Patterns sections condensed. Full detail lives in dedicated files and larva-design skill.*
