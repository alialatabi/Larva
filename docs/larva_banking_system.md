# Project Larva — Banking System Details (Complete)

> **Status:** ✅ Design Complete  
> **Parent document:** See `larva_master.md` for core systems, cross-sector rules, and progress tracker

---

## System Overview

The Banking System defines how money is held, moved, lent, and lost in the Larva economy. It sits underneath every other system — companies need accounts, players need wallets, loans fund expansion, deposits create capital pools, and bankruptcy is the final consequence of sustained failure.

Ten subsystems work together: wallet structure, credit scoring, Central Bank lending, private bank loan mechanics, deposit insurance, transfers and payments, bankruptcy, savings and interest, Central Bank rate adjustments, and the player-facing banking dashboard.

This document covers the **system-level mechanics** — how banking works. For the **Private Bank as a company type** (employees, operations, market dynamics), see `larva_sector_5_finance.md`.

---

## 1. Player Wallet Structure

Every player has two distinct money containers:

**Personal Wallet** — the player's own money. Receives salary from employment, dividends from stocks, loan disbursements, proceeds from selling companies or assets. Used for personal spending (food, housing, training fees, retail purchases, stock investments). This is what the player sees as "my balance."

**Company Account** — one per company owned. Receives customer revenue, B2B payments, loan disbursements (business loans). Pays employee salaries, supplier invoices, rent, operating costs, loan repayments. The owner cannot freely transfer from company account to personal wallet — withdrawals are subject to the **owner draw mechanic.**

### Owner Draw Mechanic

The owner can withdraw profit from a company account to their personal wallet, but only up to the company's **net profit from the previous tick.** This prevents hollowing out a company by draining its operating capital. The draw is subject to Tier 1 transaction fee (2.5%). If the company has outstanding loans, the draw is further capped at 50% of net profit until loans are repaid. If the company is publicly listed, owner draws are visible on the company's stock page — investors see exactly how much the founder is extracting.

**Why this matters:** Without the draw mechanic, players could take a business loan, immediately transfer the money to their personal wallet, and walk away. The draw restriction forces business loans to stay in the business.

---

## 2. Credit Score System

Every player has a **Credit Score** from 0 to 1000. It is visible to any bank owner evaluating a loan application. Other players cannot see each other's scores.

**Starting Score:** 500 (neutral — no history)

### What Moves the Score Up

| Action | Score Change | Notes |
|--------|-------------|-------|
| On-time loan payment | +5 per payment | Caps at +5/tick regardless of number of loans |
| Full loan repayment | +20 (one-time) | Completing any loan term |
| Consistent employment (10+ ticks) | +10 (one-time, repeatable every 10 ticks) | Proof of income stability |
| Company profitable for 10+ consecutive ticks | +15 (one-time, repeatable) | Business viability signal |
| Deposit history (maintaining balance at a bank for 20+ ticks) | +5 (one-time) | Shows financial stability |

### What Moves the Score Down

| Action | Score Change | Notes |
|--------|-------------|-------|
| Late loan payment (1 tick overdue) | -10 | Per occurrence |
| Missed loan payment (2 ticks overdue) | -25 | Per occurrence |
| Loan default (3 ticks overdue) | -100 | Devastating. Recovery takes 40+ ticks of clean behavior |
| Bankruptcy declared | -200 | Floor of 100 — score cannot drop below 100 |
| Company insolvency (as owner) | -50 | Even if personal loans are current |
| Fired from employment for cause | -5 | Minor but cumulative |

### Score Decay

Negative events decay at a rate of +2 per tick after 20 ticks of clean behavior. A player who defaults (dropping 100 points) and then behaves perfectly for 50 ticks recovers 60 points from decay alone, plus whatever positive actions they take. Full recovery from a single default takes roughly 30–40 ticks of clean behavior. Recovery from bankruptcy takes 60–80 ticks.

### Score Brackets

| Bracket | Score Range | Central Bank Access | Private Bank Signal |
|---------|------------|--------------------|--------------------|
| Excellent | 800–1000 | Lowest CB rate (10%), highest loan limit | Green flag — premium borrower |
| Good | 650–799 | Standard CB rate (12%), standard limit | Normal processing |
| Fair | 450–649 | CB rate +2% (14%), reduced limit | Caution — higher rate or collateral required |
| Poor | 250–449 | CB rate +4% (16%), minimal limit | Red flag — most private banks decline |
| Critical | 100–249 | No Central Bank lending | Effectively locked out until recovery |

