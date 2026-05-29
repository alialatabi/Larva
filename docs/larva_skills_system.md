# Project Larva — Skills System (Full Taxonomy)

> **Status:** ✅ Design Complete
> **Parent document:** See `larva_master.md` for core systems, cross-sector rules, and progress tracker

---

## Design Overview

The skills system is the connective tissue between careers, education, company performance, and the labor market. Every employee role in the game maps to a combination of skills. Every skill has a clear mechanical effect on tick processing. The system is designed to create meaningful specialization without overwhelming complexity.

**Total skill count: 25**
- 8 Foundation Skills (universal, develop through any work)
- 9 Freely Accessible Domain Skills (develop through relevant work, no gate)
- 8 Gated Domain Skills (cannot develop until a prerequisite course is completed at a Skill Training Center)

**Why 25 and not 50 or 10:** Fewer than 20 means most roles share the same skills and specialization doesn't exist — a Cook and a Driver would feel identical. More than 35 means the player profile becomes a spreadsheet and training decisions become paralysis. At 25, a player can realistically specialize in 3–5 skills during a long career, with meaningful tradeoffs about which path to pursue.

---

## Skill Scale & Core Mechanics

### The 0–100 Scale

All skills use a single 0–100 integer scale.

| Range | Label | Meaning |
|---|---|---|
| 0–15 | Novice | Entry-level work. Slow, error-prone. This is where every player starts |
| 16–35 | Basic | Competent. Can handle Standard-tier work reliably |
| 36–55 | Intermediate | Handles Premium-tier work. Competitive in most markets |
| 56–75 | Advanced | High-quality Premium output. Clear competitive edge. Most NPCs never reach this |
| 76–100 | Expert | Top-tier performance. Rare. Meaningful economic advantage over nearly everyone |

### How Skills Develop

**Through work (natural default):**
Every tick a player works, they gain a small amount of experience in the skills relevant to their current role. Gain rate follows a diminishing returns curve — early skill points come fast, later ones come slow.

```
Work XP per tick = Base Rate × Role Relevance Modifier × (1 - Current Skill / 120)
```

The `(1 - Current Skill / 120)` term means gain slows as skill rises but never reaches zero. A player at skill 80 still gains — just very slowly through work alone. The denominator of 120 (not 100) means the formula never produces zero or negative values.

**Base Rate** is a global constant, tuned during balancing. **Role Relevance Modifier** varies by how directly the role uses the skill (primary skill = 1.0, secondary = 0.5, tangential = 0.2).

**Through training (accelerated):**
Enrollment at a Skill Training Center multiplies the work-based gain rate by the Instructor's quality modifier. Player continues working while enrolled — the two run in parallel.

```
Training Multiplier = 1.0 + (Instructor Skill Level / 50)
```

An Instructor at skill 40 → 1.8× multiplier. At skill 70 → 2.4×. At skill 90 → 2.8×. Diminishing returns on instructor quality prevent infinite scaling.

**Through prerequisite unlocking (gated skills only):**
Gated domain skills have zero XP accumulation until the player completes the required foundational course at an accredited Skill Training Center. After completion, the skill behaves like any other — develops through work and can be further accelerated by advanced training courses.

**Through business ownership:**
Players who own and actively operate companies develop Management, Finance, Negotiation, and Marketing passively each tick at 0.3× the work rate. This is slow but meaningful over dozens of in-game days.

### What Players Keep When They Fail

Skills and experience are permanent. A player who loses their company, goes bankrupt, and starts over at an entry-level job retains every skill point they've ever earned. This is the core recovery mechanic — failure hurts financially but never erases capability. A bankrupt ex-restaurant-owner with Culinary Arts 65 can immediately get hired as a premium Cook.

### Skill Visibility

All player skill levels are visible on their public profile. Employers can see exactly what they're hiring. Recruitment Agency Assessors verify these numbers with accuracy dependent on Assessor skill. This transparency is intentional — it drives the labor market and makes hiring decisions strategic.

---

## Tier 1 — Foundation Skills (8)

Foundation skills are universal. They develop through almost any work, improve with experience, and are used across all nine sectors. Every role uses at least one foundation skill. These are the skills that enable career mobility — a player with high Management can manage a restaurant, a factory, or a bank.

### 1. Management

**What it does mechanically:** Multiplies the efficiency of all employees under the player's supervision. A Manager/Director/Foreman with high Management makes their entire team perform above their individual skill levels. Also determines how many employees a business owner can effectively coordinate before needing to hire a Manager.

**Without it:** Owner must micromanage every decision. Employees operate at 70% efficiency cap (no coordination bonus). Growth stalls past 5–6 employees.

**Key roles:** Every Manager, Director, Partner, Site Foreman, Facility Manager, Training Director, Operations Manager, Project Manager

**Develops through:** Any supervisory work. Fastest gain when managing 3+ employees. Business ownership provides passive gain.

---

### 2. Sales

**What it does mechanically:** Increases customer conversion rate and client acquisition speed. Higher Sales = more customers served per tick (for B2C businesses), better contract win probability (for B2B businesses), faster client onboarding.

**Without it:** Customer throughput limited to baseline. Contract bids evaluated on price and reputation only (no persuasion bonus). Client acquisition relies entirely on marketing and organic discovery.

**Key roles:** Sales Associate (all retail types), Sales Agent (Insurance), Real Estate Agent, Recruiter, Account Manager (all types), Client Relationship Manager, Enrollment Manager

**Develops through:** Any customer-facing or client-facing work. Fastest gain in direct sales roles (Sales Associate, Sales Agent).

---

### 3. Finance

**What it does mechanically:** Improves financial decision quality. Higher Finance = more accurate loan risk evaluation, better pricing instinct (tighter margin optimization), clearer cost visibility on dashboards, better investment returns on basic instruments. Also determines the depth of financial information shown to business owners on their dashboard — low Finance owners see summary numbers, high Finance owners see per-item margins, trend indicators, and cash flow projections.

