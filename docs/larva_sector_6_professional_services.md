# Project Larva — Sector 6: Professional Services (Complete)

> **Status:** ✅ All 2 company types fully designed  
> **Parent document:** See `larva_master.md` for core systems, cross-sector rules, and progress tracker

---



**Sector Philosophy:** Pure knowledge businesses. No physical goods, no inventory, no logistics dependency. Revenue comes from making other companies more effective or protecting them from losses. These businesses sell expertise and access — their assets are their employees' skills and their reputation. The lightest-weight businesses in the game operationally, but among the most skill-dependent.

**Note:** Consulting Firm and Marketing Agency were removed from this sector. Marketing is handled purely through the Central Corporation system (finalized marketing mechanic). Consulting overlapped with the Accounting Firm's Financial Strategy service (Sector 5D).

---

## 6A. Legal Firm

**Business Model:** Provides legal services to companies and players on a B2B and B2C contract basis. Three service categories: contract enforcement (recovering money from breached B2B contracts), dispute resolution (defending against claims from other players/companies), and transaction processing (handling company acquisitions, mergers, and major asset transfers). What makes it strategically distinct: it is the only business that directly affects the outcome of conflicts between other players. A Legal Firm doesn't produce or sell anything — it changes who wins when two parties disagree. The product is leverage.

**Why It Exists in the Larva Economy:**
Every finalized sector generates contract disputes. A delivery company fails a transport contract — the buyer is owed a penalty. A construction company misses a deadline — the client wants compensation. A catering company delivers substandard food — the event organizer demands a refund. Currently these penalties are automatic and system-calculated. The Legal Firm adds a layer: was the penalty fair? Could the aggrieved party recover more? Could the penalized party reduce their liability?

**Supply Chain Position:**
```
Company A (has a grievance or legal need)
      ↓ (pays retainer or per-case fee)
Legal Firm
      ↓ (processes case: enforcement, defense, or transaction)
Outcome: modified penalty, recovered funds, completed transaction
      ↓
Company B / Counterparty (affected by legal outcome)
```

No physical goods. No logistics dependency. Pure service.

**Legal Service Categories:**

| Service | What It Does | When It Triggers |
|---------|-------------|-----------------|
| Contract Enforcement | Recovers additional compensation beyond the automatic penalty when a B2B contract is breached | A delivery fails, a construction deadline is missed, a supplier delivers substandard goods — the aggrieved party hires a Legal Firm to pursue additional damages |
| Dispute Defense | Reduces or eliminates penalties and claims against the client | The penalized party hires a Legal Firm to argue mitigating circumstances — partial delivery, force majeure (economic events), counterparty contribution to the failure |
| Transaction Processing | Handles legal requirements for company acquisitions, mergers, and major asset sales | Any company buy/sell transaction. Without legal processing, transactions take longer and have a higher chance of complications (hidden liabilities, contract transfer failures) |

**How Legal Disputes Work (Core Mechanic):**

When a B2B contract is breached, the system applies an automatic base penalty (already designed in logistics, catering, construction). The Legal Firm adds an **optional adversarial layer**:

1. **Aggrieved party hires Legal Firm** → files enforcement claim → seeks damages above the automatic penalty (up to 2x the base penalty, capped)
2. **Penalized party can hire their own Legal Firm** → files defense → argues for reduced liability
3. **Resolution** is calculated at the next tick:

```
Outcome Score = (Claimant Lawyer Skill × Case Strength) vs (Defendant Lawyer Skill × Defense Strength)
```

- **Case Strength** = severity of breach (how badly the contract was violated — system-calculated from delivery data, quality shortfall, deadline miss)
- **Defense Strength** = mitigating factors (partial fulfillment, economic event during the contract period, first offense)
- **If only one side has a lawyer:** The represented side gets a significant advantage (1.5x multiplier). Unrepresented parties use the base system penalty only
- **If neither side hires a lawyer:** Standard automatic penalty applies. No change from current design

