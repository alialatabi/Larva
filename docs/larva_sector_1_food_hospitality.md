# Project Larva — Sector 1: Food & Hospitality (Complete)

> **Status:** ✅ All 5 company types fully designed  
> **Parent document:** See `larva_master.md` for core systems, cross-sector rules, and progress tracker

---

## 1A. Restaurant

**Business Model:** Buys ingredients from suppliers, hires staff, serves meals to players who need to eat (hunger need). Customers are served automatically by employees — the owner manages the business strategically from a dashboard.

**Employee Roles:**
| Role | Function |
|------|----------|
| Cook | Determines food quality and preparation speed. Higher skill = better meals, more customers served per tick |
| Server | Handles customer flow. Higher skill = more customers served, better tips, higher satisfaction |
| Cashier | Handles payments, minor efficiency role |
| Cleaner | Maintains restaurant hygiene. No cleaner = reputation drops over time |
| Manager | Optional hire that improves overall staff efficiency, reduces need for active owner management |

**Operating Costs (per tick):**
- Employee salaries
- Ingredient costs (consumed per customer served)
- Rent (fixed, based on location and size of property)
- Utilities (fixed baseline)
- Equipment maintenance (gradual wear over time)

**Revenue Model:**
- Price per meal × customers served per tick
- Customer volume driven by: price competitiveness, food quality, reputation, location, and marketing (up to 20%)

**Capacity:**
- Determined by restaurant area (bigger space = more seats = more customers per tick)
- Number of branches (each branch is a separate location with its own capacity)
- Employee count (a big space cannot serve customers without enough cooks and servers)

**Ingredient Supply Chain:**
```
Food Manufacturer (player-owned or Central Corporation)
      ↓ (sells ingredients via contract)
Restaurant
      ↓ (serves meals)
Player (satisfies hunger need)
```

**Owner's Key Decisions:**
- Menu composition and pricing
- Hiring and salary levels
- Supplier selection and contract terms (long-term vs short-term)
- Branch expansion (requires new real estate)
- Balancing quality vs cost

**Failure Points:**
- Pricing too high = fewer customers
- Pricing too low = no profit margin
- Underpaying staff = low efficiency, employees quit
- Skipping quality ingredients = food quality drops, reputation tanks
- No cleaner = slow reputation decay
- No ingredient supply = cannot serve customers

**Status:** ✅ Design Complete

---

## 1B. Café

**Business Model:** Small-scale food and drink service focused on energy boosts rather than full meals. Lower costs, simpler operations, fewer employees. Serves as the most accessible first business for new entrepreneurs. A café cannot evolve into a restaurant — if a player wants to serve full meals, they must open a separate restaurant company.

**Key Differences from Restaurant:**
- Smaller space requirement — lower rent, fewer seats
- Fewer employees needed — can start with just a barista and a cashier
- Simpler menu — fewer ingredient types required
- Lower revenue per customer but faster service — more customers per tick relative to size
- Lower startup cost — accessible first business for new players
- Provides energy boost + small hunger reduction (does not replace a full meal)

**Employee Roles:**
| Role | Function |
|------|----------|
| Barista | Prepares drinks and light food. Skill affects quality and service speed |
| Cashier | Handles payments, minor efficiency role |
| Cleaner | Optional but affects reputation over time |

**Operating Costs (per tick):**
- Employee salaries (fewer staff = lower total cost)
- Ingredient/supply costs (simpler — coffee, basic food items)
- Rent (smaller space requirement than restaurant)
- Utilities
- Equipment maintenance (lighter than restaurant)

**Revenue Model:**
- Price per item × customers served per tick
- Lower revenue per customer than restaurant but higher customer turnover relative to size
- Customer volume driven by: price, quality, reputation, location, and marketing (up to 20%)

**Capacity:**
- Same rules as restaurant — determined by space, branches, and employee count
- But needs less space and fewer employees to operate at capacity

**Player Need Impact:**
- Small hunger reduction — does not replace a full meal
- Energy boost — the primary reason players visit cafés
- Creates consistent demand separate from and complementary to restaurants

**Failure Points:**
- Bad pricing = fewer customers or no margin
- Understaffing = can't serve customer flow
- No supplies = nothing to serve
- No cleaner = slow reputation decay
- Competing with other cafés on price and quality

**Status:** ✅ Design Complete

---

## 1C. Catering Company

**Business Model:** No storefront, no walk-in customers. Revenue comes entirely from event contracts. Operates from a kitchen facility (cheaper commercial space than a restaurant). Higher risk but potentially higher margins.

**Contract Sources:**
- Central Corporation companies (automatic, guaranteed flow — but intentionally harder)
- Player-owned companies (corporate events, functions)
- Transportation companies (airline meals, train dining)
- Event planning companies (weddings, conferences, parties)

**Contract System:**
- Every contract displays a **difficulty progress bar** — calculated from contract demands versus the company's current capabilities (staff count, skill levels, ingredient stock, logistics capacity)
- Multiple catering companies can bid on the same contract
- Winner determined by: price offered, company reputation, and capacity to fulfill
- Every contract includes a **financial penalty** set by the contract provider — fail to deliver and you pay
- Central Corporation contracts are **intentionally harder** than player contracts — higher demands, stricter penalties — this incentivizes players to build relationships with other player-owned companies
- Natural progression: early players take risky Central Corporation contracts → build reputation → attract easier, more profitable player contracts

**Employee Roles:**
| Role | Function |
|------|----------|
| Cook | Prepares food for contracts. Skill determines quality and output speed |
| Logistics Staff | Handles delivery of prepared food. Skill affects on-time delivery rate |
| Manager | Optional — improves coordination, reduces failed deliveries |

