# Project Larva — Claude Code Instructions

> Read this file completely before writing any code.
> This is the ground truth for every technical and design decision.

---

## What This Project Is

Project Larva is a **massive multiplayer online economic life simulation**.
Players start with zero money, get a job, earn salary, start companies,
hire employees, trade stock, take loans, and compete in a shared live economy
with thousands of other players.

**Platforms:** iOS, Android, Web  
**Stack:** Flutter (frontend) + Supabase (backend)  
**Status:** Starting development. Full design and architecture completed.

---

## Architecture — Hard Rules (Never Violate)

These are non-negotiable. They protect the economy and the legal model.

1. **Server-authoritative economy.** Every calculation involving money,
   ownership, skill progression, or game state runs inside PostgreSQL or
   Edge Functions. The Flutter client displays state and submits player
   intentions. It NEVER calculates economic outcomes.

2. **No business logic in Flutter.** Flutter shows data and sends actions.
   It does not compute salaries, valuations, skill growth, or any game
   mechanic. All of that lives in Edge Functions or database functions.

3. **Atomic transactions.** Every money movement is a single database
   transaction. No money is created, moved, or destroyed outside a
   committed transaction.

4. **Closed currency.** The in-game currency ($) has no real-money exchange
   rate. It cannot be bought or sold for real money. Never build a mechanism
   that lets players exchange in-game currency for real value.

5. **No pay-to-win.** No real-money purchase ever grants in-game economic
   advantage — no extra currency, faster skill growth, cheaper loans, or
   any economic capacity. Real-money streams are: Premium Subscription
   ($9.99/mo, analytics only), Cosmetic Marketplace, 20% Partner Program
   cut, $250 company transfer fee.

6. **Optimistic UI with server confirmation.** Actions update the UI
   immediately, then confirm with the Edge Function. If the function fails,
   roll back with an error toast. Never wait for server confirmation before
   showing feedback.

---

## Tech Stack

```
Frontend:   Flutter (Dart) — iOS, Android, Web from one codebase
Backend:    Supabase (PostgreSQL + Edge Functions + Realtime + Auth + Storage)
State:      Riverpod (Flutter state management)
Realtime:   Supabase Realtime WebSocket subscriptions
Scheduler:  pg_cron — fires reconciliation every 6 real hours
Auth:       Supabase GoTrue (email/password + OAuth)
Runtime:    Deno (Edge Functions)
```

---

## Project File Structure

```
larva/
├── CLAUDE.md                    ← You are here
│
├── docs/                        ← Full design documentation (READ THESE)
│   ├── larva_ux_design.md           — Full UI/UX spec, all screens
│   ├── larva_system_architecture_impl.md    — Database schema + Edge Functions
│   ├── larva_system_architecture_overview.md — Architecture overview
│   ├── larva_master.md              — Master knowledge base + progress tracker
│   ├── larva_economy_balance.md     — Economy rules and inflation controls
│   ├── larva_banking_system.md      — Banking, loans, deposits, credit
│   ├── larva_stock_market.md        — IPO, trading, dividends, delisting
│   ├── larva_skills_system.md       — 25 skills, NPC ceilings, career paths
│   ├── larva_country_definitions.md — 18 countries with all modifiers
│   ├── larva_event_system.md        — Events, probabilities, effects
│   ├── larva_sector_1_food_hospitality.md
│   ├── larva_sector_2_logistics_transport.md
│   ├── larva_sector_3_retail.md
│   ├── larva_sector_4_construction_real_estate.md
│   ├── larva_sector_5_finance.md
│   ├── larva_sector_6_professional_services.md
│   ├── larva_sector_7_manufacturing.md
│   ├── larva_sector_8_technology.md
│   └── larva_sector_9_education.md
│
├── mockups/                     ← Interactive React mockups (visual reference)
│   ├── larva_dashboard.jsx          — Dashboard screen
│   ├── larva_company_detail.jsx     — Company Detail (5 tabs)
│   ├── larva_wizard.jsx             — Company Creation Wizard
│   ├── larva_onboarding.jsx         — Onboarding flow (4 screens)
│   ├── larva_stock_market.jsx       — Stock Market + Trade sheet
│   └── larva_banking.jsx            — Banking + Loans + Transactions
│
├── lib/                         ← Flutter source
│   ├── main.dart
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_colors.dart      — All color tokens
│   │   │   ├── app_typography.dart  — Syne / DM Sans / DM Mono
│   │   │   ├── app_spacing.dart     — Spacing scale
│   │   │   └── app_theme.dart       — ThemeData
│   │   ├── router/
│   │   │   └── app_router.dart      — GoRouter navigation
│   │   ├── supabase/
│   │   │   └── supabase_client.dart
│   │   └── providers/
│   │       └── supabase_providers.dart
│   │
│   ├── features/
│   │   ├── auth/
│   │   ├── dashboard/
│   │   ├── empire/
│   │   │   ├── company_list/
│   │   │   ├── company_detail/
│   │   │   ├── company_create/
│   │   │   └── stock_market/
│   │   ├── finance/
│   │   │   ├── wallet/
│   │   │   ├── transactions/
│   │   │   └── loans/
│   │   ├── world/
│   │   │   ├── events/
│   │   │   └── countries/
│   │   └── profile/
│   │       ├── player_profile/
│   │       ├── skills/
│   │       ├── needs/
│   │       └── partner/
│   │
│   └── shared/
│       ├── widgets/
│       │   ├── stat_card.dart
│       │   ├── balance_display.dart
│       │   ├── cycle_countdown.dart
│       │   ├── need_bar.dart
│       │   ├── sparkline.dart
│       │   ├── bottom_sheet_shell.dart
│       │   └── app_bottom_nav.dart
│       └── models/
│
└── supabase/
    ├── migrations/
    └── functions/
        ├── order-place/
        ├── stock-trade/
        ├── contract-sign/
        ├── loan-apply/
        ├── hire-employee/
        ├── transfer-money/
        └── reconciliation-coordinator/
```