**Anti-gaming:** Score only changes from real economic events processed by the tick system. No way to manufacture score increases without real activity over real time.

---

## 3. Central Bank Direct Lending

The Central Bank is the lender of last resort for players. Always available, always slower, always more expensive than a good private bank. Its purpose is to ensure every player has access to capital — the floor, not the ceiling.

### Loan Products

| Product | Amount Range | Term | Interest Rate | Approval |
|---------|-------------|------|--------------|----------|
| Micro Loan | 500–5,000 | 10 ticks | Credit bracket rate | Automatic (if score ≥ 250) |
| Personal Loan | 5,001–50,000 | 20 ticks | Credit bracket rate | Automatic (if score ≥ 450) |
| Business Startup Loan | 10,000–100,000 | 40 ticks | Credit bracket rate + 1% | Automatic (if score ≥ 450 + valid company) |
| Business Expansion Loan | 50,000–500,000 | 60 ticks | Credit bracket rate + 2% | Manual review (5-tick delay) |

### Approval Rules

- Automatic loans process within the same tick. No player interaction beyond submitting the application.
- Manual review loans take 5 ticks. The Central Bank is slow — this is intentional. Private banks that approve faster have a real competitive advantage.
- Maximum total outstanding Central Bank debt per player: 2× their total net worth (assets + cash − existing debt). A player with net worth of 50,000 can owe up to 100,000 to the Central Bank.
- One active loan per product type. A player can have one Micro Loan AND one Personal Loan simultaneously, but not two Personal Loans.

### Repayment

- Equal installments per tick across the loan term
- Payment = (Principal + Total Interest) ÷ Term Length
- Interest is simple, not compound — calculated once at origination and spread across the term
- Payments auto-deducted from personal wallet (personal loans) or company account (business loans) each tick
- If insufficient funds at tick processing: payment missed, late fee applied, credit score hit

### Central Bank Interest as a Sink

All interest paid to the Central Bank is permanently destroyed (removed from circulation). This is a deflationary mechanism — one of the economy's primary currency sinks. It is not developer revenue; it is an economic stabilization function that keeps the Central Bank from being a pure faucet when it lends.

---

## 4. Private Bank Loan Mechanics

Private banks set their own terms within system constraints. This section defines what's universal across all private banks.

**Loan term bounds:** Minimum 5 ticks, maximum 80 ticks. The bank owner sets the term for each loan within these bounds.

**Interest calculation:** Same as Central Bank — simple interest, calculated at origination, spread across the term in equal installments. No compound interest anywhere in the game's lending system. This keeps the math transparent for players and prevents exponential debt spirals.

### Repayment Processing Order Per Tick

1. Central Bank loans (always first priority — cannot be deferred)
2. Private bank loans (in order of origination — oldest first)
3. If a player has insufficient funds to cover all payments, the earliest-originated loan is paid first. Later loans miss their payment.

### Collateral System

Private bank owners can require collateral on loans. Collateral options:

- **Company equity:** Shares in the borrower's company
- **Real estate:** Property the borrower owns
- **Liquid assets:** Frozen portion of the borrower's personal wallet

Collateral is locked — the borrower cannot sell, transfer, or withdraw collateralized assets until the loan is repaid or the collateral is seized.

### Early Repayment

Players can repay any loan early at any time. No prepayment penalty. Remaining interest is forgiven — the borrower pays only the interest accrued up to the repayment tick. This rewards players who manage cash well and slightly reduces the bank's expected interest income.

### Loan Origination Fee

0.75% of the loan amount, paid by the borrower at disbursement, subject to Tier 3 transaction fee. Split: the origination fee goes to the bank. The transaction fee is destroyed.

---

## 5. Deposit Insurance

### Insurance Cap

50,000 game currency per player per bank. A player with 80,000 deposited in one bank recovers 50,000 if that bank fails. A player with 30,000 in Bank A and 30,000 in Bank B recovers both fully (each under the cap). This creates a natural incentive for players to spread deposits across multiple banks once their wealth exceeds the cap.

### Insurance Fund

Funded by 0.5% of the 2% regulatory fee (so 0.25% of all outstanding private bank loans per tick flows into the deposit insurance pool). The remaining 1.75% is permanently destroyed as a currency sink.

