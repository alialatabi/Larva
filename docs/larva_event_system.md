# Project Larva — Event System (Complete)

> **Status:** ✅ Design Complete  
> **Parent document:** See `larva_master.md` for core systems, cross-sector rules, and progress tracker

---

## Design Philosophy

Events exist to prevent the economy from reaching a solved equilibrium. Without events, the optimal business strategy eventually becomes static — same suppliers, same prices, same margins, forever. Events introduce controlled volatility that rewards preparation, punishes rigidity, and creates the narrative moments players remember.

Three rules govern every event in the system:

**Rule 1 — No event is purely random.** Every event has a probability that shifts based on real economic conditions. Health events are more likely when player populations are dense. Equipment failures are more likely when maintenance is neglected. Economic booms increase the probability of overheating corrections. The dice are always loaded by the state of the world.

**Rule 2 — No event is unavoidable in its consequences.** The event happens — the shock is real. But whether it destroys a business or creates an opportunity depends entirely on preparation. A technology generation shift wrecks the manufacturer who overstocked. It makes the manufacturer who kept lean inventory and invested in R&D rich. Same event, opposite outcomes.

**Rule 3 — No event targets individual players.** Events affect countries, sectors, or the global economy. They never single out a specific company or player. The consequences land unevenly because players are positioned differently — not because the system is picking winners.

---

## Event Classification

Every event belongs to one of four scopes and one of three severity tiers.

### Scopes

| Scope | Affects | Example |
|-------|---------|---------|
| Global | All 18 countries simultaneously | Technology Generation Shift |
| Regional | 2–5 countries in the same economic tier | Trade route disruption |
| Country | One specific country | Local health outbreak |
| Sector | One sector across all countries (or one sector in one country) | Raw material price shock |

### Severity Tiers

| Tier | Label | Frequency | Impact Duration | Economic Impact |
|------|-------|-----------|----------------|-----------------|
| 1 | Minor | Common (multiple per real week) | 1–3 ticks | Small margin shifts, minor demand changes |
| 2 | Major | Moderate (1–3 per real week) | 4–10 ticks | Significant supply/demand shifts, insurance claims triggered |
| 3 | Crisis | Rare (1–2 per real month) | 10–20+ ticks | Economy-reshaping, bankruptcies possible, cascading effects |

---

## Event Categories

### A. Technology Events

**Technology Generation Shift** (Global, Tier 3)

Already designed in Sector 7. Interval: 40–60 ticks average, semi-random. All previous-generation electronics lose 30% value. Production lines require 1-tick retooling. Premium pricing window for 2–3 ticks post-shift. R&D Specialists with high skill get 2–3 tick advance probabilistic warning. Affects: Electronics Manufacturers, Electronics Stores, IT Services (demand spike), every company's equipment value.

**Software Vulnerability Discovery** (Sector, Tier 1)

A randomly selected software product category is flagged with a vulnerability. All businesses subscribing to affected software products experience a 1-tick efficiency penalty until their IT Services provider patches the issue (or 2 ticks if they have no IT contract). Software Firms that produced the affected product must issue a patch — developer skill determines patch speed. Creates emergency IT Services demand and highlights the value of maintenance contracts.

**Infrastructure Outage** (Country, Tier 2)

A country's digital infrastructure degrades for 3–5 ticks. All businesses in that country experience reduced efficiency from software and data analytics subscriptions. Data Analytics reports in that country are delayed by 1 extra tick. IT Services emergency callout volume spikes. Probability increases in low-infrastructure countries.

---

### B. Health Events

**Local Health Outbreak** (Country, Tier 2)

An illness wave hits one country. Player health decay rate increases by 50% for 5–8 ticks. Pharmacy demand spikes. Health product prices rise toward the ceiling. Pharmaceutical manufacturers with stock profit. Those without stock lose the window. Insurance claims trigger for Health Insurance policyholders. Probability weighted by country player density — more crowded countries get more outbreaks.

**Seasonal Illness Wave** (Regional, Tier 1)

Mild health event affecting 2–4 countries in the same tier. Health decay rate increases 20% for 3–4 ticks. Smaller demand spike than a full outbreak. Frequent enough to be a planning factor for Pharmacy inventory management.

**Pandemic** (Global, Tier 3)

