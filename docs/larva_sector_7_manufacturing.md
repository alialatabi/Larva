# Project Larva — Sector 7: Manufacturing (Complete)

> **Status:** ✅ All 3 company types fully designed  
> **Parent document:** See `larva_master.md` for core systems, cross-sector rules, and progress tracker

---

## Raw Materials Framework (Cross-Sector Rule)

The Central Corporation is the **sole extractor and processor of all raw materials** in every country. Players cannot own mining, forestry, chemical extraction, or any raw material production operation. This is a deliberate simplification that reduces complexity while creating strong cross-country trade dynamics. It can be opened to player ownership in a future expansion if the economy supports it.

**Raw Material Categories:**

| Category | Used By | Example Materials |
|----------|---------|-------------------|
| Agricultural Products | Food Manufacturing | Grains, produce, dairy, meat, spices, sugar |
| Metals & Minerals | Electronics Manufacturer, Construction Companies | Steel, aluminum, copper, silicon, rare earth elements |
| Petroleum & Synthetics | Electronics Manufacturer, Textile Manufacturer, Pharmaceutical Manufacturer | Plastics, synthetic fibers, petrochemical compounds |
| Natural Fibers | Textile & Apparel Manufacturer | Cotton, wool, silk, linen |
| Chemical Compounds | Pharmaceutical Manufacturer | Active pharmaceutical ingredients, reagents, solvents |
| Timber & Wood | Construction Companies | Lumber, plywood, engineered wood |
| Stone & Aggregate | Construction Companies | Concrete, gravel, granite, marble |

**Country Resource Distribution:**
- Each country has **1–3 abundant resource categories** — these are available locally at the Central Corporation's base price
- All other categories must be **imported from countries where they are abundant** — base price + international logistics surcharge + extended delivery time
- Distribution is designed so that **no single country is self-sufficient** for all manufacturing needs and **no single resource is concentrated in fewer than 3 countries** (preventing single-point-of-failure trade dependencies)
- Collectively, all 18 countries cover all resource categories roughly evenly