### Fund Solvency

If the insurance fund cannot cover a bank failure, the Central Bank backstops the difference. The fund then operates at a deficit and rebuilds over subsequent ticks. Players are always made whole up to the cap — the system never defaults on insured deposits.

### Payout Process

When a private bank is declared insolvent (capital ratio falls below 0% — total liabilities exceed total assets), the system automatically:

1. Freezes all bank operations (no new loans, no withdrawals)
2. Calculates each depositor's insured amount (up to 50,000)
3. Credits insured amounts to each depositor's personal wallet within 2 ticks
4. Liquidates the bank's remaining assets (outstanding loans are sold to the Central Bank at a discount — Central Bank collects remaining payments)
5. Any recovery above depositor claims goes to the bank owner. In practice this is almost always zero.

### Player-Facing Signal

Every bank's deposit page shows "Deposits insured up to 50,000 per depositor by the Central Bank." Players always know.

---

## 6. Transfers and Payments

### Player-to-Player Transfers

Any player can send money to any other player. Subject to Tier 3 transaction fee (0.75%). Sender pays listed amount; recipient receives amount minus fee. No approval needed. Instant within the same country. Cross-country transfers take 1 tick and incur an additional 0.5% cross-border surcharge (destroyed).

### Company-to-Company Payments

All B2B transactions. Subject to Tier 1 fee (2.5%). Processed during tick. No instant settlement — payment is queued and processed at next tick. This prevents real-time price manipulation through rapid B2B cycling.

### Personal Wallet → Company Account

Allowed. This is the owner investing in their own business. Subject to Tier 1 fee. No limits — the owner can invest as much personal money as they want.

### Company Account → Personal Wallet

Owner draw only (see Section 1). Capped at prior tick's net profit. Subject to Tier 1 fee. If the company has outstanding loans, capped at 50% of net profit.

### Deposit and Withdrawal (Private Bank)

- **Deposit:** Player transfers from personal wallet to their account at a private bank. Subject to Tier 3 fee (0.75%). Instant.
- **Withdrawal:** Player withdraws from their bank account to personal wallet. Subject to Tier 3 fee. Processed at next tick (not instant — creates a real liquidity consideration for both the player and the bank).

### Cross-Country Transfer Surcharge

0.5% on top of the applicable tier fee. Destroyed. Applies to all cross-country money movement — player transfers, B2B payments, and bank transfers. This makes international commerce marginally more expensive than domestic, consistent with the international logistics surcharge on physical goods.

---

## 7. Bankruptcy System

### Trigger

A player is declared bankrupt when ALL of the following are true simultaneously at tick processing:

- Personal wallet balance is 0
- No company accounts with positive balance (or no companies owned)
- Outstanding loan payments are overdue by 3+ ticks on any loan
- Total debt exceeds total asset value by more than 50%

Bankruptcy is not instant — it requires sustained insolvency. A player who dips to zero but has assets worth more than their debt is not bankrupt, just illiquid.

### Bankruptcy Process (Automatic, Tick-Based)

**Tick 0 (declaration):** System declares bankruptcy. All accounts frozen. Credit score drops 200 points. Player receives notification.

**Tick 1–3 (asset liquidation):** System sells player's assets in priority order:

1. Stock holdings — sold at current market price (may depress price if holdings are large)
2. Company ownership — companies are put up for forced sale at 60% of algorithmic valuation. Other players can bid. If no buyer within 3 ticks, company is dissolved and assets are liquidated at 40% of book value
3. Real estate — sold at 70% of market value (forced sale discount)
4. All other assets at liquidation values

Proceeds go to creditors in order:

1. Central Bank loans (government debt first)
2. Private bank loans (in origination order)
3. Remaining balance, if any, returned to the player

**Tick 4 (discharge):** Remaining unpaid debt is discharged (forgiven). The player's slate is wiped. Credit score is at whatever it dropped to (minimum 100). All companies are gone. All investments are gone. All assets are gone.

### What the Player Keeps

- Skills (always)
- Employment (if they have a job, they keep it — their employer is unaffected)
- Knowledge of the game systems
- Their account and identity

### Post-Bankruptcy Restrictions

- Cannot take any new loan for 20 ticks (5 real days)
- Cannot start a new company for 10 ticks (2.5 real days)
- Cannot invest in the stock market for 10 ticks
- Can immediately seek employment and earn salary
- Can receive player-to-player transfers (friends can help)

