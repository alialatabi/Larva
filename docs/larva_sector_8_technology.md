# Sector 8: Technology

**Company Types:** IT Services Company · Software Firm · Data Analytics Firm

---

## Sector Introduction

The Technology sector is structurally unlike every sector before it. Seven sectors produce or move things — food, goods, property, money, legal work, manufactured products. Technology produces **capability**. It doesn't appear on a shelf or travel in a truck. It changes what other businesses can do.

This makes Sector 8 the economy's **efficiency layer** — an upstream dependency that operates invisibly until it's absent. A restaurant that subscribes to inventory management software wastes less food. A delivery company maintained by an IT firm sees fewer equipment failures. A retail chain using a data analytics subscription catches a price trend before competitors do. None of these effects are dramatic on their own. Together, they compound — and the business owners who ignore the technology layer eventually lose to those who don't.

**Three structural differences from all prior sectors:**

1. **No physical goods** (Software and Data Analytics). No logistics required. No spoilage. No damage in transit. This is the only sector where two of three company types have zero logistics dependency.
2. **Subscription-based revenue** (Software and Data). Revenue recurs every tick on a contracted basis — not per order, per delivery, or per transaction. This creates predictable cashflow but also lock-in dynamics and churn risk.
3. **Economy-scale dependence** (Data Analytics especially). The more activity in the economy, the more valuable the data. A small early-game economy has thin data. A mature economy is rich with signals. Data Analytics firms grow more powerful as the game world grows.

The Central Corporation operates baseline versions of all three company types in every country — providing low-quality IT maintenance contracts, generic off-the-shelf software with no customization, and country-level macro reports with 2-tick data lag. Beatable, but present.

---

## 8A. IT Services Company