Extremely rare — once every 200–400 ticks (50–100 real days). All countries affected simultaneously. Health decay rate doubles for 10–15 ticks. Massive pharmaceutical demand. Transportation efficiency reduced (logistics slower). Consumer spending shifts heavily toward health, away from discretionary categories. Restaurants and entertainment demand drops. Pharmacies and health-adjacent businesses boom. The single most economy-reshaping health event. Insurance companies face simultaneous claims from health, business interruption, and transport policies.

---

### C. Fashion Events

**Fashion Shift** (Global, Tier 2)

Already designed in Sector 7. Interval: 30–50 ticks average, high variance, no advance warning. Current-season designs retain value. Previous-season loses 20% Charisma modifier. Two-seasons-old loses 50%. Older designs drop to Budget-tier minimum. Affects: Textile Manufacturers (inventory depreciation), Clothing Stores (clearance pressure), players (Charisma stat shift).

**Trend Emergence** (Country, Tier 1)

A specific clothing tier or style sees increased demand in one country for 5–8 ticks. Luxury demand spikes in a wealthy country. Budget demand spikes in a country experiencing economic downturn. Clothing Stores stocking the right tier gain temporary revenue boost. Minor but creates micro-opportunities for attentive retailers.

---

### D. Supply Chain Events

**Raw Material Price Shock** (Sector, Tier 2)

One raw material category increases in price by 15–40% for 5–10 ticks. Affects all manufacturers using that material across all countries (though countries where that material is locally abundant are partially shielded — price increase is halved for abundant resources). Squeezes manufacturer margins. Smart manufacturers with long-term supply contracts are insulated. Those on short-term contracts absorb the full shock.

**Logistics Disruption** (Regional, Tier 2)

Cross-border logistics between 2–4 countries slows by 50% and costs increase by 25% for 4–8 ticks. All international shipments in the affected corridor are delayed. Companies dependent on cross-border supply chains are hit. Companies operating entirely domestically are unaffected. Creates temporary advantage for local manufacturers and domestic suppliers.

**Port/Route Closure** (Country, Tier 2)

One country's international logistics is fully blocked for 2–4 ticks. No goods in or out. Domestic operations continue normally. Companies dependent on imports face stockouts. Companies dependent on exports can't ship. Manufacturers in that country stockpile with no outbound channel. Brutal for trade-dependent economies. Probability increases for countries with low infrastructure ratings.

**Spoilage Wave** (Country, Tier 1)

Abnormal conditions cause accelerated spoilage across one product category in one country for 3–5 ticks. Affects food products, pharmaceutical products, or any spoilage-eligible inventory. Increases waste rate by 30%. Supermarkets, restaurants, and pharmacies lose more stock than usual. Creates replacement demand for manufacturers.

---

### E. Financial Events

**Credit Crunch** (Country, Tier 2)

Private bank lending tightens in one country. Central Bank wholesale rate temporarily increases by 2% for that country for 5–10 ticks. Private banks face higher borrowing costs, pass them to borrowers or absorb margin compression. New business loans become more expensive. Expansion slows. Cash-rich businesses gain competitive advantage over leveraged ones. Probability increases when the country's total outstanding private bank debt exceeds 3× total deposits.

**Market Correction** (Global, Tier 2)

Stock market prices across all listed companies drop 10–20% over 2–3 ticks, then stabilize. Triggered probabilistically when the average stock price across all companies exceeds fair value by more than 25% for 10+ consecutive ticks (market overheating). Investment Firms with heavy equity exposure take losses. Players holding stocks lose paper value. Counter-cyclical investors buy the dip. Banks with stock collateral on loans face margin calls.

**Bank Run** (Country, Tier 3)

A crisis of confidence in one country's banking sector. Depositors at all private banks in the country withdraw 30–50% of deposits over 3–5 ticks. Banks must replace cheap deposit capital with expensive wholesale borrowing or liquidate loan portfolios at a loss. Weakest banks fail. Deposit insurance kicks in. Survivors emerge with less competition. Probability increases when any private bank in the country fails (contagion trigger) or when a major employer in the country goes bankrupt (income shock).

**Liquidity Squeeze** (Country, Tier 1)

The Central Corporation temporarily reduces its injection for one country by 30–50% for 2–3 ticks. Total currency flowing into local NPC salaries and CC operations drops, tightening the money supply in that country. Background Customer Revenue for businesses in that country falls proportionally. Cash-rich businesses and those with real-player customers are largely unaffected. Businesses dependent on NPC-driven demand feel the squeeze. Probability increases when a country's currency circulation has grown faster than its economic output for 5+ consecutive ticks. Functions as the economy's natural pressure release valve — a brief tightening signal before conditions worsen further.

