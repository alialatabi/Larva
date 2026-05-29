# Sector 9: Education & Training

**Company Types:** Skill Training Center · Corporate Training Company

---

## Sector Introduction

Education is the last sector in the game for a specific reason: it only makes sense once everything else exists. A training center teaching Logistics skills has value because Delivery Companies exist and need skilled drivers. A corporate training program for Pharmaceutical quality control matters because Pharmaceutical Manufacturers are hiring. The Education sector is structurally dependent on the breadth and complexity of the economy around it — it is the sector that reflects the game back at itself.

Two company types serve fundamentally different clients. The **Skill Training Center** serves players directly — it is the only B2C company in this sector, and the only mechanism in the game that can **unlock skill branches** that cannot be started through work alone. The **Corporate Training Company** serves businesses — it pushes NPC employee skill levels past their natural performance ceiling, and it is the counter to the Recruitment Agency's hire-from-outside approach.

**Three structural characteristics that distinguish Sector 9 from all others:**

1. **No physical output and no subscription.** Skills are intangible. They transfer through time and instruction, not through delivery routes or software licenses. The Education sector produces the only product in the game that lives permanently inside the player or NPC receiving it — and cannot be repossessed, damaged, or stolen.

2. **The prerequisite gate.** Some intermediate and advanced skills cannot begin developing through work alone. They require a foundational course at a Skill Training Center before the skill tree opens. This makes Training Centers structurally necessary for long-term career advancement — not a convenience, but a gate.

3. **Compounding economy dependency.** Enrollment demand at training centers and corporate training contracts scale directly with the economy's breadth. A small early-game economy needs one or two skill tracks. A mature economy with all nine sectors active generates demand across dozens of skill domains simultaneously. The Education sector matures with the game world.

The Central Corporation operates baseline training facilities in every country — offering foundational courses at slow instruction pace with NPC instructors capped at mid-tier skill. It also provides generic NPC upskilling programs with modest gains. Beatable immediately by any player-run operation with skilled instructors.

---

## 9A. Skill Training Center

**Business Model:** A Skill Training Center offers structured courses that accelerate player skill development and unlock skill trees that cannot be entered through work experience alone. Players pay an enrollment fee per course, attend over a fixed number of ticks, and exit with either an accelerated skill level or a newly unlocked skill branch. Revenue is fee-per-enrollment. The strategic distinction: the Training Center is the only place in the game where a player can **open a door that work cannot open** — advanced and specialist skill tracks that have a formal prerequisite. Every player who wants a high-ceiling career path will eventually need to walk through one.

### The Core Skill Development Mechanic

Skills develop in three ways in Larva:

**Through work** — the natural default. Working in a role accumulates skill experience over ticks. Slow, but always on.

**Through training** — enrollment in a course at a Training Center multiplies the rate of skill gain during the course period. The player still works while enrolled (the two activities run in parallel); their work-based skill gain is boosted by the instructor's quality modifier.

**Through prerequisite unlocking** — certain skill branches cannot begin developing at all through work until a foundational course has been completed. These are intermediate and advanced specialist tracks: Financial Modeling (requires Foundational Finance course), Pharmaceutical Quality Control (requires Foundational Science course), Architectural Design (requires Foundational Engineering course), etc. Without completing the prerequisite, the skill slot exists but cannot accumulate experience.

**Design intent:** Basic skills are freely accessible. Mid-tier careers require investment in training. Senior and specialist roles require committed educational paths. Players choosing to skip training slow their own ceiling — not a block, but a meaningful cost.

**Supply Chain Position:**
```
No physical inputs

Talent pipeline:
Recruitment Agency (Sector 6B) → Instructor hires
Electronics Store (Sector 3B) → Classroom equipment

Skill Training Center
      ↓ course enrollment (B2C — players only)
      ↓ enrollment fee paid per course
Players (enrolled students)
      → accelerated skill gain rate during course ticks
      → prerequisite course completions that unlock advanced skill branches
      → course completion record (visible on player profile)
```

**Employee Roles:**

