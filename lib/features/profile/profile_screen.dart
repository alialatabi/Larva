import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../finance/wallet_providers.dart';
import 'profile_providers.dart';

// ── Data models ───────────────────────────────────────────────────────────────

class _Need {
  const _Need(this.id, this.label, this.value, this.action, this.decay, this.icon, this.color);
  final String id, label, action, decay, icon;
  final int value;
  final Color color;
}

class _Skill {
  const _Skill(this.name, this.level, {this.ceiling = 100, this.locked = false, this.prereq});
  final String name;
  final int level, ceiling;
  final bool locked;
  final String? prereq;
}

class _SkillGroup {
  const _SkillGroup(this.title, this.subtitle, this.skills);
  final String title, subtitle;
  final List<_Skill> skills;
}

class _Job {
  const _Job({required this.role, required this.company, required this.sector, required this.country, required this.salary, required this.reqSkill, required this.reqLevel, required this.icon});
  final String role, company, sector, country, reqSkill, icon;
  final int salary, reqLevel;
}

class _CareerEntry {
  const _CareerEntry({required this.role, required this.company, required this.period, required this.current});
  final String role, company, period;
  final bool current;
}

// ── Mock data ─────────────────────────────────────────────────────────────────

// Mock needs: presentation descriptors (icon/action/decay/colour) + fallback
// values. Live values come from playerNeedsProvider, matched by id.
const _needs = <_Need>[
  _Need('hunger',         'Hunger',    82, 'Buy food',      '−6 / cycle', '🍽', AppColors.needHunger),
  _Need('energy',         'Energy',    61, 'Rest',          '−9 / cycle', '⚡', AppColors.needEnergy),
  _Need('health',         'Health',    88, 'Visit clinic',  '−3 / cycle', '❤️', AppColors.needHealth),
  _Need('happiness',      'Happiness', 71, 'Leisure',       '−5 / cycle', '😊', AppColors.needHappiness),
  _Need('housing',        'Housing',   90, 'Pay rent',      '−2 / cycle', '🏠', AppColors.needHousing),
  _Need('transportation', 'Transport', 85, 'Fuel / fare',   '−4 / cycle', '🚗', AppColors.needTransport),
  _Need('drive',          'Ambition',  65, 'Hit your goals','−5 / cycle', '🔥', AppColors.needAmbition),
];

// Overlay live need values onto the presentation descriptors (or fall back).
List<_Need> _resolveNeeds(PlayerNeedsData? live) {
  if (live == null) return _needs;
  return [
    for (final n in _needs)
      _Need(n.id, n.label, live.values[n.id] ?? n.value, n.action, n.decay, n.icon, n.color),
  ];
}

const _tierMeta = <String, (String, String)>{
  'foundation':  ('Foundation', 'Universal · develop through any work'),
  'free_domain': ('Domain — Open', 'Freely accessible specialisations'),
  'gated_domain':('Domain — Gated', 'Require a foundational course to unlock'),
};

// Build the grouped skill map from live player skills (or fall back to mock).
List<_SkillGroup> _resolveSkillGroups(List<PlayerSkill>? live) {
  if (live == null || live.isEmpty) return _skillGroups;
  List<_Skill> forTier(String tier) =>
      live.where((s) => s.tier == tier).map((s) => _Skill(
            s.name, s.level,
            locked: !s.unlocked,
            prereq: s.unlocked ? null : s.prerequisite,
          )).toList()
        ..sort((a, b) {
          if (a.locked != b.locked) return a.locked ? 1 : -1; // locked last
          return b.level.compareTo(a.level);
        });
  return [
    for (final tier in const ['foundation', 'free_domain', 'gated_domain'])
      _SkillGroup(_tierMeta[tier]!.$1, _tierMeta[tier]!.$2, forTier(tier)),
  ];
}

String _titleCase(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

// Live (signed-in real data) vs Preview (debug/no session → mock fallback).
Widget _livePill(bool live) {
  final c = live ? AppColors.emerald : AppColors.amber;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(
      color: c.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: c.withValues(alpha: 0.3)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 5, height: 5, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
      const SizedBox(width: 5),
      Text(live ? 'Live' : 'Preview', style: AppTypography.label.copyWith(color: c, fontSize: 10, fontWeight: FontWeight.w600)),
    ]),
  );
}