---

### F. Labor Events

**Skilled Labor Shortage** (Country, Tier 1)

NPC employees in one skill category become scarce in one country for 5–10 ticks. Salary demands for that skill increase 20–30%. Companies relying on NPCs in that domain face higher operating costs. Companies with real player employees are unaffected. Creates temporary demand for Recruitment Agencies and Corporate Training. Probability increases when a country's economy grows faster than its workforce.

**Labor Strike** (Country, Tier 2)

NPC employees across all sectors in one country reduce productivity by 40% for 3–5 ticks. Simulates collective bargaining pressure. All companies in the country produce less output per tick. Player employees are unaffected (they make their own decisions). Countries with higher labor cost modifiers have lower strike probability (workers are already better compensated). Resolution: strike ends automatically after the duration expires. During the strike, companies that voluntarily raise NPC salaries by 10%+ see productivity restored immediately — an active choice with a permanent cost increase.

**Key Employee Poaching Wave** (Sector, Tier 1)

A sector experiences above-average employee turnover for 3–5 ticks. NPC employees in that sector have a 15% higher chance of being hired away by competing businesses per tick. Forces companies to either raise salaries preemptively or accept higher turnover risk. Creates demand for Recruitment Agencies. Realistic market pressure event.

---

### G. Natural & Infrastructure Events

**Construction Boom** (Country, Tier 1)

Real estate demand in one country increases 20% for 8–12 ticks. New properties take 1 fewer tick to complete. Rental prices rise. Property Management companies see higher occupancy. Construction Companies have more orders than capacity. Benefits the entire real estate supply chain.

**Infrastructure Degradation** (Country, Tier 2)

A country's infrastructure rating effectively drops one level for 5–10 ticks. Domestic logistics slow. Operating costs rise slightly for all businesses. Probability increases when tax revenue in the country has been low for extended periods (underinvestment in infrastructure). This creates a visible feedback loop: low taxes → low infrastructure spending → degradation event → businesses suffer → players advocate for higher taxes.

**Natural Disasters** — see dedicated section below.

---

### H. Regulatory Events

**Tax Policy Shift** (Country, Tier 1)

A country's base tax rate adjusts by 1–3 percentage points (up or down) for 10–20 ticks, then reverts. Simulates political pressure. Higher taxes temporarily squeeze margins but improve infrastructure investment (visible after a delay). Lower taxes temporarily boost margins but infrastructure spending decreases. Players in that country experience the tradeoff in real time.

**Regulatory Crackdown** (Sector, Tier 1)

One sector in one country faces increased regulatory scrutiny for 5–10 ticks. Operating costs increase 10% (compliance costs). Companies with an Accounting Firm subscription or Legal Firm on retainer are partially shielded (5% instead of 10%). Creates demand for Professional Services. Probability increases for sectors with recent quality failures (pharmaceutical recalls, food safety incidents, bank failures).

**Trade Agreement** (Regional, Tier 1)

Cross-border transaction surcharges between 2–3 countries are reduced by 50% for 10–20 ticks. International trade between those countries becomes cheaper. Benefits exporters and importers in the affected corridor. Creates temporary trade route advantages that reward repositioning.

---

## Natural Disaster Sub-System

### Design Principle

Every country is vulnerable to at least one natural disaster type. No country is vulnerable to all of them. The geographic hazard profile adds a risk dimension to country selection — a player choosing a country now weighs not just taxes, labor, and resources, but also what can go wrong. This creates insurance demand that's geographically distributed, and makes disaster preparedness a real strategic consideration.

---

### Five Disaster Types

**1. Earthquake**

Buildings and equipment take structural damage. Commercial properties in the country have a 10–25% chance of being "damaged" (requiring Construction Company repair before full operation resumes). Equipment across all businesses has a 15–30% chance of accelerated degradation (equivalent to 5–10 ticks of wear applied instantly). Inventory in warehouses and retail locations is 5–15% destroyed (shaking damages goods). Domestic logistics slowed 30% for the duration (road damage). Duration: 3–8 ticks.

**2. Coastal Storm**

International logistics to and from the affected country are fully blocked for 1–3 ticks, then slowed 50% for 3–5 additional ticks. Domestic logistics slowed 40%. Inventory in coastal storage (warehouses, retail) takes 10–20% destruction. Commercial properties have a 5–15% chance of damage. No effect on equipment. The defining characteristic: the trade blockade. Countries that depend on imports and exports are devastated. Self-sufficient domestic economies ride it out. Duration: 4–8 ticks total.