**Without it:** Pricing decisions are blind (no margin indicators). Loan evaluations show raw data with no risk assessment. Investment returns are at market average with no alpha. Business dashboard shows only top-line revenue and total costs.

**Key roles:** Teller, Loan Officer, Junior Accountant, Claims Processor, Collections Agent, Trader, Fund Manager (as secondary), business owners

**Develops through:** Any work involving money handling (Teller, Cashier, Accountant). Business ownership provides passive gain.

---

### 4. Negotiation

**What it does mechanically:** Affects the terms of every contract the player touches — supplier pricing, client fees, salary negotiations, legal dispute outcomes, contract counter-offers. Higher Negotiation = better buy prices from suppliers, higher sell prices to clients, better outcomes in Legal Firm dispute resolution.

**Without it:** All contracts resolve at market default terms. Supplier prices are listed price (no discount). Legal disputes resolve at base calculation with no modifier.

**Key roles:** Lawyer (as secondary), business owners, Project Manager, Managing Partner, Account Manager (all types), any player negotiating contracts

**Develops through:** Any work involving deal-making. Fastest in contract-based businesses (Catering, Delivery, Construction). Legal Firm work provides strong Negotiation development.

---

### 5. Organization

**What it does mechanically:** Improves operational throughput — inventory management accuracy, dispatch scheduling efficiency, stockroom rotation speed, administrative processing rate. Higher Organization = less spoilage from poor stock rotation, more efficient dispatch assignments, faster restocking, cleaner admin processes.

**Without it:** Inventory tracking has error margins (reported stock ≠ actual stock). Dispatch assignments are suboptimal (drivers idle while contracts wait). Stockrooms don't rotate properly (older stock sits while newer stock ships, causing preventable spoilage).

**Key roles:** Dispatcher (both logistics types), Warehouse Staff (all sectors), Stock Worker (all retail), Administrative Staff, Paralegal, Handler, Loader, Cashier (secondary)

**Develops through:** Any operational or administrative work. Fastest in warehouse, dispatch, and stock management roles. Every entry-level job builds Organization slowly.

---

### 6. Customer Service

**What it does mechanically:** Increases customer satisfaction and retention. Higher Customer Service = repeat customers return sooner, better reviews per transaction, faster reputation gain, higher tip modifiers (where applicable). Also reduces customer churn rate for subscription-based businesses.

**Without it:** Customer satisfaction is baseline. Repeat visit interval is at default. No tip bonus. Reputation grows only from product/service quality, not interaction quality.

**Key roles:** Server (Restaurant), Cashier (all types), Help Desk Operator, Support Specialist (Software), Teller, Tenant Relations (Property Management), Enrollment Manager

**Develops through:** Any customer-facing work. Fastest in high-volume B2C roles (Server, Cashier, Help Desk).

---

### 7. Marketing

**What it does mechanically:** Increases the effectiveness of marketing spend and organic customer discovery. Higher Marketing = better return per marketing dollar spent (more customers per unit of ad spend), improved ability to interpret Data Analytics reports, stronger company brand growth per tick.

**Without it:** Marketing spend converts at baseline rate. Data Analytics reports are received but not effectively leveraged (no bonus applied). Brand growth is slow and purely organic.

**Key roles:** Marketing Specialist (Real Estate), business owners making marketing decisions, Report Designer (Data Analytics — as secondary)

**Develops through:** Business ownership (passive), dedicated marketing roles. Relatively few roles develop this skill directly — it's primarily an owner skill.

---

### 8. Quality Assessment

**What it does mechanically:** Determines accuracy of inspection, evaluation, and verification tasks. Higher Quality Assessment = higher defect detection rate (manufacturing QA), more accurate skill verification reports (Recruitment Assessor), better certification accuracy (Corporate Training Assessor), sharper quality control on inputs and outputs.

**Without it:** Defect detection operates at base rate (60–70%). Skill verification reports have wide error margins. Certifications may overstate or understate actual skill levels. Quality control catches only obvious defects.

**Key roles:** Quality Assurance (Electronics Mfg, Pharmaceutical Mfg), Quality Control (Food Mfg), Quality Inspector (Textile Mfg), Assessor (Recruitment), Certification Assessor (Corporate Training), Pharmacist (secondary — verifying product quality)

**Develops through:** Any inspection or evaluation role. Fastest in dedicated QA/QC positions.

---

## Tier 2A — Freely Accessible Domain Skills (9)

These develop naturally through relevant work with no prerequisites. They represent technical knowledge that can be learned on the job — you don't need a degree to start cooking or driving.

### 9. Culinary Arts

**Domain:** Food preparation, recipe execution, kitchen operations, ingredient handling

**Mechanical effect:** Determines food quality output and preparation speed. Higher Culinary Arts = better meals (higher quality tier achievable), more meals prepared per tick, lower ingredient waste rate.

**Quality gating:**
| Skill Range | Maximum Output Tier |
|---|---|
| 0–25 | Basic only |
| 26–50 | Basic + Standard |
| 51+ | All tiers including Premium |

**Key roles (primary):** Cook (Restaurant, Catering), Barista (Café), Production Worker (Food Manufacturing)

**NPC ceiling:** ~45 (can handle Standard reliably, cannot produce consistent Premium)

**Entry point:** Restaurant Worker, Kiosk Worker (very slow gain)

---

### 10. Driving

**Domain:** Vehicle operation, route efficiency, cargo handling, navigation, fuel optimization

**Mechanical effect:** Determines delivery speed and cargo condition. Higher Driving = faster delivery (fewer ticks), lower spoilage/damage rate during transport, more efficient fuel usage.

**Formulas it feeds into:**
- Spoilage modifier: `Base Rate × (1 / Driver Skill Factor)`
- Damage rate: `Base Risk × (1 / Driver Skill Factor)`
- Delivery speed: `Base Time × (1 / Driver Skill Factor)`