### Recovery Path

Employment → salary → rebuild personal wallet → credit score slowly recovers through clean behavior → eventually eligible for micro loans → rebuild from there. This mirrors the master doc's recovery loop.

---

## 8. Savings and Deposit Interest

### How Deposits Work at Private Banks

The bank owner sets a deposit interest rate (typically 1–3% per tick on the deposited balance). This is paid from the bank's revenue each tick. Higher deposit rates attract more depositors (cheaper capital for lending) but increase the bank's fixed obligations.

### Interest Crediting

Deposit interest is calculated per tick on the current balance and credited to the player's bank account. Subject to Tier 3 transaction fee (0.75%) — the interest paid is the gross amount, and the fee is deducted from the credited amount. This means a 2% deposit rate effectively yields ~1.985% after fees.

### No Central Bank Savings Accounts

The Central Bank does not accept deposits from players. Players who want to earn interest must use private banks. This is intentional — it drives deposit flow toward player-owned banks, making the banking sector more meaningful.

### Compounding

Interest accrues on the full balance each tick, including previously credited interest. Since interest is credited per tick and then earns interest next tick, this is effectively compound interest on a per-tick basis. The rate is low enough (1–3%) that compounding is mild — it rewards long-term savers without creating exponential growth. A 10,000 deposit at 2% grows to ~12,190 after 10 ticks with compounding, vs ~12,000 with simple interest. Meaningful over long periods, negligible over short ones.

---

## 9. Central Bank Base Rate Adjustments

The Central Bank's wholesale rate (4%) and direct lending rate (12%) are **fixed at launch.** They do not float.

### Can They Change?

Yes, but only through the same mechanism as transaction fees — public dashboard announcement, 28-tick notice period, hard bounds.

### Hard Bounds

| Rate | Floor | Ceiling | Launch Value |
|------|-------|---------|-------------|
| Wholesale rate | 2% | 8% | 4% |
| Direct lending rate | 8% | 18% | 12% |
| Regulatory fee | 1% | 4% | 2% |

### Trigger for Adjustment

Developer discretion, but subject to the same transparency rules as fee adjustments. Every change is publicly visible, pre-announced, and bounded. The developer cannot surprise the market.

### Why This Matters

If inflation becomes a problem and transaction fees alone aren't sufficient, raising the wholesale rate makes private bank lending more expensive economy-wide — a monetary tightening lever. If the economy is in recession and lending has dried up, lowering the wholesale rate makes capital cheaper — a stimulus lever. Both are visible, predictable, and bounded.

### Frequency Expectation

Rare. These rates should change at most once every few real-world months. They are structural parameters, not active management tools.

---

## 10. Player-Facing Banking Dashboard

### Bank / Loans UI Screen

**My Finances tab:**
- Personal wallet balance (prominent)
- Company account balances (per company, if applicable)
- Total net worth (assets + cash − debt)
- Credit score with bracket label (e.g., "Good — 720")
- Credit score trend arrow (improving/declining/stable over last 10 ticks)

**My Loans tab:**
- Active loans listed with: lender (Central Bank or private bank name), remaining balance, next payment amount, next payment date (tick), interest rate, term remaining, collateral (if any)
- Payment history (on-time / late / missed flags per tick)
- "Apply for Loan" button — shows Central Bank products and any private banks in the player's country

**My Deposits tab:**
- Deposits at each bank: balance, interest rate, interest earned this tick, interest earned lifetime
- Deposit insurance indicator per bank ("Insured up to 50,000")
- "Deposit" and "Withdraw" buttons per bank

**Transfer tab:**
- Send money to another player (by username)
- Transfer to/from own company accounts (subject to draw restrictions)
- Transaction history (all transfers, payments, fees — filterable)

**Banking Market tab:**
- List of all private banks in the player's country
- Per bank: deposit rate offered, lending rate range, reputation score, total deposits (public), deposit insurance status
- Central Bank rates (wholesale, direct lending) displayed for reference
- "This data updates each tick" timestamp

---

*Last updated: May 27, 2026 — Synchronized with monetization overhaul: Central Bank interest description corrected (currency sink, not developer revenue). Deposit insurance fund description corrected (remaining regulatory fee destroyed as sink, not developer revenue).*