---

## Design System — Exact Token Values

Copy these directly. Never invent a color, size, or font.

### Colors (Dart)

```dart
// lib/core/theme/app_colors.dart
class AppColors {
  // Backgrounds
  static const bgBase     = Color(0xFF080A0E);
  static const bgSurface  = Color(0xFF0F1117);
  static const bgElevated = Color(0xFF171C26);
  static const bgInput    = Color(0xFF1E2330);

  // Borders
  static const borderSubtle  = Color(0xFF252B3A);
  static const borderDefault = Color(0xFF323847);
  static const borderStrong  = Color(0xFF4A5268);

  // Text
  static const textPrimary   = Color(0xFFEAE8E3);
  static const textSecondary = Color(0xFF8A8FA0);
  static const textTertiary  = Color(0xFF565D72);

  // Semantic — the economy's visual language
  static const gold         = Color(0xFFC9A54A); // ALL currency ($)
  static const goldBright   = Color(0xFFE8C86A); // Animated on increase
  static const goldDim      = Color(0xFF7A6228); // Historical/muted
  static const emerald      = Color(0xFF00C97A); // Profit, positive delta
  static const crimson      = Color(0xFFE63946); // Loss, negative delta
  static const sky          = Color(0xFF4A90D9); // Info, links
  static const amber        = Color(0xFFF59E0B); // Warnings
  static const violet       = Color(0xFF8B5CF6); // Partner program

  // Semantic surfaces
  static const emeraldSurface = Color(0xFF00140A);
  static const crimsonSurface = Color(0xFF1A0507);
}
```

### Typography

Three fonts. Each has one job. Import all three from Google Fonts.

```dart
// lib/core/theme/app_typography.dart
// Syne     — Display, headings, hero numbers, company names
// DM Sans  — Body, labels, buttons, navigation, descriptions
// DM Mono  — ALL financial figures, percentages, cycle timers, tables
//            Rule: if it's a number the player acts on → DM Mono

class AppTypography {
  static const displayXL = TextStyle(
    fontFamily: 'Syne', fontWeight: FontWeight.w700,
    fontSize: 40, height: 1.1, color: AppColors.textPrimary,
  );
  static const displayL = TextStyle(
    fontFamily: 'Syne', fontWeight: FontWeight.w700,
    fontSize: 32, height: 1.15,
  );
  static const displayM = TextStyle(
    fontFamily: 'Syne', fontWeight: FontWeight.w700,
    fontSize: 24, height: 1.2,
  );
  static const headingL = TextStyle(
    fontFamily: 'DMSans', fontWeight: FontWeight.w600,
    fontSize: 20, height: 1.3,
  );
  static const bodyL = TextStyle(
    fontFamily: 'DMSans', fontWeight: FontWeight.w400,
    fontSize: 16, height: 1.5,
  );
  static const bodyM = TextStyle(
    fontFamily: 'DMSans', fontWeight: FontWeight.w400,
    fontSize: 14, height: 1.5,
  );
  static const dataL = TextStyle(
    fontFamily: 'DMMono', fontWeight: FontWeight.w500,
    fontSize: 20, height: 1.2,
  );
  static const dataM = TextStyle(
    fontFamily: 'DMMono', fontWeight: FontWeight.w400,
    fontSize: 16, height: 1.3,
  );
  static const dataS = TextStyle(
    fontFamily: 'DMMono', fontWeight: FontWeight.w400,
    fontSize: 13, height: 1.4,
  );
  static const label = TextStyle(
    fontFamily: 'DMSans', fontWeight: FontWeight.w500,
    fontSize: 11, height: 1.4, letterSpacing: 0.08,
  );
}
```