| Role | Function |
|------|----------|
| Instructor | Core delivery role. Skill level in their domain determines the **quality multiplier** applied to enrolled students' skill gain rate. An Instructor with skill 70 in Logistics teaches at a 2.5× multiplier; an NPC Instructor at skill 40 teaches at 1.4×. Each Instructor can only teach courses within their own skill domain and only up to their own skill level. Enrollment capacity per Instructor is capped (typically 8–12 students simultaneously) |
| Course Designer | Develops course curriculum for new skill tracks. Skill determines breadth (how many distinct skill domains the center can offer) and depth (how many tiers per domain). Without this role, the center is locked to the founding Instructor's personal domain |
| Enrollment Coordinator | Manages incoming enrollments, scheduling, and student-to-Instructor assignments. High-skill Coordinator fills Instructor capacity with no gaps. Low-skill NPC Coordinator leaves slots empty while a waitlist builds |
| Campus Director | Player-only role. Unlocks multi-domain campuses, accreditation (prerequisite courses officially recognized as unlocking gated skill branches), and inter-country satellite campuses |

**The accreditation mechanic:** Only accredited training centers can grant the prerequisite unlocks that open locked skill branches. Accreditation requires a player Campus Director and a minimum operational track record. The Central Corporation's training centers are pre-accredited by default — new player-run centers must earn accreditation. This creates an early-game window where the only accredited option is the Central Corp, and players who build and accredit a competing center capture significant demand.

**Course Tiers:**

| Tier | Duration | Instructor Skill Required | Skill Gain Multiplier | Prerequisites Unlocked |
|---|---|---|---|---|
| Foundational | 2 ticks | ≥40 | 1.5× | Yes — opens intermediate skill branches in domain |
| Intermediate | 3 ticks | ≥60 | 2.0× | Yes — opens advanced skill branches |
| Advanced | 4 ticks | ≥80 | 2.8× | Requires Intermediate completion first |

**Operating Costs (per tick):**
- **Instructor salaries** — dominant cost. Skilled Instructors compete with industry employers offering higher salaries for the same skill level. A Logistics Instructor with skill 70 could be running their own Delivery Company instead
- **Classroom equipment** — computers, display systems, specialized training tools from Electronics Store. Subject to normal degradation. Outdated classroom equipment imposes a small Instructor quality penalty
- **Commercial real estate** — classroom space. Student capacity per square unit creates an enrollment ceiling tied to physical space
- **Course material costs** — per-student variable cost that scales with student volume
- **Accreditation maintenance fee** — once accredited, a small per-tick fee paid to the Central Corporation regulatory body. Cannot be avoided

**Revenue Model:**

*Enrollment fee per course:* The owner sets the price for each course. Students evaluate: cost vs skill gain multiplier vs available alternatives. Higher-quality instruction justifies higher fees — the fee is economically rational if the time saved in work-based skill development exceeds the cost.

*Completion record:* Every completed course is logged on the student's profile. Visible to Recruitment Agencies and employers directly. A player who has completed Advanced Logistics training is a more credibly skilled hire than one of equivalent raw skill level who hasn't.

**Key Owner Decisions:**
- **Which skill domain to teach first:** The founding Instructor determines the initial offering. The owner must read the local economy — which sectors are growing, which skills are in shortage, which career paths are currently un-trainable because no accredited center offers the prerequisite.
- **Instructor salary vs enrollment price equilibrium:** A highly skilled Instructor commands a high salary justified only if enrollment fees are high enough and the center stays full. Calculation: (enrollment price × students per Instructor) must exceed (Instructor salary + operating costs) per tick.
- **Breadth vs depth:** One domain taught brilliantly (definitive training center, known "best" in the country) vs multiple domains taught competently (more potential students, but a specialist competitor beats you in every lane).
- **Accreditation timing:** Pursuing accreditation requires a player Campus Director and operational track record. Unaccredited centers earn fee revenue but cannot unlock the prerequisite gates. The investment is justified once local demand for gated skill tracks exists.

