# Project Larva — Economy Balance & Inflation Control (Complete)

> **Status:** ✅ Design Complete
> **Parent document:** See `larva_master.md` for core systems, cross-sector rules, and progress tracker

---

## System Overview

Economy balance in Larva is managed through four interconnected systems: a hybrid currency faucet that fades as the player economy grows, a tiered transaction fee sink that scales with activity, a progressive tax system that redistributes wealth from top to bottom, and a set of pre-announced emergency levers that activate automatically under abnormal conditions.

The guiding principle: **no hidden levers, no manual overrides, no secret adjustments.** Every mechanism is visible on the public economic dashboard. Players can verify the math at any time.

---

## 1. Currency Creation — The CC Injection Faucet

### How Currency Enters the Economy

There is one source of new game currency: the **Central Corporation injection mechanism.** There is no player buy-in, no real-money exchange, and no exchange rate. Players cannot purchase in-game currency with real money — the currency (₳) is a closed game currency that only enters the economy through the Central Corporation.

**Central Corporation Injection:** The Central Corporation receives a tick-based currency injection to fund its operations (NPC salaries, inventory, baseline services). This injection scales inversely with the player economy's size, closing as the player economy grows.

### Central Corporation Injection Formula

```
Injection = Base Rate × (1 - Player Economy Share)
```

- **Base Rate** = currency needed for the Central Corporation to operate at full capacity with zero players (total salary obligations + operating costs across all 18 countries)
- **Player Economy Share** = percentage of total economic activity handled by player-owned businesses vs Central Corporation businesses

### Injection Behavior Over Time

| Phase | Player Economy Share | Injection Level | Description |
|-------|---------------------|----------------|-------------|
| Launch (0 players) | 0% | 100% of Base Rate | CC is the entire economy. Full faucet |
| Early game (~50 players) | 15–20% | 80–85% of Base Rate | Players entering, faucet closing |
| Growth phase (~500 players) | 50–60% | 40–50% of Base Rate | Player economy becoming dominant |
| Mature (~5,000+ players) | 85–95% | 5–15% of Base Rate | CC running skeleton operations |
| Theoretical full saturation | 100% | 0% | CC is a dormant fallback |

### Injection as a Developer Operating Cost

The CC injection is funded as a developer operational cost — equivalent to running the NPC-driven economy that bootstraps the game. Currency injected is real in-game currency entering circulation; it is not redeemable by players for real money and carries no exchange obligation. The developer is simply paying the cost of running the CC, the same way a game studio funds its always-on game world.

### Central Corporation Surplus Destruction

When players purchase goods/services from the Central Corporation, currency returns to its operating pool. If CC revenue exceeds its operating costs + injection needs, the surplus is **destroyed** (removed from circulation). This makes the Central Corporation a natural net sink as the economy matures.

### Player-Visible Signal

The public economic dashboard shows the Central Corporation injection amount each tick. Players can watch the injection percentage decline as the player economy grows — a visible signal of economic maturity.

---

## 2. Currency Destruction — Tiered Transaction Fee Sink

### Core Mechanic

Every financial transaction in the game incurs a fee. The fee is automatically deducted and the collected currency is **permanently destroyed** (removed from circulation). This is the economy's primary deflation engine.

### Fee Model — Embedded (Seller-Side)

The buyer always pays the listed price. The seller receives the listed price minus the fee. The fee appears as a line item in the seller's transaction log but never confronts the buyer at checkout. This mirrors real-world payment processor behavior.

### Three Fee Tiers

**Tier 1 — Business Operations (2.5% at launch)**

Applied to:
- B2B purchase orders (raw materials, wholesale goods, parts, supplies)
- Salary payments (both NPC and player employee wages)
- Logistics contracts (delivery and freight fees)
- Rent payments (commercial and residential)
- Utility and operating cost payments
- Insurance premium payments
- IT/Software/Analytics subscription payments
- Corporate training contracts
- Equipment purchases

Highest-volume tier. Every business fires multiple Tier 1 transactions per tick by operating. Shows up as a line item in the company P&L.

**Tier 2 — Consumer Transactions (1.5% at launch)**

Applied to:
- All B2C retail purchases (food, clothing, electronics, pharmacy)
- Restaurant and café orders
- Player personal services (legal consultations, training enrollment fees)
- Player needs spending (food, housing-related purchases)
- Marketing purchases made with game currency

Players see these directly on every purchase. Low enough to not feel punitive, high enough to matter at aggregate volume.

**Tier 3 — Financial Transactions (0.75% at launch)**

Applied to:
- Stock market trades (buy and sell)
- Investment fund purchases and redemptions
- Player-to-player direct payments
- Loan origination (one-time fee at disbursement)
- Bank deposit withdrawals
- Dividend payouts

