# Project Larva — Sector 4: Construction & Real Estate (Complete)

> **Status:** ✅ All 4 company types fully designed  
> **Parent document:** See `larva_master.md` for core systems, cross-sector rules, and progress tracker

---

## 4A. Construction Company

**Business Model:** Builds, expands, and renovates commercial and residential properties on commission. Does not own or sell property — it builds it for others. Every other sector's ability to grow physically depends on this one: a restaurant wants a second branch, a factory needs a bigger floor, a player needs a home upgrade — all hire a Construction Company. Revenue comes entirely from contracts. No storefront, no walk-in customers. What makes it strategically distinct: it is the physical bottleneck of the entire economy. When construction is scarce, every other sector's expansion halts.

**Supply Chain Position:**
```
Central Corporation (raw materials: steel, concrete, lumber, glass)
      ↓ (sells steel, concrete, lumber, glass via contract)
      ↓ (transported by Trucking/Freight — Sector 2B)
Construction Company
      ↓ (builds properties on commission)
Real Estate Agency ──→ lists newly built properties
Property owner (player or company) ──→ receives completed building
      ↓
Every other sector (needs property to open/expand)
```

**Employee Roles:**
| Role | Function |
|------|----------|
| Construction Worker | Core output role. Skill determines build quality and speed. Low-skill = slow builds, higher defect rate. Build quality affects the completed property's efficiency rating |
| Site Foreman | Coordinates workers on active build sites. Skill multiplies worker output — a skilled Foreman can make a team of average workers perform above their individual skill level. No Foreman = workers operate at 70% efficiency cap |
| Architect | Designs the build. Skill determines maximum quality tier achievable and unlocks larger/more complex building types. Required for Premium/Luxury builds. NPC Architect is limited to Standard tier |
| Equipment Operator | Operates heavy machinery (cranes, excavators). Skill affects build speed on large projects. Without an operator, large-scale contracts cannot be accepted |
| Project Manager | Only meaningful when a real player. Manages client relationships, approves contracts, schedules crews across multiple active sites. NPC here = owner must manage everything manually |

**Operating Costs (per tick):**
- Employee salaries (high — construction is skilled labor)
- Raw material costs (consumed per contract — steel, concrete, lumber, glass)
- Equipment maintenance (cranes, excavators, trucks — heavy wear)
- Yard/depot rent (commercial space for equipment storage and crew staging)
- Material transport costs (Trucking/Freight required for raw material delivery to site)

**Revenue Model:**
- Contract-based. Every build is a contract with defined scope, price, and deadline measured in ticks
- Contract price negotiated upfront — owner sets bid, client accepts/rejects/counter-offers
- Revenue = contract price minus material costs, employee costs, transport costs, equipment wear
- Larger/more complex builds = higher revenue but require more skilled workers and an Architect
- **Build Quality Bonus:** Completed builds that exceed client expectations (high-skill workers, premium materials) earn a reputation bonus and can command quality premiums on future bids

**Key Owner Decisions:**
- **Material sourcing:** Long-term contracts (stable price, locked in even when cheaper options emerge) vs short-term (flexible, vulnerable to price spikes mid-project). Getting caught in a price spike on a fixed-price bid is the most reliable way to destroy margin
- **Project size targeting:** Small residential jobs (low risk, thin margins, always available) vs large commercial projects (high margins, need skilled crew + Architect, high penalty if failed)
- **Crew specialization vs breadth:** Generalist crew handles any job type; specialists get efficiency bonuses but sit idle when that contract type dries up
- **Equipment ownership:** Own heavy equipment (high capital cost, unlocks large contracts, ongoing maintenance) vs subcontract (no capital cost, lower margins, dependent on availability)

**Capacity & Scaling:**
- Each active build site ties up workers and equipment for the duration of the contract
- A company can run multiple simultaneous sites — limited by total worker count and equipment
- Project Manager is the scale bottleneck: without a real player in that role, the owner manually manages scheduling. One complex project is manageable; four simultaneous without delegation is chaos
- Branches expand geographic reach and raw material sourcing options

**Cross-Sector Dependencies:**
- Central Corporation — sole raw material supplier (steel, concrete, lumber, glass) at country-specific prices
- Trucking/Freight (Sector 2B) — all raw material delivery to site
- Real Estate Agency (Sector 4B) — lists and sells completed buildings
- Electronics Store (Sector 3B) — equipment upgrades and site management systems
- Finance (Sector 5) — construction requires large working capital; loans are common
- Every other sector — all expansion, all new branches, all property upgrades require construction

