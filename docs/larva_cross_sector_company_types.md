# Project Larva — Cross-Sector Company Types

> **Status:** ✅ Holding Company fully designed  
> **Parent document:** See `larva_master.md` for core systems, cross-sector rules, and progress tracker

This file contains company types that operate across multiple sectors rather than belonging to any single one. These are structural entities that sit above the sector layer and interact with companies from any or all of the 9 sectors.

---

## Holding Company

**Business Model:** A Holding Company is a corporate parent entity that owns and manages a portfolio of at least 3 operating companies (subsidiaries). It does not produce goods or serve end customers directly. Its product is professional corporate management — strategic oversight, shared back-office services, and coordinated resource allocation across its subsidiaries. Revenue comes from management fees charged to each subsidiary per tick in exchange for real efficiency bonuses those subsidiaries could not achieve independently. What makes it strategically distinct: it is the only company type in the game whose entire value proposition is making other companies better. It produces nothing on its own — it is a pure multiplier. A well-run holding company makes every subsidiary more profitable than they would be alone. A poorly-run one is a parasite that drains them.

### Formation Requirements

- The player must already own **at least 3 operating companies** before they can form a Holding Company
- All 3+ companies must have been operational for at least **20 ticks** (proves they aren't shells created just to qualify)
- The player must acquire **corporate headquarters** — commercial real estate separate from any subsidiary's space
- A one-time **formation fee** is charged by the system (similar to a listing fee — represents legal incorporation costs)
- Once formed, the holding company is a real entity with its own balance sheet, employees, and operating costs

### Structural Rules

- A holding company can own subsidiaries from **any sector** — cross-sector portfolios are the norm, not the exception
- Subsidiaries retain their individual company identity, their own employees, their own customers, and their own sector-specific operations
- The holding company owner is the ultimate decision-maker — but the entire point is delegating that authority to holding-level executives and subsidiary-level managers
- A holding company **cannot own another holding company** — one layer only, no recursive structures
- A player can only own **one holding company** at a time
- Subsidiaries can still be independently listed on the stock market — the holding company's ownership stake in listed subsidiaries is reflected in its valuation
- The holding company itself can also be listed — its share price reflects the aggregate performance of all subsidiaries plus its own management efficiency
- **Minimum subsidiary count is enforced continuously** — if subsidiaries drop below 3 (sale, closure, or bankruptcy), a **10-tick grace period** begins. If the owner doesn't acquire or create a third subsidiary within that window, the holding company is forcibly dissolved and all remaining subsidiaries become independent companies again
- **No hard cap on subsidiaries** — scaling is purely economically gated through COO coverage caps, accountant step-function costs, and escalating HQ space requirements

### Supply Chain Position

```
Holding Company (Corporate HQ)
      ↓ management fees (per tick)          ↑ efficiency bonuses
      ↓                                      ↑
┌─────────────┬─────────────┬─────────────┐
│ Subsidiary A│ Subsidiary B│ Subsidiary C│ ... up to N
│ (any sector)│ (any sector)│ (any sector)│
└─────────────┴─────────────┴─────────────┘
      ↓                                      ↑
   Normal sector operations continue — all existing
   rules (logistics, spoilage, employees, etc.) unchanged
```

The holding company sits above the sector layer. It does not interrupt any subsidiary's normal supply chain. Subsidiaries still buy from suppliers, sell to customers, hire employees, and pay for logistics exactly as they would independently. The holding company adds a management layer on top.

**Critical Rule — No Special Treatment for Inter-Subsidiary Transactions:**
Transactions between subsidiaries within the same holding group follow **all normal rules** — mandatory logistics, standard transaction fees, market-rate pricing. No discounts, no shortcuts, no fee waivers. This prevents the holding company from becoming a vehicle for price manipulation, artificial revenue inflation, or money laundering. The only advantage of shared ownership is coordination — knowing what your other companies need and when they need it. Information advantage, not rule-breaking advantage.

### Employee Roles

| Role | Function |
|------|----------|
| Chief Executive Officer (CEO) | The strategic brain. Only meaningful when filled by a **real player**. Provides a **management efficiency bonus** to all subsidiaries — each subsidiary operates as if its owner were actively managing it, even when the actual owner hasn't touched it that tick. NPC CEO provides zero strategic bonus — the holding company exists but adds no management value. This is the single most consequential hiring decision in the game. A real-player CEO running a 6-company holding effectively gives the owner 7 pairs of hands |
| Chief Operating Officer (COO) | Coordinates operations across subsidiaries. Skill determines the **subsidiary coverage cap** — how many subsidiaries one COO can actively oversee per tick without quality degradation. Base coverage: 3 subsidiaries at full efficiency. Each additional subsidiary beyond the cap reduces the efficiency bonus by 15% per extra company. A high-skill COO raises the cap. NPC COO covers 2 subsidiaries at reduced efficiency |
| Chief Financial Officer (CFO) | Manages consolidated finances. Provides **cash flow optimization** — reduces waste from poor timing on payments, improves purchasing coordination across subsidiaries (the CFO sees all subsidiaries' upcoming expenses and can time large purchases to avoid cash crunches). Higher skill = better financial dashboard data for the owner (margin breakdowns per subsidiary, trend projections, cost anomaly flags). NPC CFO provides basic consolidated reporting only |
| Corporate Accountant | Replaces the need for individual accountants in each subsidiary. One Corporate Accountant can handle accounting for **up to 4 subsidiaries**. Beyond that, additional accountants are needed. This is the most direct cost saving — instead of 6 accountants across 6 companies, the holding company employs 2 who cover all 6. Skill affects accuracy of financial records across all covered subsidiaries |
| HR Coordinator | Manages talent across the holding group. Enables **inter-subsidiary employee transfers** — moving an employee from one subsidiary to another without firing and rehiring (preserves skill progression, avoids the open market). Also provides a small **recruitment bonus** — the holding company's reputation attracts slightly better NPC candidates across all subsidiaries. Skill determines transfer processing speed and recruitment quality bonus |
| Corporate Legal Counsel | Handles routine legal compliance for all subsidiaries — contract reviews, employment disputes, regulatory filings. Replaces the need for each subsidiary to retain a Legal Firm for routine matters. **Complex legal matters** (major disputes, litigation, regulatory investigations) still require an external Legal Firm (Sector 6A). Skill determines the threshold between "routine" and "complex" — a high-skill Counsel handles more internally, saving external legal fees |

### Operating Costs (per tick)

- **Executive salaries** — CEO, COO, CFO are premium roles. Real players in these seats command top-tier compensation. This is the dominant cost and the primary reason a holding company only makes sense at scale
- **Corporate staff salaries** — Accountants, HR Coordinator, Legal Counsel
- **Corporate headquarters rent** — commercial real estate. Not a warehouse, not a storefront — office space. Size scales with subsidiary count (more subsidiaries = larger HQ needed for the staff to manage them)
- **Management systems** — software from the Technology sector (Software Firm 8B). A portfolio management platform that enables consolidated dashboards and cross-subsidiary coordination. Subject to normal software degradation and version cycles
- **Utilities and equipment** — standard office operational costs
- **Formation fee amortization** — the one-time formation fee is significant enough to discourage casual creation

### Revenue Model

**Management fee per subsidiary per tick:** The holding company charges each subsidiary a percentage of that subsidiary's **gross revenue** as a management fee. The owner sets the rate — typical range **3–8%** of gross revenue.

- At 3%: minimal drain on subsidiaries, but the holding company struggles to cover its own costs unless the portfolio is large
- At 8%: healthy holding company margins, but subsidiaries are visibly less profitable than independent competitors — risk of the subsidiaries being valued lower on the stock market
- The fee is automatically deducted from each subsidiary's revenue before profit calculation
- **This is a real cost that appears on each subsidiary's income statement** — visible to stock market investors, visible to the valuation algorithm, visible to anyone analyzing the company

**The break-even calculation:** A holding company is only economically rational when the **efficiency bonuses** it provides exceed the **management fees** it charges plus its own **operating costs** divided across subsidiaries. With 3 subsidiaries, the math is tight. With 6+, it's clearly profitable. This naturally gates the holding company as a late-game scaling play.

### Efficiency Bonuses (What Subsidiaries Get)

| Bonus | Source | Effect |
|-------|--------|--------|
| Management Coverage | CEO (real player) | Each subsidiary operates at "actively managed" efficiency even when the owner isn't directly managing it that tick. Without this, unattended subsidiaries suffer the standard "absent owner" penalty |
| Operational Coordination | COO | Subsidiaries within the COO's coverage cap receive a 5–10% employee efficiency bonus (coordination reduces wasted effort). The COO effectively acts as a remote Manager for subsidiaries that don't have their own |
| Financial Optimization | CFO | 3–5% reduction in operating cost waste (timing purchases better, avoiding unnecessary expenses). More impactful for capital-intensive subsidiaries |
| Shared Accounting | Corporate Accountant | Direct cost saving — subsidiary doesn't need its own accountant. Quality depends on Accountant skill |
| Talent Mobility | HR Coordinator | Employee transfers between subsidiaries without market exposure. Preserves skill, avoids recruitment costs. Small recruitment quality bonus across all subsidiaries |
| Routine Legal Coverage | Corporate Legal Counsel | Direct cost saving — subsidiary doesn't need an external Legal Firm retainer for routine matters |

### Key Owner Decisions

- **Management fee rate:** The core tension. Higher fee = more holding company revenue but weaker subsidiaries. Lower fee = stronger subsidiaries but the holding company may operate at a loss. The optimal rate depends on portfolio size and subsidiary profitability — no universal right answer
- **C-suite hiring strategy:** Real players in CEO/COO/CFO seats are transformationally powerful but extremely expensive. NPC executives are cheap but provide minimal benefit — an NPC-staffed holding company is barely better than no holding company. The question is whether the efficiency gains from real-player executives justify their salaries across the portfolio
- **Portfolio composition:** Should all subsidiaries be in related sectors (vertical integration — food manufacturer + logistics + supermarket) for supply chain synergy, or diversified across unrelated sectors (insurance against any one sector's downturn)? Both are viable. Vertical stacks maximize coordination value. Diversification maximizes resilience
- **Subsidiary autonomy vs centralized control:** Each subsidiary can still have its own real-player Manager. The holding company adds a layer on top. The owner must decide: do subsidiary Managers report to the holding CEO (creating a real corporate hierarchy), or does the owner maintain direct relationships with each subsidiary Manager? More hierarchy = more scalable, less direct control
- **Growth timing:** When to add the 4th, 5th, 6th subsidiary. Each new subsidiary adds revenue to the holding company but also increases COO coverage pressure and HQ space requirements. Growing too fast without scaling the holding company's staff degrades efficiency bonuses for everyone
- **Dissolution calculation:** A holding company with only 3 mediocre subsidiaries might cost more than it provides. The owner must periodically assess whether the holding structure is still justified — or whether dissolving it and running companies independently would be more profitable. This is the "kill your darling" decision

### Capacity & Scaling

- **COO coverage cap** is the primary bottleneck. Base: 3 subsidiaries at full efficiency. High-skill real-player COO: up to 6 at full efficiency. Beyond the cap, every subsidiary suffers diminishing bonuses. Scaling past the cap requires either a second COO (expensive, requires reorganizing the hierarchy) or accepting degraded performance
- **Corporate Accountant capacity:** Each covers 4 subsidiaries. Scaling past 4, 8, 12 subsidiaries requires additional accountants — a step-function cost increase
- **HQ space:** Larger portfolios need larger headquarters. This means higher rent, possibly needing to relocate to a bigger property — coordinated through the Real Estate sector
- **No hard cap on subsidiaries** — the system doesn't impose a maximum. But management costs scale faster than management benefits past roughly 8–10 subsidiaries unless the C-suite is stacked with elite real players. The natural ceiling is economic, not arbitrary
- **Multi-country expansion:** A holding company can own subsidiaries in different countries. But the COO's coverage cap still applies regardless of location — managing companies across borders is no harder or easier than managing them locally (this is a simplification for gameplay — the complexity is in the subsidiaries' local markets, not the holding company's management layer)

### Cross-Sector Dependencies

| Dependency | Interaction |
|------------|------------|
| **All 9 sectors** | Subsidiaries can be any company type from any sector. The holding company is the only entity in the game that structurally connects to every sector simultaneously |
| **Real Estate (Sector 4)** | Corporate headquarters requires commercial real estate. Larger portfolios need larger HQ |
| **Technology — Software Firm (8B)** | Portfolio management software subscription. Without it, the holding company operates with reduced dashboard visibility and coordination tools |
| **Professional Services — Legal Firm (6A)** | Complex legal matters beyond the Corporate Legal Counsel's scope still require external legal services. Formation of the holding company itself may require Legal Firm services |
| **Finance — Accounting Firm (5D)** | Annual audits for the holding company if listed on the stock market. The holding company's consolidated financials are more complex than a single-entity company |
| **Finance — Private Bank (5A)** | Consolidated credit lines — a holding company with strong subsidiaries may qualify for larger loans than any single subsidiary would alone |
| **Stock Market** | The holding company can be listed. Its valuation reflects aggregate subsidiary performance. Individual subsidiaries can also be listed independently — creating a two-tier investment structure |
| **Recruitment Agency (6B)** | C-suite hiring for the holding company itself. CEO, COO, CFO positions are among the most difficult and expensive roles to fill in the game |

### Market Dynamics

- **Threshold effect:** Holding companies don't exist in the early game. They emerge once the economy matures enough for individual players to accumulate 3+ successful companies. The first holding companies in a country signal economic maturity
- **Natural scarcity:** Not every player will build a holding company. The prerequisite (3+ operational companies, 20 ticks each) means only the most successful business operators qualify. This makes holding company ownership a visible status marker in the game's social hierarchy
- **Competitive pressure on independents:** An independent restaurant competing against a subsidiary restaurant backed by a holding company's efficiency bonuses faces a structural disadvantage — the subsidiary has lower effective overhead, better talent pipeline, and coordinated supply if the holding group includes related businesses. This creates a natural consolidation pressure — independent operators either join a holding group (by selling to a holding company owner) or find niche advantages the holding company can't replicate
- **No oversaturation risk in the traditional sense:** Unlike sector-specific companies that compete for the same customers, holding companies compete for acquisition targets — good companies to buy. In a mature economy, the scarce resource isn't customers, it's well-run independent businesses available for acquisition
- **The empire builder vs. the specialist:** Two viable endgame strategies emerge. Empire builders create holding companies with wide portfolios and compete on scale. Specialists stay independent, go deep in one sector, and compete on quality. Neither dominates — both are viable paths to wealth

### Failure Points

- **Cost drain on weak subsidiaries:** A subsidiary going through a rough period still pays the management fee. If two subsidiaries are struggling simultaneously, the holding company's fees accelerate their decline. The holding company can waive fees temporarily — but then it can't cover its own costs. Downturns cascade across the portfolio because the management fee doesn't stop during bad times
- **C-suite departure cascade:** The real-player CEO resigns. Every subsidiary instantly loses the "actively managed" bonus. If the COO also leaves (common — C-suite departures often trigger each other), the holding company provides nearly zero value while still charging fees. The owner must either fill the roles immediately (expensive panic-hiring) or dissolve the holding company. This is the single most catastrophic event for a holding company
- **Overexpansion spiral:** Owner acquires a 7th subsidiary but doesn't hire a second COO. All 7 subsidiaries now receive degraded efficiency bonuses. The subsidiaries that were previously well-served notice the decline — if any of them are listed, their share prices may dip. The owner is now paying more in total management fees but delivering less value per subsidiary. The correct move is to either scale the holding company's staff or sell a subsidiary — but the owner's pride often prevents the latter
- **The parasite trap:** A holding company charging 8% management fees but staffed with NPC executives provides almost no efficiency bonuses. It's a pure tax on the subsidiaries. The owner doesn't realize this because the holding company's own balance sheet looks fine (management fee revenue covers costs), but the subsidiaries are all underperforming their potential. The tell: the portfolio's aggregate growth rate is lower than comparable independent companies in the same market
- **Dissolution shock:** If the holding company is dissolved (voluntarily or by dropping below 3 subsidiaries), all shared-service benefits vanish instantly. Subsidiaries that relied on the Corporate Accountant suddenly have no accounting. Subsidiaries that transferred employees through HR Coordinator now have no talent pipeline. The transition disruption can cause a 2–3 tick performance dip across all former subsidiaries

### Emergent Gameplay

- **The vertical empire:** A player builds a holding company containing a Food Manufacturer, a Delivery Company, and a Supermarket. The Food Manufacturer produces the goods, the Delivery Company transports them, and the Supermarket sells them. Each transaction is at market rates (no special treatment rule), but the information advantage is enormous — the owner knows exactly what the Supermarket needs, when the Delivery Company has capacity, and what the Manufacturer can produce. Competitors operating independently must negotiate, wait for quotes, and risk supply disruptions. The vertical empire's edge isn't cheaper transactions — it's perfect coordination. The COO makes this work by optimizing timing across all three
- **The hostile acquisition play:** A holding company owner identifies a struggling independent competitor in one of their subsidiary's markets. They offer to buy the struggling company at a discount, fold it into the holding group, inject holding-company-level management expertise, turn it around, and now dominate that market with two subsidiaries. The competitor was failing independently — under the holding company's management bonuses and shared services, it becomes viable. This is the Larva version of private equity
- **The conglomerate IPO:** A holding company with 6 profitable subsidiaries across 4 sectors goes public. Investors can now buy shares in the holding company — effectively getting diversified exposure to 6 different business types through one stock. This is less volatile than investing in any single subsidiary. Investment Firms (Sector 5B) love this as a core holding for conservative funds. The holding company's share price becomes a proxy for the overall health of the local economy — if the conglomerate is doing well, it means multiple sectors are doing well simultaneously
- **The management-for-hire play:** An elite real-player CEO with a track record of turning around failing holding companies commands massive salary. Holding company owners compete to hire them. The CEO's presence alone can lift a struggling portfolio — not through magic, but through the management efficiency bonus applied across 5+ subsidiaries simultaneously. A great CEO is the highest-leverage employee in the game — their skill multiplies across every company in the group

### Abuse & Exploit Analysis

- **Management fee extraction:** Owner creates a holding company, charges 8% management fees, staffs it with NPCs, and extracts cash from subsidiaries with no real value provided. **Counter:** This is self-defeating. The subsidiaries underperform, their valuations drop, stock prices (if listed) fall, and the total portfolio value declines faster than the fees extract value. The holding company itself becomes worth less. It's the equivalent of a real-world company paying dividends from principal instead of profits — the numbers look fine for a few ticks, then everything collapses. No external counter needed — the mechanic punishes itself
- **Inter-subsidiary price manipulation:** Owner has Subsidiary A sell goods to Subsidiary B at inflated prices to move money between entities and inflate Subsidiary A's revenue. **Counter:** Already covered by the existing cross-sector rule — all inter-subsidiary transactions follow normal rules, and the valuation algorithm already detects and discounts same-owner transactions. Flagged in audit trails
- **Holding company as money laundering vehicle:** Create a holding company, cycle money through subsidiaries via management fees, extract through the holding company. **Counter:** Management fees are visible line items on every subsidiary's income statement. The holding company's revenue must match the sum of its management fees — any discrepancy is flagged. All flows are auditable. The mandatory transaction records make this harder, not easier, than laundering through a single company
- **Rapid acquisition shell game:** Player buys 3 cheap failing companies, forms a holding company to access the structure, then immediately sells the holding company at a markup based on "potential." **Counter:** The 20-tick operational requirement means the subsidiaries must have been running (and burning cash) for 5 real days. The valuation algorithm values the holding company based on subsidiary performance, not potential. A holding company with 3 failing subsidiaries has a near-zero or negative fair value. No one would buy it unless they saw a turnaround path — which is legitimate gameplay, not an exploit

### Central Corporation

The Central Corporation does **not** operate a holding company. The Central Corporation is already a unified entity by design — it doesn't need a holding structure because it's the system itself. This is consistent with the CC's role as baseline competitor, not as a player-like entity.

### Stock Market Interaction

- A holding company can be listed following all standard listing requirements (60 ticks operational, 20/30 ticks profitable, 5+ employees, zero defaults)
- Its **fair value** is calculated as: sum of ownership stakes in all subsidiaries' fair values + holding company net assets − holding company liabilities. Effectively a **net asset value (NAV)** calculation
- If a subsidiary is also independently listed, the holding company's stake is valued at the subsidiary's market price (not fair value) — creating an interesting dynamic where the holding company's share price partially tracks its subsidiaries' stock performance
- Investors choosing between buying the holding company vs. individual subsidiaries are making a diversification vs. concentration bet — exactly as in the real world

---

*Last updated: May 26, 2026 — Holding Company design complete*