**3. Drought**

Agricultural Products in the affected country become scarce. Local agricultural raw material prices increase 40–60% for 8–15 ticks. Food Manufacturing output drops 25% (ingredient shortage). Restaurants, cafés, and supermarkets face supply pressure — either pay more for local ingredients or import at international logistics cost plus surcharge. No structural damage to buildings or equipment. No logistics disruption. Pure supply-side shock to the food chain. Duration: 8–15 ticks (longest-lasting disaster type — droughts are slow).

**4. Flood**

Inventory destruction is the primary impact: 20–35% of all stored goods in the country are destroyed (warehouses, retail shelves, manufacturer stockpiles). Commercial properties have a 10–20% chance of damage. Domestic logistics severely disrupted (speed reduced 60%) for the duration. International logistics slowed 30%. Equipment takes moderate water damage (5–10% accelerated degradation). The defining characteristic: inventory wipeout. Businesses that were running lean lose less. Businesses that were stockpiling lose enormously. Duration: 4–8 ticks.

**5. Wildfire**

Timber & Wood and Natural Fibers in the affected country become scarce. Local prices for these resources increase 50–70% for 6–12 ticks. Construction material supply chains disrupted (timber-dependent projects stall). Textile manufacturing faces fiber shortage. Commercial properties in the country have a 5–10% chance of fire damage (more severe than other disaster types — fire damage costs more to repair). Domestic logistics slowed 20% (road closures). Duration: 6–12 ticks.

---

### Geographic Hazard Profiles

Each country is assigned 1–2 disaster vulnerabilities based on its identity, resources, and economic position.

| Country | Tier | Hazard Vulnerabilities | Design Rationale |
|---------|------|----------------------|------------------|
| **Valen** | Developed | Earthquake, Flood | Dense financial capital — urban earthquake risk, flood-prone from density and development |
| **Thorn** | Developed | Earthquake | Tech hub, dense urban, built on mineral-rich geology (chemicals, metals) |
| **Aurel** | Developed | Coastal Storm, Flood | Luxury market, high-density coastal economy |
| **Pella** | Developed | Flood, Earthquake | Suburban sprawl — sprawling development creates flood exposure, seismic risk from metals-bearing geology |
| **Bren** | Developed | Wildfire | University city surrounded by timber country |
| **Korr** | Emerging | Earthquake, Coastal Storm | Industrial port, heavy extraction geology — seismic risk, coastal trade exposure |
| **Meris** | Emerging | Drought, Flood | Breadbasket — agricultural flatlands, vulnerable to both drought and river flooding |
| **Cassen** | Emerging | Coastal Storm | Trading crossroads — port-dependent economy, storm shuts down the trade lifeline |
| **Dravel** | Emerging | Drought | Arid tax haven with petroleum — water scarcity, agricultural imports already strained |
| **Lorren** | Emerging | Earthquake, Wildfire | Build city on stone and timber — seismic geology, forested surroundings |
| **Solven** | Emerging | Flood, Earthquake | Pharma valley — low-lying valley geography, chemical-geology seismic risk |
| **Rynna** | Emerging | Coastal Storm, Flood | Emerging port city — coastal exposure, river delta flooding |
| **Nova** | Emerging | Drought, Wildfire | Balanced center with agriculture and timber — vulnerable to both |
| **Vesk** | Developing | Flood, Drought | Textile floor with low infrastructure — low-lying agricultural area |
| **Kethos** | Developing | Earthquake | Mining hub — deep extraction destabilizes geology, seismic zone |
| **Zara** | Developing | Drought | Frontier farm — agricultural economy, minimal water infrastructure |
| **Orval** | Developing | Earthquake, Wildfire | Quarry state — extraction-heavy geology, remote forested areas |
| **Tyrn** | Developing | Wildfire, Flood | Raw frontier — dense wilderness, minimal flood infrastructure |

### Distribution Verification

| Disaster | Countries Vulnerable | Count |
|----------|---------------------|-------|
| Earthquake | Valen, Thorn, Pella, Korr, Lorren, Solven, Kethos, Orval | 8 |
| Coastal Storm | Aurel, Korr, Cassen, Rynna | 4 |
| Drought | Meris, Dravel, Nova, Vesk, Zara | 5 |
| Flood | Valen, Aurel, Pella, Meris, Solven, Rynna, Vesk, Tyrn | 8 |
| Wildfire | Bren, Lorren, Nova, Orval, Tyrn | 5 |