**Market Dynamics:**
- **Undersaturated:** Every expanding business waits for a construction slot. Companies charge premium rates and pick only the most profitable contracts. The economy's growth rate is capped by construction capacity
- **Oversaturated:** Price war on contracts. Thin margins. Weakest fold when a material price spike hits during a fixed-price contract
- **Natural cycle:** Early game — high demand, low supply (everyone building first branches). Mid game — equilibrium. Late game — demand shifts from new builds to renovation and expansion
- **Country dynamics:** Low infrastructure countries need more construction. High real estate cost countries = larger contracts but higher material costs

**Failure Points:**
- Material price spike on a fixed contract → completing the contract costs more than the bid → absorb the loss or abandon (and pay penalty)
- Overcommitment → all 5 contracts run late → all 5 pay delay penalties → reputation collapse → no new contracts → fixed costs continue
- No Architect → locked out of Premium builds → only competing on Standard tier → every new entrant bids you down
- Equipment breakdown without mechanic → build stalls mid-project → deadline missed → penalty → reputation hit
- Cash flow gap → materials purchased before revenue arrives. Insufficient working capital = can't start large projects even when you win the bid

**Emergent Gameplay:**
- **Vertical integration squeeze:** A player who owns both a Construction Company AND the primary steel manufacturer can self-supply at cost while competitors pay market rate — or refuse to sell during a construction boom, creating an artificial shortage and monopolizing high-value contracts
- **Infrastructure speculation:** Buy undeveloped land cheap in a low-infrastructure country, hire your own Construction Company to build commercial properties there, sell at premium after the country's infrastructure improves from tax investment. Patient capital + vertical integration = reliable long-term play

**Abuse & Exploit Analysis:**
- **Self-contracting inflation:** A player contracts their own construction company at above-market rates across all their businesses, inflating construction revenue for valuation purposes. **Counter:** Contracts between same-owner entities are flagged; valuations from self-contracts are discounted. The valuation model requires demonstrated transactions with unrelated clients for full valuation credit

**Status:** ✅ Design Complete

---

## 4B. Real Estate Agency

**Business Model:** Lists, markets, and brokers the sale and rental of all commercial and residential properties. Does not own property — it facilitates transactions between owners and buyers/tenants. Every player needs housing. Every business needs commercial space. The Real Estate Agency sits at the center of every property transaction, earning commission on both sides. What makes it strategically distinct: it is a pure information and relationship business. No inventory. No spoilage. No raw materials. Its assets are its listings network, its reputation, and the skill of its agents.

**Supply Chain Position:**
```
Construction Company ──→ produces new properties
Property Owner (player/company) ──→ lists property for sale or rent
      ↓
Real Estate Agency (markets, matches, brokers)
      ↓
Buyer/Tenant (player/company) ──→ acquires property
      ↓
Every sector (every business needs commercial space)
Every player (needs housing)
```

**Employee Roles:**
| Role | Function |
|------|----------|
| Real Estate Agent | Core revenue role. Manages listings and buyer/tenant matching. Skill affects: listings managed per tick, negotiation success rate (higher skill = price closer to asking on both sides), and commission earned per transaction |
| Property Analyst | Assesses fair market value for listings. Skill affects valuation accuracy — low-skill = misvalued listings, clients lose trust, agency loses repeat business |
| Marketing Specialist | Promotes listings. Skill affects time-to-transaction — how quickly a listed property finds a buyer or tenant |
| Administrator | Handles contract management. Skill affects how many simultaneous transactions can be processed per tick. Without one, owner manually handles all paperwork — hard bottleneck at volume |
| Branch Manager | Only meaningful when a real player. Can acquire listings, approve deals, manage agents. NPC here = owner must personally approve every transaction |

**Operating Costs (per tick):**
- Employee salaries (agents and analysts command professional wages)
- Office space rent (smaller commercial space — quality matters for client perception)
- Marketing fees (listing promotion — property takes longer to sell without investment)
- Platform transaction fees (portion of every brokered deal)