Lowest rate. Keeps financial markets viable — a round-trip stock trade costs 1.5% total, meaning traders need >1.5% price movement to profit. Naturally dampens speculative volatility.

### Developer Fee Rate Control — Gentle Correction Model

The developer can adjust all three tier rates through an admin dashboard, subject to three constraints:

**Hard Bounds (immutable, not adjustable):**

| Tier | Floor | Ceiling | Launch Rate |
|------|-------|---------|-------------|
| Tier 1 — Business Operations | 1.0% | 4.0% | 2.5% |
| Tier 2 — Consumer Transactions | 0.5% | 3.0% | 1.5% |
| Tier 3 — Financial Transactions | 0.25% | 1.5% | 0.75% |

**Public Visibility:** Every rate change is displayed on the public economic dashboard — current rates, historical chart of all changes, and hard bounds.

**7-Day Notice Period:** All rate changes take effect after 28 ticks (7 real days). When queued, the dashboard immediately shows the pending change and effective date. No emergency fast-track — every change follows the same process.

### Estimated Sink Volume (1,000 active players)

| Tier | Est. Transactions/Tick | Est. Avg Value | Fee Rate | Currency Destroyed/Tick |
|------|----------------------|---------------|----------|----------------------|
| Tier 1 | ~5,000 | ~500 | 2.5% | ~62,500 |
| Tier 2 | ~3,000 | ~100 | 1.5% | ~4,500 |
| Tier 3 | ~1,000 | ~2,000 | 0.75% | ~15,000 |
| **Total** | | | | **~82,000/tick** |

Per real day (4 ticks): ~328,000 currency destroyed. Scales proportionally with player count and economic activity.

---

## 3. NPC Salary Recycling — Country Consumer Spending Pool

### The Problem

Every business employs NPCs. NPCs receive salaries — real currency leaving company accounts. Without a recycling mechanism, NPC salaries either vanish (hidden deflation) or accumulate in phantom wallets (currency leak).

### The Solution

NPC salaries are pooled per country per tick into a **Country Consumer Spending Pool** that flows back to businesses as background customer revenue.

### Flow Per Tick

```
Step 1: Every company pays NPC salaries (deducted from company balance)
Step 2: Transaction fee (Tier 1, 2.5%) is destroyed
Step 3: Remaining 97.5% flows into the Country Consumer Spending Pool
Step 4: Pool is distributed to businesses as "Background Customer Revenue"
```

The pool does NOT accumulate — whatever flows in during a tick is fully distributed that same tick. No balance carries over.

### Spending Category Distribution

| Category | % of Pool | Receiving Businesses |
|----------|-----------|---------------------|
| Food & Dining | 30% | Restaurants, Cafés, Supermarkets |
| Housing & Utilities | 25% | Property Management (rent), utilities |
| Retail Goods | 20% | General Store, Clothing Store, Electronics Store, Pharmacy |
| Transportation | 10% | Delivery Companies (personal transport services) |
| Services | 10% | Legal, Banking (deposits), Insurance (personal policies) |
| Savings (destroyed) | 5% | Permanently removed from circulation |

The 5% savings leakage is a deliberate secondary sink. Combined with the 2.5% transaction fee on salary payment, approximately **7.4% of all NPC salaries** are permanently removed from circulation each tick.

### Distribution Weighting Within Categories

Each category's allocation is distributed across eligible businesses based on:

| Factor | Weight | Effect |
|--------|--------|--------|
| Quality Score | 50% | Higher quality tier → larger share |
| Pricing Competitiveness | 30% | Below category average price → larger share |
| Marketing Boost | 20% | Active marketing → larger share (capped at 20% influence) |

### Player-Facing Display

Business owners see "Background Customer Revenue" as a distinct line item on their P&L, separate from real player customer revenue. Transparency into how much income comes from NPC-driven demand vs actual players.

### Technical Efficiency

One aggregation query per country per tick:

```
SUM(npc_salaries) per country → apply fee → split by category → 
weighted distribution per category → credit businesses
```

~100 database operations total for all 18 countries. Trivial computational cost.

---

## 4. Progressive Tax System — Wealth Redistribution

### Replacing Flat Tax

The country base tax rate (5–25%) is no longer applied as a flat percentage. It becomes the **base rate** for a progressive bracket system where wealthier players pay higher effective rates.

### Net Worth Calculation (Per Tick)

```
Net Worth = Cash + Company Valuations + Stock Portfolio Value 
            + Real Estate Owned + Outstanding Loans Owed TO Player 
            - Debts Owed BY Player
```

### Bracket Structure (Relative to Country Median Net Worth)