**Outcome range:**
- Claimant wins strongly → recovers up to 2x base penalty from defendant
- Claimant wins narrowly → recovers 1.0–1.5x base penalty
- Defense wins → penalty reduced to 0.5–0.9x base penalty
- Defense wins strongly → penalty reduced to 0.25x base penalty (minimum — never zero, the breach still happened)

This creates a real legal market: companies that frequently deal in high-value contracts have an incentive to retain a Legal Firm. Companies that rarely face disputes can gamble without one.

**Transaction Processing Mechanic:**

Company acquisitions and major asset transfers require legal processing. Without a Legal Firm:
- Transaction takes 3 ticks to complete (administrative delay)
- 15% chance of "complication" — hidden liabilities surface post-sale (buyer inherits undisclosed debt, pending contract obligations, or damaged equipment not reflected in the sale price)
- Seller must disclose all liabilities, but without legal review, disclosure is based on the seller's honesty

With a Legal Firm (buyer's side):
- Transaction time reduced to 1 tick
- Complication chance reduced based on Lawyer skill: high-skill Lawyer → complication chance drops to 2–3%
- Due diligence report: Lawyer reviews all contracts, debts, employee obligations, pending disputes — buyer sees full picture before committing
- Legal Firm catches intentionally hidden liabilities and voids the sale pre-completion

With a Legal Firm (seller's side):
- Transaction time reduced to 1 tick
- Seller's valuation is presented more favorably — skilled Lawyer structures the deal to maximize sale price (5–15% premium on negotiated price, depending on skill)
- Post-sale liability shield — seller is legally protected from buyer's post-sale claims

**Best case for both parties:** Both hire Legal Firms. Fastest processing, maximum transparency, fair deal. The legal fees are the cost of certainty.

**Employee Roles:**

| Role | Function |
|------|----------|
| Lawyer | Core revenue role. Handles cases and transactions. Skill determines case outcome multiplier and transaction quality. Higher skill = better results for clients. Each Lawyer handles 2–3 active cases per tick. NPC Lawyers function at baseline skill with no growth — adequate for simple cases, outmatched by player Lawyers in contested disputes |
| Paralegal | Prepares case files — skill affects how much case data the Lawyer receives before resolution. Low-skill Paralegal = Lawyer works with incomplete information, worse outcomes. 1 Paralegal supports 2 Lawyers |
| Client Relations | Acquires new clients. Skill affects client volume per tick. Without this role, owner must personally seek clients |
| Managing Partner | Only meaningful when filled by a real player. Can accept cases, set fees, assign Lawyers to cases, negotiate retainers. NPC here = owner approves everything. The role that enables scaling beyond the owner's personal attention |

**The Lawyer is the product.** A firm with one exceptional player Lawyer attracts high-value clients willing to pay premium fees. A firm with NPC Lawyers handles routine small claims at commodity rates. The skill gap between NPC and player Lawyers is the largest in any Professional Services role — because the outcome directly affects other players' money.

**Operating Costs (per tick):**
- Employee salaries (Lawyers are premium-wage professionals — among the highest per-employee cost in the game)
- Office rent (moderate commercial space — client perception matters, a law firm in cheap space loses credibility = reputation penalty)
- Utilities and equipment maintenance (minimal)
- Case filing fees (small per-case cost paid to the system — prevents spam litigation)

**Revenue Model:**
- **Per-case fee:** Fixed game currency amount per case, paid upfront by the client (owner sets price)
- **Success bonus:** Additional percentage of recovered/saved amount, paid on favorable outcome only (owner sets percentage — typical 10–25% of the delta between base penalty and actual outcome)
- **Retainer contracts:** Ongoing fee per tick for priority access — client's cases are handled first, guaranteed Lawyer assignment. Premium pricing for reliability
- **Transaction processing fee:** Flat fee per company acquisition or asset transfer processed. Typically 2–5% of transaction value
- Owner controls: fee structure, case acceptance, Lawyer assignment
- Market determines: case volume (driven by contract breach frequency across all sectors), willingness to pay for legal representation

**Key Owner Decisions:**
- **Specialization vs generalist:** Focus on enforcement (aggressive, represents aggrieved parties, higher success bonuses) vs defense (protective, represents penalized parties, steadier demand) vs transactions (M&A specialist, high-value but low-volume)?
- **Fee structure:** High upfront + low success bonus (safe income regardless of outcome) vs low upfront + high success bonus (aligned incentives, volatile income)?
- **Case selection:** Take every case (volume, some losers) or cherry-pick strong cases (high win rate = reputation = premium fees)?
- **Lawyer investment:** One exceptional player Lawyer (expensive, competitive advantage, single point of failure) vs multiple NPC Lawyers (cheaper, higher volume, mediocre outcomes)?
- **Retainer strategy:** Lock in large companies on retainer (stable revenue, less flexibility) or stay available for the highest bidder per case?
- **Office quality:** Premium office space costs more but provides a reputation modifier — clients trust a firm in a professional office. Cheap space saves rent but clients see it

**Capacity & Scaling:**
- Purely staff-limited — each Lawyer handles 2–3 cases per tick
- Paralegal is the quality bottleneck: Lawyers without Paralegal support work with less case data
- Growth: hire more Lawyers → handle more cases → build reputation → attract higher-value clients → increase fees
- Branch expansion into new countries strategic — every country's economy generates disputes
- First Legal Firm in a country has temporary monopoly on legal services

**Cross-Sector Dependencies:**
- All sectors with B2B contracts — Logistics (delivery/freight failures), Construction (deadline misses, quality shortfalls), Manufacturing (supply quality disputes), Catering (contract failures)
- Finance — company acquisitions and mergers require transaction processing. Private Banks may require legal review for large loans
- Real Estate — property transactions can benefit from legal processing (hidden defects, lease disputes)
- Accounting Firm (5D) — natural referral partner. Accountant discovers financial irregularity → refers to Legal Firm for enforcement
- Central Corporation — its disputes use the base system only (no Legal Firm) unless a player takes a case against it. Players CAN sue the Central Corporation through a Legal Firm for breach of contract — creates an interesting David vs Goliath dynamic

**Market Dynamics:**
- **Oversaturated:** Fee compression on routine cases. Differentiation through win rate and Lawyer skill. Star player Lawyers become the moat — clients pay for the Lawyer, not the firm
- **Undersaturated:** All disputes resolved at base system rates. First Legal Firm captures all demand. Enforcement clients especially eager — they want MORE than the automatic penalty
- **Natural cycle:** Dispute volume tracks economic activity. Boom periods = more contracts = more breaches = more legal work. Downturns = fewer contracts but more failures = different mix of work. M&A activity spikes when struggling companies sell to stronger ones
- **Country dynamics:** High-activity countries with many B2B transactions = more disputes = more legal demand. Low-infrastructure countries = more transport failures = more delivery disputes

**Failure Points:**
- **Star Lawyer departure:** Best player Lawyer leaves → takes client relationships → firm's win rate drops → premium clients leave → forced to compete on price with NPC Lawyers → margin collapse
- **Losing streak:** String of losses (bad case selection or outmatched by opposing counsel) → win rate drops publicly → clients choose competitors → forced to accept weaker cases → more losses → reputation spiral
- **Overextension:** More cases than Lawyers can handle → Paralegal support spread thin → case preparation quality drops → outcomes worsen → clients dissatisfied → cancellations
- **Fee miscalculation:** Success bonus too high on a losing case = revenue loss. Upfront fees too high = clients go to competitors. Finding the right balance is the core challenge

**Emergent Gameplay:**
- **The legal arms race:** Two rival companies in the same sector (competing supermarkets, dueling delivery companies) each retain a Legal Firm on retainer. Every contract dispute between them becomes a proxy war between their lawyers. The Legal Firms profit from the rivalry — and have zero incentive to resolve it. The longer the feud, the more billable ticks
- **The M&A gatekeeper:** A Legal Firm specializing in transaction processing develops unmatched due diligence capability. Every smart buyer in the country routes acquisitions through them. The firm sees every deal before it closes — information advantage rivaling the Real Estate Agency's listing access. Combined with an Investment Firm, this player knows which companies are being sold before the market does
- **Legal extortion defense:** A player with a strong Legal Firm on retainer is harder to exploit through bad-faith breach claims. Competitors think twice before filing frivolous enforcement cases because they know the defense will be competent. The retainer becomes a deterrent, not just a service

**Abuse & Exploit Analysis:**
- **Frivolous litigation spam:** Player files enforcement claims on every minor contract deviation to harass competitors. **Counter:** Case filing fees (per-case cost to the system) make spam expensive. Cases with weak Case Strength scores resolve quickly with minimal or no additional penalty — the filing fee is wasted. Repeated frivolous filings flag the account
- **Collusive case throwing:** Two players agree — one's Legal Firm deliberately loses a case to transfer money to the other player (who recovers excess penalty). **Counter:** Case outcomes are calculated from skill × case strength, not player intent. Deliberately low-skilled representation just loses — the money goes to the winning side minus fees, no net transfer advantage. The filing fees and success bonus structure make this more expensive than a direct transaction
- **Self-suing:** Player breaches their own contract with their own company, hires their own Legal Firm to "recover" damages. **Counter:** Same-owner transactions flagged. Legal case outcomes between related parties are voided. One-account-per-identity prevents multi-identity workarounds at scale

**Status:** ✅ Design Complete

---

## 6B. Recruitment Agency

**Business Model:** Sources, screens, and places employees — both NPC and real player — into companies that need to hire. Every company in the game needs employees. Currently, hiring is a direct process: company posts a job, available workers fill it. The Recruitment Agency adds an intermediary layer that provides measurable hiring advantages: faster fills, higher-quality candidates, skill verification, and access to a broader talent pool. Revenue comes from placement fees paid by the hiring company. What makes it strategically distinct: it is the only business that directly affects the quality of another company's most important asset — its workforce. A Recruitment Agency doesn't make things or move things — it makes other companies' people better.

**Why It Exists in the Larva Economy:**
The NPC vs real player employee distinction is a core economic driver. Companies need skilled workers but can't easily evaluate candidate quality. A restaurant owner looking for a Premium-level Cook doesn't know whether the applicant's stated skill level translates to actual performance. A growing delivery company needs five Drivers by next tick or it loses contracts — but the open market might not surface candidates fast enough. The Recruitment Agency solves two problems: **speed** (fill positions faster) and **quality verification** (confirm candidate skill before placement).

**Supply Chain Position:**
```
Available Workers (NPC pool + real players seeking jobs)
      ↓ (sourced and screened by agency)
Recruitment Agency
      ↓ (places candidates, collects placement fee)
Hiring Company (any sector, any company type)
      ↓ (receives employee with verified skills)
Better company performance → revenue → agency reputation grows
```

No physical goods. No logistics dependency. Pure labor market service.

**How Recruitment Works (Core Mechanic):**

**Without a Recruitment Agency (base system):**
- Company posts a job listing with salary and role
- NPC candidates appear from a general pool — quality is random within a range based on salary offered and country labor cost modifier
- Real player candidates apply if they see the listing and choose to apply
- Hiring takes 1–2 ticks for the position to be filled
- No skill verification — employer learns actual employee quality after hiring

**With a Recruitment Agency:**
- Company contracts the agency for a specific role with requirements
- Agency's Recruiter draws from an **enhanced candidate pool** — higher average quality candidates, weighted by Recruiter skill
- **Skill verification:** Agency's Assessor evaluates candidates before placement. Client sees verified skill levels, not just self-reported. Accuracy depends on Assessor skill
- **Speed:** Positions fill in the same tick the contract is placed (vs 1–2 tick delay without agency)
- **Real player sourcing:** Agency's network includes real player jobseekers who have registered with the agency — access to candidates the hiring company wouldn't see through direct listings alone
- **Placement guarantee:** If a placed employee underperforms below the verified skill threshold within a set number of ticks, the agency replaces them at no additional cost. Duration and terms of guarantee depend on contract tier

**Candidate Quality Enhancement:**
```
Base Candidate Quality = Country Labor Pool × Salary Offered × Random Variance
Agency Candidate Quality = Base × (1 + Recruiter Skill Bonus) × Pool Depth Modifier
```
- **Recruiter Skill Bonus:** 10–30% improvement over base pool quality, based on Recruiter skill level
- **Pool Depth Modifier:** Agencies that have been operating longer and have more registered jobseekers get a wider selection — first-mover advantage in the labor market
- The agency doesn't create better workers — it finds the better workers that already exist and matches them more efficiently

**Service Tiers:**

| Tier | What Client Gets | Fee Structure |
|------|-----------------|---------------|
| Standard Placement | Same-tick fill, verified skill report, basic candidate matching | One-time placement fee (% of first tick's salary) |
| Priority Placement | Same-tick fill, top-tier candidates prioritized, placement guarantee (4 ticks), Assessor-verified detailed skill report | Higher placement fee (% of first 2 ticks' salary) |
| Executive Search | For Manager, Director, and specialty roles (Architect, Pharmacist, Partner). Exhaustive search including real player outreach. Highest quality candidates. Extended guarantee (8 ticks) | Premium fee (% of first 4 ticks' salary) |
| Retainer | Ongoing relationship — agency fills all open positions automatically as they arise. Priority access, guaranteed fill speed, volume discount | Per-tick retainer fee + reduced per-placement fee |

**Employee Roles:**

| Role | Function |
|------|----------|
| Recruiter | Core revenue role. Sources candidates from the labor pool. Skill determines candidate quality bonus and fill speed. Each Recruiter handles 3–5 placements per tick. Higher skill = access to better candidates from the pool. NPC Recruiters function but produce baseline-quality matches only |
| Assessor | Evaluates candidate skills before placement. Skill determines accuracy of the skill verification report. Low-skill Assessor = skill report has wider error margins — a candidate reported as "skill 70" might actually be 55 or 85. High-skill Assessor = report accurate within 5%. The role that makes the agency trustworthy |
| Account Manager | Manages client relationships. Skill affects client retention and upselling (Standard → Priority → Retainer). Only meaningful when filled by a real player — NPC maintains existing contracts but cannot acquire new clients or negotiate upgrades |
| Director | Only meaningful as a real player. Sets pricing, approves retainer contracts, manages recruiter assignments, handles executive searches personally. NPC here = owner manages everything |

**The Assessor is the trust mechanic.** Two agencies place identical candidates — but one provides a verified skill report accurate to within 5%, the other within 25%. The company that hires through the accurate agency knows exactly what they're getting. Inaccurate reports lead to mismatched hires, underperformance, and the hiring company blaming the agency. Assessor quality is what separates a premium agency from a body shop.

**Operating Costs (per tick):**
- Employee salaries (Assessors command mid-to-high professional wages — specialized skill evaluation role)
- Office rent (moderate commercial space — client-facing, needs professional appearance)
- Candidate sourcing costs (small per-candidate cost to maintain the pool — database, outreach, screening infrastructure)
- Utilities and equipment maintenance (minimal)
- Placement guarantee cost (if a placed employee underperforms and must be replaced — agency covers the replacement, eating into margin)

**Revenue Model:**
- **Placement fee:** Percentage of the placed employee's salary, paid by the hiring company. Typical range 50–150% of one tick's salary per placement (varies by tier)
- **Retainer fee:** Per-tick fixed fee for ongoing priority access. Lower per-placement cost but committed recurring revenue
- **Executive search premium:** Highest per-placement fee, lowest volume. Specialty roles command 200–300% of one tick's salary
- Owner controls: fee percentages, tier offerings, client selection, Recruiter assignment
- Market determines: hiring volume (driven by business creation and expansion across all sectors), competition from direct hiring

**Key Owner Decisions:**
- **Volume vs premium:** High volume of Standard placements (thin margins, many clients, commoditized) vs focused Executive Search (fat margins, few clients, reputation-dependent)?
- **Assessor investment:** High-skill Assessor (expensive salary, accurate reports, client trust, competitive moat) vs NPC Assessor (cheap, inaccurate reports, clients can't trust the data)?
- **Guarantee aggressiveness:** Long guarantee periods attract clients but expose the agency to replacement costs. Short guarantees are cheaper but less competitive
- **Retainer balance:** More retainer clients = predictable revenue but less capacity for high-margin one-off Executive Searches
- **Real player pool building:** Actively recruiting real player jobseekers to register with the agency costs time and offers (higher commission to players who find jobs through you?) but creates a talent network that competitors can't replicate
- **Country specialization:** Some countries have expensive labor (1.4x modifier) — premium placements matter more because hiring mistakes are costlier. Other countries have cheap labor (0.7x) — volume matters more because individual hires cost less

**Capacity & Scaling:**
- Staff-limited — each Recruiter handles 3–5 placements per tick
- Assessor is the quality bottleneck: more placements than Assessors can evaluate → unverified placements → quality drops → reputation drops
- The real player talent pool is the long-term moat — agencies that build a network of registered jobseekers have access that new competitors don't
- Branch expansion into new countries taps new labor markets with different dynamics
- First Recruitment Agency in a country builds the talent pool first — significant first-mover advantage

**Cross-Sector Dependencies:**
- All sectors — every company type needs employees, making every company a potential client
- Construction (4A) — high demand for specialized roles (Architect, Equipment Operator, Site Foreman). Construction booms create hiring surges
- Finance (Sector 5) — specialized roles (Loan Officer, Actuary, Fund Manager) are hard to fill. Executive Search territory
- Food & Hospitality — high employee turnover (low-skill roles churn frequently). Volume placement opportunity
- Retail — seasonal demand (fashion cycle shifts in Clothing Stores trigger restaffing)
- Legal Firm (6A) — natural referral partner. Legal Firm needs a skilled Lawyer? Contacts the Recruitment Agency. Recruitment Agency client has an employment dispute? Refers to the Legal Firm
- Central Corporation — operates its own basic hiring but cannot match agency quality. Players who want better employees than Central Corp provides go to Recruitment Agencies
- Country System — labor cost modifiers directly affect placement fees (which are salary-based) and candidate pool quality

**Market Dynamics:**
- **Oversaturated:** Placement fee compression. Agencies compete on Assessor accuracy, fill speed, and talent pool depth. Volume players undercut on Standard placements; premium players defend Executive Search margins. Agencies with real player networks are defensible
- **Undersaturated:** All hiring through direct listings (slow, unverified, random quality). First agency captures pent-up demand — every company owner frustrated by bad hires becomes a client
- **Natural cycle:** Hiring demand tracks business creation and expansion. Economic booms = new companies = massive hiring demand = agency revenue spikes. Downturns = layoffs, reduced hiring, agencies compete for shrinking demand. **Counter-cyclical opportunity:** downturn creates a pool of displaced skilled workers — agencies that maintain relationships with these workers place them fast when recovery begins
- **Country dynamics:** High labor cost countries = hiring mistakes are expensive = clients pay premium for accurate placement. Low labor cost countries = hiring is cheap = clients less willing to pay agency fees. Manufacturing and construction countries = specialized role demand

**Failure Points:**
- **Assessor credibility collapse:** Inaccurate skill reports → clients hire based on faulty data → employees underperform → clients blame agency → cancellations → forced to offer free replacements (guarantee cost) → margin destruction → reputation spiral
- **Talent pool attrition:** Real player jobseekers stop registering because the agency places them in bad fits or takes too long. Pool shrinks → candidate quality drops → clients notice → leave for competitors
- **Guarantee overexposure:** Aggressive guarantee terms + string of underperforming placements → replacement costs stack → operating at a loss → forced to weaken guarantees → less competitive
- **Volume trap:** Too many Standard placements, no investment in Assessor quality or Executive Search capability → commoditized, no margin, any new competitor undercuts you
- **Key account dependency:** 50% of revenue from two retainer clients → one client folds → revenue halves instantly. Concentration risk identical to Property Management

**Emergent Gameplay:**
- **The talent cartel:** A Recruitment Agency with the deepest real player pool in a country becomes a labor gatekeeper. Companies that don't use the agency get second-tier candidates. The agency owner decides which companies get the best workers — not explicitly, but through priority assignment. Rival business owners may pay premium retainer fees not because they love the service but because they fear being cut off from top talent
- **The vertical staffing play:** A player who owns a Recruitment Agency AND companies in other sectors (a restaurant, a delivery company) uses the agency to cherry-pick the best candidates for their own businesses first, then passes the rest to external clients. Not against any rule — the agency is just doing its job — but competitors notice they never get the top candidates. Reputation risk if discovered, but the competitive advantage is enormous
- **Counter-cyclical talent banking:** During an economic downturn, skilled workers are laid off and desperate for placement. A smart agency owner offers reduced-fee placements to keep these workers employed (and registered in the pool). When the economy recovers, this agency has the deepest bench of proven, skilled workers and can charge premium rates. Patient capital strategy

**Abuse & Exploit Analysis:**
- **Placement churn:** Agency places a worker, collects the fee, then poaches the worker back and places them elsewhere — double-dipping on placement fees for the same employee. **Counter:** Placement guarantee period means the agency must replace at no cost if the employee leaves within the guarantee window. Churning within the guarantee costs the agency money, not the client. Churning after the guarantee is just normal labor market activity — the agency earned the re-placement fee legitimately
- **Self-placement loop:** Player registers alt accounts as jobseekers, places them through their own agency, collects fees from hiring companies for fake employees who quit immediately. **Counter:** One-account-per-identity rule prevents alt creation. Placement guarantee forces free replacement. Repeated early departures from agency-placed employees flag the agency for investigation
- **Inflated skill reports:** Agency overstates candidate skills to justify higher placement fees. **Counter:** Assessed skills vs actual performance is tracked. Systematic overstatement is visible in the agency's placement accuracy stats (public). Clients see the accuracy record before contracting. Market self-corrects — inaccurate agencies lose clients

**Status:** ✅ Design Complete

---

## Sector 6 Summary

| Company Type | Revenue Model | Volatility | Key Dependency |
|---|---|---|---|
| Legal Firm | Per-case fee + success bonus + transaction processing | Medium-High (case outcomes vary, M&A activity fluctuates) | Lawyer skill + case volume + win rate reputation |
| Recruitment Agency | Placement fee (% of salary) + retainer contracts | Medium (tracks hiring cycles across all sectors) | Assessor accuracy + talent pool depth + client retention |

**Cross-referral dynamic:** Legal Firms and Recruitment Agencies are natural partners — Legal needs skilled Lawyers (Executive Search), Recruitment clients need dispute resolution (contract enforcement). A player owning both creates a Professional Services hub that captures value on both sides of the labor and legal market.

**Sector-wide characteristic:** Both company types are pure expertise businesses with the lowest capital requirements in the game (no inventory, no equipment beyond office basics, no logistics) but the highest dependency on employee quality. A Legal Firm with NPC Lawyers is barely functional. A Recruitment Agency with NPC Assessors is unreliable. This sector rewards players who invest in skilled real-player employees more than any other — it is the sector where the NPC vs player gap matters most.


---

-e 
---

*Last updated: May 25, 2026 — Split from master document*