const _skillGroups = <_SkillGroup>[
  _SkillGroup('Foundation', 'Universal · develop through any work', [
    _Skill('Management', 72),
    _Skill('Finance', 58),
    _Skill('Organization', 66),
    _Skill('Customer Service', 54),
    _Skill('Sales', 49),
    _Skill('Marketing', 44),
    _Skill('Quality Assessment', 40),
    _Skill('Negotiation', 35),
  ]),
  _SkillGroup('Domain — Open', 'Freely accessible specialisations', [
    _Skill('Information Technology', 31),
    _Skill('Culinary Arts', 28),
    _Skill('Design & Aesthetics', 22),
    _Skill('Real Estate', 18),
    _Skill('Manufacturing & Production', 15),
    _Skill('Driving', 12),
    _Skill('Healthcare Basics', 9),
    _Skill('Mechanical Repair', 0),
    _Skill('Construction', 0),
  ]),
  _SkillGroup('Domain — Gated', 'Require a foundational course to unlock', [
    _Skill('Accounting', 30, ceiling: 100),
    _Skill('Financial Modeling', 24),
    _Skill('Software Engineering', 0, locked: true, prereq: 'Foundational Computing'),
    _Skill('Data Analytics', 0, locked: true, prereq: 'Foundational Computing'),
    _Skill('Pharmaceutical Science', 0, locked: true, prereq: 'Foundational Science'),
    _Skill('Architecture', 0, locked: true, prereq: 'Foundational Engineering'),
    _Skill('Electronics Engineering', 0, locked: true, prereq: 'Foundational Engineering'),
    _Skill('Legal Practice', 0, locked: true, prereq: 'Foundational Law'),
  ]),
];

const _currentJob = _Job(
  role: 'Software Developer', company: 'Horizon Tech', sector: 'Technology',
  country: 'Caedoria', salary: 8000, reqSkill: 'Information Technology', reqLevel: 3, icon: '💻',
);

const _openJobs = <_Job>[
  _Job(role: 'Store Manager',         company: 'Caedoria Retail', sector: 'Retail',             country: 'Caedoria', salary: 680, reqSkill: 'Management',           reqLevel: 3, icon: '📱'),
  _Job(role: 'Junior Accountant',     company: 'Ventrex Capital', sector: 'Finance',            country: 'Ventrex',  salary: 700, reqSkill: 'Finance',              reqLevel: 2, icon: '💰'),
  _Job(role: 'Logistics Coordinator', company: 'Nexlogic Freight',sector: 'Logistics',          country: 'Brimark',  salary: 640, reqSkill: 'Organization',         reqLevel: 3, icon: '🚚'),
  _Job(role: 'IT Support Specialist', company: 'Eltria Tech',     sector: 'Technology',         country: 'Pella',    salary: 590, reqSkill: 'Information Technology',reqLevel: 2, icon: '🖥'),
  _Job(role: 'Senior Barista',        company: 'Volta Café',      sector: 'Food & Hospitality', country: 'Caedoria', salary: 520, reqSkill: 'Customer Service',     reqLevel: 2, icon: '☕'),
];

const _careerHistory = <_CareerEntry>[
  _CareerEntry(role: 'Software Developer', company: 'Horizon Tech',    period: 'Cycle 31 — now', current: true),
  _CareerEntry(role: 'Sales Associate',    company: 'Caedoria Retail', period: 'Cycle 18 — 31',  current: false),
  _CareerEntry(role: 'Barista',            company: 'Volta Café',      period: 'Cycle 6 — 18',   current: false),
];

// ── ProfileScreen ─────────────────────────────────────────────────────────────

enum _ProfileView { hub, needs, skills, jobs }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  _ProfileView _view = _ProfileView.hub;

  void _to(_ProfileView v) => setState(() => _view = v);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: switch (_view) {
          _ProfileView.hub   => _ProfileHub(onOpen: _to),
          _ProfileView.needs => _NeedsDetail(onBack: () => _to(_ProfileView.hub)),
          _ProfileView.skills => _SkillsMap(onBack: () => _to(_ProfileView.hub)),
          _ProfileView.jobs  => _JobsView(onBack: () => _to(_ProfileView.hub)),
        },
      ),
    );
  }
}