**Operating Costs (per tick):**
- Employee salaries
- Ingredient costs (consumed per contract fulfilled)
- Kitchen facility rent (cheaper than restaurant — no dining area needed)
- Equipment maintenance
- Delivery/transport costs

**Revenue Model:**
- Contract value minus costs
- Bigger contracts = more revenue but require more staff and ingredients
- Reputation directly affects which contracts you can win
- Owner's negotiation skill influences bid success

**Key Differences from Restaurant:**
- No passive customer flow — if you don't win contracts, you earn nothing
- Higher risk but potentially higher margins on big contracts
- More dependent on negotiation skill and reputation than location
- Requires less expensive real estate (kitchen facility only, no dining area)

**Failure Points:**
- Underbidding = win the contract but no profit margin
- Understaffing = can't fulfill large contracts, delivery fails
- Bad ingredients = low quality delivery, reputation damage
- No logistics staff = late deliveries, penalties
- Taking contracts beyond your difficulty bar = high chance of failure and financial penalty

**Status:** ✅ Design Complete

---

## 1D. Food Manufacturing

**Business Model:** Produces packaged/processed food products from raw materials. Sells exclusively B2B through contracts to restaurants, cafés, supermarkets, and catering companies. Never sells directly to players.

**Employee Roles:**
| Role | Function |
|------|----------|
| Production Worker | Operates manufacturing line. Skill affects output volume and quality |
| Quality Control | Determines product quality tier. Higher skill = ability to produce premium products |
| Warehouse Staff | Manages inventory, tracks spoilage, handles shipments |
| Manager | Optional — improves overall efficiency and coordination |

**Quality Tiers:**
- **Basic** — cheap raw materials, low skill needed, low margins, sells to budget businesses
- **Standard** — moderate cost, reliable demand, serves most food businesses
- **Premium** — expensive raw materials, high-skill workers required, high margins, sells to high-end restaurants

**Operating Costs (per tick):**
- Employee salaries
- Raw material costs (consumed per production cycle)
- Industrial facility rent (large space, cheaper per unit than retail)
- Equipment maintenance (heavy — factory equipment)
- Storage costs for unsold inventory

**Revenue Model:**
- Bulk supply contracts with restaurants, cafés, supermarkets, catering companies
- Contract system with difficulty bars and financial penalties (same as catering)
- Price per unit × volume sold
- Premium products command higher prices
- Long-term contracts provide stability, short-term provide flexibility

**Spoilage System:**
- All food products have a spoilage timer measured in ticks
- Timer starts at production
- Processed/packaged products last longer than raw ingredients
- Expired stock is destroyed automatically — total loss
- Creates urgency to maintain active contracts and avoid overproduction
- Example: a real-world 2-day shelf life = 8 ticks in-game (4 ticks per real day)

**Supply Chain Position:**
```
Central Corporation (raw materials at country-specific prices)
      ↓ (sells raw materials)
Food Manufacturer
      ↓ (sells processed products via contract)
Restaurant / Café / Supermarket / Catering
      ↓ (serves players)
Player
```

**Failure Points:**
- No raw material supply = production stops entirely
- Low-skill workers producing premium tier = quality fails, reputation damage
- Overproduction without contracts = spoilage losses
- No active contracts = product sits and rots
- Underbidding contracts = win but no profit margin

**Status:** ✅ Design Complete

---

## 1E. Supermarket / Grocery

**Business Model:** Buys products from food manufacturers and suppliers. Sells directly to players. Players can buy food here instead of eating at restaurants — bulk buying covers multiple ticks of hunger at a lower per-meal cost than restaurants.

**Employee Roles:**
| Role | Function |
|------|----------|
| Stock Worker | Keeps shelves stocked. Skill affects restocking speed and product availability |
| Cashier | Handles customer transactions. Skill affects customer throughput |
| Warehouse Staff | Manages incoming inventory from suppliers, tracks spoilage |
| Manager | Optional — improves overall efficiency |

**Operating Costs (per tick):**
- Employee salaries
- Inventory purchase costs (bought from food manufacturers via contracts)
- Rent (needs significant retail space — bigger = more product variety and volume)
- Utilities
- Equipment maintenance (refrigeration, shelving)

**Revenue Model:**
- Markup on products bought from manufacturers
- Default markup is 20% over wholesale cost — owner can adjust freely
- Higher markup = more profit per sale, fewer customers
- Lower markup = more customers, thinner margins
- Customer volume driven by: pricing, product variety, location, reputation, and marketing (up to 20%)

**Pricing Strategy:**
- Default 20% markup provides a safe starting point
- Owner adjusts percentage to compete — creates natural price wars between supermarkets
- Aggressive undercutting can steal market share but risks operating at a loss

**Spoilage:**
- Same system as food manufacturing — products expire on shelves
- Overstocking perishables = waste and losses
- Owner must balance inventory levels against expected demand

**Capacity:**
- Determined by store size, branches, and employee count
- Bigger space = more product variety and higher volume
- Same real estate dependency as all other businesses

**Player Need Impact:**
- Bulk food purchase covers multiple ticks of hunger
- Lower cost per meal compared to restaurants
- Creates a real player choice: eat cheap from supermarket or eat conveniently at restaurants

**Failure Points:**
- No supplier contracts = empty shelves, no revenue
- Overstocking perishables = spoilage losses
- Margins too high = customers go to competitors
- Margins too low = no profit
- Understaffing = slow service, customers lost

**Status:** ✅ Design Complete

---

*Last updated: May 25, 2026 — Split from master document*