| Bracket | Net Worth Range | Tax Rate Multiplier | Example (10% base) | Example (25% base) |
|---------|----------------|--------------------|--------------------|-------------------|
| 1 — Starting Out | Below 0.5× Median | 0.0× (exempt) | 0% | 0% |
| 2 — Establishing | 0.5× to 1.5× Median | 0.75× | 7.5% | 18.75% |
| 3 — Comfortable | 1.5× to 5× Median | 1.0× | 10% | 25% |
| 4 — Wealthy | 5× to 20× Median | 1.5× | 15% | 37.5% |
| 5 — Elite | 20× to 100× Median | 2.0× | 20% | 40% (capped) |
| 6 — Tycoon | Above 100× Median | 2.5× | 25% | 40% (capped) |

### Hard Tax Ceiling

No effective tax rate can exceed **40%** regardless of bracket or country base rate. This prevents confiscatory taxation in high-base-rate countries.

In high-tax countries, Elite and Tycoon brackets converge at the 40% cap — no additional penalty for growing larger past the Elite threshold. In low-tax countries, every bracket remains distinct. Different strategic texture per country.

### Median Smoothing

The median net worth used for bracket calculation is a **rolling average of the last 28 ticks** (7 real days). This dampens tick-to-tick volatility.

**Cold-start rule:** If a country has fewer than 20 players, brackets default to fixed absolute values set at launch until the population crosses 20.

### Tax Revenue Redistribution

| Destination | Share | Purpose |
|-------------|-------|---------|
| Infrastructure Fund | 40% | Improves country infrastructure rating. Better logistics, cheaper transport |
| New Player Stimulus | 30% | Distributed equally among all Bracket 1 players. The financial safety net |
| Establishing Player Support | 20% | Distributed among Bracket 2 players. Smaller per-player amount, helps new businesses |
| Country Development Reserve | 10% | Pooled buffer for country-level improvements — new commercial zones, resource efficiency, trade surcharge reductions |

### The Redistribution Cycle

```
Wealthy players earn profits
      ↓
Progressive tax takes higher share
      ↓
Tax revenue splits into four streams
      ↓
New/poor players receive stimulus → buy food, pay rent, take courses
      ↓
That spending becomes revenue for businesses (including wealthy players' businesses)
      ↓
Cycle continues — wealth flows down, spending flows back up
```

The wealthy fund their own future competitors. The system self-perpetuates.

### Developer Adjustability — Gentle Correction Model

All tax parameters are adjustable via admin dashboard with 7-day notice period, public visibility, and hard bounds:

**Bracket Ceiling Bounds:**

| Parameter | Floor | Ceiling | Launch Value |
|-----------|-------|---------|-------------|
| Bracket 1 ceiling | 0.25× Median | 1.0× Median | 0.5× Median |
| Bracket 2 ceiling | 1.0× Median | 3.0× Median | 1.5× Median |
| Bracket 3 ceiling | 3.0× Median | 10.0× Median | 5.0× Median |
| Bracket 4 ceiling | 10.0× Median | 50.0× Median | 20.0× Median |
| Bracket 5 ceiling | 50.0× Median | 200.0× Median | 100.0× Median |

**Rate Multiplier Bounds:**

| Parameter | Floor | Ceiling | Launch Value |
|-----------|-------|---------|-------------|
| Bracket 1 multiplier | 0.0× | 0.0× | 0.0× (always exempt — immutable) |
| Bracket 2 multiplier | 0.5× | 1.0× | 0.75× |
| Bracket 3 multiplier | 0.75× | 1.25× | 1.0× |
| Bracket 4 multiplier | 1.0× | 2.0× | 1.5× |
| Bracket 5 multiplier | 1.25× | 2.5× | 2.0× |
| Bracket 6 multiplier | 1.5× | 3.0× | 2.5× |
| Hard tax ceiling | 30% | 50% | 40% |

**Redistribution Share Bounds:**

| Parameter | Floor | Ceiling | Launch Value |
|-----------|-------|---------|-------------|
| Infrastructure Fund | 20% | 60% | 40% |
| New Player Stimulus | 15% | 50% | 30% |
| Establishing Support | 10% | 30% | 20% |
| Country Development Reserve | 5% | 20% | 10% |

Redistribution shares must always sum to 100%. Admin dashboard enforces this constraint.

---

## 5. Growth Scaling

### Self-Scaling Systems

The economy's core systems are designed to scale automatically without manual intervention:

| System | Scaling Mechanism |
|--------|------------------|
| Transaction fee sink | Volume-proportional — more activity = more currency destroyed |
| CC injection faucet | Inverse to Player Economy Share — fades as players grow |
| Tax brackets | Relative to median net worth — brackets grow with the economy |
| NPC consumer pool | Proportional to total NPC employment — scales with business count |

### Early-Game Cold Start Handling

**Median smoothing:** 28-tick rolling average prevents volatile bracket swings from small sample sizes.

**Population threshold:** Countries with fewer than 20 players use fixed absolute bracket values until the population crosses 20, then switch to median-relative calculation.