// ── Hub ───────────────────────────────────────────────────────────────────────

class _ProfileHub extends ConsumerWidget {
  const _ProfileHub({required this.onOpen});
  final void Function(_ProfileView) onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider).asData?.value;
    final countryNames = ref.watch(countryNamesProvider).asData?.value ?? const {};
    final companyCount = ref.watch(playerCompanyCountProvider).asData?.value;
    final walletBal = ref.watch(walletBalanceProvider).asData?.value;
    final needs = _resolveNeeds(ref.watch(playerNeedsProvider).asData?.value);
    final skills = ref.watch(playerSkillsProvider).asData?.value;

    final avgNeed = needs.fold(0, (s, n) => s + n.value) ~/ needs.length;
    final lowestNeed = needs.reduce((a, b) => a.value < b.value ? a : b);

    final name = profile?.displayName ?? 'Alex Rivera';
    final countryName = profile == null
        ? 'Caedoria'
        : (countryNames[profile.countryId] ?? _titleCase(profile.countryId));
    final standing = profile == null ? 'Entrepreneur' : (profile.isPartner ? 'Partner' : 'Independent');
    final cyclesVal = profile?.cycleCount.toString() ?? '47';
    final companiesVal = companyCount?.toString() ?? '3';
    final netWorthVal = walletBal != null ? '\$ ${NumberFormat.compact().format(walletBal)}' : '\$847K';

    // Strongest unlocked skill for the Skills card subtitle.
    final strongest = (skills == null || skills.isEmpty)
        ? null
        : skills.where((s) => s.unlocked).fold<PlayerSkill?>(
            null, (best, s) => best == null || s.level > best.level ? s : best);
    final skillsSubtitle = strongest == null
        ? '25 skills · Management is your strongest at 72'
        : '25 skills · ${strongest.name} is your strongest at ${strongest.level}';

    return ListView(padding: const EdgeInsets.all(AppSpacing.screenH), children: [
      const SizedBox(height: AppSpacing.md),
      // Avatar
      Center(child: Container(
        width: 80, height: 80,
        decoration: BoxDecoration(
          color: AppColors.bgElevated,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.4), width: 2),
        ),
        child: const Center(child: Text('🧑', style: TextStyle(fontSize: 36))),
      )),
      const SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(name, style: AppTypography.displayM.copyWith(fontSize: 22)),
        const SizedBox(width: 8),
        _livePill(profile != null),
      ]),
      Center(child: Text('$standing · $countryName', style: AppTypography.labelCaps.copyWith(fontSize: 11))),
      const SizedBox(height: AppSpacing.x2l),

      // Stats strip
      Container(
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _StatPill(label: 'Cycles', val: cyclesVal),
          _StatPill(label: 'Companies', val: companiesVal),
          _StatPill(label: 'Net Worth', val: netWorthVal, color: AppColors.gold),
        ]),
      ),
      const SizedBox(height: 14),

      // Navigation cards
      _NavCard(
        icon: Icons.favorite_outline, color: AppColors.needHealth,
        title: 'My Needs', subtitle: 'Avg $avgNeed% · ${lowestNeed.label} lowest at ${lowestNeed.value}%',
        trailing: _RingBadge(value: avgNeed),
        onTap: () => onOpen(_ProfileView.needs),
      ),
      const SizedBox(height: 10),
      _NavCard(
        icon: Icons.auto_graph, color: AppColors.sky,
        title: 'Skills Map', subtitle: skillsSubtitle,
        onTap: () => onOpen(_ProfileView.skills),
      ),
      const SizedBox(height: 10),
      _NavCard(
        icon: Icons.work_outline, color: AppColors.gold,
        title: 'Jobs & Career', subtitle: '${_currentJob.role} · \$ ${_currentJob.salary}/cycle',
        onTap: () => onOpen(_ProfileView.jobs),
      ),
      const SizedBox(height: 14),

      // Partner program
      Container(
        decoration: BoxDecoration(
          color: AppColors.violet.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.violet.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: AppColors.violet.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(11)),
            child: const Icon(Icons.workspace_premium_outlined, color: AppColors.violet, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Partner Program', style: AppTypography.headingS.copyWith(color: AppColors.violet)),
            const SizedBox(height: 2),
            Text('2 qualifying cycles from Bronze tier.', style: AppTypography.bodyS.copyWith(fontSize: 11)),
          ])),
          const Icon(Icons.chevron_right, color: AppColors.violet, size: 18),
        ]),
      ),
      const SizedBox(height: 14),

      // Settings
      for (final item in [
        (Icons.settings_outlined, 'Settings'),
        (Icons.help_outline, 'Help & FAQ'),
        (Icons.logout, 'Sign out'),
      ])
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: ListTile(
            leading: Icon(item.$1, color: AppColors.textSecondary, size: 20),
            title: Text(item.$2, style: AppTypography.bodyS.copyWith(color: AppColors.textSecondary, fontSize: 14)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 18),
          ),
        ),
      const SizedBox(height: AppSpacing.xl),
    ]);
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.label, required this.val, this.color});
  final String label, val;
  final Color? color;
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(val, style: AppTypography.dataM.copyWith(fontSize: 18, color: color ?? AppColors.textPrimary)),
    const SizedBox(height: 2),
    Text(label, style: AppTypography.labelCaps.copyWith(fontSize: 10)),
  ]);
}

