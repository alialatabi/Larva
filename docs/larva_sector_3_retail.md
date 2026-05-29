# Project Larva — Sector 3: Retail (Complete)

> **Status:** ✅ All 4 company types fully designed  
> **Parent document:** See `larva_master.md` for core systems, cross-sector rules, and progress tracker

---

## 3A. General Store

**Business Model:** Large-format multi-category retailer. Buys products across multiple categories from various manufacturers — food, basic electronics, basic clothing, basic pharmacy items. Sells directly to players. Largest physical retail footprint in the game, highest startup cost in the Retail sector, requires the most employees. The General Store is the one-stop shop — it covers every product category but only stocks **Budget and Standard tiers**. Players who want Premium or Luxury go to specialist stores. It competes with every specialist retailer simultaneously but can never beat any of them on quality depth. It wins on convenience and breadth.

**Supply Chain Position:**
```
Food Manufacturer ──────────┐
Clothing Manufacturer ──────┤──→ General Store ──→ Player
Electronics Manufacturer ───┤
Pharmaceutical Manufacturer─┘
         ↑
   (all inbound goods require logistics)
```

**Employee Roles:**
| Role | Function |
|------|----------|
| Stock Worker | Keeps shelves filled across all departments. Skill affects restocking speed — empty shelves = lost sales |
| Cashier | Processes transactions. Skill affects customer throughput per tick — bottleneck role at high volume |
| Warehouse Staff | Manages incoming shipments from multiple suppliers, tracks expiration on perishables, organizes storage |
| Department Manager | Only meaningful when filled by a real player. Manages pricing and inventory for one product category. NPC in this seat does nothing — owner handles everything |
| Store Manager | Only meaningful when filled by a real player. Oversees entire store operations, can adjust staffing, approve supplier contracts, set store-wide pricing policy. Enables true absentee ownership |

**Operating Costs (per tick):**
- Employee salaries (highest headcount in Retail)
- Inventory purchase costs (multiple supplier contracts across categories)
- Rent (largest retail space requirement — significantly more expensive than specialist stores)
- Utilities (more space, more refrigeration for food section)
- Equipment maintenance (shelving, refrigeration, POS systems)