**Central Corporation full operations:** At launch, the CC runs everything at full capacity across all 18 countries. The injection faucet is 100% open. Players enter a functioning economy, not an empty sandbox.

### No Manual Scaling Required

No developer intervention is needed as the game grows from 100 to 100,000 players. Every system self-adjusts through its built-in formulas. The developer's only active tools are the gentle correction levers on fee rates and tax parameters — and those are for fine-tuning, not structural scaling.

---

## 6. Emergency Levers

Four pre-announced, publicly visible mechanisms that activate under abnormal economic conditions. All visible on the public economic dashboard. No secret levers exist.

### Lever 1 — Currency Injection Throttle

**Trigger:** Currency in circulation grows by more than 3% in a single tick during a non-event period (i.e., not caused by a Tier 3 event that justifiably expands spending).

**Action:** Central Corporation injection pauses entirely for 2 ticks, then resumes at 50% of the scheduled rate for a further 3 ticks before returning to normal. Limits the faucet when circulation is already growing too fast.

**Activation:** Automatic, formula-based. No developer action required.

**Dashboard display:** "CC injection throttled — elevated currency circulation growth detected. Resuming in X ticks."

**Purpose:** Prevents the CC faucet from worsening inflation when circulation is already expanding rapidly.

### Lever 2 — Transaction Fee Auto-Escalator

**Trigger:** Total currency in circulation grows by more than 5% in a single tick.

**Action:** All three fee tiers temporarily increase by 0.5 percentage points (still subject to hard ceilings). Accelerates the sink during abnormal inflation.

**Reversion:** Automatically reverts once circulation growth returns to normal range (<5% per tick) for 7 consecutive ticks.

**Activation:** Automatic, formula-based. No developer action required.

**Dashboard display:** "Temporary fee escalation active — elevated circulation growth detected. Reversion in X ticks."

### Lever 3 — Country Population Surge Buffer

**Trigger:** A country's player count increases by more than 50% within 7 real days.

**Action:** Central Corporation in that country temporarily expands operations — more NPCs hired, increased inventory, additional baseline services. Funded from CC's existing pool or injection.

**Reversion:** Scales back as player businesses fill the demand.

**Activation:** Automatic, formula-based. No developer action required.

**Dashboard display (country-level):** "Central Corporation surge response active — elevated demand detected."

### Lever 4 — Developer Currency Burn (Manual)

**Trigger:** Developer discretion — the only manual lever.

**Action:** Developer directly destroys a fixed quantity of game currency from the Central Corporation's operating pool. No real money involved. This permanently reduces currency in circulation — a targeted deflationary intervention for extreme inflation scenarios that the automatic levers have not resolved.

**Cost:** The CC operating pool shrinks. If the burn is large, the CC may temporarily reduce services (fewer NPC employees, thinner inventory). Visible tradeoff.

**Activation:** Manual. Requires developer to make a deliberate decision with a visible consequence.

**Dashboard display:** "Developer currency burn executed: ₳X destroyed. Circulation reduced by X%. Reason: [stated reason]."

### What Does NOT Exist

- No ability to freeze player accounts or transactions
- No ability to manually adjust any exchange rate (no exchange rate exists)
- No ability to confiscate player currency
- No ability to roll back transactions
- No secret levers not visible on the dashboard
- No emergency overrides on fee rates or tax parameters

Catastrophic exploits (currency duplication, etc.) are handled through code fixes and the public support process using the audit trail — not through hidden economic levers.

---

## System Interaction Summary

```
FAUCETS (Currency Creation)               SINKS (Currency Destruction)
─────────────────────────                  ──────────────────────────
Central Corp injection (scales down)       Transaction fees (Tier 1/2/3)
                                           Central Bank regulatory fee (2%/tick)
                                           Loan interest to Central Bank
                                           Central Corp surplus destruction
                                           NPC savings leakage (5% of pool)
                                           Company sale fees

           REDISTRIBUTION (Currency Movement, Not Destruction)
           ──────────────────────────────────────────────────
           Progressive taxes → Infrastructure + Stimulus + Support
           NPC consumer pool → Background revenue to businesses
           Tax returns → Bracket 1 and Bracket 2 players
```

The system is designed so that **sinks slightly exceed faucets** in a healthy economy, creating mild natural deflation. Currency in circulation trends slowly downward relative to economic activity as the economy matures — meaning the purchasing power of held currency increases gradually. Players who hold currency are rewarded for good financial discipline. This aligns developer and player incentives: a healthy, growing economy benefits everyone.

---

*Last updated: May 27, 2026 — Synchronized with monetization overhaul: removed Player Buy-In faucet, reserve backing requirement, and exchange rate references. Lever 1 trigger updated to circulation growth metric. Lever 4 replaced with Developer Currency Burn. System Interaction Summary updated.*
