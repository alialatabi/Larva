# Project Larva — Comprehensive System Architecture (v3)

> **Status:** Architecture Design Document  
> **Stack:** Flutter (frontend) + Supabase (backend) + PostgreSQL  
> **Architecture Model:** Hybrid — Real-time event-driven transactions + Periodic background reconciliation  
> **Monetization Model:** Four streams — Premium Subscription, Cosmetic Marketplace, Partner Program (20% cut), Company Transfer Fee ($250)  
> **Last updated:** May 27, 2026

---

## Table of Contents

1. Architecture Overview
2. Database Schema
3. Real-Time Transaction Engine
4. Periodic Reconciliation Cycle
5. Partner Program System
6. Edge Functions / API Layer
7. Real-Time Subscriptions
8. Authentication & Security
9. Flutter Frontend Architecture
10. Infrastructure & Deployment
11. Performance & Scaling Strategy
12. Monitoring & Observability
13. Data Integrity & Audit System
14. Disaster Recovery

---

## 1. Architecture Overview

### The Hybrid Model

Larva's economy runs on two parallel processing tracks:

**Track 1 — Real-Time Transactions (event-driven, instant):**
When a player acts — buys food, trades stock, signs a contract, hires an employee, transfers money — the action processes immediately through an Edge Function. The player sees the result within seconds. Revenue is collected at the moment of sale. Stock trades execute on the spot. Contracts bind when both parties agree. Money moves the instant a transfer is confirmed.

**Track 2 — Periodic Reconciliation (scheduled, every 6 real hours):**
Once per game day (every 6 real hours), a background process settles the books. Salaries are paid. Rent is due. Loan installments are deducted. Player needs decay. Skills accumulate XP. Company valuations update. The stock market recalculates fair values. Taxes are collected. Events roll. Partner qualifications are evaluated. The economy takes a snapshot of itself.

The reconciliation is invisible to players during normal play. Transactions flow freely at all times. The cycle simply ensures that periodic obligations (salary, rent, loan payments, skill growth) and partner metrics resolve on a predictable schedule.

**Time conversion:** 6 real hours = 1 in-game day. This is a flavor/display conversion. The UI shows "Day 47" or "Your employee has worked for 12 game days." The underlying system tracks real timestamps and a cycle counter.

### Monetization Model: Four Revenue Streams

Larva does **not** have a real-money currency exchange. Players cannot buy or sell in-game currency for real money. The platform generates revenue through four streams, all of which are pay-to-win safe — no real-money purchase ever grants in-game economic capacity, currency, or advantage.

**Stream 1 — Premium Subscription ($9.99/month):**
Enhanced analytics dashboard, market intelligence tools, multi-company portfolio view, competitor tracking, price history exports, priority support, cosmetic profile perks. No effect on in-game economy whatsoever. Fully optional.

**Stream 2 — Cosmetic Marketplace (one-time purchases):**
Company branding packs, player avatars, office interior themes, prestige leaderboard badges. Zero in-game economic effect.

**Stream 3 — 20% Platform Cut on Partner Payouts:**
When a partner payout executes, the partner receives 80% of the published tier amount. The platform retains 20% as a processing fee. Self-funding — scales automatically with partner program growth. Partners are shown gross tier amounts; net transfer amounts reflect the 20% cut.

**Stream 4 — Company Transfer Fee ($250 USD per transfer):**
Every private company ownership transfer between players requires a $250 real-money legal processing fee paid by the buyer. The transfer is processed exclusively through the Central Corporation Legal Firm in the company's country of operation. Listed companies are excluded — they transfer ownership via the stock market. The $250 is a platform service fee; the company's in-game purchase price is still paid in ₳ through normal game mechanics.

**Partner Program — the core player incentive:**
Players who achieve demonstrable economic success receive monthly real-money payouts. Payouts are skill-based performance rewards — deterministic, objectively measurable, achievable through strategy alone.

**Partner tiers (gross amounts; net = gross × 0.80 after platform cut):**
- **Contributor**: 1 active company, 30-day revenue > ₳50K → $25/month gross
- **Builder**: 3+ companies, 30-day revenue > ₳500K → $100/month gross
- **Entrepreneur**: 5+ companies, 1 listed, market cap > ₳5M → $500/month gross
- **Mogul**: 10+ companies, 3+ listed, empire revenue > ₳50M → $2,500/month gross
- **Legend**: By invitation only, maximum 5 active Legend partners at any time → $5,000–10,000/month gross (negotiated)