class _NavCard extends StatelessWidget {
  const _NavCard({required this.icon, required this.color, required this.title, required this.subtitle, required this.onTap, this.trailing});
  final IconData icon;
  final Color color;
  final String title, subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(11)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTypography.headingS),
            const SizedBox(height: 2),
            Text(subtitle, style: AppTypography.bodyS.copyWith(fontSize: 11)),
          ])),
          trailing ?? const Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 18),
        ]),
      ),
    );
  }
}

class _RingBadge extends StatelessWidget {
  const _RingBadge({required this.value});
  final int value;
  @override
  Widget build(BuildContext context) {
    final c = AppColors.needColor(value);
    return SizedBox(
      width: 38, height: 38,
      child: Stack(alignment: Alignment.center, children: [
        SizedBox(
          width: 38, height: 38,
          child: CircularProgressIndicator(
            value: value / 100,
            strokeWidth: 3,
            backgroundColor: AppColors.bgInput,
            valueColor: AlwaysStoppedAnimation(c),
          ),
        ),
        Text('$value', style: AppTypography.dataS.copyWith(fontSize: 11, color: c)),
      ]),
    );
  }
}

// ── Sub-screen header ─────────────────────────────────────────────────────────

class _SubHeader extends StatelessWidget {
  const _SubHeader({required this.title, required this.onBack, this.trailing});
  final String title;
  final VoidCallback onBack;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderSubtle))),
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 10, AppSpacing.screenH, 12),
      child: Row(children: [
        GestureDetector(
          onTap: onBack,
          child: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: AppColors.bgSurface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.borderSubtle)),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 16),
          ),
        ),
        const SizedBox(width: 12),
        Text(title, style: AppTypography.headingL.copyWith(fontSize: 18)),
        if (trailing != null) ...[const Spacer(), trailing!],
      ]),
    );
  }
}

// ── Needs Detail ──────────────────────────────────────────────────────────────

class _NeedsDetail extends ConsumerWidget {
  const _NeedsDetail({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(playerNeedsProvider);
    final isLive = async.asData?.value != null;
    final needs = _resolveNeeds(async.asData?.value);
    final avg = needs.fold(0, (s, n) => s + n.value) ~/ needs.length;
    return Column(children: [
      _SubHeader(title: 'My Needs', onBack: onBack, trailing: _livePill(isLive)),
      Expanded(child: ListView(padding: const EdgeInsets.all(AppSpacing.screenH), children: [
        // Overall wellbeing
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(AppRadius.hero),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(children: [
            _RingBadge(value: avg),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Overall Wellbeing', style: AppTypography.labelCaps),
              const SizedBox(height: 4),
              Text('$avg% satisfied', style: AppTypography.displayM.copyWith(fontSize: 22, color: AppColors.needColor(avg))),
              const SizedBox(height: 2),
              Text('Low needs reduce your work output and skill gain.', style: AppTypography.bodyS.copyWith(fontSize: 11)),
            ])),
          ]),
        ),
        const SizedBox(height: 16),
        for (final n in needs) _NeedDetailCard(need: n),
        const SizedBox(height: AppSpacing.x3l),
      ])),
    ]);
  }
}