### Spacing

```dart
class AppSpacing {
  static const xs  = 4.0;
  static const sm  = 8.0;
  static const md  = 12.0;
  static const lg  = 16.0;
  static const xl  = 24.0;
  static const x2l = 32.0;
  static const x3l = 48.0;
  static const screenPadding = 20.0;
}

class AppRadius {
  static const card  = 12.0;
  static const hero  = 16.0;
  static const chip  = 8.0;
  static const sheet = 24.0;
}
```

---

## Database Schema — Key Tables

Full schema is in `docs/larva_system_architecture_impl.md`.
The 8 database schemas:

```
larva_core      — players, skills, needs, credit scores
larva_economy   — companies, employees, contracts, orders, inventory
larva_finance   — wallets, transactions, loans, deposits, insurance
larva_market    — stock listings, shares, trading, dividends
larva_world     — countries, real estate, properties, events
larva_logistics — transport contracts, shipments, spoilage
larva_partners  — partner program, tiers, payouts
larva_admin     — system config, cycle tracking, audit logs
```

---

## Edge Functions Catalog

Full specs in `docs/larva_system_architecture_impl.md`.
Real-time functions (instant player actions):

```
order-place              — Place product order
stock-trade              — Buy or sell shares
contract-sign            — Accept B2B contract
transfer-money           — Player-to-player transfer
loan-apply               — Loan application
hire-employee            — Hire NPC or accept player application
fire-employee            — Remove employee
buy-property             — Lease commercial or residential space
company-create           — Register new company
company-list-stock       — IPO application
insurance-claim          — File insurance claim
partner-apply            — Partner program application
```

Periodic functions (run at cycle settlement, every 6 hours):
```
reconciliation-coordinator   — Orchestrates the full cycle
reconciliation-country-worker — Processes one country per invocation
reconciliation-global        — Post-country global steps
event-roller                 — Generates random events
valuation-engine             — Updates all company valuations
economy-metrics              — Calculates global economic indicators
```

---

## The Economy Cycle — How It Works

**Every 6 real hours:**
1. pg_cron fires `reconciliation-coordinator`
2. Per country: process all companies (revenue, expenses, orders)
3. Pay salaries to all employees
4. Collect rent from all tenants
5. Deduct loan installments
6. Decay player needs
7. Accumulate skill XP from roles
8. Update company valuations
9. Roll events
10. Update stock fair values
11. Evaluate partner tier qualifications
12. CC injection (if economy is undersupplied)

**Real-time (instant, any time between cycles):**
- Player buys food → need_hunger increases immediately
- Player trades stock → shares transfer instantly
- Player signs contract → binding immediately
- Player receives salary → wallet credits at cycle settle only

---

## State Management Pattern (Riverpod)

```dart
// Pattern for all screens:
// 1. Provider fetches initial state from Supabase
// 2. Realtime subscription updates state on changes
// 3. Actions call Edge Functions, optimistically update local state
// 4. On error: revert local state, show error toast

// Example provider pattern:
final walletProvider = StreamProvider<int>((ref) {
  return supabase
    .from('larva_finance.wallets')
    .stream(primaryKey: ['id'])
    .eq('player_id', currentPlayerId)
    .map((rows) => rows.first['balance'] as int);
});
```

---

## UI Rules — What Claude Code Must Always Do

These rules come from the Larva UI/UX design skill. Follow them exactly.

**Currency:**
- All `$` amounts use `AppColors.gold` — never `textPrimary`
- All financial figures use `DM Mono` font
- Format: `$ 84,200` with thousands separator, never `$84200`
- Positive deltas: `AppColors.emerald` with `+` prefix
- Negative deltas: `AppColors.crimson` with `−` prefix

**Live wallet balance:**
- Must animate with a CountUp effect when balance increases
- Duration: 400ms, cubic ease-in-out
- Gold glow on increase: `BoxShadow` with `AppColors.gold` at low opacity
- This is non-optional — it's the core "economy feels alive" mechanic

**Cycle countdown:**
- Always visible in bottom nav chip AND on Dashboard
- Real `Timer.periodic` countdown, not decorative
- Under 30 minutes: turns `AppColors.amber`, pulses

**Status on company cards:**
- ✅ Operating: `AppColors.borderDefault` border
- ⚠️ Issue: `AppColors.amber` border with glow
- 🚨 Critical: `AppColors.crimson` border with pulse animation
- Never hide status in a notification badge