Every disaster type hits 4–8 countries. Earthquake and Flood are the most widespread (8 each). Coastal Storm is the most concentrated (4 countries).

### Vulnerability Count Per Country

| Vulnerabilities | Countries |
|----------------|-----------|
| 1 disaster | Thorn, Bren, Cassen, Dravel, Kethos, Zara |
| 2 disasters | Valen, Aurel, Pella, Korr, Meris, Lorren, Solven, Rynna, Nova, Vesk, Orval, Tyrn |

---

### Probability and Severity

Natural disasters use the same probability framework as all other events with additional modifiers.

**Base probability:** 0.5% per tick per eligible disaster type per vulnerable country. Each specific disaster in each specific country fires roughly once every 200 ticks (50 real days) on average.

**Condition Multipliers:**

| Condition | Multiplier | Logic |
|-----------|-----------|-------|
| Low infrastructure | ×1.5 | Worse preparedness, less resilient systems |
| Medium infrastructure | ×1.0 | Baseline |
| High infrastructure | ×0.7 | Better engineering, early warning systems, flood defenses |
| Recent same-disaster cooldown (within 40 ticks) | ×0.1 | Near-immunity after a recent hit — prevents stacking |
| High player density in country | ×1.2 | More economic activity = more exposure |

**Severity Scaling:**

When a disaster fires, severity is rolled on a weighted distribution:

| Severity | Probability | Impact Level |
|----------|------------|--------------|
| Minor (Tier 1) | 50% | Lower end of damage ranges. 2–3 tick duration. Manageable. |
| Major (Tier 2) | 35% | Mid-range damage. Full stated duration. Insurance claims spike. |
| Catastrophic (Tier 3) | 15% | Upper end of all damage ranges. Maximum duration. Economy-reshaping. |

A Tier 3 catastrophic earthquake in a low-infrastructure developing country is possible but rare — roughly once every 1,300 ticks (325 real days) for any given country. When it happens, it's the defining economic event of that game period.

---

### Economic Ripple Effects

Natural disasters don't just damage the affected country — they ripple through the trade network:

**Supply chain disruption:** If a disaster hits a major manufacturing country (Korr earthquake, Solven flood), downstream retailers and businesses in other countries face supply shortages until the source recovers.

**Price spikes in unaffected countries:** When supply from a disaster-hit country drops, demand shifts to alternative suppliers. A Meris drought makes agricultural prices rise in Vesk, Nova, Rynna, and Zara as buyers compete for remaining supply.

**Logistics rerouting:** A Cassen coastal storm forces international shipments to route through Rynna or other logistics hubs. Rynna logistics companies see a temporary demand spike.

**Insurance cascade:** Disaster events trigger simultaneous claims across multiple insurance policy types. This tests insurance company reserves. A well-capitalized insurer survives and gains reputation. An undercapitalized one collapses.

**Construction boom post-disaster:** After any disaster that damages buildings, Construction Companies in and near the affected country see a demand surge. Repair contracts flood in. Construction material prices rise. Disasters destroy value, construction rebuilds it.

---

### Interaction with Infrastructure Investment

The progressive tax system funds infrastructure improvements. Higher tax revenue → better infrastructure → fewer and less severe disasters (×0.7 multiplier, damage at 70% of stated ranges for high-infrastructure countries).

This creates a visible feedback loop: higher taxes → better infrastructure → fewer and less severe disasters → more stable economy → businesses thrive → generates more tax revenue. Low-tax countries save money but accept higher disaster risk. Players in those countries can partially offset this with insurance — but premiums will be higher in high-risk countries.

---

### Player-Facing Disaster Information

**Country selection screen (addition):** Each country's profile shows its Geographic Hazard Profile — which disaster types it's vulnerable to. No probability numbers shown, just hazard icons and labels.

**Economic dashboard (addition):** Active disasters show with affected country, type, severity, remaining duration, and estimated economic impact. Historical disaster log per country.

**Data Analytics advantage:** Subscribers receive disaster risk assessments — statistical likelihood per country based on current conditions. One of the highest-value intelligence products in the game.

---

### Abuse Prevention

**No player-triggered disasters.** All disasters are system-rolled.

**No disaster arbitrage through timing.** Disaster rolls happen at tick processing before business operations. Damage applies before any player response is possible. Response happens on the next tick.

**Insurance fraud prevention.** Claims are automatic and server-verified. The system knows exactly what was destroyed, damaged, and what the replacement value is.

---

## Event Probability System