**Revenue Model:**
- Markup-based — owner sets markup percentage per product category
- Default 15% markup across all categories (lower than Supermarket's 20% — competes on volume, not margin)
- Customer volume driven by: pricing, product availability, variety breadth, location, reputation, and marketing (up to 20%)
- A fully stocked General Store with competitive pricing becomes a traffic magnet — players prefer one stop over visiting four specialist stores

**Key Owner Decisions:**
- **Category selection:** Stock all four categories or drop underperformers? Each category added means another supplier relationship, more warehouse complexity, more staff — but also more customer traffic
- **Per-category markup:** Price food low to pull traffic, mark up electronics higher? Each strategy attracts different customer profiles
- **Supplier management:** Juggling 4+ supplier contracts is the core complexity. Long-term contracts lock in prices but reduce flexibility
- **Staffing depth vs breadth:** Many low-skill workers across departments or fewer high-skill workers concentrated in high-revenue categories?
- **Compete or complement:** Undercut specialist stores on price (thin margins, high volume) or position as the convenience option (moderate prices, no direct war)?

**Capacity & Scaling:**
- Largest space requirement in Retail — highest customer throughput potential
- Bottlenecked by: floor space, cashier count, stock worker count
- Scaling means opening additional branches in different locations/countries
- Each branch requires its own full staff complement

**Cross-Sector Dependencies:**
- Food Manufacturing (Sector 1) — food products
- Manufacturing (Sector 7) — basic electronics, basic clothing, basic pharmacy
- Logistics — Delivery Company (Sector 2) — all inbound inventory
- Real Estate (Sector 4) — largest commercial retail space needed
- Competes with Supermarket on food (Budget/Standard only vs Supermarket's Premium capability)
- Competes with all specialist Retail stores on their Budget/Standard tier

**Market Dynamics:**
- **Oversaturated:** Price war on identical Budget/Standard goods → margins collapse → weakest fold → survivors absorb customer base
- **Undersaturated:** Local monopoly — high traffic, healthy margins, until a competitor moves in
- **Natural cycle:** General Stores thrive in early-game when specialists are rare. As economy matures and specialists open, General Stores face category-by-category competition. Late-game survival depends on convenience and volume, not margins
- **vs Supermarkets:** Supermarkets win on food quality (can stock Premium). General Stores win on breadth. Players needing only food go to Supermarket. Players needing food AND clothes AND medicine go to General Store

**Failure Points:**
- Overextension across all four categories without enough capital → supplier payments drain cash → shelves empty → spiral
- Missing a supplier contract renewal → one department goes empty → cross-category traffic loss
- Understaffing → shelves empty despite warehouse inventory → customers leave
- Price war death → margins too thin → one bad tick → operating at a loss → can't recover

**Status:** ✅ Design Complete

---

## 3B. Electronics Store

**Business Model:** Sells electronic equipment and devices to both businesses (B2B) and players (B2C). The only retail type serving two distinct customer bases. Business clients buy operational equipment — POS systems, kitchen equipment, refrigeration units, factory control systems, office computers, logistics tracking systems. Every company in the game needs equipment to operate, and higher-tier equipment improves company efficiency ratings. Player clients buy personal devices contributing to happiness and productivity. It is an infrastructure supplier to the entire economy — when any company upgrades equipment, the Electronics Store is where that transaction happens.

**Supply Chain Position:**
```
Electronics Manufacturer (Sector 7) ──→ Electronics Store ──→ Companies (equipment)
                                                           ──→ Players (personal devices)
         ↑
   (inbound goods require logistics)
```

**Equipment Tier System:**
| Tier | Effect on Buyer | Cost | Target Market |
|------|----------------|------|---------------|
| Basic | Default efficiency — no bonus, just functional | Low | Startups, budget companies, new players |
| Standard | Moderate efficiency boost (~10–15% to relevant company output) | Medium | Established businesses optimizing operations |
| Premium | Significant efficiency boost (~20–30% to relevant company output) | High | Profitable companies maximizing output per tick |

Equipment does not spoil but **degrades over time** with use. Every tick of operation wears equipment down. Degraded equipment loses its efficiency bonus gradually until it reaches Basic-equivalent performance. Owners must decide when to replace — too early wastes money, too late loses the efficiency advantage.

**Equipment Impact Examples:**
- Restaurant with Premium kitchen equipment → cooks produce more meals per tick
- Delivery company with Premium tracking systems → dispatcher efficiency bonus
- Factory with Premium production line equipment → higher output volume per tick
- Supermarket with Premium POS systems → cashier throughput bonus

**Employee Roles:**
| Role | Function |
|------|----------|
| Sales Specialist | Handles B2B and B2C sales. Skill affects upselling rate — convinces businesses to buy higher tiers. Directly affects revenue per transaction |
| Technician | Installs and configures equipment for business clients. Skill affects whether equipment reaches its full efficiency rating on delivery. Low-skill technician installing Premium = equipment underperforms |
| Cashier | Handles walk-in player transactions |
| Warehouse Staff | Manages inventory, tracks incoming shipments |
| Manager | Only meaningful when filled by a real player. Can negotiate B2B contracts, approve pricing, manage technician scheduling |

**Operating Costs (per tick):**
- Employee salaries (technicians and sales specialists command higher wages — skilled roles)
- Inventory purchase costs (electronics are expensive per unit — high capital tied up)
- Rent (moderate retail space — smaller than General Store, needs showroom area)
- Utilities
- Equipment maintenance (display units, testing stations)

**Revenue Model:**
- **B2C:** Markup-based, default 25% markup (electronics are discretionary, less price-sensitive than food)
- **B2B:** Contract-based OR direct sale. Business clients can place one-time orders or sign maintenance contracts (recurring revenue — store handles equipment replacement on a schedule)
- **Revenue split decision:** Owner chooses floor space and staff allocation between B2B vs B2C
- Customer volume driven by: pricing, equipment variety, technician reputation, location, and marketing (up to 20%)

**Technology Obsolescence System:**
Every set number of ticks, a new technology generation releases (system-driven, global event). When a new generation drops:
- Previous generation loses ~30% resale value immediately
- Previous generation still functions but efficiency bonus reduced vs current generation
- Stores holding old-generation inventory take a paper loss
- Creates urgency to manage inventory turnover — don't overstock

**Key Owner Decisions:**
- **B2B vs B2C allocation:** B2B is higher margin but requires technicians and relationship management. B2C is simpler but lower margin
- **Inventory depth vs breadth:** Stock all three tiers or specialize?
- **Maintenance contracts:** Recurring revenue but commits technicians to ongoing service
- **Obsolescence timing:** Discount old stock before new generation or hold and risk paper loss?
- **Technician quality:** Cheap NPC technicians save salary but installations underperform → B2B reputation damage

**Capacity & Scaling:**
- Moderate space requirement
- B2B capacity bottlenecked by technician count
- B2C capacity bottlenecked by sales floor and cashier throughput
- Branch expansion strategic when entering new country markets

**Cross-Sector Dependencies:**
- Electronics Manufacturing (Sector 7) — sole inventory source
- Logistics — Delivery Company (Sector 2) — inbound transport. Equipment subject to damage system during transport
- Real Estate (Sector 4) — commercial retail space with showroom capacity
- Every other sector — all companies need equipment to operate. Universal upstream dependency
- General Store — competes on Basic tier consumer electronics only. General Store cannot stock Standard/Premium or offer B2B/technician services

**Market Dynamics:**
- **Oversaturated:** B2C price wars. B2B maintenance contracts create switching costs — early movers defensible
- **Undersaturated:** Essential infrastructure. First Electronics Store in underserved country has temporary B2B monopoly
- **Natural cycle:** Technology generation releases create demand spikes followed by quiet periods
- **Country dynamics:** Manufacturing countries = strong B2B demand. High-spending countries = strong B2C demand

**Failure Points:**
- Obsolescence trap — overstock current generation → new gen drops → inventory crashes 30%
- Technician neglect — cheap NPC installations underperform → B2B reputation tanks
- Capital lock-up — expensive inventory without confirmed buyers → cash flow crisis
- B2B dependency spiral — entire business built on 2–3 contracts → one client folds → massive revenue drop

**Status:** ✅ Design Complete

---

## 3C. Clothing Store

**Business Model:** Sells clothing to players that directly affects their Charisma composite stat. Clothing is functional economic equipment, not cosmetic. A player's Charisma modifier influences negotiation outcomes, sales performance, contract bidding success, customer-facing job efficiency, and salary negotiations. What makes the Clothing Store distinct: it sells a **depreciating asset that affects a dynamic stat**. Clothes wear out, fashion cycles shift demand unpredictably, and owners must balance inventory risk against margin opportunity.

**Supply Chain Position:**
```
Textile/Clothing Manufacturer (Sector 7) ──→ Clothing Store ──→ Player (Charisma modifier)
         ↑
   (inbound goods require logistics)
```

**Clothing Tier System:**
| Tier | Charisma Clothing Modifier | Degradation Rate | Target Market |
|------|---------------------------|------------------|---------------|
| Budget | Small boost | Degrades fast (~16 ticks / 4 real days) | Broke players, new accounts, low-spending countries |
| Standard | Moderate boost | Moderate (~32 ticks / 8 real days) | Working players, mid-career |
| Premium | Strong boost | Slow (~64 ticks / 16 real days) | Successful employees, business owners |
| Luxury | Maximum boost | Slowest (~96 ticks / 24 real days) | Wealthy players, executives, high-stakes negotiators |

Clothing is the only retail product with **four quality tiers** instead of three. Luxury exists because Charisma is a competitive advantage — wealthy players pay top price for every negotiation edge.

**Clothing Degradation:**
Every tick a player is active, clothing loses durability. Once durability hits zero, tier drops to the next level down (Premium → Standard → Budget → None). Fully degraded clothing = zero Charisma boost from clothing factor. Creates **guaranteed recurring demand** — the most reliable individual-customer return rate in the game.

**Fashion Cycle System:**
At unpredictable intervals (system-driven), a **fashion shift** occurs globally:
- Current-season clothing retains full Charisma modifier
- Previous-season loses ~20% Charisma modifier
- Two-seasons-old loses ~50% Charisma modifier
- Older provides only base tier minimum (Budget-equivalent)

Fashion shifts affect inventory on shelves too — stores holding previous-season stock are holding depreciating assets. Less predictable than food spoilage or electronics obsolescence because timing varies.

**Employee Roles:**
| Role | Function |
|------|----------|
| Sales Associate | Skill affects customer conversion rate and average transaction value |
| Stylist | **Unique role — only exists in Clothing Stores.** Skill affects upselling AND provides a "fit bonus" — clothing purchased from a store with a skilled Stylist gives 5–10% additional Charisma boost on top of tier baseline. Competitive differentiator between stores |
| Cashier | Handles transactions |
| Stock Worker | Manages floor inventory and display |
| Manager | Only meaningful when filled by a real player. Adjusts pricing, manages suppliers, plans for fashion cycles, runs clearance |

**The Stylist separates good Clothing Stores from mediocre ones.** Two stores selling identical Premium clothing — but one has a skilled Stylist. Players travel to the better Stylist store even at a price premium. Creates a labor market for skilled Stylists and prevents pure price wars.

**Operating Costs (per tick):**
- Employee salaries (Stylists and skilled Sales Associates command higher wages)
- Inventory purchase costs (mid-range per unit)
- Rent (moderate retail space — needs display/showroom area)
- Utilities
- Equipment maintenance (display fixtures, fitting rooms)
- Season-end markdowns (clearing old-season stock at a loss)

**Revenue Model:**
- Markup-based, default 30% markup (highest default in Retail — fashion-driven, less price-sensitive)
- Luxury tier has significantly higher absolute margins but lower volume
- Customer volume driven by: pricing, tier variety, Stylist quality, fashion currency (current-season?), reputation, location, and marketing (up to 20%)
- **Clearance mechanic:** Owner can trigger clearance pricing on old-season stock — steep discount to move inventory. Attracts bargain-hunters at thin/negative margins

**Key Owner Decisions:**
- **Tier mix:** Budget-only (high-volume low-margin), Luxury-only (tiny but profitable market), or Standard/Premium core with additions based on local demand
- **Fashion cycle management:** How aggressively to stock new-season vs hold previous-season
- **Clearance timing:** Too early leaves money on the table, too late means stock is nearly worthless
- **Stylist investment:** Expensive skilled Stylist for fit bonus and competitive edge? Or save salary and compete on price alone?
- **Country strategy:** Low-spending countries = Budget/Standard. High-spending countries = Standard and above

**Capacity & Scaling:**
- Moderate space requirement
- Throughput bottlenecked by Sales Associates and Cashiers
- Stylist capacity limited — one Stylist per finite customers per tick
- Branch expansion strategic for different country spending profiles

**Cross-Sector Dependencies:**
- Textile/Clothing Manufacturing (Sector 7) — sole inventory source
- Logistics — Delivery Company (Sector 2) — inbound transport. Clothing is lightweight, low damage risk, cheap shipping
- Real Estate (Sector 4) — commercial retail space
- General Store — competes on Budget/Standard only. Cannot stock Premium/Luxury or offer Stylist service
- Charisma system — only business directly affecting a core player stat

**Market Dynamics:**
- **Oversaturated:** Price war on Standard/Premium. Differentiation through Stylist quality and fashion timing
- **Undersaturated:** Players limited to General Store (Budget/Standard, no Stylist). First Clothing Store captures entire Premium/Luxury market
- **Natural cycle:** Fashion shifts create demand spikes → quiet replacement-only periods between
- **Charisma-driven demand:** Countries with negotiation-heavy businesses (finance, consulting) → higher clothing demand and willingness to pay premium

**Failure Points:**
- Fashion cycle misread — heavy stock before a shift → inventory depreciates → forced clearance while needing new-season capital
- Stylist dependency — exceptional player Stylist leaves → customers follow → revenue drops
- Tier mismatch — Luxury in a low-spending country won't sell, Budget-only in a wealthy country loses to competitors
- Clearance addiction — training customers to wait for discounts → full-price sales collapse permanently

**Status:** ✅ Design Complete

---

## 3D. Pharmacy

**Business Model:** Sells health-related products serving the Health need. Health is mandatory — when it drops, player efficiency decreases. Severely neglected health causes job loss or inability to perform. The Pharmacy is the primary dedicated source for health products. What makes it distinct: guaranteed demand from a non-optional need, but constrained margins because exploiting a mandatory need would create pay-to-win dynamics. Reliable income, limited upside.

**Health Need Context:**
Players lose health from overwork, neglected needs (hunger, energy), and random health events (system-driven illness, minor injuries). Recovery requires health products. Without recovery, health decline continues, degrading work performance until the player cannot work at all. Creates **inelastic demand** — players MUST buy health products regardless of price.

**Supply Chain Position:**
```
Pharmaceutical Manufacturer (Sector 7) ──→ Pharmacy ──→ Player (Health need recovery)
         ↑
   (inbound goods require logistics)
```

**Health Product Tiers:**
| Tier | Effect | Cost | Availability |
|------|--------|------|-------------|
| Basic | Slow recovery over multiple ticks. Stops decline but doesn't restore quickly | Low | General Store + Pharmacy |
| Standard | Moderate recovery. Meaningful health within 2–3 ticks | Medium | Pharmacy only |
| Premium | Fast recovery. Full health within 1 tick. Temporary health buffer — reduced chance of health loss next tick | High | Pharmacy only |

**General Stores can only stock Basic health products.** Standard and Premium are Pharmacy-exclusive.

**Central Corporation Price Ceiling:** The Central Corporation Pharmacy in every country sells at a fixed baseline price per tier. Player-owned Pharmacies can price **at or below** the Central Corporation price — never above. This is the only retail type with a system-enforced price ceiling. Justification: health is mandatory with inelastic demand. Without a ceiling, Pharmacy owners in underserved countries could extort players.

**Expiration System:**
| Tier | Shelf Life |
|------|-----------|
| Basic | ~48 ticks (12 real days) |
| Standard | ~32 ticks (8 real days) |
| Premium | ~24 ticks (6 real days) |

Higher-tier products expire faster (more potent formulations). Same inventory management tension as food retail.

**Employee Roles:**
| Role | Function |
|------|----------|
| Pharmacist | **Required — store cannot operate without one.** Skill determines which tiers can be sold. Low-skill: Basic/Standard only. High-skill: all tiers including Premium. Gatekeeper role |
| Cashier | Handles transactions |
| Stock Worker | Manages inventory, tracks expiration, rotates stock (FIFO). Skill affects spoilage from poor rotation |
| Manager | Only meaningful when filled by a real player. Adjusts pricing within ceiling, manages suppliers, monitors expiration |

**The Pharmacist is the key mechanic.** A new owner with a low-skill NPC Pharmacist is locked out of Premium entirely. Unlocking Premium requires a high-skill NPC (expensive) or a real player Pharmacist (very expensive, grows over time). Natural growth curve: start Basic/Standard → invest in better Pharmacist → unlock Premium → increase margins.

**Operating Costs (per tick):**
- Employee salaries (Pharmacists command higher wages — specialized role)
- Inventory purchase costs (moderately expensive per unit)
- Rent (small to moderate retail space — no large showroom needed)
- Utilities (climate-controlled storage)
- Equipment maintenance (storage, refrigeration)
- Spoilage losses (expired products destroyed automatically)

**Revenue Model:**
- Markup-based but **ceiling-constrained** — final price cannot exceed Central Corporation baseline
- Effective margin range: 5–20%
- Lower maximum margins than Clothing or Electronics, but the most **reliable** demand in all of Retail
- Volume highly predictable — driven by game mechanics (work drains health, events cause health loss) not player discretion
- Customer volume driven by: pricing (relative to ceiling and competitors), product availability, Pharmacist reputation, location, and marketing (up to 20% — less impactful here because demand is need-driven)

**Key Owner Decisions:**
- **Tier strategy:** Invest in high-skill Pharmacist for Premium access (highest margin, fastest expiration, highest salary) or stay Basic/Standard (lower margin, lower overhead, slower expiration)?
- **Pricing within ceiling:** At ceiling (max margin, competitors may undercut) or aggressive undercutting (thinner margin, higher volume)?
- **Inventory management:** Health events cause demand spikes. Overstocking for spikes risks spoilage during quiet periods. Understocking means lost sales during events
- **Spoilage vs availability:** Minimal stock (low spoilage risk, may run out during events) or deep stock (always available, some expiration losses inevitable)?
- **Central Corp competition:** Always exists, always stocks all tiers at baseline. Compete by being better stocked, more conveniently located, and reliable during health events

**Capacity & Scaling:**
- Smallest space requirement in Retail
- Bottlenecked by Pharmacist skill and stock levels
- Low startup cost — smallest space, fewer employees, guaranteed demand. Accessible first business, but price ceiling limits upside
- Branch expansion for geographic coverage within a country

**Cross-Sector Dependencies:**
- Pharmaceutical Manufacturing (Sector 7) — sole inventory source
- Logistics — Delivery Company (Sector 2) — inbound transport. Products are lightweight but temperature-sensitive — spoilage modifier applies during transport
- Real Estate (Sector 4) — small commercial retail space
- General Store — competes on Basic tier only
- Player Needs System — directly tied to Health need. Demand mechanically guaranteed
- Central Corporation — permanent competitor and price ceiling in every country

**Market Dynamics:**
- **Oversaturated:** Margins compress toward zero under the price ceiling. The most margin-fragile retail type in oversaturated conditions. Only exit is stores closing until supply normalizes
- **Undersaturated:** Central Corporation always present but operates at baseline efficiency — long queues, limited stock during events. Player-owned Pharmacy easily captures share by being better stocked and faster
- **Natural cycle:** Health events (illness waves, seasonal effects) create demand spikes. Between events, steady but lower demand. Survive quiet periods, have stock ready for events
- **Country dynamics:** Price ceiling pegged to Central Corp pricing, which adjusts per country. High-spending countries = higher ceilings = more margin room. Low-spending countries = tighter margins

**Failure Points:**
- Pharmacist loss — required role quits → store cannot operate until replacement found
- Spoilage spiral — overstock Premium → products expire → capital lost → understocked during next event → lost sales → reputation drops → spiral
- Ceiling squeeze — multiple pharmacies undercut each other → margins near-zero → one bad tick → operating at a loss → can't raise above ceiling
- Event misforecast — stocked for an event that doesn't come → spoilage. Ran lean when event hits → missed all demand

**Status:** ✅ Design Complete

---

-e 
---

*Last updated: May 25, 2026 — Split from master document*