class _NeedDetailCard extends StatelessWidget {
  const _NeedDetailCard({required this.need});
  final _Need need;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.needColor(need.value);
    final critical = need.value < 40;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: critical ? AppColors.crimson.withValues(alpha: 0.4) : AppColors.borderSubtle),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(children: [
        Row(children: [
          Text(need.icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(need.label, style: AppTypography.headingS),
          if (critical) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(color: AppColors.crimson.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
              child: Text('CRITICAL', style: AppTypography.labelCaps.copyWith(color: AppColors.crimson, fontSize: 9, fontWeight: FontWeight.w700)),
            ),
          ],
          const Spacer(),
          Text('${need.value}%', style: AppTypography.dataM.copyWith(fontSize: 16, color: c)),
        ]),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: SizedBox(height: 5, child: LinearProgressIndicator(
            value: need.value / 100,
            backgroundColor: AppColors.bgInput,
            valueColor: AlwaysStoppedAnimation(c),
          )),
        ),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            const Icon(Icons.trending_down, size: 12, color: AppColors.textTertiary),
            const SizedBox(width: 4),
            Text('Decays ${need.decay}', style: AppTypography.labelCaps.copyWith(fontSize: 10)),
          ]),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: c.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: c.withValues(alpha: 0.3)),
              ),
              child: Text(need.action, style: AppTypography.label.copyWith(color: c, fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
      ]),
    );
  }
}

// ── Skills Map ────────────────────────────────────────────────────────────────

class _SkillsMap extends ConsumerWidget {
  const _SkillsMap({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(playerSkillsProvider);
    final isLive = async.asData?.value != null && async.asData!.value!.isNotEmpty;
    final groups = _resolveSkillGroups(async.asData?.value);
    final all = groups.expand((g) => g.skills).toList();
    final unlocked = all.where((s) => !s.locked).length;
    final avg = unlocked == 0 ? 0 : all.where((s) => !s.locked).fold(0, (s, sk) => s + sk.level) ~/ unlocked;

    return Column(children: [
      _SubHeader(title: 'Skills Map', onBack: onBack, trailing: _livePill(isLive)),
      Expanded(child: ListView(padding: const EdgeInsets.all(AppSpacing.screenH), children: [
        // Summary
        Row(children: [
          Expanded(child: _SkillSummary(label: 'Skills Active', value: '$unlocked / ${all.length}')),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: _SkillSummary(label: 'Avg. Level', value: '$avg', color: AppColors.sky)),
        ]),
        const SizedBox(height: AppSpacing.xl),
        for (final group in groups) ...[
          Text(group.title.toUpperCase(), style: AppTypography.labelCaps.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(group.subtitle, style: AppTypography.bodyS.copyWith(fontSize: 11)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Column(children: [
              for (final s in group.skills) _SkillRow(skill: s),
            ]),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
        const SizedBox(height: AppSpacing.lg),
      ])),
    ]);
  }
}

class _SkillSummary extends StatelessWidget {
  const _SkillSummary({required this.label, required this.value, this.color = AppColors.textPrimary});
  final String label, value;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      color: AppColors.bgSurface,
      borderRadius: BorderRadius.circular(AppRadius.card),
      border: Border.all(color: AppColors.borderSubtle),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTypography.labelCaps.copyWith(fontSize: 10)),
      const SizedBox(height: 6),
      Text(value, style: AppTypography.dataM.copyWith(fontSize: 18, color: color)),
    ]),
  );
}

class _SkillRow extends StatelessWidget {
  const _SkillRow({required this.skill});
  final _Skill skill;