Events are not purely random. Each event has a **base probability per tick** modified by **condition multipliers.**

```
Actual Probability = Base Probability × Π(Condition Multipliers)
```

**Example — Local Health Outbreak:**
- Base probability: 2% per tick per country
- Player density multiplier: ×1.0 at normal density, ×1.5 at high density, ×2.0 at very high density
- Recent outbreak suppressor: ×0.2 if an outbreak occurred in the same country within the last 20 ticks (immunity window)
- Infrastructure quality: ×0.8 for high infrastructure, ×1.0 for medium, ×1.3 for low

A high-density, low-infrastructure country with no recent outbreaks: ~5.2% chance per tick (once every ~19 ticks on average). A low-density, high-infrastructure country post-outbreak: ~0.32% chance (once every ~312 ticks).

### Cooldown Mechanic

Every event type has a minimum cooldown per scope after firing. Technology Generation Shifts can't fire within 30 ticks of the last one. Health Outbreaks can't hit the same country within 20 ticks. Natural disasters of the same type can't hit the same country within 40 ticks.

### Clustering Prevention

No more than 3 Tier 2+ events can be active globally at any given tick. If a 4th would fire, it's deferred to the next tick where a slot opens. Tier 1 events are exempt from this cap.

---

## Event Notification System

### Pre-Event Signals (Where Applicable)

- Technology Generation Shift: R&D Specialists get probabilistic warning (skill-dependent, 2–3 ticks)
- Data Analytics subscribers may detect leading indicators for economic events (credit crunches, market corrections) 1–2 ticks early based on report quality
- No other events have advance warning — they arrive at tick processing

### At-Event Notification

- All players in the affected scope receive a notification: event name, severity, expected duration, affected scope
- The economic dashboard shows active events with remaining duration and affected areas
- Company owners in affected sectors see event impact on their next P&L projection

### Post-Event Summary

- When an event expires, affected players see a summary: what happened, estimated economic impact, how their businesses were affected
- Historical event log available on the economic dashboard

---

## Event Impact on Insurance

Every Tier 2 and Tier 3 event generates automatic insurance claims for eligible policyholders:

| Event Category | Insurance Types Triggered |
|----------------|-------------------------|
| Health events | Health Insurance (player claims), Business Interruption (if staff shortage) |
| Technology shifts | Equipment Insurance (obsolescence losses) |
| Supply chain disruptions | Transport Insurance, Inventory Insurance, Business Interruption |
| Natural disasters | Equipment Insurance, Inventory Insurance, Business Interruption, Transport Insurance |
| Financial events | Loan Default Insurance (if borrower defaults increase) |

Claims are processed automatically at tick. No manual filing. The Insurance Company pays if the claim falls within policy terms and above the deductible.

---

## Event Calendar Transparency

The system does NOT publish upcoming events. But it DOES publish:

- Active events and their remaining duration
- Historical event log with timestamps and impacts
- Base probability ranges for each event type (players can read the rules)
- Current condition multipliers per country (player density, infrastructure, recent event history)

Players with Data Analytics subscriptions see deeper analysis — statistical likelihood of events per country, leading indicators, and sector-specific risk assessments.

---

## Technical Implementation

### Tick Processing Order for Events

1. Roll event probabilities for all event types across all scopes
2. Check cooldowns and clustering cap
3. Fire qualifying events
4. Apply event effects to affected entities (before business processing)
5. Process business operations with event modifiers active
6. Process insurance claims generated by events
7. Update event durations (decrement remaining ticks)
8. Expire completed events and generate post-event summaries

### Database Requirements

- `events` table: event_id, type, scope, severity, affected_countries[], affected_sectors[], start_tick, duration, remaining_ticks, modifiers{}, status (active/expired)
- `event_history` table: permanent log of all past events for dashboard and analytics
- `event_conditions` table: per-country condition multiplier snapshots updated each tick
- `country_hazard_profiles` table: country_id, disaster_types[], probability_modifiers{}

### Computational Cost

Event probability rolls are lightweight — ~30 event types × 18 countries = ~540 rolls per tick. Condition multiplier lookups are pre-cached. Natural disaster rolls add ~90 additional checks (18 countries × up to 5 disaster types, but most countries only have 1–2). Total event processing: negligible compared to business tick processing.

---

*Last updated: May 27, 2026 — Currency Pressure Event (obsolete — referenced real-money cashouts and exchange rate) replaced with Liquidity Squeeze event aligned with the closed-currency model.*