**Capacity & Scaling:**
- **Primary bottleneck — Instructor headcount and capacity:** Each Instructor has a student cap. Exceeding it degrades quality for all enrolled students (multiplier drops)
- **Real estate cap:** Student volume ultimately bounded by classroom space
- **Course Designer gate:** Without this role, center cannot expand its course catalog
- **Campus Director gate:** Multi-domain accreditation and satellite campuses require this role — the major scale step

**Cross-Sector Dependencies:**
- **All sectors (students)** — every player is a potential student regardless of career path
- **Recruitment Agency (Sector 6B)** — Training Center completion records feed directly into Assessors' skill verification. An agency that can cite training history in placements is more credible. Natural referral partnership
- **Electronics Store (Sector 3B)** — classroom equipment
- **Corporate Training Company (Sector 9B)** — complementary, not competitive. Training Center serves players; Corporate Training serves NPC employees
- **Finance (Sector 5)** — Private Banks could offer education loans to players who want advanced training but lack upfront capital. Creates demand that wouldn't otherwise exist

**Market Dynamics:**
- **Oversaturated:** Fierce competition on Instructor quality and pricing. Students compare multipliers and fees directly. Whoever has the highest-skill Instructor in a domain is the default choice.
- **Undersaturated:** Default early-game state. Students choose between Central Corp's slow NPC-instructed courses and nothing else. First accredited Training Center in an underserved domain has monopoly pricing on prerequisite unlocking.
- **Country specialization dynamics:** A country known for Finance generates strong demand for Finance-track training. A manufacturing country creates demand for Technical and Production courses. Smart Training Center owners read country economic profiles before deciding where to open.
- **Central Corporation competition:** Foundational courses only, NPC Instructors capped at skill 55 (1.6× multiplier maximum). Not accredited for Advanced tracks. Beatable immediately on quality, accreditation depth, and advanced course availability.

**Failure Points:**
- **Instructor departure:** A high-skill player Instructor resigning drops course quality immediately. All courses in their domain run at degraded quality (lower multiplier, students notice) or are suspended. If the Instructor was the only accredited Advanced-track teacher, the premium product is gone until a replacement is hired and verified.
- **Enrollment cliff from poor domain choice:** A center opened for a skill domain with weak local demand cannot fill seats. Fixed costs run every tick regardless. Pivoting requires a Course Designer and time.
- **Reputation damage from low-quality results:** Students who complete a course but find their skill gain was far below the promised multiplier leave negative ratings. Enrollment drops before revenue signals the problem. By the time revenue reflects the issue, reputation has already priced in the decline.

**Emergent Gameplay:**
- **The self-training empire:** A player who owns both a Skill Training Center and a company in the same domain can enroll their own characters through their own center at cost — eliminating the margin. Their skills develop faster than any competitor paying market rate. The compounding effect: better skills → better business performance → more profit → can afford higher-skill Instructors → the center becomes genuinely excellent → trains competitors too.
- **The prerequisite monopoly:** In an early-game country where no Foundational Finance course exists, every player who wants to pursue a Finance career is gated. The first player to open an accredited Training Center with a Finance Instructor effectively controls entry into Finance careers in that country. Premium pricing on this position is aggressive and defensible — accreditation track record is slow to replicate.

**Abuse & Exploit Analysis:**
- **Self-enrollment fee laundering:** An owner enrolls their own characters at inflated fees, moving money between entities to inflate the center's revenue. **Counter:** Same-owner transactions flagged and discounted in the valuation algorithm. Enrollment fees from linked accounts applied at a capped rate when calculating verified revenue.

**Status:** ✅ Design Complete

---

## 9B. Corporate Training Company

**Business Model:** A Corporate Training Company designs and delivers structured training programs that increase NPC employee skill levels and push them past the performance ceiling they would naturally reach on the job alone. Revenue comes from B2B contracts — businesses pay per NPC enrolled in a training program. The strategic distinction: the core product is not acceleration but **ceiling expansion** — the ability to develop NPCs beyond the plateau that unassisted work experience creates. This directly competes with the Recruitment Agency's hire-fresh approach, creating one of the most strategically interesting tradeoffs in the game for any business owner managing a workforce.