**Pricing:**
- Abundant locally: Central Corporation sells at base price (set per resource type, adjusted by country's Resource Availability modifier)
- Not abundant locally: Central Corporation sells at base price × 1.5–2.5x import multiplier (varies by scarcity), plus the buyer must arrange international logistics (Trucking/Freight for bulk materials)
- Prices are fixed per tick by the Central Corporation — no player negotiation on raw materials. This is the one area where the Central Corporation has absolute pricing power

**Strategic Implications for Manufacturers:**
- A Textile Manufacturer in a country rich in Natural Fibers gets cheap cotton but pays import prices for Petroleum & Synthetics (needed for synthetic blends)
- An Electronics Manufacturer in a country rich in Metals & Minerals gets cheap silicon and copper but imports Petroleum & Synthetics for plastic components
- Manufacturers must choose: locate where primary raw materials are cheap (save on biggest input cost) or locate where the end customer market is strongest (save on outbound logistics)?
- This location-vs-sourcing tradeoff is a foundational strategic decision for every manufacturing company

---

## Sector Philosophy

Manufacturing is the upstream engine of the entire retail and construction economy. Every product on every shelf in every store was produced by a manufacturer. Every piece of equipment in every company came from a factory. Manufacturers don't interact with players directly — they sell B2B exclusively, through contracts with retailers and other businesses. Their customers are business owners, not consumers.

What makes Manufacturing strategically distinct from other sectors: **the owner never sees the end customer.** A restaurant owner watches customers walk in. A manufacturer watches contracts come in. Success is measured in production efficiency, supply chain management, and contract pipeline — not foot traffic or reputation with players. This creates a fundamentally different gameplay feel: less reactive, more strategic, higher stakes per decision because each contract is larger and failures cascade upstream through the entire supply chain.

All three manufacturer types share common mechanics:

- **B2B only** — never sell directly to players
- **Contract-based revenue** — same system as Catering and Logistics (difficulty bar, financial penalties for failure)
- **Quality tier production** — output tier determined by worker skill + raw material quality + equipment tier
- **Spoilage or obsolescence** — all manufactured goods have a shelf life, expiration, or depreciation mechanism
- **Mandatory logistics** — all outbound shipments require a logistics company (Delivery Company for standard goods, Trucking/Freight for heavy/bulk)
- **Central Corporation competition** — Central Corp manufacturers exist in every country, producing at baseline quality and volume. Beatable by player-owned manufacturers on quality, price, or reliability
- **Raw materials from Central Corporation** — all input materials purchased from the Central Corp at country-specific prices

---

## 7A. Electronics Manufacturer

**Business Model:** Specialized facility producing electronic equipment and devices across all three quality tiers (Basic, Standard, Premium). Produces two product categories: **commercial equipment** (POS systems, kitchen equipment, refrigeration units, industrial controls, logistics tracking systems, factory production line equipment — sold B2B to Electronics Stores who resell to all companies) and **consumer electronics** (personal devices — sold B2B to Electronics Stores for B2C resale to players). The sole source of all electronics in the economy. Every company in the game depends on equipment to operate, and higher-tier equipment provides efficiency bonuses — making this manufacturer a universal upstream dependency. What makes it strategically distinct: the **Technology Generation system**. At semi-random intervals, a new technology generation releases globally, immediately devaluing all previous-generation inventory. The manufacturer must balance production volume against obsolescence risk — overproduction before a generation shift means catastrophic inventory losses. Underproduction means missing the premium pricing window when retailers scramble for new-generation stock.

**Supply Chain Position:**
```
Central Corporation (raw materials: Metals & Minerals, Petroleum & Synthetics)
      ↓ (sells raw materials at country-specific prices)
      ↓ (transported by Trucking/Freight — Sector 2B — for bulk material orders)
Electronics Manufacturer
      ↓ (sells finished electronics via B2B contract)
      ↓ (transported by Delivery Company — Sector 2A — subject to damage system)
Electronics Store (Sector 3B)
      ↓ (sells to companies as equipment / sells to players as consumer devices)
All Companies (equipment efficiency) + Players (personal devices → Happiness)
```

**Employee Roles:**

| Role | Function |
|------|----------|
| Production Engineer | Core output role. Skill determines production volume per tick and maximum quality tier achievable. Low-skill engineers can only produce Basic reliably — attempting Standard or Premium with insufficient skill produces defective units (wasted materials, zero output). High-skill engineers can run Premium production lines efficiently |
| R&D Specialist | **Unique role — only exists in Electronics Manufacturing.** Skill determines how many ticks of advance warning the manufacturer receives before a Technology Generation shift. High-skill R&D: 3-tick warning. Mid-skill: 1-2 tick warning. Low-skill NPC: 0-1 tick warning (essentially reactive, not proactive). This is the competitive intelligence role — the difference between a manufacturer who is prepared for a generation shift and one caught with warehouses full of obsolete stock |
| Quality Assurance | Inspects output each tick. Skill determines defect detection rate — defective units caught before shipping are scrapped (material loss but no reputation damage). Undetected defects ship to retailers → equipment underperforms → retailer blames manufacturer → reputation damage to both. Without QA, defect rate is the raw production defect rate with no filter |
| Warehouse Staff | Manages raw material inventory and finished goods. Skill affects inventory tracking accuracy and loading efficiency (affects damage rate during outbound shipping — poor loading = higher damage in transit) |
| Production Manager | Only meaningful when filled by a real player. Can adjust production line allocation between equipment vs consumer electronics, shift tier priorities, negotiate supplier contracts for raw materials, plan production around generation cycles. NPC here = owner manages everything manually. The role that enables scaling beyond a single production focus |

**The R&D Specialist is the killer role.** Two competing electronics manufacturers with identical production capacity — one has a high-skill R&D Specialist, the other has a baseline NPC. A generation shift is coming. The first manufacturer gets a 3-tick warning: stops current-gen production, draws down inventory, retools production line, and has new-gen products ready when the shift hits. The second manufacturer finds out when it happens — warehouses full of now-30%-cheaper stock, 1 tick of downtime to retool, and arrives to market after competitors have already captured premium pricing. Over a full game cycle, the R&D advantage compounds dramatically.

**Technology Generation System (Manufacturer Perspective):**

- Generation shifts are **system-driven global events** at semi-random intervals (average every 40–60 ticks / 10–15 real days, with variance to prevent perfect prediction)
- When a new generation drops:
  - All previous-generation finished goods in manufacturer warehouses lose **30% value immediately**
  - Production lines must be **retooled** for new generation: 1 tick of zero production output + retooling cost (raw materials consumed for calibration)
  - Raw material requirements may shift slightly — new generation may need more Rare Earth Elements (higher cost) or new synthetic compounds
  - **Premium pricing window:** For the first 2–3 ticks after a generation shift, new-gen products command a **15–25% price premium** over standard market rates because demand spikes and supply is limited. Manufacturers who retool first capture this window
- R&D Specialist warning allows the manufacturer to:
  - Reduce current-gen production 2–3 ticks early (minimize obsolescence losses)
  - Begin retooling before the shift (ready to produce new-gen immediately)
  - Notify key retail clients (strengthens relationships — retailers prepare shelf space)
  - Short current-gen inventory at discount to clear warehouse before depreciation hits

**Equipment Tier Production Requirements:**

| Tier | Required Engineer Skill | Required QA Skill | Raw Material Cost | Production Time |
|------|------------------------|-------------------|-------------------|-----------------|
| Basic | Low (any) | Optional | Base cost | Fastest — highest volume per tick |
| Standard | Mid | Recommended | 1.5x base | Moderate volume |
| Premium | High | Required (high-skill) | 2.5x base | Slowest — lowest volume per tick |

Premium production is the most profitable per unit but requires the highest investment in skilled labor AND produces the fewest units per tick. Basic is the volume play. Standard is the balanced middle. No single strategy dominates — it depends on the local market's equipment demand mix.

**Operating Costs (per tick):**
- Employee salaries (Production Engineers and R&D Specialists command high industrial wages — among the most expensive non-Finance roles)
- Raw material costs from Central Corporation (Metals & Minerals + Petroleum & Synthetics — consumed per production unit)
- Industrial facility rent (large space requirement — production floor, testing area, warehouse)
- Equipment maintenance (production line machinery — heavy wear, especially on Premium lines)
- Utilities (significant — precision manufacturing requires climate control, clean rooms for Premium)
- Retooling costs (periodic — triggered by technology generation shifts)
- Defective unit losses (material cost of scrapped units caught by QA)

**Revenue Model:**
- **Contract-based B2B** to Electronics Stores exclusively
- Price per unit × volume delivered per contract
- Owner sets pricing per tier — market determines whether retailers accept
- **Premium pricing window** after generation shifts provides temporary margin boost for first movers
- **Recurring equipment contracts:** Electronics Stores with B2B maintenance programs need regular equipment supply — long-term contracts provide revenue stability
- **Contract difficulty bar:** Same system as Catering — every contract shows difficulty based on the manufacturer's current capacity, skill levels, and material stock. Financial penalty for failed delivery
- Owner controls: tier allocation, pricing, contract acceptance, production scheduling
- Market determines: total equipment demand (driven by business creation and expansion across all sectors), competitive pricing pressure from other manufacturers and Central Corporation

**Key Owner Decisions:**
- **Tier allocation:** What percentage of production capacity goes to Basic vs Standard vs Premium? Premium is highest margin but requires the best engineers, is slowest to produce, and ties up the most capital in raw materials. Basic is high-volume commodity — thin margins but steady demand. The optimal mix shifts with market conditions
- **Generation timing:** When R&D signals a generation shift is approaching, how aggressively to draw down current-gen production? Too early = lost revenue on products that still have value. Too late = warehouses full of depreciated stock. The 1–3 tick warning window is where fortunes are made or lost
- **Inventory strategy:** Produce-to-order (no obsolescence risk, but miss the premium pricing window after generation shifts because you have nothing in stock) vs produce-to-stock (capture premium window, risk obsolescence if timing is wrong)?
- **R&D investment:** High-skill R&D Specialist is expensive but provides the advance warning that defines competitive advantage. NPC R&D saves salary but leaves the manufacturer reactive. This is the single most consequential staffing decision in the company
- **Raw material sourcing:** Long-term contracts with Central Corporation lock in current prices (protection against increases, miss out on decreases). Spot buying each tick is flexible but vulnerable to price spikes. Country selection at company founding determines base raw material costs for the life of the business
- **Equipment vs consumer electronics:** Different demand profiles. Equipment demand is steady (all companies need it) but cyclical around generation shifts. Consumer electronics demand is more volatile (player spending patterns). How to split production capacity?

**Capacity & Scaling:**
- Production capacity determined by: facility size (production floor area), number of Production Engineers, and equipment tier of the production line itself (yes — the manufacturer needs equipment from an Electronics Store to run its own production lines, creating a circular dependency)
- QA is the quality bottleneck — more production without proportional QA means more defective units shipping
- R&D Specialist is unique: only one needed, but quality matters enormously. Not a scale bottleneck but a capability ceiling
- Branch expansion means opening a second factory — potentially in a different country with different raw material costs and market dynamics
- The capital intensity is the highest in Manufacturing — Premium production lines require Premium equipment, high-skill engineers, expensive raw materials. The barrier to Premium production is the steepest in the game

**Cross-Sector Dependencies:**
- Central Corporation — sole raw material supplier (Metals & Minerals, Petroleum & Synthetics)
- Trucking/Freight (Sector 2B) — inbound raw material delivery (bulk, heavy)
- Delivery Company (Sector 2A) — outbound finished goods delivery to Electronics Stores. Electronics subject to **damage system** during transport — low-skill handlers can damage delicate equipment
- Electronics Store (Sector 3B) — sole retail channel. The manufacturer's only customer type. Relationship with Electronics Stores is the commercial lifeline
- All other sectors — indirect dependency: every company buys equipment from Electronics Stores, which source from Electronics Manufacturers. When a generation shift hits, the ripple travels: manufacturer retooling → Electronics Store stock gaps → companies can't upgrade equipment → efficiency stalls economy-wide
- Real Estate (Sector 4) — large industrial property required
- Finance (Sector 5) — highest capital requirements in Manufacturing. Loans common for startups and expansion. Insurance for obsolescence losses viable
- Electronics Store (circular) — manufacturer needs equipment to run its own production lines

**Market Dynamics:**
- **Oversaturated:** Price war on Basic tier (commodity, thin margins, volume game). Standard tier compresses but maintains some differentiation through reliability. Premium is the defensible niche — few manufacturers can produce it, but oversaturation even here eventually compresses margins. Weakest manufacturers fold when a generation shift catches them with full warehouses
- **Undersaturated:** Equipment shortage across the economy. Every company's efficiency is capped by available equipment. First Electronics Manufacturer in an underserved country has effective monopoly — massive margins, can't produce fast enough. Attracts competitors rapidly
- **Generation shift dynamics:** Create predictable boom-bust cycles. Pre-shift: production slows as smart manufacturers draw down. Shift hits: price spike for new-gen, crash for old-gen. Post-shift: production ramps back up, prices normalize. Manufacturers with R&D advantage profit from the cycle; those without get punished by it
- **Country dynamics:** Countries rich in Metals & Minerals attract electronics manufacturers (cheap primary input). High-spending-power countries attract manufacturers who want to be close to the strongest retail market. The optimal location depends on whether the manufacturer prioritizes input cost savings or outbound logistics savings
- **Central Corporation competition:** Central Corp electronics manufacturers produce Basic and Standard at baseline volume. Slow retooling after generation shifts (2 ticks vs player's 1 tick). Never produce Premium. Player manufacturers win on Premium quality, faster generation adoption, and relationship-based contract reliability

**Failure Points:**
- **Generation shift catastrophe:** Full warehouse of current-gen stock when the shift hits → 30% immediate depreciation → forced to sell at deep discount or scrap → cash flow crisis → can't afford retooling materials → production stalls → contracts fail → penalties → spiral. The signature failure mode of Electronics Manufacturing — fast, dramatic, and visible to the entire supply chain
- **R&D neglect:** NPC R&D with no advance warning → always reactive → always late to new generation → always selling at post-premium prices → always competing on cost with manufacturers who captured the premium window → structural margin disadvantage that compounds every cycle
- **Quality collapse:** Pushing for Premium production with mid-skill engineers → high defect rate → material waste + units that pass weak QA and ship defective → retailer reputation damage → contract cancellations → forced back to Standard/Basic production → invested in Premium raw materials with no Premium output → capital trapped
- **Single-client dependency:** All contracts with one Electronics Store → that store folds or switches suppliers → entire revenue disappears in one tick. Diversification across multiple retailers and countries is essential but requires logistics investment
- **Raw material price shock:** Country's raw material prices increase (system event) or international logistics costs spike → production costs rise → fixed-price contracts become unprofitable → forced to renegotiate or eat the loss

**Emergent Gameplay:**
- **The generation insider:** A manufacturer with an exceptional R&D Specialist shares advance generation shift warnings with allied Electronics Stores — in exchange for guaranteed purchase contracts at premium pricing. The Store prepares shelf space and marketing, the manufacturer has a guaranteed buyer for new-gen stock. Together they capture the premium window that solo operators miss. This information-sharing alliance creates a competitive moat that pure price competition can't easily breach
- **The equipment monopolist:** In a small or new country, the first Electronics Manufacturer has temporary monopoly on all equipment. Every business in the country depends on them. The manufacturer can use this leverage to negotiate favorable terms across sectors — "I'll prioritize your equipment orders if you give my delivery company exclusive transport contracts." Cross-sector leverage from an infrastructure position
- **The obsolescence play:** A manufacturer deliberately dumps large quantities of current-gen stock at below-cost prices just before a generation shift they know is coming (via R&D). Competing manufacturers who didn't see the dump coming assume demand has collapsed and slow their own production. When the generation shift hits, the dumping manufacturer is already retooled and producing new-gen while competitors are still processing the market signal. Aggressive, risky, requires deep capital reserves and excellent R&D intelligence

**Abuse & Exploit Analysis:**
- **Generation insider trading:** Manufacturer shares R&D-sourced generation shift timing with an allied Investment Firm, which shorts Electronics Store stocks before the shift and buys after the crash. **Counter:** R&D advance warning is probabilistic (skill-based window, not exact timing), and the stock market's transaction fee structure makes rapid trading expensive. Not perfectly preventable but naturally unprofitable at the margins needed to be worthwhile. Social enforcement also applies — other players notice patterns
- **Self-contracting inflation:** Manufacturer sells to its own Electronics Store at inflated prices to inflate revenue metrics for valuation purposes. **Counter:** Same-owner transactions are flagged and discounted in the valuation algorithm. The valuation model requires demonstrated transactions with unrelated clients for full credit. Same rule as Construction Company self-contracting
- **Artificial scarcity:** Sole manufacturer in a country deliberately underproduces to create equipment shortage, driving up prices across the economy. **Counter:** Central Corporation always produces at baseline volume — it can't be starved out. New manufacturers are attracted by high margins. And deliberately underproducing means deliberately leaving revenue on the table — the exploit is self-limiting because someone else will fill the gap

**Status:** ✅ Design Complete

---

## 7B. Textile & Apparel Manufacturer

**Business Model:** Specialized facility producing clothing across all four quality tiers (Budget, Standard, Premium, Luxury). Sells B2B exclusively to Clothing Stores and General Stores (Budget/Standard only to General Stores). The only manufacturer in the game with **four quality tiers** instead of three — because clothing feeds the Charisma composite stat, which has four impact levels. What makes it strategically distinct: the **Fashion Cycle interaction** combined with the **Material Waste mechanic**. Fashion shifts (system-driven, unpredictable timing) cause demand for current-season designs to collapse, making unsold inventory depreciate rapidly. Simultaneously, the material waste rate — the percentage of raw materials lost during production — varies dramatically with worker skill, creating the largest per-unit cost variance between a well-run and poorly-run factory in the entire Manufacturing sector. A skilled textile manufacturer produces more output from less input AND times production to match fashion demand. An unskilled one wastes materials on clothes nobody wants to buy.

**Supply Chain Position:**
```
Central Corporation (raw materials: Natural Fibers, Petroleum & Synthetics)
      ↓ (sells raw materials at country-specific prices)
      ↓ (transported by Trucking/Freight — Sector 2B — for bulk fiber/material orders)
Textile & Apparel Manufacturer
      ↓ (sells finished clothing via B2B contract)
      ↓ (transported by Delivery Company — Sector 2A — lightweight, low damage risk)
Clothing Store (Sector 3C) ──→ Player (Charisma modifier)
General Store (Sector 3A) ──→ Player (Budget/Standard only)
```

**Employee Roles:**

| Role | Function |
|------|----------|
| Textile Worker | Core production role. Skill determines output volume AND material waste rate. Low-skill: 25–30% raw material waste (for every 100 units of cotton input, 25–30 units lost as scrap). High-skill: 5–10% waste. This is the single largest variable cost driver — a factory of skilled workers produces nearly 3x more output per unit of raw material than an unskilled one |
| Pattern Designer | **Unique role — only exists in Textile Manufacturing.** Skill determines two things: (1) which fashion season the output belongs to (higher skill = ability to design "classic" pieces that depreciate 10–15% slower per fashion cycle than standard seasonal designs), and (2) design variety (higher skill = more distinct product lines per tick, allowing retailers to stock wider selections — more variety attracts more customers). NPC Pattern Designer produces only standard seasonal designs with minimal variety |
| Quality Inspector | Determines the actual quality tier of output. Budget requires no inspection. Standard requires basic inspection. Premium requires mid-skill. Luxury requires high-skill Inspector AND premium raw materials AND skilled Textile Workers — all three must align. Attempting Luxury with any one factor weak produces Premium at best (downgraded, not wasted) |
| Dye Specialist | Affects product variety and visual distinction. Higher skill = more color/pattern options per production run. Low-skill or no Dye Specialist = all output is uniform — retailers have nothing to differentiate their stock from competitors buying from the same manufacturer. Creates a competitive dimension beyond tier: two manufacturers both producing Standard clothing, but one offers 5 variations and the other offers 15 |
| Factory Manager | Only meaningful as a real player. Manages production scheduling, fashion cycle planning, supplier contracts, tier allocation, and clearance decisions for aging inventory. NPC here = owner handles all strategic decisions. The role that enables multi-tier production without constant owner attention |

**Material Waste Mechanic (Core Differentiator):**
```
Usable Output = Raw Material Input × (1 - Waste Rate)
Waste Rate = Base Waste × (1 / Avg Textile Worker Skill)
```
- Base Waste = 15% (industry baseline)
- Low-skill workers: Waste Rate = 25–30% → 100 units input = 70–75 units output
- High-skill workers: Waste Rate = 5–10% → 100 units input = 90–95 units output
- This creates a **permanent efficiency advantage** for manufacturers who invest in skilled labor — their per-unit raw material cost is structurally lower
- Waste is the primary reason why two textile manufacturers with identical raw material contracts and identical pricing can have dramatically different profit margins
- Waste materials are destroyed — no recycling, no recovery. Pure loss

**Fashion Cycle Interaction (Manufacturer Perspective):**

Fashion shifts are system-driven global events at **unpredictable intervals** (less predictable than technology generations — average 30–50 ticks / 7.5–12.5 real days, but with high variance). Unlike technology generations, there is **no advance warning system** — no R&D equivalent role. Fashion shifts are inherently unpredictable. This is by design: fashion is not engineering. You cannot reverse-engineer when the next trend arrives.

When a fashion shift occurs:
- Current-season designs retain full Charisma modifier
- **Previous-season** designs lose ~20% Charisma modifier
- **Two-seasons-old** designs lose ~50% Charisma modifier
- **Older** designs provide only Budget-tier minimum Charisma (regardless of actual quality tier)

For the manufacturer:
- Finished goods in warehouse tagged as previous-season lose desirability → retailers cancel or reduce orders → unsold stock depreciates
- Unlike electronics (30% immediate value drop), clothing depreciation is gradual but relentless — each additional fashion shift further degrades older stock
- The Pattern Designer's "classic design" ability slows this depreciation by 10–15% per cycle — not immunity, but meaningful. A manufacturer with a skilled Pattern Designer produces some clothing that holds value longer, commanding premium pricing from retailers who want inventory with slower markdown risk
- **No retooling required** — fashion shift doesn't require production line changes. New-season production begins immediately. The cost is in unsold previous-season inventory, not in production downtime

**Quality Tier Production Requirements:**

| Tier | Required Worker Skill | Required Inspector | Required Materials | Market |
|------|----------------------|--------------------|--------------------|--------|
| Budget | Any | None | Base fibers | General Store, budget Clothing Stores |
| Standard | Low-Mid | Basic | Standard fibers + basic dyes | General Store, most Clothing Stores |
| Premium | Mid-High | Mid-skill | Premium fibers + quality dyes | Clothing Stores only |
| Luxury | High | High-skill | Premium fibers + rare dyes + specialty materials | Clothing Stores only (wealthy player market) |

Luxury production is the tightest bottleneck in textile manufacturing — requires the convergence of skilled workers (low waste), high-skill Inspector (quality verification), premium raw materials (expensive, may require import), AND high-skill Dye Specialist (Luxury customers expect variety). The margin per unit is the highest, but the total volume is the lowest and the target market is the smallest.

**Operating Costs (per tick):**
- Employee salaries (Pattern Designers and Dye Specialists are skilled creative roles — mid-to-high wages)
- Raw material costs from Central Corporation (Natural Fibers + Petroleum & Synthetics for blends — consumed per production unit, amplified by waste rate)
- Material waste losses (raw materials consumed but producing no output — the hidden cost that bad manufacturers don't track until it's too late)
- Industrial facility rent (moderate space — smaller than electronics, no clean room needed, but requires dyeing and finishing areas)
- Equipment maintenance (looms, cutting machines, dyeing equipment — moderate wear)
- Utilities (moderate — dyeing and finishing require water and temperature control)
- Unsold inventory depreciation (aging stock loses value each fashion cycle — a carrying cost that incentivizes lean inventory)

**Revenue Model:**
- **Contract-based B2B** to Clothing Stores and General Stores
- Price per unit × volume delivered per contract
- Luxury tier: highest per-unit price, lowest volume, smallest market — the prestige play
- Budget tier: lowest per-unit price, highest volume, guaranteed demand (clothing degrades, everyone needs replacements) — the reliability play
- **Seasonal pricing dynamics:** Immediately after a fashion shift, new-season designs command a brief premium (retailers need fresh stock). Between shifts, pricing normalizes and competition determines margins
- **Design variety premium:** Manufacturers with skilled Dye Specialists can charge more because their products give retailers inventory variety — retailers pay for differentiation, not just fabric
- Owner controls: tier allocation, pricing, contract acceptance, inventory management, clearance decisions
- Market determines: fashion cycle timing (uncontrollable), competitive pricing pressure, retailer demand mix

**Key Owner Decisions:**
- **Tier strategy:** Budget/Standard volume play (low margins, guaranteed demand from clothing degradation, minimal fashion risk because cheap clothes are disposable anyway) vs Premium/Luxury prestige play (high margins, small market, significant fashion risk because expensive unsold stock hurts more)? Or balanced across tiers?
- **Fashion cycle management:** With no advance warning, the owner must decide how much inventory risk to carry. Conservative: produce to confirmed orders only (no fashion risk, but miss demand spikes after shifts). Aggressive: maintain finished goods buffer (capture immediate post-shift demand, risk depreciation). Balanced: small buffer in current-season, clear aggressively before next shift
- **Worker skill investment:** Skilled workers are expensive but their waste rate advantage is permanent and compounding. Every tick, the skilled factory produces more output from less input. Over 50 ticks, the cost savings from 10% waste vs 30% waste dwarf the salary difference. This is the clearest long-term ROI calculation in any manufacturing type
- **Pattern Designer priority:** Classic designs (slower depreciation, premium pricing) or trendy designs (higher short-term appeal, faster depreciation)? A skilled player Pattern Designer can read market signals and adjust — NPC always produces standard seasonal
- **Variety investment:** Hire and pay a skilled Dye Specialist for product variety? Or save salary and produce commodity output? The variety advantage is subtle — retailers prefer varied stock, but they won't pay 2x for it. The question is whether the variety premium covers the Dye Specialist's salary
- **Country location:** Natural Fiber-rich countries reduce primary input cost. High-spending-power countries have stronger Luxury demand. The two rarely overlap — forcing a location-vs-market tradeoff

**Capacity & Scaling:**
- Production capacity determined by: facility size, Textile Worker count, and equipment quality (better looms = faster output per worker)
- Quality Inspector is the tier bottleneck — more production without proportional QA means more downgrades (Premium attempted → Standard produced)
- Pattern Designer and Dye Specialist are differentiation roles, not capacity roles — one of each covers the entire factory's output
- Branch expansion strategic for accessing different raw material markets or serving different country spending profiles
- Scaling the workforce is the primary growth lever — more workers = more output, and skilled workers provide disproportionate returns due to waste rate reduction

**Cross-Sector Dependencies:**
- Central Corporation — sole raw material supplier (Natural Fibers, Petroleum & Synthetics)
- Trucking/Freight (Sector 2B) — inbound raw material delivery (bulk fibers)
- Delivery Company (Sector 2A) — outbound finished goods delivery to Clothing Stores and General Stores. Clothing is lightweight with low damage risk — cheapest outbound logistics in Manufacturing
- Clothing Store (Sector 3C) — primary retail channel. All four tiers
- General Store (Sector 3A) — secondary channel. Budget/Standard only
- Real Estate (Sector 4) — industrial property
- Finance (Sector 5) — moderate capital requirements. Loans for expansion. Insurance against fashion cycle losses viable
- Charisma system — indirect but critical: clothing's Charisma impact drives demand. Countries with negotiation-heavy businesses (finance, legal, consulting) have structurally higher clothing demand

**Market Dynamics:**
- **Oversaturated:** Budget/Standard becomes commodity pricing — margins compress to near-zero, weakest fold from waste-rate cost disadvantage (inefficient factories can't compete on thin margins). Premium/Luxury retains margins longer because fewer manufacturers can produce it. Variety and classic-design capability become the differentiators at scale
- **Undersaturated:** Players limited to Central Corporation clothing (Budget/Standard, no variety, no classic designs, no Stylist cooperation). First Textile Manufacturer captures all Premium/Luxury demand and most Standard demand through better variety
- **Fashion shift dynamics:** Post-shift demand spike → manufacturers with stock capture premium → calm period → stock builds → next shift creates winners and losers. Unlike technology generations (predictable cycle with R&D warning), fashion shifts are unpredictable, creating genuine uncertainty that rewards conservative inventory management
- **Country dynamics:** Natural Fiber-rich countries attract manufacturers (cheap input). High-spending-power countries attract Luxury production (strongest end market). Manufacturing and labor-cost-modifier countries with cheap skilled labor are dark horse locations — waste rate savings from cheap skilled workers can offset higher raw material import costs
- **Clothing degradation guarantee:** Unlike food (hunger can be delayed) or electronics (old equipment still works), clothing degradation is constant and unavoidable — every active player's clothes wear down every tick. This creates the most structurally guaranteed demand of any manufactured product. Budget textile manufacturing is the closest thing to a safe bet in the entire game

**Failure Points:**
- **Waste rate death spiral:** New manufacturer with unskilled workers → 30% waste → high per-unit cost → prices must be high to cover costs → can't compete with skilled competitors → revenue drops → can't afford to upgrade workers → cost structure permanently uncompetitive. The waste rate advantage is self-reinforcing: skilled manufacturers earn more, reinvest in better workers, waste rate improves, margins widen. The gap between efficient and inefficient factories only grows over time
- **Fashion cycle overexposure:** Aggressive production build-up → fashion shift hits → warehouse full of previous-season stock → retailers cancel orders → forced clearance at below-cost prices → cash flow crisis → can't buy raw materials for new-season production → miss the new-season premium window → competitors capture the market → spiral
- **Luxury overreach:** Attempting Luxury with mid-skill workers or mid-skill Inspector → output downgrades to Premium → Premium raw material costs with Standard output → margin collapse → capital trapped in expensive materials that won't produce Luxury returns
- **Single-retailer dependency:** All contracts with one Clothing Store → that store folds or switches suppliers → revenue disappears. Especially dangerous because Clothing Stores themselves are vulnerable to fashion cycle mismanagement
- **Dye Specialist departure:** Skilled player Dye Specialist leaves → product variety drops → retailers switch to manufacturers offering more variety → contracts lost. Harder to replace than Production Workers because the role is specialized

**Emergent Gameplay:**
- **The vertical fashion house:** A player who owns both a Textile Manufacturer AND a Clothing Store creates a vertically integrated fashion operation. The manufacturer produces exclusive designs (skilled Pattern Designer + skilled Dye Specialist) available only through their own retail chain. Competitors can't replicate the product — they can only compete with different designs. This is the strongest brand moat in the Retail sector, built upstream in Manufacturing. Add a skilled Stylist in the store and you have the complete player experience: exclusive designs + fit bonus + current season = maximum Charisma advantage
- **The waste arbitrage:** In a market with multiple textile manufacturers, the manufacturer with the lowest waste rate has a structural cost advantage that can never be matched by competitors without equivalent worker investment. This player can strategically undercut competitors on Standard-tier pricing — thin margins that are profitable for them but unprofitable for inefficient competitors. Over time, competitors fold from margin pressure. The surviving manufacturer raises prices. The waste rate advantage becomes a market-clearing weapon
- **The classic design stockpiler:** A manufacturer with an exceptional Pattern Designer produces predominantly "classic" designs that depreciate 10–15% slower per fashion cycle. These products are worth more to retailers because they carry less markdown risk. The manufacturer charges a premium for classic designs and builds a reputation as the "safe supplier" — retailers who stock from this manufacturer lose less to fashion shifts. Over many cycles, the reliability premium compounds into a dominant market position

**Abuse & Exploit Analysis:**
- **Waste rate reporting fraud:** Manufacturer claims high-skill workers (low waste) to justify lower pricing, but actually uses low-skill workers and eats the loss to undercut competitors, planning to raise prices after competitors fold. **Counter:** This is just predatory pricing — a real business strategy with real risk. The manufacturer genuinely loses money during the undercutting phase. If they run out of capital before competitors fold, they go bankrupt. No system intervention needed — the market punishes miscalculated predatory pricing naturally
- **Fashion cycle front-running via allied retailer:** Manufacturer uses retailer sales data to guess fashion shift timing (rapid sales increase might signal a shift is coming). **Counter:** Fashion shifts are system-driven and inherently unpredictable. Sales data might provide weak signals but nothing reliable. This is just good business intelligence, not an exploit
- **Self-contracting:** Same rule as all sectors — same-owner transactions flagged and discounted in valuation. Textile manufacturing to own Clothing Store is legitimate vertical integration; inflated inter-company pricing is flagged

**Status:** ✅ Design Complete

---

## 7C. Pharmaceutical Manufacturer

**Business Model:** Specialized facility producing health products across three quality tiers (Basic, Standard, Premium). Sells B2B exclusively to Pharmacies and General Stores (Basic only to General Stores). The most **quality-critical** manufacturer in the game. What makes it strategically distinct: the **Batch Quality system**. Unlike other manufacturers where output quality is deterministic (skill + materials = tier), pharmaceutical production has inherent **batch variance** — each production run has a probability of producing substandard output that looks normal but delivers reduced health benefit to players. Defective batches that reach players trigger a **recall event** damaging both the manufacturer AND the retailer's reputation. This makes Quality Assurance not just important but existentially necessary. Combined with the shortest shelf life at Premium tier (24 ticks / 6 real days) and the downstream Pharmacy price ceiling (limiting how much retailers will pay for inventory), Pharmaceutical Manufacturing is the tightest-margin, highest-consequence production operation in the game. There is no room for error, and errors are not immediately visible — they emerge when players use the product.

**Supply Chain Position:**
```
Central Corporation (raw materials: Chemical Compounds, Petroleum & Synthetics)
      ↓ (sells raw materials at country-specific prices)
      ↓ (transported by Trucking/Freight — Sector 2B — for bulk chemical orders)
Pharmaceutical Manufacturer
      ↓ (sells finished health products via B2B contract)
      ↓ (transported by Delivery Company — Sector 2A — temperature-sensitive, spoilage modifier applies)
Pharmacy (Sector 3D) ──→ Player (Health need recovery)
General Store (Sector 3A) ──→ Player (Basic tier only)
```

**Employee Roles:**

| Role | Function |
|------|----------|
| Lab Technician | Core production role. Skill determines output volume per tick and base defect rate. Higher skill = more units produced AND lower probability of batch defects. The dual benefit makes skilled Lab Technicians the most valuable production employees in this sector |
| Chemist | **Critical quality-gating role.** Skill determines which tiers can be produced — directly mirrors how the Pharmacist gates what can be SOLD at retail. Low-skill Chemist: Basic only. Mid-skill: Basic + Standard. High-skill: all tiers including Premium. Without a Chemist, the factory can only produce Basic. The Chemist is the manufacturing equivalent of the Pharmacy's Pharmacist — the single role that determines the company's revenue ceiling |
| Quality Assurance | **Existentially necessary role.** Inspects every batch before shipping. Skill determines defective batch detection rate. High-skill QA: catches 95%+ of defective batches (scrapped before shipping — material loss, no reputation damage). Low-skill QA: catches 60–70%. No QA: zero defective batches caught — all ship, and players discover the defects when products don't restore health properly. QA is the firewall between a production defect and a reputation catastrophe |
| Warehouse Staff | Manages climate-controlled storage for raw materials and finished products. Skill affects spoilage rate during storage (pharmaceutical products are temperature-sensitive) and inventory tracking accuracy. Also handles outbound shipment preparation — poor preparation increases spoilage risk during transport |
| Production Manager | Only meaningful as a real player. Manages production scheduling, quality thresholds, supplier contracts, and the critical decision of when to scrap vs ship marginal batches. NPC here = owner makes all quality decisions. The role that enables quality-conscious scaling |

**Batch Quality System (Core Mechanic):**

Every production tick, each batch of pharmaceutical products has a quality variance:

```
Actual Quality = Target Quality × (1 + Variance)
Variance = Random(-Range, +Range)
Range = Base Variance × (1 / Avg Lab Technician Skill)
```

- **Base Variance:** 15% (industry baseline)
- Low-skill Lab Technicians: Range = ±20–25% → a "Standard" batch might actually deliver 75–125% of Standard effectiveness
- High-skill Lab Technicians: Range = ±5–8% → a "Standard" batch delivers 92–108% of Standard effectiveness
- Batches that fall below **80% of target quality** are classified as **defective** — they look normal in inventory but deliver reduced health benefit when used by players

**QA Detection:**
- QA tests batches before shipping
- Detected defective batches are scrapped (raw material loss, but no reputation damage)
- Undetected defective batches ship to Pharmacies and General Stores
- When a player uses a defective product and gets reduced health benefit, the system triggers a **recall event**

**Recall Event Cascade:**
1. Affected product batch flagged across all retailers holding it
2. Remaining units from the batch destroyed at all retail locations
3. Manufacturer reputation takes a significant hit (proportional to the number of defective units that reached players)
4. Retailer reputation takes a moderate hit (they sold it, even though they didn't produce it)
5. Manufacturer must issue compensation to affected retailers (automatic — covers wholesale cost of destroyed units)
6. Public recall notice visible on both manufacturer and retailer profiles for a set number of ticks

A single recall event is survivable. Two in quick succession is devastating. Three and the manufacturer may lose all retail contracts as Pharmacies switch to safer suppliers. This is the harshest quality penalty in the game — justified because health products affect a mandatory player need.

**Expiration System (Manufacturer Side):**

| Tier | Shelf Life (from production) | Time Pressure |
|------|------------------------------|---------------|
| Basic | ~48 ticks (12 real days) | Low — ample time to sell |
| Standard | ~32 ticks (8 real days) | Moderate — needs active contracts |
| Premium | ~24 ticks (6 real days) | High — must sell almost immediately |

- Spoilage timer starts at production and runs continuously — through warehouse storage, during transport, on retail shelves
- Expired products are destroyed automatically (total loss)
- Premium products have a **6 real-day total lifecycle** from production to player purchase — the tightest pipeline in the game. A Premium product produced on Monday must be in a player's hands by Sunday or it's gone
- This creates extreme produce-to-order pressure for Premium: manufacturers cannot stockpile. Every Premium unit needs a confirmed buyer before production
- Transport time consumed during delivery eats into shelf life — manufacturers far from their retail clients lose shelf life to logistics. Location relative to Pharmacies matters

**Tier Production Requirements:**

| Tier | Required Chemist Skill | Required QA Skill | Raw Material Cost | Batch Variance |
|------|----------------------|-------------------|-------------------|----------------|
| Basic | Low (any) | Recommended | Base cost | Highest (wider variance range) |
| Standard | Mid | Strongly recommended | 1.8x base | Moderate |
| Premium | High | Required (high-skill) | 3x base | Lowest (but consequences of defects are worst — Premium batch failure costs the most in materials and reputation) |

**Operating Costs (per tick):**
- Employee salaries (Chemists command the highest wages in Manufacturing — specialized scientific role. High-skill Chemists are among the most expensive employees in the game outside Finance)
- Raw material costs from Central Corporation (Chemical Compounds + Petroleum & Synthetics — consumed per production unit)
- Climate-controlled storage costs (pharmaceutical products require temperature-controlled warehousing — higher utility cost than other manufacturers)
- Industrial facility rent (moderate — smaller than electronics, but requires lab-grade facilities for Premium production)
- Equipment maintenance (lab equipment, climate control systems — moderate wear)
- Utilities (high — climate control, lab operations)
- Batch scrap losses (defective batches caught by QA — material cost lost but reputation preserved. A cost of doing business)
- Recall compensation (variable — when defective batches reach retail, manufacturer covers wholesale replacement cost)
- Expired product losses (unsold inventory destroyed — especially painful for Premium tier)

**Revenue Model:**
- **Contract-based B2B** to Pharmacies and General Stores (Basic only)
- Price per unit × volume delivered per contract
- **Margin ceiling effect:** Pharmacies are price-ceiling constrained (cannot sell above Central Corporation baseline). This limits how much Pharmacies will pay for inventory — the Pharmacy's margin cap becomes the manufacturer's pricing cap. The manufacturer's maximum viable price = Central Corp retail price minus Pharmacy's desired margin minus transport costs
- Premium tier has the highest per-unit price but: shortest shelf life (produce-to-order only), highest raw material cost, highest defect consequence, and requires the most expensive staff. Premium is profitable only with the best Chemist, the best QA, and confirmed contracts before production begins
- **Steady demand guarantee:** Health is a mandatory need. Players must buy health products. Pharmacies must stock them. Demand is the most structurally reliable in all of Manufacturing — not cyclical, not seasonal, not fashion-dependent. The closest thing to guaranteed revenue, constrained only by the price ceiling and competition
- Owner controls: tier production allocation, pricing (within the margin ceiling), contract acceptance, quality standards (scrap threshold)
- Market determines: Pharmacy demand (driven by health events and player activity), competitive pricing from other manufacturers and Central Corporation

**Key Owner Decisions:**
- **Quality vs volume:** Hire expensive high-skill Lab Technicians (low defect rate, high volume, expensive) or save on salary and accept higher scrap rates? The answer depends on QA quality — if QA catches defects, cheaper technicians are viable. If QA is weak, cheap technicians mean defective products reaching players. The interaction between Lab Technician skill and QA skill defines the company's risk profile
- **Chemist investment:** The Chemist gates everything. Basic-only Chemist = low revenue ceiling, low risk. Premium-capable Chemist = highest revenue potential, highest risk (Premium defects are the most expensive and most reputation-damaging). The Chemist hire is the company's identity decision — what tier of manufacturer do you want to be?
- **Scrap threshold:** Owner sets the quality threshold for scrapping batches. Tight threshold (scrap anything below 90% of target) = less risk, more waste. Loose threshold (only scrap below 70%) = less waste, more defective products reaching market. This is the ethical dilemma of pharmaceutical manufacturing — how much risk to take with products that affect player health
- **Premium production commitment:** Premium requires produce-to-order (24-tick shelf life is too short for stockpiling). This means confirmed contracts BEFORE production. If a major Pharmacy contract falls through mid-production, those Premium units may expire before a replacement buyer is found. The owner must decide: accept only iron-clad contracts with guaranteed volume, or maintain flexibility to capture spot demand?
- **Country location:** Chemical Compound-rich countries provide cheap primary input. Countries with many Pharmacies provide short logistics chains (preserving shelf life). High-infrastructure countries have faster internal transport. The optimal location balances input cost, logistics speed, and end-market proximity — and for Premium production, logistics speed may be the decisive factor

**Capacity & Scaling:**
- Production capacity determined by: lab facility size, Lab Technician count, and equipment quality
- Chemist is the tier ceiling — one high-skill Chemist enables Premium for the entire factory. Not a capacity bottleneck but an absolute capability gate
- QA is the quality bottleneck — more production without proportional QA means more defective batches passing undetected
- Premium capacity is self-limiting: produce-to-order only, highest material cost, most staff-intensive. A factory producing 50% Premium and 50% Basic has dramatically different risk profiles across its two lines
- Branch expansion strategic for accessing different raw material markets and reducing transport time to distant Pharmacies (preserving shelf life)

**Cross-Sector Dependencies:**
- Central Corporation — sole raw material supplier (Chemical Compounds, Petroleum & Synthetics)
- Trucking/Freight (Sector 2B) — inbound raw material delivery
- Delivery Company (Sector 2A) — outbound finished product delivery. **Temperature-sensitive goods** — spoilage modifier applies during transport. Low-skill delivery handlers can cause pharmaceutical products to degrade in transit, arriving at the Pharmacy with reduced shelf life. The choice of logistics company directly affects product quality at retail
- Pharmacy (Sector 3D) — primary retail channel. Price-ceiling constrained
- General Store (Sector 3A) — secondary channel, Basic tier only
- Real Estate (Sector 4) — industrial property with lab-grade facility requirements
- Finance (Sector 5) — moderate capital requirements. Insurance against recall events would be highly valuable — creating demand for Insurance Company (5C) recall-specific policies
- Insurance Company (Sector 5C) — natural client for recall event insurance. A Pharmaceutical Manufacturer with recall insurance can survive reputation catastrophes that would destroy an uninsured competitor. Creates a direct Finance-Manufacturing dependency

**Market Dynamics:**
- **Oversaturated:** Basic/Standard price compression under the margin ceiling. Multiple manufacturers competing for the same Pharmacies, all constrained by the same price ceiling — the margin gets squeezed from both sides (competition pushes wholesale prices down, ceiling prevents retail prices from rising). Premium retains margins because few manufacturers can produce it safely, but the market for Premium is limited by the Pharmacy's Pharmacist skill (only high-skill Pharmacists can sell Premium)
- **Undersaturated:** Central Corporation always produces Basic/Standard at baseline. Player manufacturer entering an underserved market has immediate demand — every Pharmacy wants a reliable supplier better than Central Corp. Premium production in an underserved market is a license to print money (limited competition, mandatory demand, high margins)
- **Health event spikes:** System-driven health events (illness waves, seasonal effects) create sudden demand surges. Manufacturers with inventory buffer capture the spike. Manufacturers running lean miss it — Pharmacies switch to whoever has stock. These events are the equivalent of fashion shifts for this sector, but health events increase demand (good for manufacturers) while fashion shifts depreciate inventory (bad for textile manufacturers)
- **Country dynamics:** Chemical Compound-rich countries attract pharmaceutical manufacturers. High-infrastructure countries preserve shelf life through faster internal transport. These often aren't the same country — creating a genuine location dilemma

**Failure Points:**
- **Recall cascade:** Defective batch passes weak QA → ships to 5 Pharmacies → players use defective products → recall triggered → manufacturer reputation tanked → all 5 Pharmacies lose trust → contracts cancelled → revenue collapses → can't afford to hire better QA → next batch also risky → second recall → company reputation effectively destroyed. The recall cascade is the fastest reputation-destruction mechanism in the game — a manufacturer can go from healthy to terminal in 2 ticks
- **Chemist departure:** High-skill Chemist quits → Premium production immediately impossible → all Premium contracts must be cancelled or downgraded → revenue drops to Standard-tier levels → can't afford to hire replacement at equivalent salary → permanently downgraded to Standard manufacturer until finances recover. The single most damaging key-employee loss in any sector because it removes an entire revenue tier
- **Premium shelf life death:** Premium products produced without confirmed buyers → 24-tick timer ticking → no buyer found in time → products expire → total material loss at 3x base cost per unit → cash flow crisis → can't afford next production cycle. A few ticks of unsold Premium output can bankrupt a manufacturer that overcommitted to production
- **Margin ceiling squeeze:** Rising raw material prices + fixed retail price ceiling → manufacturer margins compressed to zero or negative → can't reduce quality without recall risk → can't raise prices because retailers won't pay above their own ceiling → trapped. Only exit: wait for material prices to normalize, relocate to cheaper-input country, or fold
- **Transport spoilage feedback:** Cheap logistics company with low-skill handlers → products arrive at Pharmacy with reduced shelf life → Pharmacy has less time to sell → Pharmacy demands lower wholesale price to compensate → manufacturer margins shrink → cuts logistics costs further → even worse handlers → faster spoilage → spiral

**Emergent Gameplay:**
- **The quality monopolist:** A Pharmaceutical Manufacturer with the best Chemist, highest-skill QA, and zero recall history builds an unassailable reputation. Pharmacies pay premium wholesale prices for this manufacturer's products because they trust zero defects. New competitors can't break in — they have no track record, and a single recall event sets them back years. The quality monopolist doesn't compete on price; they compete on trust. This is the most defensible competitive position in Manufacturing because it cannot be replicated quickly — trust is built over dozens of ticks of flawless production
- **The insurance play:** Pharmaceutical Manufacturer takes out recall insurance from an Insurance Company (Sector 5C). This allows the manufacturer to set a looser scrap threshold (accepting more marginal batches, reducing waste) because recall events are insured. The manufacturer's expected cost of a recall drops, enabling higher throughput at slightly higher risk. The Insurance Company prices this risk based on the manufacturer's QA skill and recall history — creating a direct link between manufacturing quality and insurance pricing. A well-run manufacturer gets cheap insurance and higher throughput. A sloppy manufacturer gets expensive insurance or is uninsurable
- **The shelf-life logistics alliance:** Premium Pharmaceutical Manufacturer partners with a specific high-skill Delivery Company, guaranteeing them exclusive transport contracts in exchange for priority handling and best-in-class spoilage modifier. Products arrive at Pharmacies with maximum remaining shelf life — giving the manufacturer's products more time on shelves, which translates to higher retailer satisfaction and willingness to pay more. The logistics partnership becomes a competitive advantage that competitors without equivalent logistics quality can't match

**Abuse & Exploit Analysis:**
- **Deliberate contamination of competitor's supply chain:** A player hires their own employee into a competitor's QA role, deliberately allowing defective batches through to trigger recalls. **Counter:** QA detection rate is skill-based and system-calculated — a real player QA employee can't deliberately lower their own detection rate. QA is a function of skill, not intent. The system calculates batch quality and detection independently of player wishes. Additionally, employee activity logs allow owners to monitor QA performance metrics
- **Recall insurance fraud:** Manufacturer deliberately produces low-quality batches, triggers recall, collects insurance payout. **Counter:** Insurance companies see recall history. Repeated recalls = premiums skyrocket or policy cancelled. The regulatory fee structure means recalls cost more in reputation than insurance recovers in money. Recalls damage retailer relationships — no insurance payout replaces lost contracts
- **Self-contracting:** Same rule as all sectors — same-owner transactions flagged and discounted. Pharmaceutical manufacturer selling to own Pharmacy is legitimate vertical integration; inflated pricing is flagged

**Status:** ✅ Design Complete

---

## Sector 7 Summary

| Company Type | Revenue Model | Volatility | Key Differentiator | Core Risk |
|---|---|---|---|---|
| Electronics Manufacturer | Contract B2B to Electronics Stores | High (generation shift cycles) | R&D advance warning system, technology generation timing | Obsolescence — warehouses of deprecated stock |
| Textile & Apparel Manufacturer | Contract B2B to Clothing/General Stores | Medium (fashion cycles, unpredictable) | Material waste rate mechanic, 4 quality tiers, Pattern Designer | Fashion shift inventory depreciation + waste rate cost structure |
| Pharmaceutical Manufacturer | Contract B2B to Pharmacies/General Stores | Low-Medium (steady demand, event spikes) | Batch quality variance, recall system, price ceiling constraint | Recall cascade — defective batches destroying reputation |

**Sector-wide characteristics:**
- All three manufacturer types are **B2B only** — they never interact with players directly
- All three require raw materials from the **Central Corporation** at country-specific prices — location determines input cost structure
- All three use the **contract system** with difficulty bars and financial penalties
- All three produce goods subject to **mandatory logistics** — finished goods don't teleport to retailers
- All three have **unique quality mechanics** that don't exist in other sectors: technology generations (electronics), material waste rate (textiles), batch variance and recalls (pharmaceuticals)
- The **Central Corporation** operates baseline manufacturers in every country — producing Basic/Standard at default quality and volume. Player manufacturers win by producing Premium/Luxury, by offering better reliability, by timing cycles better, or by operating more efficiently

**Cross-manufacturer dynamics:**
- All three compete for **skilled labor** in their country's labor pool — a Chemist, an R&D Specialist, and a Pattern Designer are all high-skill specialized roles. Countries with small labor pools may not have enough skilled workers for multiple premium manufacturers
- All three depend on **Delivery Company quality** for outbound shipping — but the consequences differ. Electronics: damage. Textiles: minimal risk (lightweight). Pharmaceuticals: spoilage (temperature-sensitive). This creates differentiated logistics demand
- All three need **industrial real estate** — creating demand for Construction Companies and Real Estate Agencies specifically in industrial-zoned properties. A manufacturing boom in a country triggers a construction boom
- **Vertical integration opportunities:** Electronics Manufacturer + Electronics Store. Textile Manufacturer + Clothing Store. Pharmaceutical Manufacturer + Pharmacy. Each vertical pair captures both manufacturing margin and retail margin — the strongest competitive moats in the game

**Update to General Store (Sector 3A):**
With the Manufacturing sector finalized as three specialist types, the General Store's product categories are confirmed as four: food products (from Food Manufacturing, Sector 1D), basic electronics (from Electronics Manufacturer, Sector 7A), basic clothing (from Textile Manufacturer, Sector 7B), and basic pharmacy items (from Pharmaceutical Manufacturer, Sector 7C). The previously referenced "household goods" category is removed — the General Store's competitive breadth comes from stocking these four categories under one roof, not from a fifth product type. This change has no impact on the General Store's core mechanics — it still competes with each specialist retailer on Budget/Standard tier while winning on convenience and breadth.



---

---

-e 
---

*Last updated: May 25, 2026 — Split from master document*