**Revenue Model:**
- **Commission-based:** A percentage of every property transaction brokered — applies to both sales and rentals
- Sales commission: % of sale price, paid at close. One-time but large
- Rental commission: % of first month's rent, paid at signing. Lower per-transaction but higher volume
- **Exclusive listings:** Agency negotiates exclusive rights to list a property — guarantees commission even if buyer comes independently
- Commission rate is market-determined — agencies compete on rates. Low-reputation agencies must charge less to attract listings

**Key Owner Decisions:**
- **Residential vs commercial focus:** Commercial properties = larger transactions (higher commission per deal) but fewer. Residential = high-volume, lower commission per deal
- **Exclusive vs open listings:** Exclusive guarantees your commission but requires effort to win from the owner. Open listings = competition with other agencies on the same property — first to close wins
- **Agent quality vs volume:** Few highly skilled agents (high salary, high commission per deal) or many mediocre agents (low salary, low commission, but more listings covered simultaneously)?
- **Location strategy:** Active construction countries = abundant new listings. Mature markets = fewer new listings but stable property prices

**Capacity & Scaling:**
- Each agent has a maximum active listing count per tick based on skill — the core capacity metric
- Administrator is the processing bottleneck: too many simultaneous transactions without admin → deals stall, clients leave
- Branches expand geographic coverage and tap into construction activity in new countries
- First Real Estate Agency in a new country has a significant first-mover advantage — all initial listings go through them until a competitor opens

**Cross-Sector Dependencies:**
- Construction Company (Sector 4A) — primary source of new listings; strong relationship = pipeline of fresh properties
- Property Management Company (Sector 4C) — referral partner: agency closes the deal, management handles the ongoing relationship
- Finance (Sector 5) — buyers needing loans to purchase commercial space; referrals to player-owned banks earn referral fees
- Every sector — all companies must acquire commercial space
- All players — housing need makes every player a potential residential client

**Market Dynamics:**
- **Oversaturated:** Commission rates compress. Agencies compete on reputation and service speed. Commodity trap: if all agencies list the same properties at the same rate, only brand and reputation differentiate
- **Undersaturated:** First mover has effective monopoly on listings. Can charge premium rates. Construction boom creates explosive listing pipeline
- **Natural cycle:** Follows construction activity. Construction boom → property supply increases → agency revenue peaks → prices stabilize → activity slows. Predictable by tracking construction company activity
- **Country dynamics:** High real estate cost countries = higher absolute commission. Low-infrastructure countries = fewer builds = first agency gets monopoly but limited total volume

**Failure Points:**
- Dry pipeline → no new construction = no new listings = no transactions = fixed costs with zero revenue. Complete dependence on new construction = zero revenue during downturns
- Agent exodus → skilled agent takes client relationships to a competitor or starts their own agency. Contacts and listings follow them
- Valuation errors → low-skill Property Analyst overvalues properties → listings sit unsold → sellers blame the agency → reputation drops → listings pulled
- Processing bottleneck → high volume without admin support → deals queue → clients leave despite having the listings

**Emergent Gameplay:**
- **The developer pipeline:** A player who owns both a Real Estate Agency AND a Construction Company captures both sides: build it, list it through your own agency, collect both margins. In a construction boom this player captures two revenue streams simultaneously
- **Information asymmetry:** Real Estate Agents see all listings across a country before most players do. A player running an agency alongside investment activities has unique first-mover access to undervalued properties — the information advantage is the job, not an exploit

**Abuse & Exploit Analysis:**
- **Wash trading:** Owner lists their own property through their own agency at an inflated price, "sells" it to create a fake capital gain and collect the commission. **Counter:** Same-owner transactions flagged. Agency commissions from same-owner deals are voided. The one-account-per-identity rule makes this impractical at scale with real accounts

**Status:** ✅ Design Complete

---

## 4C. Property Management Company

**Business Model:** Manages commercial and residential properties on behalf of landlords who don't want to self-manage. Landlords pay a recurring management fee per property per tick in exchange for having tenant relationships, maintenance coordination, rent collection, and vacancy management handled professionally. It is the lowest-volatility business in the sector: no inventory, no spoilage, no construction risk, no market timing. Revenue scales through portfolio depth, not transaction volume. What makes it strategically distinct: more managed properties = more predictable, compounding recurring revenue — the most stable income stream available to any player in the real estate economy.