**Business Model:** An IT Services company maintains the technology infrastructure of other businesses — diagnosing equipment failures, servicing hardware purchased from the Electronics Store, managing network systems, and responding to technical emergencies. Revenue comes from two streams: **maintenance contracts** (recurring fee per tick, client's equipment degrades more slowly) and **emergency callouts** (high-margin single-event responses when equipment fails unexpectedly). The strategic distinction: IT Services is the only company in the game that directly interacts with the **equipment degradation system** that underpins every other business's efficiency. Every other sector buys equipment and watches it degrade. IT Services is the gear that slows the clock.

**Supply Chain Position:**
```
Electronics Store (Sector 3B)
      ↓ (replacement parts, diagnostic tools — physical goods, delivered by Delivery Company)
IT Services Company
      ↓ maintenance contracts (service output — no logistics required)
      ↓ emergency callouts (event-triggered, same-tick response)
Every business with equipment (all sectors)
      → slower equipment degradation
      → faster fault recovery
      → reduced unplanned downtime losses
```

**Employee Roles:**

| Role | Function |
|------|----------|
| IT Technician | Core service role. Skill determines maintenance quality (how much degradation is slowed per tick) and fault diagnosis speed (how many ticks an emergency response takes). Low-skill NPC technician: minimal degradation improvement, slow emergency resolution. High-skill player technician: near-baseline degradation rate for clients, 1-tick emergency resolution |
| Network Engineer | Manages system-level infrastructure. Skill affects how many clients a single technician can service simultaneously (capacity multiplier). Without a Network Engineer, each IT Technician can service fewer clients — growth hits a hard ceiling early |
| Help Desk Operator | Handles inbound client tickets. Skill determines triage accuracy — directing the right technician to the right problem. Low-skill: technicians waste time on misrouted calls. High-skill player operator: no wasted dispatches. Only becomes meaningful once the client base exceeds ~8 contracts |
| Operations Manager | Player-only role at scale. Unlocks priority contract tiers, multi-country service agreements, and SLA (Service Level Agreement) customization. Required to sign contracts above a minimum value threshold |

**Critical mechanic — the Technician-to-Client ratio:** Each IT Technician has a base service capacity (number of maintenance contracts they can actively service per tick). Exceeding this ratio degrades service quality across all contracts simultaneously. The owner must either hire more technicians or refuse new contracts — a real scaling decision with a visible cliff.

**Operating Costs (per tick):**
- **Salaries** — Technicians, Network Engineer, Help Desk. The dominant cost at scale
- **Parts inventory** — Replacement components sourced from Electronics Store. Held in storage. If parts are out of stock when an emergency callout fires, resolution time doubles. Holding excess inventory ties up capital
- **Diagnostic equipment** — Purchased from Electronics Store. Degrades over time (standard equipment degradation system). The equipment maintenance company must maintain its own equipment
- **Office/depot space** — Small commercial real estate. Used for parts storage and technician dispatch base. Size determines max parts inventory cap
- **Transport costs** — Delivery Company contract for parts restocking (physical goods from Electronics Store must be transported)

**Revenue Model:**

*Maintenance contracts:* Fixed fee per tick per client. The owner sets the contract rate. Client equipment degrades at **(base degradation rate × (1 - technician skill modifier))** while under contract. High-skill technicians justify higher contract fees — the fee is economically rational if degradation savings exceed the cost.

*Emergency callouts:* When a client (contracted or uncontracted) suffers equipment failure, they can request an emergency callout. Fee = base rate × urgency multiplier. Emergency callouts are higher margin but unpredictable. Uncontracted emergency clients pay a premium surcharge. Contracted clients get a response SLA — penalty if the IT firm misses it.

**Key Owner Decisions:**
- **Contract rate vs retention:** Higher rates = more revenue per client but higher churn risk. Clients who calculate the maintenance-versus-replacement math will drop a too-expensive contract and just buy new equipment.
- **Emergency coverage policy:** Accept emergency calls from non-clients (high margin, unpredictable scheduling disruption) or contract-only (predictable but leaves money on the table).
- **Specialization vs generalization:** Focus on one sector (e.g., only restaurants and food manufacturers) — deeper familiarity, domain-specific skill bonus — or service all sectors for a broader client base.
- **Parts inventory level:** Lean (low capital tied up, risk of stockout mid-emergency) vs padded (higher capital cost, zero stockout risk).

**Capacity & Scaling:**
- **Bottleneck 1 — Technician headcount:** Each technician services a fixed number of contracts. Exceeding capacity degrades all contracts.
- **Bottleneck 2 — Parts inventory cap:** Determined by depot/office size. Larger real estate = larger inventory buffer.
- **Bottleneck 3 — Network Engineer:** Without one, technician capacity is capped at a lower level. Adding a Network Engineer multiplies effective capacity without adding headcount.
- **Growth path:** Hire technicians → add Network Engineer (capacity multiplier) → add Help Desk (emergency management) → hire Operations Manager (premium contracts) → expand to second branch in another country.

**Cross-Sector Dependencies:**
- **Electronics Store (Sector 3B)** — source of all parts inventory. Generation shifts that spike electronics prices hit IT Services' parts budget immediately
- **Delivery Company (Sector 2A)** — transports parts from Electronics Store to depot
- **All sectors (clients)** — every company in the game is a potential client
- **Construction & Real Estate (Sector 4)** — office/depot space
- **Software Firm (Sector 8B)** — natural referral and bundling partnership opportunity

**Market Dynamics:**
- **Oversaturated:** Price war on contract rates. Quality differentiation becomes the only moat. Technician hiring becomes competitive. Margin compression forces out low-skill operations.
- **Undersaturated:** Equipment failures go unserviced economy-wide. First IT Services firm in a market captures all emergency callout flow with premium pricing and zero competition.
- **Natural cycle:** Demand spikes after Technology Generation shifts (new-gen equipment installed everywhere = setup/configuration volume spike) and after economic event shocks. Smart IT firms staff for normal, take on contract labor for spikes.
- **Central Corporation version:** Basic maintenance contracts at a flat fee. Slow emergency response (2 ticks). No premium tier. No SLA customization.

**Failure Points:**
- **Technician-to-client ratio breach:** Owner keeps adding contracts without hiring. Service quality degrades across all clients. SLA penalties stack. Clients cancel. Revenue drops. Can't afford to hire. Spiral.
- **Parts stockout during emergency wave:** Multiple simultaneous equipment failures exhaust inventory. Emergency responses delayed. Contracted SLAs missed. Reputation drops. Contracts not renewed.
- **Overspecialization:** IT firm focused entirely on one sector gets hit when that sector contracts — revenue collapses with no base elsewhere.

**Emergent Gameplay:**
- **Vertical IT stack:** An Electronics Manufacturer that also owns an IT Services company ensures their own equipment is always maintained at peak quality and can offer product-plus-maintenance bundles through affiliated Electronics Stores.
- **The SLA arbitrage:** An IT firm that negotiates a premium SLA with a major player — "I'll give you 1-tick emergency response for a 40% higher contract rate" — effectively insures that player's operation. If the IT firm delivers, both parties win. If not, penalty structure punishes the IT firm badly. Real player-to-player stakes.

**Abuse & Exploit Analysis:**
- **Deliberate underservice exploit:** IT firm signs contracts, performs minimal maintenance to increase emergency callout frequency from the same clients, earning double from the same customer. **Counter:** Reputation system tracks equipment failure rates of each technician. Technicians with abnormally high client failure rates are flagged. Clients see failure rate history before signing contracts.

**Status:** ✅ Design Complete

---

## 8B. Software Firm

**Business Model:** A Software Firm designs, develops, and sells software products that provide permanent efficiency bonuses to subscribing businesses. Unlike every other company in the game, the Software Firm's product is non-physical — delivered instantly, requires no logistics, has no spoilage, and can scale to any number of subscribers without producing more units. Revenue is subscription-based: businesses pay a recurring fee per tick to maintain access to a software product. The strategic distinction: **software is the only product in Larva that gets better or worse over time without changing hands.** Bug fixes improve it. Neglect degrades it. Competitors releasing superior versions steal your subscribers. A strong Software Firm demands ongoing development investment to maintain its advantage.

**Supply Chain Position:**
```
No physical inputs required for software delivery

Talent pipeline:
Recruitment Agency (Sector 6B) → Developer/QA hires
Electronics Store (Sector 3B) → Development workstations (equipment for the firm itself)

Software Firm (develops products)
      ↓ digital delivery, no logistics required
      ↓ subscription contract per business
Subscribing businesses (all sectors)
      → efficiency bonus applied at tick processing
```

**Software Product Categories:**

| Product | Primary Market | Efficiency Bonus |
|---|---|---|
| Inventory Management System | Food & Hospitality, Retail, Manufacturing | Reduces spoilage/waste rate by a percentage based on software tier |
| CRM Platform | Retail, Restaurants, Cafés | Improves customer retention modifier — repeat customers return sooner and more reliably |
| Logistics Optimizer | Delivery Company, Trucking/Freight | Improves route efficiency (more deliveries per tick at same fuel cost) |
| HR & Payroll Suite | Any business with employees | Reduces hidden overhead from inefficient payroll processing; improves NPC employee satisfaction modifier |
| Equipment Monitoring System | All sectors | Reduces equipment degradation rate (synergy with IT Services — stackable bonus) |
| Property Management Platform | Property Management Company | Increases properties-per-manager capacity |
| Financial Reporting Suite | Accounting Firms, businesses with loan obligations | Improves financial visibility; small reduction in loan interest rate when using certified accounting software |

The firm **chooses one product to develop first.** Each additional product requires a full development cycle.

**Employee Roles:**

| Role | Function |
|------|----------|
| Software Developer | Core production role. Skill determines development speed (ticks to first release) and initial bug rate at launch. High-skill developer: fast release, low initial bugs. Low-skill NPC developer: slow release, high initial bug rate. Multiple developers reduce development time but don't reduce bugs — that's the QA role |
| QA Tester | Reduces bug rate before launch and during maintenance cycles. Without QA, software launches with baseline bugs that reduce effectiveness. High-skill player QA catches systemic issues before they damage reputation |
| Support Specialist | Handles subscriber issues. Skill determines how fast bugs reported by clients get resolved. Only matters once subscriber count exceeds a threshold |
| Product Manager | Player-only role. Unlocks multi-product development and custom feature bundles for enterprise clients. Without this role, expanding the portfolio creates cross-team friction penalties |

**Bug Rate Mechanic:** Every software product has a Bug Rate stat (0–100%). High bug rate = reduced effectiveness of the efficiency bonus. At 20% bug rate, a Logistics Optimizer that should reduce fuel costs by 15% only reduces them by 12%. Bugs accumulate over time without maintenance development cycles. Subscribers can see the bug rate and factor it into renewal decisions.

**Software Tiers:**

| Tier | Developer Skill Required | Bug Rate Profile | Subscriber Justification |
|---|---|---|---|
| Basic | ≥30 | Moderate without QA | First-mover product, fast to market, beatable |
| Standard | ≥55 | Normal with QA | Volume tier — core revenue product |
| Premium | ≥75 + QA mandatory | Low if QA is high-skill | Maximum efficiency bonus, highest churn risk from competition |

**Operating Costs (per tick):**
- **Salaries** — Developers, QA, Support. Software firms are labor-heavy; this is the dominant cost
- **Office space** — Standard commercial real estate. Size scales with team headcount
- **Development equipment** — Workstations from Electronics Store. Subject to degradation. Outdated equipment imposes a developer productivity penalty
- **Bug fix cost** — Not a direct tick cost, but bug fixing pulls Developers off the next product or feature cycle (opportunity cost, not a fee)

**Revenue Model:**

*Subscription fee per tick:* The firm sets a price per software tier. Subscribing businesses pay each tick while under contract. Contracts are typically 4–20 ticks — longer contracts lock in revenue but require competitive pricing upfront.

*Version releases:* The firm can release a new version of a product (requires development time). New versions reset the bug rate and can improve the efficiency bonus multiplier — protecting a subscriber base from defecting to a newer competitor.

**Key Owner Decisions:**
- **Which product to build first:** Market size and competitive landscape differ significantly by product category. The choice determines who your first subscribers are and what competitive dynamics you face.
- **Launch timing:** Rush (faster revenue, higher initial bug rate) vs delay for quality (longer cycle, lower bug rate, better retention from day one). A competitor might capture the market in the gap.
- **Maintenance vs expansion:** Developer time is finite. Fix bugs in the current product (protects existing subscribers) or develop the next product (expands portfolio). Recurs every few ticks as bug rate creeps up.
- **Pricing strategy:** Premium pricing with fewer subscribers (higher margin, vulnerable to churn) vs accessible pricing with high subscriber volume (lower margin, more defensible).

**Capacity & Scaling:**
- **Development capacity** — Number of active products in development or maintenance is constrained by Developer headcount
- **Subscriber capacity** — Technically unlimited. Effective cap is Support capacity — too many subscribers per Support Specialist = rising churn
- **Product Manager gate** — Multi-product operation without a player Product Manager causes cross-team friction penalty
- **Second office** — Enables a dedicated regional development team for multi-country product development

**Cross-Sector Dependencies:**
- **Electronics Store (Sector 3B)** — development workstations
- **Recruitment Agency (Sector 6B)** — Developer and QA are among the highest-demand professional roles in the economy
- **IT Services (Sector 8A)** — maintaining the Software Firm's own equipment protects developer productivity
- **Finance (Sector 5)** — high upfront development costs before any revenue; loan financing is common and rational here

**Market Dynamics:**
- **Oversaturated:** Winner-takes-most dynamics per product category. Subscribers cluster around the highest-quality product. Third and fourth entrants in the same category struggle to find subscribers.
- **Undersaturated:** Any gap in a product category is a free market. A country with no Logistics Optimizer means every Delivery Company is operating below peak efficiency.
- **Version cycle dynamics:** A competitor releasing a new superior version triggers subscriber churn unless the firm responds with its own version release. Creates predictable development pressure cycles.
- **Central Corporation software:** Generic, uncustomized, Basic/Standard tier only. Moderate bug rate, no version updates. The one dangerous version: the Central Corp's Property Management Platform is the default for new property management companies — an installed base that player firms must actively displace.

**Failure Points:**
- **Launch day bug catastrophe:** Rushing a product to market with low QA → high bug rate → efficiency bonus barely above zero → no renewals → revenue collapses before covering development cost. Reputation damage follows the firm's name, not just the product.
- **Maintenance neglect spiral:** Owner stops investing in bug fixes to pursue new product development. Bug rate climbs. Renewal rates drop. Revenue falls. Can't afford to fix old product AND build new one simultaneously.
- **Talent poaching:** High-skill Developers are the scarcest role in the game. A competing firm offering higher salaries causes immediate development speed drops and rising bug rates on existing products.

**Emergent Gameplay:**
- **The software monopoly play:** A player identifies an unserved product category, races to build Standard tier, sets aggressively long contract terms (20 ticks) to lock in the entire market before a competitor can enter. By the time a competitor launches, every eligible business is under contract.
- **Cross-sector vertical lock:** A food manufacturing empire that also owns a Software Firm producing an Inventory Management System subscribes its own factories at cost while selling to competitor factories at full price. Their spoilage rate is permanently lower than anyone who has to pay for the software.
- **The bug bounty market:** A sophisticated Software Firm offers subscribers an in-game credit refund when they report a confirmed bug before the dev team finds it. Accelerates bug discovery, creates goodwill, justifies premium pricing. Entirely emergent — players designing their own reputation mechanics within the framework.

**Abuse & Exploit Analysis:**
- **Zero-cost subscription farming:** A player owns both a Software Firm and a subscribing company, prices the subscription at an inflated rate to move money between entities and inflate the Software Firm's revenue. **Counter:** Same-owner transactions flagged and discounted in the valuation algorithm. Intra-owner subscription pricing compared against market rates; anomalous pricing applied as a valuation modifier.

**Status:** ✅ Design Complete

---

## 8C. Data Analytics Firm

**Business Model:** A Data Analytics Firm collects, processes, and sells market intelligence derived from the game economy's real transaction data. While every other business is acting on instinct, contracts, and visible market prices, a Data Analytics subscriber receives structured intelligence: price trend forecasts, labor market reports, sector performance summaries, and supply-chain health indicators. Revenue is subscription-based, sold as tiered intelligence packages. The strategic distinction: **the Data Analytics Firm is the only company in the game that explicitly monetizes the economy's own complexity.** The more players, companies, sectors, and countries are active, the richer the data — and the more valuable the firm's product. It grows with the world around it.

**Supply Chain Position:**
```
Game Economy Transaction Data (anonymized aggregate feed — provided by Central Corporation data access license)
      ↓ (purchased as raw data subscription — paid to Central Corporation per tick)
Data Analytics Firm
      ↓ Analysts process raw data into structured intelligence products
      ↓ subscription contract, no logistics required
Subscribing businesses (all sectors)
      → better pricing decisions
      → better inventory decisions
      → better hiring decisions
      → better contract timing
```

**Important:** The Central Corporation sells a raw data access license. This is the only input the Data Analytics Firm cannot produce internally. The license is a fixed operating expense regardless of analytical output quality. The firm's margin is determined entirely by how well its Analysts turn raw data into products clients pay for.

**Employee Roles:**

| Role | Function |
|------|----------|
| Data Analyst | Core production role. Skill determines report quality — depth of trend analysis, forecast accuracy window, and breadth of sector coverage. Low-skill NPC Analyst: 1-tick-lag price reports for a single sector. High-skill player Analyst: 2-tick forward-looking trend reports across multiple sectors with confidence intervals |
| Research Specialist | Adds sector-specific depth to reports. A Specialist with Finance domain knowledge produces significantly better investment and credit market reports. Multiple Specialists can each cover different sectors, expanding the firm's reportable scope without degrading quality |
| Report Designer | Improves the UX of delivered intelligence. High-skill Report Designer → subscribers can act on reports more easily. Influences subscriber retention even when a competitor offers similar data. Only impactful above ~15 subscribers |
| Analytics Director | Player-only role. Unlocks cross-country reports, enterprise intelligence bundles, and real-time alert subscriptions (event-triggered notifications). Required for the most valuable product tiers |

**Operating Costs (per tick):**
- **Central Corporation data license** — mandatory, fixed cost per tick. Covers anonymized aggregate transaction data for the firm's home country. Each additional country costs an additional license fee. Cannot be avoided or reduced
- **Salaries** — Analysts, Research Specialists, Report Designer, Director
- **Office space** — standard commercial real estate
- **Analytics equipment** — higher-tier processing workstations from Electronics Store improve Analyst throughput. Subject to normal degradation

**Revenue Model:**

*Subscription tiers:*
- **Sector Report** — covers one industry sector. Price reflects depth (company types covered, forecast horizon)
- **Country Report** — macro-level view of a country's economic health. Useful for investors and Finance sector clients
- **Custom Intelligence Package** — requires Analytics Director. Tailored to one client's specific business. Highest price, highest renewal probability

*Report quality modifiers:*
- Analyst skill → forecast accuracy (±5% variance for high-skill vs ±15% for low-skill)
- Data lag → 1-tick-lag (what happened last tick) vs 0-lag (current-state) vs leading indicators (trend-based forward signals)
- Coverage breadth → single-sector vs multi-sector vs cross-country

*One-time reports:* Sold to non-subscribers at a higher per-report price. Lower total value but accessible to clients who don't want recurring commitment.

**Key Owner Decisions:**
- **Coverage specialization:** Focus deep on one sector (definitive intelligence for that market, premium pricing, more defensible) or spread across sectors (lower quality per sector, larger potential subscriber base, more resilient to sector downturns).
- **Country expansion:** Each additional country requires a separate data license fee. Expanding too early = license cost exceeds revenue from new subscribers. Timing this expansion is the primary strategic decision at mid-game.
- **Data lag investment:** Investing heavily in Analyst quality produces forward-looking reports. The premium isn't just the information — it's the time advantage. Knowing something this tick vs last tick can be worth significant money to a large business.
- **Enterprise vs retail:** Many small businesses (stable volume, low per-subscriber revenue, low per-client churn risk) vs a few large enterprises with custom packages (high per-client revenue, catastrophic if one leaves).

**Capacity & Scaling:**
- **Analyst capacity** — each Analyst produces a fixed number of reports per tick. Cannot sell more than can be produced
- **Research Specialist gate** — without domain specialists, multi-sector coverage thins out. Hiring dedicated specialists per sector is the mid-game quality bottleneck
- **Data license cost per country** — natural brake on expansion; each country added increases fixed costs before adding revenue
- **Analytics Director gate** — cross-country reports and enterprise bundles locked without this role

**Cross-Sector Dependencies:**
- **Central Corporation (data license)** — the only company type in the game where the Central Corporation is not just a competitor but also a supplier. Every Data Analytics Firm pays the Central Corporation for raw data regardless of which firm wins subscribers
- **Finance (Sector 5)** — Investment Firms and Private Banks are the highest-value subscribers. Country and sector performance reports are worth substantially more to someone managing a loan portfolio or investment fund
- **Electronics Store (Sector 3B)** — analytics workstations
- **Recruitment Agency (Sector 6B)** — Analytics roles require high skill; competitive salary and recruitment pipeline required
- **Legal Firm (Sector 6A)** — data privacy compliance in high-regulation countries

**Market Dynamics:**
- **Oversaturated:** Rare — unlike software, analytics firms naturally segment into specialist lanes by sector coverage. Head-to-head competition is possible but less likely than in other sectors.
- **Undersaturated:** The default early-game state. First entrant has enormous value even with modest analyst skill — something beats nothing. First-mover lock-in through contracts is critical.
- **Economy scale dependency:** Small early-game economy → thin data → narrow, low-confidence reports → modest fees. Large late-game economy → rich transaction history → deep trend analysis → premium pricing justified. The one company type that gets mechanically more powerful as the game world matures.
- **Finance sector symbiosis:** As Finance sector grows — more loans, investment activity, insurance claims — demand for credit and market intelligence explodes. A firm with strong Finance sector coverage in a mature economy is among the highest-revenue businesses in the game.
- **Central Corporation competition:** Generic country-level macro reports with 2-tick data lag. Immediately beatable by any player firm with skilled Analysts and sector-specific coverage.

**Failure Points:**
- **License cost without subscribers:** Expanding to new countries before building a subscriber base there pays the license fee every tick with no offsetting revenue. Across two or three countries simultaneously, fixed license costs overwhelm operating cashflow.
- **Analyst departure:** The entire firm's product quality rests on Analyst skill. A high-skill player Analyst resigning drops report quality immediately. Mass churn in the following contract cycle if a replacement isn't hired quickly.
- **Data relevance collapse:** In a severe economic downturn, low transaction volume makes reports low-confidence. Subscribers — whose businesses are also struggling — cancel subscriptions to cut costs. Revenue collapses exactly when the economic environment is most stressful.
- **Over-specialization in a declining sector:** A firm that built its entire product line around one sector suffers badly if that sector contracts. Pivoting requires hiring new Research Specialists with different domain knowledge — slow and expensive.

**Emergent Gameplay:**
- **The intelligence monopoly:** A Data Analytics Firm with senior Analysts covering every sector and an Analytics Director handling cross-country reports holds the economy's information advantage. A player who combines this with an Investment Firm can make near-optimal investment decisions every tick using their own analytics product — legally, since there's no rule against self-subscriptions. Requires enormous investment in both firms simultaneously; a strong competitor in either sector breaks the advantage.
- **Intelligence as a weapon:** A retail empire subscribes specifically to track competitor pricing trends in their own sector. If the analytics firm is skilled enough, reports show competitor price movements 1–2 ticks in advance (leading indicators based on wholesale purchase patterns). Entirely legal — devastating to competitors who don't subscribe.

**Abuse & Exploit Analysis:**
- **Subscription inflation exploit:** Same-owner subscription pricing flagged; valuation algorithm discounts intra-owner transactions. Data is anonymized and aggregated — the report shows "average restaurant ingredient cost rose 8% this tick," not "Player X's restaurant is paying $14/unit for flour." Intelligence advantage is real but not omniscient.

**Status:** ✅ Design Complete

---

## Sector 8 Summary

| Company Type | Revenue Model | Volatility | Key Differentiator | Core Risk |
|---|---|---|---|---|
| IT Services | Maintenance contracts + emergency callouts | Medium (event-triggered spikes) | Direct interaction with equipment degradation system | Technician-to-client ratio breach; SLA penalty cascade |
| Software Firm | Subscription per tick per subscribing business | Medium-High (competitor version releases, subscriber churn) | Non-physical product; scales infinitely; version cycle competition | Bug rate damage + developer talent loss |
| Data Analytics Firm | Subscription per intelligence package per tick | Low-Medium (scales with economy maturity) | Economy-scale dependency; grows more powerful as the game world matures | License cost expansion trap; analyst departure; sector-specific subscriber collapse |

**Sector-wide characteristics:**
- All three are **B2B only** — they serve businesses, never individual players directly
- No physical goods produced in Software or Data Analytics — the only sector where two of three company types have zero logistics dependency
- All three use **subscription-based revenue** (Software and Data) or recurring contract revenue (IT Services) — creating predictable cashflow and churn dynamics unique to this sector
- All three are **efficiency multipliers** — their value is measured not in what they produce independently but in what they enable other companies to do better
- The **Central Corporation** operates baseline versions of all three — basic maintenance contracts, generic uncustomized software, lagged macro reports. Beatable by player firms investing in skill and quality
- All three depend on **Electronics Store equipment** for internal operations
- All three compete for **specialized high-skill labor** — Developers, Analysts, and skilled Technicians are among the rarest employees in the economy

**Cross-technology dynamics:**
- IT Services + Software Firm natural partnership: IT maintains the workstations the software firm develops on, and can refer clients to the software firm for efficiency tools
- Software Firm + Data Analytics natural synergy: Analytics reports reveal which sectors are underserved by software products, informing the Software Firm's next development investment
- Data Analytics + Finance natural symbiosis: The most valuable intelligence subscribers are Finance companies managing investment and credit decisions

---

*Last updated: May 25, 2026 — Sector 8 design complete*