**Partner Payout Wallet funding:**
The `partner_payout_wallet` is funded exclusively from real-money platform inflows — subscription fees and cosmetic marketplace revenue. It is fully isolated from the in-game economy. Partner payouts are a platform operating cost, not a game economy transaction. Every real-money inflow is recorded in `larva_partners.platform_revenue_log` to provide a traceable funding source.

**Pay-to-win hard rule:** No purchase — subscription, cosmetic, transfer fee, or any future stream — ever grants a player more in-game currency, companies, employees, faster skill growth, cheaper loans, better equipment, or any form of in-game economic capacity. Building from scratch is always free and always viable. Every new revenue idea is tested against this rule before it is added.

### System Topology

```
+------------------------------------------------------------------+
|                      PLAYER DEVICES                               |
|  Flutter Mobile (iOS/Android)  ·  Flutter Web                     |
|  Dashboard-driven UI · Real-time subscriptions · Offline-tolerant |
+--------------------------+----------------------------------------+
                           | HTTPS (actions) + WSS (live updates)
                           v
+------------------------------------------------------------------+
|                    SUPABASE PLATFORM LAYER                          |
|                                                                     |
|  +-------------+  +--------------+  +-------------------------+    |
|  |   Auth      |  |  PostgREST   |  |  Realtime (WebSocket)   |    |
|  |  (GoTrue)   |  |  (Read views)|  |  Broadcast + DB Changes |    |
|  +------+------+  +------+-------+  +------------+------------+    |
|         |                |                      |                   |
|  +------+----------------+----------------------+----------------+   |
|  |                  PostgreSQL Database                            |   |
|  |  RLS · Triggers · DB Functions · pg_cron · Partitioned tables  |   |
|  +----------------------------------------------------------------+   |
|                                                                     |
|  +----------------------------------------------------------------+   |
|  |              Edge Functions (Deno Runtime)                      |   |
|  |                                                                 |   |
|  |  REAL-TIME FUNCTIONS           PERIODIC FUNCTIONS               |   |
|  |  -------------------           -------------------              |   |
|  |  order-place                   reconciliation-coordinator       |   |
|  |  stock-trade                   reconciliation-country-worker    |   |
|  |  contract-sign                 reconciliation-global            |   |
|  |  transfer-money                event-roller                     |   |
|  |  loan-apply                    valuation-engine                 |   |
|  |  hire-employee                 economy-metrics                  |   |
|  |  buy-property                                                   |   |
|  |  insurance-claim                                                |   |
|  |  partner-apply                                                  |   |
|  |  ... (all player actions)                                       |   |
|  +----------------------------------------------------------------+   |
|                                                                     |
|  +----------------+  +-------------------------------------------+   |
|  | Supabase Storage|  |  pg_cron (Reconciliation Scheduler)      |   |
|  | (KYC docs,      |  |  Fires every 6 real hours                |   |
|  |  company logos)  |  |  Calls reconciliation-coordinator       |   |
|  +----------------+  +-------------------------------------------+   |
+------------------------------------------------------------------+
                           |
                           v
+------------------------------------------------------------------+
|                   EXTERNAL SERVICES                                 |
|  Sumsub/Stripe Identity (KYC) · Stripe Connect (Partner Payouts)  |
|  Push Notifications (FCM/APNS) · Error Tracking (Sentry)          |
+------------------------------------------------------------------+
```

### Architectural Principles

**Server-Authoritative Economy:** Every calculation involving money, ownership, skill progression, or game state runs inside PostgreSQL or Edge Functions. The Flutter client displays state and submits player intentions. It never calculates outcomes.

**Atomic Financial Transactions:** Every money movement is a single database transaction with ACID guarantees. No money is created, moved, or destroyed outside a committed transaction.

**Immediate Feedback, Periodic Settlement:** Player actions resolve instantly. Periodic obligations (salary, rent, taxes) and partner metrics settle on a predictable 6-hour cycle. Players experience a live economy, not a turn-based one.

**Skill-Based Rewards, Not Gambling:** Partner payouts are deterministic rewards for measurable economic achievement. No random chance determines payout eligibility. Players earn through strategy, management, and market understanding.

**Progressive Disclosure for the Client:** The Flutter app loads dashboard summaries first, then streams detail on demand. Real-time subscriptions push changes as they happen.

---


---

*For complete database schema, Edge Function catalog, reconciliation pipeline, Flutter structure, and infrastructure details, see `larva_system_architecture_impl.md`.*