**Supply Chain Position:**
```
Property Owner (landlord — player or company)
      ↓ (pays management fee %)
Property Management Company
      ↓ (collects rent, manages maintenance, handles vacancies)
Tenant (player/company renting space)
      ↓
Maintenance needs ──→ contracts Construction Company for repairs
```

**Employee Roles:**
| Role | Function |
|------|----------|
| Property Manager | Core operational role. Manages tenant relationships, processes rent collection. Skill determines: properties managed per tick, tenant retention rate, vacancy resolution speed. Low-skill = tenants leave more often, vacancies drag on |
| Maintenance Coordinator | Schedules and manages repair contracts with Construction Companies. Skill affects: how quickly maintenance is arranged and whether the cost-effective contractor is hired. Poor coordination = properties deteriorate, tenants leave |
| Leasing Agent | Fills vacant units. Skill affects vacancy fill time — how many ticks a property sits empty after a tenant leaves |
| Accountant | Tracks rent collection, fees, and maintenance costs per property. Low-skill = billing errors, disputes with tenants and landlords |
| Operations Manager | Only meaningful when a real player. Handles portfolio strategy, landlord relationships, contractor negotiations. NPC here = owner approves all maintenance contracts manually |

**Operating Costs (per tick):**
- Employee salaries (managers and coordinators require mid-tier professional wages)
- Office space rent (small commercial office)
- Systems/software (portfolio tracking tools — sourced from Technology sector)
- Maintenance dispatch costs (coordination overhead — repairs themselves bill to the landlord)

**Revenue Model:**
- **Management fee:** A percentage of rent collected per property per tick. Owner sets rate — typical range 8–15%. Higher rates for luxury/complex properties
- **Portfolio is the moat:** Revenue scales linearly with properties under management. 50 properties earns 50x more than 1, with nearly no additional fixed cost per property once staff infrastructure exists
- **Vacancy penalty:** If a property sits vacant, no rent collected = no management fee. Incentivizes fast vacancy resolution
- **Maintenance markup:** Minor secondary revenue from small markups on maintenance contracts arranged for landlords

**Key Owner Decisions:**
- **Fee rate vs portfolio size:** High rate (15%) attracts fewer landlords but larger margin per property. Low rate (8%) builds portfolio faster but requires more properties to reach the same revenue
- **Residential vs commercial portfolio:** Commercial = higher rent = higher absolute fee. Residential = more stable tenants, more predictable volume
- **Maintenance contractor relationships:** Long-term contracts with construction companies (predictable cost, reliable service) vs open market every time (potentially cheaper but unpredictable availability)
- **Vacancy response speed:** Heavy staffing toward leasing agents (fast fill, high salary cost) or lean (vacancies sit longer, lower overhead)

**Capacity & Scaling:**
- Portfolio capacity capped by Property Manager headcount — each manager has a maximum properties per tick based on skill
- Maintenance Coordinator is the quality bottleneck at scale
- Growth priority: hire managers first (expands capacity) → coordinators (quality) → leasing agents (reduce vacancy drag)
- Branches expand into new countries — property management is inherently local

**Cross-Sector Dependencies:**
- Real Estate Agency (Sector 4B) — primary source of new client referrals; natural partnership
- Construction Company (Sector 4A) — all maintenance and renovation contracted out
- Technology (Sector 8) — portfolio management software; player-run tech firms can provide tools with efficiency bonuses
- Finance (Sector 5) — referring landlords for property purchase financing builds client stickiness
- All sectors — every business that owns property it doesn't want to self-manage is a potential client

**Market Dynamics:**
- **Oversaturated:** Fee compression. Companies compete entirely on service quality — vacancy fill speed, maintenance responsiveness, financial reporting accuracy
- **Undersaturated:** Landlords must self-manage. First management company captures all reluctant self-managers with strong pricing power
- **Natural cycle:** Demand grows as the economy matures. Early game — few landlords. Mid game — businesses accumulating branches need help. Late game — wealthy players with portfolios need full-service management
- **Country dynamics:** High real estate cost countries = higher rents = larger absolute fees. Low-infrastructure = lower rent, less competition