**Key roles (primary):** Driver (Delivery Company), Heavy Driver (Trucking/Freight)

**NPC ceiling:** ~50 (adequate for Standard delivery contracts, marginal for Premium cargo or time-critical routes)

**Entry point:** Delivery Worker (entry-level job)

---

### 11. Mechanical Repair

**Domain:** Equipment maintenance, vehicle repair, fault diagnosis, system troubleshooting

**Mechanical effect:** Determines equipment degradation slowdown and repair quality. Higher Mechanical Repair = slower equipment degradation for maintained assets, faster fault resolution, lower repair costs, reduced vehicle breakdown probability.

**Key roles (primary):** Mechanic (Delivery Co, Trucking/Freight), Maintenance Technician (Property Management), Maintenance Worker (Storage Facility)

**Key roles (secondary):** IT Technician (overlaps — physical hardware repair component)

**NPC ceiling:** ~50 (keeps equipment functional but doesn't extend lifespan significantly)

**Entry point:** Construction Helper (very slow gain), any role involving equipment operation

---

### 12. Construction

**Domain:** Building, renovation, structural work, heavy equipment operation, site execution

**Mechanical effect:** Determines build speed, build quality, and defect rate on completed properties. Higher Construction = faster project completion (fewer ticks per contract), higher quality rating on finished buildings (affects the property's efficiency rating for its eventual tenant), ability to handle larger and more complex projects.

**Quality gating:**
| Skill Range | Maximum Build Quality |
|---|---|
| 0–30 | Basic (residential, small commercial) |
| 31–55 | Standard (medium commercial, multi-unit residential) |
| 56+ | Premium/Luxury (large commercial, complex industrial) |

**Key roles (primary):** Construction Worker, Equipment Operator

**Key roles (secondary):** Site Foreman (uses Construction + Management), Loader (Freight — basic physical labor overlap)

**NPC ceiling:** ~48 (handles Standard builds adequately, cannot achieve Premium quality)

**Entry point:** Construction Helper (entry-level job)

---

### 13. Information Technology

**Domain:** System administration, network management, hardware troubleshooting, software support, infrastructure monitoring

**Mechanical effect:** Determines maintenance quality (equipment degradation slowdown for IT-maintained assets) and fault diagnosis speed. Higher IT = more clients serviceable per Technician, faster emergency callout resolution, better network infrastructure design (capacity multiplier).

**Key roles (primary):** IT Technician, Network Engineer, Help Desk Operator

**NPC ceiling:** ~45 (provides minimal maintenance improvement, slow emergency resolution)

**Entry point:** Help Desk Operator (most accessible tech role)

---

### 14. Real Estate

**Domain:** Property valuation, market analysis, tenant relations, zoning knowledge, property condition assessment

**Mechanical effect:** Determines property valuation accuracy, listing quality, tenant matching success, and property management efficiency. Higher Real Estate = more accurate appraisals (closer to true market value), better tenant-property matching, higher occupancy rates for managed portfolios, faster deal closure.

**Key roles (primary):** Real Estate Agent, Appraiser (uses Real Estate + Finance), Property Manager, Facility Manager (Storage — secondary)

**NPC ceiling:** ~45 (handles basic transactions, poor at complex commercial deals or market timing)

**Entry point:** Administrative Staff (Real Estate Agency), Tenant Relations (Property Management)

---

### 15. Design & Aesthetics

**Domain:** Visual design, fashion sense, garment pattern creation, trend awareness, presentation quality, UX layout

**Mechanical effect:** Determines creative output quality. For Stylists: accuracy of the "fit bonus" applied to customers (correct clothing recommendation = full Charisma benefit, poor recommendation = partial). For Pattern Designers: garment design quality and fashion cycle timing (skill determines how well new designs align with upcoming fashion trends). For Report Designers: subscriber UX quality (affects retention).

**Key roles (primary):** Stylist (Clothing Store), Pattern Designer (Textile Manufacturer), Report Designer (Data Analytics)

**Key roles (secondary):** Curriculum Designer (Skill Training Center — course design quality)

**NPC ceiling:** ~40 (functional but uninspired — no fashion trend anticipation, generic patterns, baseline report layouts)

**Entry point:** Sales Associate at Clothing Store (very slow gain), Stock Worker at Clothing Store

---

### 16. Healthcare Basics

**Domain:** Health product knowledge, basic pharmaceutical awareness, patient care fundamentals, wellness assessment

**Mechanical effect:** Provides the baseline for pharmacy and health-related roles. Determines which basic health products can be correctly recommended, customer trust modifier for health-related sales, and basic product handling quality (reduces wastage from improper storage).

**Relationship to Pharmaceutical Science:** Healthcare Basics is the free foundation. It allows a player to work in a Pharmacy, handle health products, and assist customers. But it does NOT unlock tier gating — that requires the gated Pharmaceutical Science skill. A player with Healthcare Basics 60 and no Pharmaceutical Science is a great pharmacy Sales Associate but cannot function as a Pharmacist.

**Key roles (primary):** Sales Associate (Pharmacy), Stock Worker (Pharmacy — secondary)

**NPC ceiling:** ~45

**Entry point:** Any health-related retail work

---

### 17. Manufacturing & Production

**Domain:** Production line operation, batch processing, output optimization, material handling, factory workflow

**Mechanical effect:** Determines production throughput and base output quality for manufacturing roles. Higher Manufacturing & Production = more units produced per tick, lower base defect rate, more efficient raw material usage (less waste per unit).

**Key roles (primary):** Production Worker (Food Mfg, Textile Mfg), Lab Technician (Pharmaceutical Mfg — secondary alongside Pharmaceutical Science), Production Engineer (Electronics Mfg — secondary alongside Electronics Engineering)

**NPC ceiling:** ~50 (handles Standard production volume adequately)

**Entry point:** Warehouse Laborer (entry-level, very slow gain), any factory floor role

---

## Tier 2B — Gated Domain Skills (8)

These skills CANNOT accumulate any experience until the player completes the specified prerequisite course at an accredited Skill Training Center. The skill slot exists on the player's profile from day one — visible but locked, showing the prerequisite. After course completion, the skill develops through work and can be further accelerated through advanced training courses.

**Design intent:** Basic careers are freely accessible. Mid-tier careers require investment in training. Senior and specialist roles require committed educational paths. This creates the Education sector's demand, gives players long-term goals, and ensures that the most impactful roles in the economy are filled by players who made deliberate career investments.

### 18. Pharmaceutical Science

**Prerequisite:** Foundational Science (course at Skill Training Center)

**Domain:** Drug chemistry, pharmaceutical production methodology, quality control protocols, tier-specific formulation, health product analysis

**Mechanical effect:** This is the tier-gating skill for both pharmaceutical production and pharmacy retail.

**For Chemists (Pharmaceutical Manufacturer):**
| Skill Range | Production Capability |
|---|---|
| 1–25 | Basic tier only |
| 26–50 | Basic + Standard |
| 51+ | All tiers including Premium |

**For Pharmacists (Pharmacy Retail):**
| Skill Range | Dispensing Capability |
|---|---|
| 1–25 | Basic tier only |
| 26–50 | Basic + Standard |
| 51+ | All tiers including Premium |

**Key roles (primary):** Chemist (Pharmaceutical Mfg), Pharmacist (Pharmacy), Lab Technician (Pharmaceutical Mfg — secondary, combined with Manufacturing & Production)

**NPC ceiling:** ~42 (just reaches Standard tier — cannot produce or dispense Premium)

---

### 19. Architecture

**Prerequisite:** Foundational Engineering (course at Skill Training Center)

**Domain:** Building design, structural planning, load calculations, complex project specification, large-scale facility layout

**Mechanical effect:** Determines maximum build quality tier achievable and unlocks larger/more complex building types. The Architect designs the build — without Architecture skill, a Construction Company is limited to basic projects.

| Skill Range | Design Capability |
|---|---|
| 1–30 | Standard residential and small commercial |
| 31–55 | Large commercial, multi-unit, industrial facilities |
| 56+ | Premium/Luxury builds, complex mixed-use, custom designs with efficiency bonuses |

**Key roles (primary):** Architect (Construction Company)

**NPC ceiling:** ~40 (limited to Standard tier — NPC Architects cannot design Premium or Luxury buildings)

---

### 20. Software Engineering

**Prerequisite:** Foundational Computing (course at Skill Training Center)

**Domain:** Application development, code architecture, testing methodology, software lifecycle management, debugging

**Mechanical effect:** Determines development speed (ticks to first release), initial bug rate, and code quality. Higher Software Engineering = faster releases, fewer bugs at launch, more efficient software (better efficiency bonus for subscribing businesses).

**Key roles (primary):** Software Developer, QA Tester (combined with Quality Assessment)

**NPC ceiling:** ~40 (slow development, high initial bug rate — functional but not competitive)

---

### 21. Data Analytics

**Prerequisite:** Foundational Computing (course at Skill Training Center)

**Domain:** Statistical analysis, trend identification, market pattern recognition, forecast modeling, data visualization

**Mechanical effect:** Determines report quality — depth of trend analysis, forecast accuracy window (how many ticks ahead predictions are reliable), and breadth of sector coverage per Analyst. Higher Data Analytics = forward-looking reports with confidence intervals vs backward-looking price snapshots.

| Skill Range | Report Capability |
|---|---|
| 1–25 | 1-tick-lag price reports, single sector, no forecasting |
| 26–50 | Current-tick reports, 2-3 sectors, basic trend direction |
| 51+ | 2-tick forward forecasts, all sectors, confidence intervals, anomaly detection |

**Key roles (primary):** Data Analyst, Research Specialist (combined with domain expertise for sector-specific depth)

**NPC ceiling:** ~38 (basic backward-looking reports only — no forecasting capability)

---

### 22. Financial Modeling

**Prerequisite:** Foundational Finance (course at Skill Training Center)

**Domain:** Risk modeling, portfolio theory, actuarial science, advanced investment analysis, credit scoring, derivative pricing

**Mechanical effect:** Unlocks advanced financial roles and improves the quality of complex financial decisions. Higher Financial Modeling = more accurate risk assessment (narrower confidence intervals on default probability), better portfolio construction (higher alpha on investments), more precise actuarial tables (better premium pricing for insurance).

**Key roles (primary):** Fund Manager (Investment Firm), Risk Analyst (Private Bank), Actuary (Insurance Company)

**Key roles (secondary):** Senior Accountant and Partner (Accounting Firm — combined with Accounting skill)

**NPC ceiling:** ~35 (basic risk assessment only — cannot handle complex portfolio decisions or advanced actuarial work)

---

### 23. Legal Practice

**Prerequisite:** Foundational Law (course at Skill Training Center)

**Domain:** Case law, litigation strategy, contract drafting, dispute resolution, regulatory compliance, transaction processing

**Mechanical effect:** Determines legal outcome quality. In disputes, Lawyer skill directly enters the resolution formula:

```
Outcome Score = (Lawyer Skill × Case Strength) vs (Opposing Lawyer Skill × Defense Strength)
```

Higher Legal Practice = better dispute outcomes for clients, faster transaction processing (fewer complication risks), more effective contract enforcement recovery.

**Key roles (primary):** Lawyer (Legal Firm)

**Key roles (secondary):** Managing Partner (Legal Firm — combined with Management and Negotiation)

**NPC ceiling:** ~38 (handles basic cases, poor at complex disputes or high-value transactions)

---

### 24. Accounting

**Prerequisite:** Foundational Finance (course at Skill Training Center)

**Domain:** Tax optimization methodology, audit procedures, financial strategy, cost efficiency analysis, regulatory compliance

**Mechanical effect:** Determines the quality of accounting services provided to client businesses. Higher Accounting = greater tax reduction percentage, larger cost efficiency savings, more detailed and actionable financial strategy reports.

| Skill Range | Service Capability |
|---|---|
| 1–25 | Basic Bookkeeping (visibility only, no optimization) |
| 26–45 | Tax Optimization (5–10% effective tax reduction) + Cost Efficiency Audit (5–7% cost reduction) |
| 46+ | Full Financial Strategy (all services + adaptive recommendations, cash flow forecasting, expansion analysis) |

**Key roles (primary):** Senior Accountant, Partner (Accounting Firm)

**Note:** Junior Accountant uses Finance (foundation skill) only. Senior Accountant and Partner require both Finance AND Accounting. The Partner role also requires Management at a high level.

**NPC ceiling:** ~35 (can provide Tax Optimization at low effectiveness, cannot perform Financial Strategy)

---

### 25. Electronics Engineering

**Prerequisite:** Foundational Engineering (course at Skill Training Center)

**Domain:** Circuit design, production line engineering, technology generation analysis, component architecture, R&D methodology

**Mechanical effect:** Determines production capability for electronics manufacturing and R&D intelligence quality.

**For Production Engineers:**
| Skill Range | Production Capability |
|---|---|
| 1–30 | Basic tier electronics only |
| 31–55 | Basic + Standard |
| 56+ | All tiers including Premium (and ability to run premium lines efficiently) |

**For R&D Specialists:** Skill determines advance warning ticks before a Technology Generation shift:
| Skill Range | Warning |
|---|---|
| 1–25 | 0–1 ticks (essentially reactive) |
| 26–50 | 1–2 ticks |
| 51+ | 2–3 ticks |

**Key roles (primary):** Production Engineer (Electronics Mfg), R&D Specialist (Electronics Mfg)

**NPC ceiling:** ~38 (can produce Standard electronics, minimal R&D warning)

---

## Prerequisite Course Map

Five foundational courses unlock eight gated domain skills. Each course is delivered by a Skill Training Center and requires an Instructor with sufficient skill in the relevant foundation domain.

| Foundational Course | Instructor Needs Skill In | Unlocks | Typical Duration |
|---|---|---|---|
| Foundational Science | Healthcare Basics or Pharmaceutical Science (existing practitioners) | Pharmaceutical Science | 3–4 ticks |
| Foundational Engineering | Construction or Electronics Engineering (existing practitioners) | Architecture, Electronics Engineering | 3–4 ticks |
| Foundational Computing | Information Technology or Software Engineering (existing practitioners) | Software Engineering, Data Analytics | 3–4 ticks |
| Foundational Finance | Finance (foundation skill, 50+ recommended) | Financial Modeling, Accounting | 2–3 ticks |
| Foundational Law | Legal Practice or high Negotiation (60+ for basic instruction) | Legal Practice | 3–4 ticks |

**Key dynamics:**
- Foundational Engineering is the most valuable course offering — it unlocks TWO career paths (Architecture and Electronics Engineering), making Training Centers that offer it a high-demand destination
- Foundational Finance is the fastest course but also the most broadly demanded — nearly every serious business owner benefits from the skills it unlocks
- Foundational Law has the narrowest career output (only Lawyer) but the highest per-role economic impact — a single skilled Lawyer can shift millions in dispute outcomes
- Foundational Computing unlocks the Technology sector's two most knowledge-intensive roles — the only way into the digital economy's production side

**The instructor bootstrap problem:** Who teaches Foundational Science in a new country where no one has Pharmaceutical Science yet? The Central Corporation's baseline Training Centers have NPC instructors with mid-tier skill in all foundational domains. They teach slowly and at low quality, but they exist from day one. The first player to develop a high skill in any domain and then train as an Instructor captures enormous demand.

---

## Skill-to-Role Master Map

Every employee role in the game, mapped to its skill dependencies. **Primary** = the skill that most directly determines role performance. **Secondary** = contributes meaningfully but isn't the main driver.

### Sector 1: Food & Hospitality

| Role | Primary Skill | Secondary Skill(s) |
|---|---|---|
| Cook (Restaurant/Catering) | Culinary Arts | Organization |
| Barista (Café) | Culinary Arts | Customer Service |
| Server (Restaurant) | Customer Service | Sales |
| Cashier (all food) | Organization | Customer Service |
| Cleaner | — (no skill requirement) | Organization (slow passive gain) |
| Logistics Staff (Catering) | Organization | Driving |
| Production Worker (Food Mfg) | Manufacturing & Production | Culinary Arts |
| Quality Control (Food Mfg) | Quality Assessment | Culinary Arts |
| Warehouse Staff (Food Mfg/Supermarket) | Organization | — |
| Stock Worker (Supermarket) | Organization | — |
| Manager (all food types) | Management | Finance |

### Sector 2: Logistics & Transport

| Role | Primary Skill | Secondary Skill(s) |
|---|---|---|
| Driver (Delivery) | Driving | Organization |
| Heavy Driver (Freight) | Driving | Construction (heavy vehicle overlap) |
| Handler (Delivery) | Organization | — |
| Loader (Freight) | Construction | Organization |
| Dispatcher (both types) | Organization | Management |
| Mechanic (both types) | Mechanical Repair | — |
| Manager (both types) | Management | Negotiation |

### Sector 3: Retail

| Role | Primary Skill | Secondary Skill(s) |
|---|---|---|
| Sales Associate (General) | Sales | Customer Service |
| Sales Associate (Electronics) | Sales | Information Technology |
| Sales Associate (Clothing) | Sales | Design & Aesthetics |
| Sales Associate (Pharmacy) | Sales | Healthcare Basics |
| Technician (Electronics) | Information Technology | Mechanical Repair |
| Stylist (Clothing) | Design & Aesthetics | Customer Service |
| Pharmacist (Pharmacy) | Pharmaceutical Science | Healthcare Basics |
| Cashier (all retail) | Organization | Customer Service |
| Stock Worker (all retail) | Organization | — |
| Manager (all retail) | Management | Sales |

### Sector 4: Construction & Real Estate

| Role | Primary Skill | Secondary Skill(s) |
|---|---|---|
| Construction Worker | Construction | — |
| Site Foreman | Management | Construction |
| Architect | Architecture | Construction |
| Equipment Operator | Construction | Mechanical Repair |
| Project Manager | Management | Negotiation, Finance |
| Real Estate Agent | Sales | Real Estate |
| Appraiser | Real Estate | Finance |
| Marketing Specialist (RE) | Marketing | Real Estate |
| Office Manager (RE) | Management | Organization |
| Property Manager | Real Estate | Management |
| Maintenance Technician | Mechanical Repair | Construction |
| Tenant Relations | Customer Service | Real Estate |
| Administrative Staff | Organization | — |
| Facility Manager (Storage) | Management | Real Estate |
| Security Staff | — (no skill requirement) | Organization (slow passive) |
| Maintenance Worker (Storage) | Mechanical Repair | — |

### Sector 5: Finance

| Role | Primary Skill | Secondary Skill(s) |
|---|---|---|
| Teller (Bank) | Finance | Customer Service |
| Loan Officer (Bank) | Finance | Quality Assessment |
| Risk Analyst (Bank) | Financial Modeling | Finance |
| Collections Agent | Negotiation | Finance |
| Manager (Bank) | Management | Finance |
| Fund Manager (Investment) | Financial Modeling | Finance |
| Research Analyst (Investment) | Data Analytics | Finance |
| Trader (Investment) | Finance | — |
| Account Manager (Investment) | Sales | Finance |
| Director (Investment) | Management | Financial Modeling |
| Actuary (Insurance) | Financial Modeling | Quality Assessment |
| Sales Agent (Insurance) | Sales | Finance |
| Claims Processor (Insurance) | Organization | Finance |
| Manager (Insurance) | Management | Finance |
| Junior Accountant | Finance | Organization |
| Senior Accountant | Accounting | Finance |
| Partner (Accounting) | Accounting | Management, Finance |

### Sector 6: Professional Services

| Role | Primary Skill | Secondary Skill(s) |
|---|---|---|
| Lawyer | Legal Practice | Negotiation |
| Paralegal | Organization | Legal Practice (slow gain even pre-gate, or just Negotiation) |
| Client Intake (Legal) | Customer Service | Organization |
| Managing Partner (Legal) | Management | Legal Practice, Negotiation |
| Recruiter | Sales | Quality Assessment |
| Assessor (Recruitment) | Quality Assessment | — |
| Account Manager (Recruitment) | Sales | Customer Service |

**Note on Paralegal:** The Paralegal role is the one exception to the strict gating rule. Working as a Paralegal does NOT develop Legal Practice (which is gated). Instead, it develops Organization (primary) and Negotiation (secondary). A Paralegal who wants to become a Lawyer must still take the Foundational Law course. The Paralegal role is the career "on-ramp" — it gives the player context and income while they save for the course.

### Sector 7: Manufacturing

| Role | Primary Skill | Secondary Skill(s) |
|---|---|---|
| Production Engineer (Electronics) | Electronics Engineering | Manufacturing & Production |
| R&D Specialist (Electronics) | Electronics Engineering | Data Analytics |
| Quality Assurance (Electronics) | Quality Assessment | Electronics Engineering |
| Warehouse Staff (Electronics) | Organization | — |
| Production Manager (Electronics) | Management | Electronics Engineering |
| Production Worker (Textile) | Manufacturing & Production | — |
| Pattern Designer (Textile) | Design & Aesthetics | Manufacturing & Production |
| Quality Inspector (Textile) | Quality Assessment | Design & Aesthetics |
| Warehouse Staff (Textile) | Organization | — |
| Production Manager (Textile) | Management | Manufacturing & Production |
| Lab Technician (Pharma) | Manufacturing & Production | Pharmaceutical Science |
| Chemist (Pharma) | Pharmaceutical Science | Quality Assessment |
| Quality Assurance (Pharma) | Quality Assessment | Pharmaceutical Science |
| Warehouse Staff (Pharma) | Organization | Healthcare Basics |
| Production Manager (Pharma) | Management | Pharmaceutical Science |

### Sector 8: Technology

| Role | Primary Skill | Secondary Skill(s) |
|---|---|---|
| IT Technician | Information Technology | Mechanical Repair |
| Network Engineer | Information Technology | Organization |
| Help Desk Operator | Customer Service | Information Technology |
| Operations Manager (IT) | Management | Information Technology |
| Software Developer | Software Engineering | — |
| QA Tester (Software) | Software Engineering | Quality Assessment |
| Support Specialist (Software) | Customer Service | Software Engineering |
| Product Manager (Software) | Management | Software Engineering |
| Data Analyst | Data Analytics | Finance (for financial data), Information Technology |
| Research Specialist | Data Analytics | (domain-specific secondary varies) |
| Report Designer | Design & Aesthetics | Data Analytics |
| Analytics Director | Management | Data Analytics |

### Sector 9: Education & Training

| Role | Primary Skill | Secondary Skill(s) |
|---|---|---|
| Instructor (Training Center) | *Domain being taught* | Customer Service |
| Curriculum Designer | Design & Aesthetics | *Domain being designed for* |
| Enrollment Manager | Sales | Customer Service |
| Training Director | Management | *Any relevant domain* |
| Corporate Trainer | *Domain being trained* | Management |
| Program Developer (Corp Training) | *Domain being developed for* | Design & Aesthetics |
| Certification Assessor | Quality Assessment | *Domain being assessed* |
| Client Relationship Manager | Sales | Customer Service |

**Sector 9 special rule:** Instructors and Corporate Trainers use their skill IN THE DOMAIN THEY'RE TEACHING as their primary skill. An Instructor teaching Culinary Arts uses their Culinary Arts skill to determine instruction quality. An Instructor teaching Pharmaceutical Science uses Pharmaceutical Science. This means the Education sector draws its talent pool from every other sector — a retired Chef with Culinary Arts 80 is worth more as an Instructor than a new Cook. This creates a natural career capstone path.

---

## NPC Skill Ceiling Reference

NPC employees develop skill through work but follow a diminishing returns curve that plateaus. These ceilings are adequate for Standard-tier business performance but insufficient for Premium or specialist roles. Corporate Training pushes past these ceilings.

### Foundation Skills — NPC Ceilings

| Skill | NPC Ceiling | Implication |
|---|---|---|
| Management | 40 | NPC Manager provides basic coordination, no strategic decisions |
| Sales | 45 | NPC Sales Associate handles standard customers, no upselling talent |
| Finance | 40 | NPC processes transactions but cannot evaluate complex decisions |
| Negotiation | 35 | NPC cannot negotiate — accepts default terms always |
| Organization | 50 | NPC handles routine logistics well — this is where NPCs shine |
| Customer Service | 45 | NPC provides adequate service, no exceptional retention effect |
| Marketing | 30 | NPC marketing is nearly useless — this is a player-dominated skill |
| Quality Assessment | 45 | NPC catches obvious defects, misses subtle ones |

### Domain Skills — NPC Ceilings

| Skill | NPC Ceiling | Implication |
|---|---|---|
| Culinary Arts | 45 | Reliable Standard food, inconsistent Premium |
| Driving | 50 | Adequate delivery speed and handling |
| Mechanical Repair | 50 | Keeps equipment functional, doesn't extend lifespan much |
| Construction | 48 | Standard builds only |
| Information Technology | 45 | Minimal maintenance improvement |
| Real Estate | 45 | Basic transactions, poor at complex deals |
| Design & Aesthetics | 40 | Functional but uninspired output |
| Healthcare Basics | 45 | Can handle standard pharmacy work |
| Manufacturing & Production | 50 | Standard production volume |
| Pharmaceutical Science | 42 | Just reaches Standard tier |
| Architecture | 40 | Standard designs only |
| Software Engineering | 40 | Slow development, buggy output |
| Data Analytics | 38 | Backward-looking reports only |
| Financial Modeling | 35 | Basic risk assessment only |
| Legal Practice | 38 | Simple cases only |
| Accounting | 35 | Low-effectiveness Tax Optimization |
| Electronics Engineering | 38 | Standard production, minimal R&D |

**Pattern:** Skills requiring creativity, judgment, or strategic thinking (Marketing, Negotiation, Financial Modeling, Legal Practice, Architecture) have LOWER NPC ceilings. Skills involving execution, procedure, and physical competence (Driving, Organization, Mechanical Repair, Manufacturing) have HIGHER NPC ceilings. This is intentional — it makes real players most valuable in roles where judgment matters, while NPCs can handle routine execution adequately.

---

## Entry-Level Job Skill Development

Entry-level jobs require no skills to start but slowly develop foundation and basic domain skills. This is the player's first contact with the skill system — progress is visible but slow, creating the motivation to pursue training or better roles.

| Entry-Level Job | Primary Skill Developed | Secondary Skill(s) | Gain Rate |
|---|---|---|---|
| Cleaner | Organization | — | Very slow |
| Restaurant Worker | Customer Service | Organization, Culinary Arts (trace) | Slow |
| Car Wash Worker | Customer Service | Organization | Very slow |
| Warehouse Laborer | Organization | Manufacturing & Production (trace) | Slow |
| Delivery Worker | Driving | Organization | Slow |
| Supermarket Stock Worker | Organization | Customer Service (trace) | Slow |
| Construction Helper | Construction | Organization | Slow |
| Kiosk Worker | Sales | Customer Service | Slow |

**"Trace" gain** means the skill develops at roughly 0.1–0.2× the primary rate — barely noticeable per tick but meaningful over 50+ ticks. This prevents players from feeling zero progress in secondary domains while keeping them hungry for a role that develops their target skill faster.

---

## Career Path Examples

These show how skills flow through a player's career, illustrating the system's intended progression.

### Path 1: The Chef → Instructor

```
Restaurant Worker (entry-level)
  → builds Customer Service (slow), Organization (slow), Culinary Arts (trace)
Cook (promoted — requires Culinary Arts ~15)
  → builds Culinary Arts (fast), Organization (secondary)
  → reaches Culinary Arts 45 through work over ~80 ticks
  → enrolls in Advanced Culinary course at Training Center
  → Culinary Arts accelerates to 65 over 12 ticks of training
Head Cook / Kitchen Manager (player employee role)
  → builds Management (secondary), Culinary Arts continues
  → Culinary Arts reaches 75
Instructor at Skill Training Center (career capstone)
  → teaches Culinary Arts at 2.5× multiplier
  → earns premium instructor salary
  → continues developing Culinary Arts (slowly) while teaching
```

**Time to capstone:** ~150–200 ticks (37–50 real days)

### Path 2: The Construction Worker → Architect

```
Construction Helper (entry-level)
  → builds Construction (slow), Organization (trace)
Construction Worker (promoted — requires Construction ~15)
  → builds Construction (fast)
  → reaches Construction 40 over ~60 ticks
  → realizes Architecture is GATED — cannot start developing it
Enrolls in Foundational Engineering course (3–4 ticks)
  → Architecture skill slot UNLOCKED at 0
  → continues working as Construction Worker
  → Architecture begins developing through work (slow — Construction Worker is not Architect role)
Gets hired as junior Architect (requires Architecture ~10, Construction 40+)
  → Architecture develops faster in the Architect role
  → enrolls in Advanced Architecture course to accelerate
  → Architecture reaches 55 over ~80 ticks
Senior Architect (player employee — Premium/Luxury builds)
  → commands premium salary
  → first Architect in a country with no competition = pricing power
```

**Time to senior role:** ~180–250 ticks (45–62 real days)

### Path 3: The Finance Track

```
Kiosk Worker (entry-level)
  → builds Sales (slow), Customer Service (slow)
Teller at Private Bank (requires Finance ~10, Customer Service ~15)
  → builds Finance (fast), Customer Service (secondary)
  → reaches Finance 35 over ~50 ticks
Enrolls in Foundational Finance course (2–3 ticks)
  → Financial Modeling AND Accounting both UNLOCKED at 0
Decision point: Investment track or Accounting track?

INVESTMENT TRACK:
Research Analyst → Fund Manager → Investment Firm Director
  → develops Financial Modeling + Finance + Data Analytics

ACCOUNTING TRACK:
Junior Accountant → Senior Accountant → Partner
  → develops Accounting + Finance + Management
```

**Design intent:** Foundational Finance is the most broadly useful single course in the game — it opens two completely different career paths. This makes Finance-focused Training Centers high-demand operations.

### Path 4: The Serial Entrepreneur

```
Any entry-level job → builds foundation skills
Saves enough capital to open a Café (lowest barrier to entry)
  → develops Management (passive, business ownership), Finance (passive)
  → develops Sales, Customer Service through active work
Café succeeds → opens second business (General Store)
  → Management develops faster (managing two businesses)
  → Negotiation develops from supplier contract negotiations
Enrolls in Foundational Finance (wants better financial control)
  → Accounting unlocked → hires self as "acting accountant" for own businesses
  → Finance + Accounting develop in parallel
Sells Café, buys a Restaurant
  → Management 50+, Finance 40+, Negotiation 35
  → now managing employees with real strategic decisions
```

**This path shows the breadth player** — instead of deep domain specialization, they build wide foundation skills. They'll never be the best Cook or the best Architect, but they can manage any business type competently. A different but equally valid strategy.

---

## Cross-Skill Interaction Rules

### Multi-Skill Roles

Many roles use two skills simultaneously. The performance formula for multi-skill roles:

```
Role Output = (Primary Skill × 0.7) + (Secondary Skill × 0.3)
```

This means the primary skill dominates but the secondary creates meaningful differentiation. Two Architects at Architecture 60 are NOT equal if one has Construction 50 (secondary) and the other has Construction 20. The first produces measurably better buildings because they understand the physical execution of their designs.

### The Owner Bonus

Business owners gain a small passive development bonus to Management, Finance, Negotiation, and Marketing each tick. This represents learning-by-doing as an entrepreneur. Rate: 0.3× the normal work-based gain rate. Over a long career, an active business owner naturally develops a broad foundation skill base even without targeted training.

### Skill Decay — Not Implemented

Skills do NOT decay from disuse. A player who develops Culinary Arts to 60 and then spends 100 ticks as a Delivery Driver still has Culinary Arts 60. This is a deliberate design choice — it prevents punishing players for trying new careers and ensures that the skill investment always has value. The economy's natural counter to skill hoarding is that time spent maintaining one career is time not spent advancing another.

**Exception — NPC Skill Degradation:** NPCs who are unemployed for extended periods (10+ ticks) experience slow skill degradation as a labor market mechanic. This prevents the NPC pool from accumulating infinitely skilled unused workers and creates demand for Corporate Training's Refresher Course product.

---

## System Interactions

### Skills × Education Sector
The Skill Training Center's entire business model depends on the gating system (prerequisite courses) and the acceleration system (training multipliers). Without the 8 gated skills, Training Centers would be a nice-to-have luxury. With them, they're structurally necessary for every player pursuing a mid-to-high career. The 5 foundational courses are the Training Center's guaranteed demand floor.

### Skills × Recruitment Agency
The Recruitment Agency's Assessor role uses Quality Assessment to verify candidate skill levels. The skill system's transparency (all skills visible on profiles) means the Assessor's value comes from VERIFICATION accuracy — confirming the displayed numbers are real. In a trust-based economy, Assessor skill is what makes the Recruitment Agency worth paying for.

### Skills × Corporate Training
Corporate Training pushes NPC skill ceilings higher. The ceiling values defined in this document set the baseline that Corporate Training works against. A Standard Program pushes an NPC +8–12 points above their natural ceiling. This interaction means every NPC ceiling value in this document directly defines Corporate Training's addressable market.

### Skills × Company Valuation
Active employee skill levels feed into the company valuation algorithm. A restaurant with Cook skill 70 is worth more than one with Cook skill 30 — it can produce Premium meals, command higher prices, and attract more customers. Skill drives revenue drives valuation. This creates the incentive for business owners to invest in employee training.

### Skills × Country System
Country labor cost modifiers (0.7×–1.4×) affect NPC salary expectations. High-skill NPCs in expensive labor countries (1.4×) cost significantly more — making Corporate Training vs Recruitment Agency tradeoffs sharper. In cheap labor countries (0.7×), NPCs are affordable but the talent ceiling is the same, meaning training has the same absolute benefit but lower relative cost.

---

## Balancing Notes (For Future Tuning)

The following values are designed for internal consistency but WILL need tuning during playtesting:

- **Base XP gain rate per tick** — the foundation of all progression speed. Too fast = players reach Expert quickly, Training Centers lose value. Too slow = early game feels like grinding.
- **Training multiplier formula** — currently `1 + (Instructor Skill / 50)`. May need adjustment if high-skill instructors make training too fast.
- **NPC ceiling values** — set at levels where Standard-tier business is achievable but Premium is not. If Premium production is too easy with NPCs, the entire player labor market weakens.
- **Multi-skill role weighting** — currently 70/30 primary/secondary. May need per-role tuning if some role combinations feel unbalanced.
- **Foundational course duration** — currently 2–4 ticks (12–24 real hours). Too short = gate feels meaningless. Too long = new players feel locked out of careers for days.
- **Business ownership passive gain rate** — currently 0.3×. Too high = every business owner becomes a finance expert naturally. Too low = entrepreneurs never develop business skills.

---

*Last updated: May 25, 2026 — Skills System Full Taxonomy — Design Complete*