### The NPC Skill Ceiling Mechanic

NPC employees develop skill naturally through work, but their growth follows a diminishing returns curve. Without intervention, an NPC Driver plateaus around skill 50. An NPC Cook plateaus around skill 45. These ceilings are adequate for Standard-tier business performance but insufficient for Premium-tier production or specialized roles.

**Corporate Training pushes past the ceiling.** A training program for a Driver capped at skill 50 can develop them to 65 over a multi-tick program. The cost is:
1. Program fee paid to the Corporate Training Company
2. Reduced NPC availability during training (the NPC is in training for 1–3 ticks — partially or fully unavailable for their normal role)

**The tradeoff vs Recruitment Agency:**
- **Hire skilled NPC** (via Recruitment Agency): immediate capability, high upfront placement fee, no transition downtime
- **Train existing NPC** (via Corporate Training): lower long-term cost, takes several ticks, opportunity cost during training, but produces an employee with loyalty history and a known track record who is now above market ceiling

Neither approach is universally better. The right answer changes based on cashflow, urgency, how much the existing NPC is trusted, and what competing employers are offering.

**Supply Chain Position:**
```
No physical goods produced

Talent pipeline:
Recruitment Agency (Sector 6B) → Trainer hires (specialized domain professionals)

Corporate Training Company
      ↓ B2B training contract (per NPC enrolled, per program)
      ↓ physical attendance at training facility
Businesses (all sectors)
      → NPC returns with higher skill level and optional Certification
      → expanded NPC performance ceiling
      → potential NPC salary renegotiation (they're now worth more)
```

**Employee Roles:**