**Bottom sheets:**
- CTA button always shows the consequence in its label
- `"Buy 200 shares — $ 3,480"` not `"Confirm"`
- `"Place Order — $ 280"` not `"Submit"`
- No "Are you sure?" inside bottom sheets

---

## Visual References

The `mockups/` directory contains interactive React prototypes for every
major screen. Read them to understand exact layouts, interactions, and
edge cases before building a screen in Flutter.

Screens with validated mockups:
- `larva_dashboard.jsx` — Dashboard with live balance, cycle countdown, company cards
- `larva_company_detail.jsx` — 5 tabs: Overview, Employees, Orders, Inventory, Finances
- `larva_wizard.jsx` — Company Creation (5 steps + success screen)
- `larva_onboarding.jsx` — World splash, country select, account, first day
- `larva_stock_market.jsx` — Market overview, listing detail with chart, trade sheet
- `larva_banking.jsx` — Wallet, transactions, loans with heartbeat dots, loan wizard

Screens to be mocked up before building (check `docs/larva_ux_design.md`):
- Profile + Needs
- Skills Map
- Jobs (Find Work + My Career)
- Events Feed
- Notification Center

---

## Build Order

Build in this sequence. Do not skip steps.

### Phase 1 — Foundation (do this first, everything depends on it)
1. Flutter project + pubspec.yaml with all dependencies
2. `AppColors`, `AppTypography`, `AppSpacing`, `AppRadius` — exact values above
3. `AppTheme` applying all tokens to `ThemeData`
4. Supabase client init with env vars
5. GoRouter navigation shell
6. `AppBottomNav` widget with cycle countdown chip

### Phase 2 — Core Screens
7. Dashboard screen (fully validated mockup available)
8. Empire screen — Company List
9. Company Detail — Overview tab
10. Company Detail — Employees tab
11. Company Detail — Orders tab
12. Company Detail — Inventory tab
13. Company Detail — Finances tab

### Phase 3 — Creation and Market
14. Company Creation Wizard (5 steps)
15. Stock Market Overview + Listing Detail
16. Trade bottom sheet

### Phase 4 — Finance
17. Wallet Overview (live balance is the priority)
18. Transaction History
19. Loans screen + heartbeat dots
20. Loan Application Wizard

### Phase 5 — Life Layer (mock up first, then build)
21. Player Profile
22. Needs Detail
23. Skills Map
24. Jobs — Find Work
25. Jobs — My Career

### Phase 6 — World
26. Events Feed
27. Country Browser
28. Notification Center

---

## Dependencies (pubspec.yaml — suggested)

```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^2.0.0       # Supabase client + realtime
  flutter_riverpod: ^2.4.0       # State management
  riverpod_annotation: ^2.3.0    # Code generation for providers
  go_router: ^13.0.0             # Navigation
  google_fonts: ^6.1.0           # Syne, DM Sans, DM Mono
  intl: ^0.19.0                  # Number and date formatting
  fl_chart: ^0.67.0              # Charts (price history, sparklines)
  phosphor_flutter: ^2.0.0       # Icon library
  cached_network_image: ^3.3.0   # Avatars, company logos
  flutter_secure_storage: ^9.0.0 # Auth token storage
  hive_flutter: ^1.1.0           # Offline cache

dev_dependencies:
  build_runner: ^2.4.0
  riverpod_generator: ^2.3.0
  flutter_test:
    sdk: flutter
```

---

## Important Reference Files

When working on any system, read the relevant doc first:

| Building...              | Read first...                              |
|--------------------------|--------------------------------------------|
| Any UI screen            | `docs/larva_ux_design.md` — that screen's section |
| Database tables          | `docs/larva_system_architecture_impl.md`   |
| Edge Functions           | `docs/larva_system_architecture_impl.md`   |
| Economy/cycle logic      | `docs/larva_economy_balance.md`            |
| A company type           | The relevant `docs/larva_sector_N_*.md`    |
| Banking/loans            | `docs/larva_banking_system.md`             |
| Stock market             | `docs/larva_stock_market.md`               |
| Skills / career          | `docs/larva_skills_system.md`              |
| Countries / modifiers    | `docs/larva_country_definitions.md`        |
| Events                   | `docs/larva_event_system.md`               |

---

## What "Done" Looks Like for a Screen

A screen is done when:
1. It matches the mockup in `mockups/` (layout, colors, fonts)
2. It connects to real Supabase data (no hardcoded values)
3. It handles loading state (skeleton screens, not spinners)
4. It handles error state (toast notification, graceful fallback)
5. It handles empty state (meaningful empty state, not blank)
6. Live data updates via Realtime subscription where applicable
7. All `$` amounts animate when they change (wallet screens)
8. Offline: shows last-known state with "Last synced X ago" banner