**Failure Points:**
- Portfolio collapse → a key landlord managing 10 properties pulls all in one tick. Revenue drops proportionally with no warning. Concentration risk is the primary strategic danger
- Maintenance spiral → Coordinator leaves or is understaffed → maintenance queues → properties deteriorate → tenants leave → landlords pull portfolios
- Vacancy trap → heavy vacancy during downturns → no rent collected → no fee → fixed costs continue → operating at a loss until occupancy recovers
- Leasing agent gap → properties vacant longer than landlord tolerance → landlords switch → portfolio shrinks → hard to attract new clients without track record

**Emergent Gameplay:**
- **Vertically integrated property empire:** A player owning Construction + Real Estate Agency + Property Management captures the complete lifecycle: build → list → manage. The only money leaving is raw materials and labor
- **Distressed property hunting:** A savvy manager monitors vacancy rates across the market. When vacancy spikes during downturns, they approach distressed landlords with below-market fee offers in exchange for long-term contracts. When the market recovers, those locked-in clients generate disproportionate profit

**Abuse & Exploit Analysis:**
- **Maintenance markup inflation:** Owner's construction company charges above-market rates for repairs; the management company passes the inflated cost to the landlord while appearing to offer a fair management fee. **Counter:** Maintenance contracts between related parties are flagged; landlords can see cost breakdowns and compare to market rates. Systematic overcharging causes landlords to leave for independent-contractor competitors

**Status:** ✅ Design Complete

---

## 4D. Storage Facility

**Business Model:** Rents commercial storage space to businesses that need more inventory capacity than their primary property allows. It is not a logistics company — goods sit here, they don't move through it. Revenue is rental: businesses pay per tick per unit occupied. Demand is structural — every business with inventory management tensions eventually overflows their on-site space. What makes it strategically distinct: it is the only business in the game that earns revenue while doing nearly nothing operationally. The trade-off is exactly that — low ceiling, low variance, high reliability. And one critical rule: **storage does not pause spoilage timers**.

**Critical Mechanic:** Spoilage timers continue running for all perishables stored here. Businesses using storage for food or pharmaceuticals are trading short-term capacity relief for increased spoilage risk. This is a deliberate, unresolvable dilemma — storage buys space, not time.

**Supply Chain Position:**
```
Any business with excess inventory (food manufacturers, supermarkets,
construction companies, manufacturers, etc.)
      ↓ (rents storage units per tick)
Storage Facility
      ↓ (goods arrive/depart via logistics — Delivery or Trucking/Freight)
      ↓ (spoilage timers continue running on all perishables)
Business retrieves goods when needed
```

**Employee Roles:**
| Role | Function |
|------|----------|
| Warehouse Worker | Core operational role. Manages receiving and retrieval. Skill affects: processing throughput per tick and goods handling quality (spoilage modifier during loading/unloading — identical to the logistics sector rule) |
| Inventory Controller | Tracks what is stored where, monitors expiration, notifies tenants before goods expire. Skill affects record accuracy. Low-skill = errors, missed expiration warnings, tenants lose goods and blame the facility |
| Security | Prevents theft and unauthorized access. Without security, a periodic random chance of inventory loss applies |
| Facility Manager | Only meaningful when a real player. Manages tenant relationships, pricing adjustments, expansion decisions, long-term contracts |

**Storage Unit Types:**
| Type | Contents | Rent | Utility Cost |
|------|----------|------|-------------|
| Standard | Non-perishables, construction materials, manufactured goods | Low | Low |
| Refrigerated | Food products, pharmaceuticals | Premium | High |
| Secure | High-value goods, electronics | Premium | Medium |

**Operating Costs (per tick):**
- Employee salaries
- Property rent or mortgage (the single largest cost — the facility IS the product)
- Utilities (refrigeration, lighting, security systems — significant for refrigerated units)
- Equipment maintenance (forklifts, loading dock equipment, shelving)

**Revenue Model:**
- **Storage rental fee per unit per tick** — set by the owner. Price competition is the primary market dynamic
- **Occupancy rate** is the core KPI. A facility at 90% occupancy is profitable. At 50%, margins collapse
- **Contract terms:** Short-term (flexible for tenant, uncertain for facility) vs long-term (locked income, tenant pays slightly less, owner has certainty)