| Role | Function |
|------|----------|
| Corporate Trainer | Core delivery role. Must have high skill in the domain they're training — cannot teach past their own skill level. Skill determines ceiling expansion magnitude: a Trainer with skill 70 can push a Driver's ceiling from 50 to 65; a Trainer with skill 80 can push to 72. NPC Trainers work but are capped at modest ceiling expansions |
| Program Developer | Designs the structured training program curricula. Skill determines program effectiveness (ticks to complete and ceiling expansion achieved per tick). Without a Program Developer, the center offers generic programs — lower efficiency, higher cost relative to results |
| Certification Assessor | Evaluates NPC performance after program completion and issues a Certification. Skill affects certification accuracy — the Certification's stated skill level matches the NPC's actual post-training level within a margin determined by Assessor skill. High-accuracy Certifications are trusted by the market |
| Client Relationship Manager | Manages ongoing contracts with business clients. Skill affects renewal rate and upsell success (getting a 2-NPC client to commit to a full-team program). Only impactful once the client base exceeds ~5 businesses |
| Training Director | Player-only role. Unlocks enterprise-scale programs (entire departments trained simultaneously), cross-country delivery, and Certification accreditation (the firm's Certifications are recognized by Recruitment Agencies as verified skill evidence) |

**Program Tiers:**

| Tier | Duration | Ceiling Expansion | NPC Availability During Training | Fee Level |
|---|---|---|---|---|
| Standard Program | 2 ticks | +8–12 skill points above natural ceiling | 50% available | Standard |
| Intensive Program | 3 ticks | +15–20 skill points above natural ceiling | 0% available (full-time training) | High |
| Executive Program | 4 ticks | +22–30 skill points above natural ceiling | 0% available | Premium |
| Refresher Course | 1 tick | Restores skill degradation from long inactivity | 80% available | Low |

**Operating Costs (per tick):**
- **Trainer salaries** — dominant cost. Same competitive dynamic as Skill Training Center Instructors: skilled professionals who could otherwise be working in their field
- **Training facility space** — larger than an office; needs practical demonstration areas for hands-on domains. Commercial/industrial real estate depending on domain
- **Program materials** — per-NPC variable cost during programs
- **Specialist equipment** — domain-specific training equipment from Electronics Store. A logistics training program needs tracking system workstations; a manufacturing training program needs production simulation equipment. Subject to degradation
- **Certification issuance fees** — small per-certification cost for formal documentation

**Revenue Model:**

*Contract fee per NPC per program:* Base rate × program tier × NPC's starting skill level (higher-skill NPCs require more sophisticated training, command higher fees).

*Certification as a revenue add-on:* After program completion, the client can purchase a Certification assessment. Optional but most clients take it — validates their investment and makes the NPC more credible on the labor market (while also making them an attractive poaching target).

*Retainer contracts:* Large businesses with ongoing training needs sign retainer agreements — guaranteed throughput with a per-tick fee. Predictable revenue, committed client, volume discount on per-NPC rate.

**Key Owner Decisions:**
- **Domain specialization:** Only trains specific sectors (deeper Trainer expertise, higher fees, smaller addressable market) or broad coverage (wider client pool, Trainers spread thinner across skill domains).
- **Program tier offering:** All tiers (attracts all budget levels, requires Trainers of varying skill levels) vs Premium/Intensive only (higher per-contract revenue, only requires senior Trainers). A firm that only offers Standard programs competes on price. A firm that only offers Executive programs competes on prestige and outcomes.
- **Certification accreditation investment:** Without a Training Director, the firm's Certifications carry limited market weight. Investing in accreditation creates a genuine quality signal — worth the cost if the client base is large enough to justify it.
- **Capacity vs relationship:** Fill every training slot with one-off contracts (high throughput, no loyalty) or pursue long-term retainer relationships with fewer businesses (predictable revenue, deeper client knowledge, better program design over time).

**Capacity & Scaling:**
- **Trainer capacity** — each Trainer handles a fixed number of NPCs simultaneously per program. Exceeding this reduces program quality (smaller ceiling expansion)
- **Facility space** — NPC volume bounded by physical training space per domain
- **Program Developer gate** — without this role, adding new domain programs requires Trainers to develop curriculum themselves, degrading training time. Growth into new domains is slow
- **Training Director gate** — enterprise programs and accreditation locked without this role. The key scale inflection point

**Cross-Sector Dependencies:**
- **All sectors (clients)** — every business with NPC employees is a potential client. Demand proportional to business density and quality ambition
- **Recruitment Agency (Sector 6B)** — the primary competitive alternative for businesses. Natural rivalry but also natural partnership: Agency places NPCs, Corporate Training improves them post-placement. An Agency that formally partners with a Training Company (referral agreements: "we'll place at skill 50, our partner can develop them to 70 over 3 ticks") adds a differentiated offering to both businesses
- **Skill Training Center (Sector 9A)** — complementary. At scale, both operations can be run under one ownership structure as a unified Education group
- **Finance (Sector 5)** — businesses may take short-term loans to fund training programs, especially Intensive/Executive tier. The ROI calculation is sound — lenders can assess it
- **Legal Firm (Sector 6A)** — a business that trains an NPC to above-market skill level often wants a non-poaching clause or extended employment commitment. Legal Firms draft these agreements

**Market Dynamics:**
- **Oversaturated:** Price competition on Standard programs (commodity, thin margins). Premium and Executive programs maintain margin because few firms have Trainers with skill high enough to deliver top-tier ceiling expansion.
- **Undersaturated:** Business owners have no path to developing their NPC workforce beyond natural ceilings. The first Corporate Training Company in an underserved country captures all demand from businesses who chose train-from-scratch over hire-premium.
- **The poaching cycle:** A Corporate Training Company upgrades an NPC to above-market skill. If the original employer doesn't raise the NPC's salary in response, the NPC leaves. The client business loses the investment. This creates recurring demand — businesses that invest in training must invest in retention, and businesses whose trained NPCs leave need to either retrain or hire already-skilled. The Corporate Training Company benefits from both sides of this cycle.
- **Central Corporation competition:** Generic 2-tick programs for common roles only. Ceiling expansion modest (maximum +8 skill points). No Executive tier. No Certification. Adequate for businesses who don't know their options.

**Failure Points:**
- **Program quality collapse from Trainer departure:** A high-skill Trainer leaving mid-client relationship breaks ongoing programs. NPCs in training receive degraded results. Client refund demands and non-renewal follow. If the departing Trainer was the only one covering a domain, all programs in that domain are suspended.
- **Poaching backfire reputation:** The Corporate Training Company becomes known as the place where NPCs go to get good enough to leave. Businesses notice that NPCs trained here consistently defect. Demand drops because clients calculate the benefit doesn't survive long enough to justify the cost. Certification with accreditation is the long-term counter — but it's a slow reputational rebuild.
- **Oversized facility with thin demand:** Premium training infrastructure in a country with low business density or a weak economy. Fixed costs run against a thin client base. The high operating cost model requires sustained high-fee program volume to be viable.

**Emergent Gameplay:**
- **The workforce development moat:** A manufacturing empire that commits to systematically training all NPCs through Corporate Training programs over 10–15 ticks builds a workforce operating at skill levels competitors cannot easily replicate. Trained NPCs develop loyalty (lower turnover risk than freshly placed NPCs). The training empire's advantage compounds — the hardest competitive moat in the game to build, but also the slowest.
- **The combined Education group:** A player who owns both a Skill Training Center (accredited, Premium) and a Corporate Training Company (accredited, Executive-tier) controls the entire human capital development pipeline in their country. Players train there for career advancement. Businesses send NPCs there for workforce development. Recruitment Agencies trust their Certifications. Each side makes the other more legitimate and valuable. The Education sector's ultimate end game — a vertically integrated knowledge economy.

**Abuse & Exploit Analysis:**
- **NPC skill laundering:** A business trains its own NPC through an owned Corporate Training Company — paying itself the program fee to inflate the Training Company's revenue. **Counter:** Same-owner intra-company transactions flagged and discounted in valuations.
- **Credential inflation:** A Corporate Training Company issues Certifications claiming skill levels higher than the NPC actually reached. **Counter:** Certification Assessor accuracy is publicly visible. Certifications from firms with poor accuracy records are discounted by Recruitment Agencies' Assessors. The Recruitment Agency sector has direct incentive to expose inaccurate Certifications — it makes the Agency's own assessments more valuable by comparison. Market self-corrects through the inter-sector trust network.

**Status:** ✅ Design Complete

---

## Sector 9 Summary

| Company Type | Revenue Model | Volatility | Key Differentiator | Core Risk |
|---|---|---|---|---|
| Skill Training Center | Enrollment fee per course per player | Medium (tracks player career advancement demand) | Prerequisite gate system — the only mechanism that unlocks gated skill branches | Instructor departure; domain misalignment with local economy; accreditation loss |
| Corporate Training Company | Contract fee per NPC per program | Medium (tracks business expansion and NPC quality ambition) | NPC ceiling expansion past natural work plateau; Certification creates inter-sector trust signal | Trainer departure; poaching backfire reputation; high fixed costs in thin markets |

**Sector-wide characteristics:**
- No physical goods produced — entirely service and knowledge-based
- Both company types are **multipliers of other sectors' performance** — they make everything else work better
- Both depend on **skilled, specialized human capital** (Instructors and Trainers) as their core resource — the sector that teaches skills is itself entirely dependent on skilled employees
- Both have **Central Corporation baseline competition** that is pre-accredited but low-quality — beatable from day one by any operation with genuine skill investment
- Both generate **completion records and Certifications** that feed into the Recruitment Agency's trust network — creating a three-way interdependency between Education, Recruitment, and every hiring business
- The two company types are **complementary, not competitive** — Training Center serves players, Corporate Training serves NPCs. Unified ownership creates the most defensible position in the sector

**Cross-Education dynamics:**
- A player who operates both company types effectively controls a country's human capital development — the pace at which players advance careers and the quality ceiling of NPC workforces both pass through their hands
- The sector is the game's **long-term retention engine** — players pursuing advanced skill tracks through training have explicit future goals, return schedules, and progression stakes. Well-designed training tracks make players care about their characters' development arcs far beyond what any other sector provides

---

*Last updated: May 25, 2026 — Sector 9 design complete*