  @override
  Widget build(BuildContext context) {
    if (skill.locked) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(children: [
          const Icon(Icons.lock_outline, size: 14, color: AppColors.textTertiary),
          const SizedBox(width: 8),
          Expanded(child: Text(skill.name, style: AppTypography.bodyS.copyWith(fontSize: 13, color: AppColors.textTertiary))),
          Text('Needs ${skill.prereq}', style: AppTypography.labelCaps.copyWith(fontSize: 9, color: AppColors.amber)),
        ]),
      );
    }
    final c = AppColors.needColor(skill.level);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(children: [
        SizedBox(width: 130, child: Text(skill.name, style: AppTypography.bodyS.copyWith(fontSize: 12, color: AppColors.textSecondary))),
        Expanded(child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: SizedBox(height: 4, child: LinearProgressIndicator(
            value: skill.level / 100,
            backgroundColor: AppColors.bgInput,
            valueColor: AlwaysStoppedAnimation(skill.level == 0 ? AppColors.borderStrong : c),
          )),
        )),
        const SizedBox(width: 8),
        SizedBox(width: 22, child: Text('${skill.level}', textAlign: TextAlign.right, style: AppTypography.dataS.copyWith(fontSize: 11, color: skill.level == 0 ? AppColors.textTertiary : c))),
      ]),
    );
  }
}

// ── Jobs (Find Work + My Career) ──────────────────────────────────────────────

class _JobsView extends StatefulWidget {
  const _JobsView({required this.onBack});
  final VoidCallback onBack;
  @override
  State<_JobsView> createState() => _JobsViewState();
}

class _JobsViewState extends State<_JobsView> with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _SubHeader(title: 'Jobs & Career', onBack: widget.onBack),
      Container(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderSubtle))),
        child: TabBar(
          controller: _tabs,
          labelColor: AppColors.gold,
          unselectedLabelColor: AppColors.textTertiary,
          labelStyle: AppTypography.bodyS.copyWith(fontWeight: FontWeight.w600),
          unselectedLabelStyle: AppTypography.bodyS,
          indicatorColor: AppColors.gold,
          indicatorWeight: 2,
          tabs: const [Tab(text: 'Find Work'), Tab(text: 'My Career')],
        ),
      ),
      Expanded(child: TabBarView(
        controller: _tabs,
        children: const [_FindWork(), _MyCareer()],
      )),
    ]);
  }
}

class _FindWork extends StatelessWidget {
  const _FindWork();

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(AppSpacing.screenH), children: [
      Text('${_openJobs.length} OPENINGS', style: AppTypography.labelCaps.copyWith(fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      for (final job in _openJobs) _JobListing(job: job),
      const SizedBox(height: AppSpacing.x3l),
    ]);
  }
}

class _JobListing extends StatelessWidget {
  const _JobListing({required this.job});
  final _Job job;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(11), border: Border.all(color: AppColors.borderDefault)),
            child: Center(child: Text(job.icon, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(job.role, style: AppTypography.headingS),
            const SizedBox(height: 2),
            Text('${job.company} · ${job.sector}', style: AppTypography.bodyS.copyWith(fontSize: 11)),
            Text('📍 ${job.country}', style: AppTypography.labelCaps.copyWith(fontSize: 10)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('\$ ${job.salary}', style: AppTypography.dataM.copyWith(fontSize: 16, color: AppColors.gold)),
            Text('per cycle', style: AppTypography.labelCaps.copyWith(fontSize: 9)),
          ]),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppColors.bgInput, borderRadius: BorderRadius.circular(6)),
            child: Text('${job.reqSkill} · Lv ${job.reqLevel}+', style: AppTypography.label.copyWith(color: AppColors.sky, fontSize: 10)),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Application sent to ${job.company} for ${job.role}'),
              backgroundColor: AppColors.bgElevated,
              behavior: SnackBarBehavior.floating,
            )),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(8)),
              child: Text('Apply — \$ ${job.salary}/c', style: AppTypography.label.copyWith(color: AppColors.bgBase, fontWeight: FontWeight.w700)),
            ),
          ),
        ]),
      ]),
    );
  }
}