**Key Owner Decisions:**
- **Storage type mix:** All-standard (low cost to build, wide market, commodity pricing), all-refrigerated (expensive, premium rent, less competition), or mixed
- **Contract term preference:** Maximize long-term contracts (stable, lower rate) or keep flexible (higher rate, uncertain occupancy)?
- **Pricing strategy:** Market rate (full occupancy, commodity margins) or premium with services (Inventory Controller expiration alerts, climate control, security)?
- **Location:** Near manufacturing districts = constant demand, higher property cost. Remote = cheap property, lower rent income, harder to attract tenants

**Capacity & Scaling:**
- Total capacity fixed by property size. Expanding requires new commercial space (Real Estate Agency) or construction (Construction Company)
- Throughput bottlenecked by Warehouse Worker count during peak periods
- Branching is geographic — a facility near a manufacturing district serves different clients than one near a retail hub

**Cross-Sector Dependencies:**
- Real Estate Agency (4B) / Construction Company (4A) — acquiring and expanding the facility itself
- Delivery Company (2A) / Trucking/Freight (2B) — all goods entering or leaving require logistics contracts. The facility is a node on the logistics network, not a provider
- Food Manufacturing, Supermarket, Catering (Sector 1) — primary users of refrigerated storage
- Construction Company (4A) — primary user of standard storage for materials
- Manufacturing (Sector 7) — large inventory buffer users
- Pharmacy (Sector 3D) — climate-controlled storage for pharmaceuticals

**Market Dynamics:**
- **Oversaturated:** Standard storage becomes a commodity — lowest price wins. Refrigerated and secure units maintain margins; standard-only operators squeezed to near-zero
- **Undersaturated:** Businesses have no inventory buffer. Production capacity is physically limited by on-site storage. A storage facility in an undersaturated market commands premium rates
- **Natural cycle:** Demand tracks inventory tension across the economy. Growth phase = storage fills up. Downturn = businesses clear inventory and cancel contracts, occupancy collapses
- **Country dynamics:** Manufacturing and production countries = constant demand. High real estate cost countries = high facility costs eat into margin

**Failure Points:**
- Occupancy crash → economic downturn causes multiple tenants to cancel simultaneously → revenue halves → fixed costs remain → operating at a loss
- Refrigeration failure → equipment breakdown causes temperature failure → tenant goods spoil → damage claims → reputation collapse → all refrigerated tenants leave
- Spoilage dispute → tenant stores perishables too long, goods expire, tenant blames the facility. **Mitigation:** Inventory Controller sends documented expiration alerts — paper trail protects the facility
- Security gap → no Security role → periodic loss events → tenants see unexplained inventory shrinkage → cancellations

**Emergent Gameplay:**
- **The logistics hub:** A player who owns a storage facility positioned between a manufacturing district and a retail district creates a physical hub for the supply chain. Manufacturers store output here; retailers draw from it on demand. Combined with a Delivery Company, this player controls a mini-distribution network — buying in bulk from manufacturers and reselling storage access to retailers who need flexible inventory
- **Spoilage arbitrage:** A storage facility owner who understands the food supply chain can offer refrigerated units with guaranteed rapid retrieval. Food manufacturers with tight spoilage windows pay a premium for this. Standard storage can't compete because speed matters when your product expires in 8 ticks

**Abuse & Exploit Analysis:**
- **Occupancy inflation:** A player routes all their own inventory through their own storage facility, artificially inflating apparent occupancy and revenue for valuation purposes. **Counter:** Self-storage between same-owner entities is flagged and discounted in the valuation algorithm. The facility must demonstrate transactions with unrelated tenants for full valuation credit

**Status:** ✅ Design Complete

---

## Sector 4 Summary
## Sector 4 Summary

| Company Type | Revenue Model | Volatility | Key Dependency |
|---|---|---|---|
| Construction Company | Contract-based, per build | High (bid wins/losses, material price swings) | Raw materials + skilled crew + Architect |
| Real Estate Agency | Commission on transactions | Medium (follows construction cycles) | Listing pipeline + agent skill |
| Property Management | Recurring fee % of rent | Low (predictable, portfolio-based) | Portfolio depth + maintenance coordination |
| Storage Facility | Rental per unit per tick | Medium-Low (occupancy-driven) | Property size + location + tenant mix |

**Vertical integration opportunity:** Build (Construction) → List (Agency) → Manage (Property Management) → Store overflow (Storage). A full property empire capturing every layer of the real estate economy.

---

-e 
---

*Last updated: May 25, 2026 — Split from master document*