class _MyCareer extends StatelessWidget {
  const _MyCareer();

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(AppSpacing.screenH), children: [
      // Current position hero
      Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.bgElevated, AppColors.bgSurface]),
          borderRadius: BorderRadius.circular(AppRadius.hero),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.25)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('CURRENT POSITION', style: AppTypography.labelCaps.copyWith(fontWeight: FontWeight.w700)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: AppColors.emerald.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(width: 5, height: 5, decoration: const BoxDecoration(color: AppColors.emerald, shape: BoxShape.circle)),
                const SizedBox(width: 5),
                Text('Employed', style: AppTypography.label.copyWith(color: AppColors.emerald)),
              ]),
            ),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Text(_currentJob.icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_currentJob.role, style: AppTypography.headingL.copyWith(fontSize: 18)),
              Text('${_currentJob.company} · ${_currentJob.sector}', style: AppTypography.bodyS.copyWith(fontSize: 12)),
            ])),
          ]),
          const SizedBox(height: 16),
          const Divider(color: AppColors.borderSubtle, height: 1),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('SALARY', style: AppTypography.labelCaps.copyWith(fontSize: 9)),
              const SizedBox(height: 3),
              Text('\$ ${_currentJob.salary}/c', style: AppTypography.dataM.copyWith(fontSize: 16, color: AppColors.gold)),
            ])),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('DEVELOPS', style: AppTypography.labelCaps.copyWith(fontSize: 9)),
              const SizedBox(height: 3),
              Text(_currentJob.reqSkill, style: AppTypography.bodyS.copyWith(fontSize: 12, color: AppColors.sky)),
            ])),
          ]),
        ]),
      ),
      const SizedBox(height: 14),
      // Skill XP this cycle
      Container(
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('SKILL GAIN THIS CYCLE', style: AppTypography.labelCaps.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          const _XpRow(skill: 'Information Technology', from: 31, gain: 1),
          const SizedBox(height: 10),
          const _XpRow(skill: 'Management', from: 72, gain: 0),
        ]),
      ),
      const SizedBox(height: 14),
      // History
      Text('CAREER HISTORY', style: AppTypography.labelCaps.copyWith(fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      for (int i = 0; i < _careerHistory.length; i++)
        _TimelineRow(entry: _careerHistory[i], isLast: i == _careerHistory.length - 1),
      const SizedBox(height: AppSpacing.x3l),
    ]);
  }
}

class _XpRow extends StatelessWidget {
  const _XpRow({required this.skill, required this.from, required this.gain});
  final String skill;
  final int from, gain;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Text(skill, style: AppTypography.bodyS.copyWith(fontSize: 12, color: AppColors.textSecondary))),
      Text('$from', style: AppTypography.dataS.copyWith(fontSize: 12)),
      if (gain > 0) ...[
        const SizedBox(width: 6),
        const Icon(Icons.arrow_forward, size: 11, color: AppColors.emerald),
        const SizedBox(width: 6),
        Text('${from + gain}', style: AppTypography.dataS.copyWith(fontSize: 12, color: AppColors.emerald)),
        const SizedBox(width: 6),
        Text('+$gain', style: AppTypography.label.copyWith(color: AppColors.emerald, fontWeight: FontWeight.w600)),
      ] else
        Text('  no gain', style: AppTypography.labelCaps.copyWith(fontSize: 10)),
    ]);
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.entry, required this.isLast});
  final _CareerEntry entry;
  final bool isLast;
  @override
  Widget build(BuildContext context) {
    final c = entry.current ? AppColors.emerald : AppColors.borderStrong;
    return IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(children: [
        Container(
          width: 12, height: 12, margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: entry.current ? AppColors.emerald : AppColors.bgBase,
            shape: BoxShape.circle,
            border: Border.all(color: c, width: 2),
          ),
        ),
        if (!isLast) Expanded(child: Container(width: 2, color: AppColors.borderSubtle)),
      ]),
      const SizedBox(width: 12),
      Expanded(child: Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(entry.role, style: AppTypography.bodyM.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(entry.company, style: AppTypography.bodyS.copyWith(fontSize: 12)),
          const SizedBox(height: 2),
          Text(entry.period, style: AppTypography.labelCaps.copyWith(fontSize: 10)),
        ]),
      )),
    ]));
  }
}
