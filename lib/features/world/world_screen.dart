import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

// ── Data models ───────────────────────────────────────────────────────────────

class _WorldEvent {
  const _WorldEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.scope,
    required this.severity, // 1 Minor · 2 Moderate · 3 Major
    required this.cyclesLeft,
    required this.affectsMe,
    required this.summary,
    required this.icon,
    required this.effects,
  });
  final int id, severity, cyclesLeft;
  final String title, category, scope, summary, icon;
  final bool affectsMe;
  final List<String> effects;
}

class _WorldCountry {
  const _WorldCountry({
    required this.id,
    required this.name,
    required this.region,
    required this.tier,
    required this.living,
    required this.tax,
    required this.wage,
    required this.advantage,
    required this.tags,
    this.isHome = false,
  });
  final String id, name, region, tier, living, tax, wage, advantage;
  final List<String> tags;
  final bool isHome;
}

// ── Mock data ─────────────────────────────────────────────────────────────────

const _events = <_WorldEvent>[
  _WorldEvent(
    id: 1, title: 'Labor Strike', category: 'Labor', scope: 'Caedoria', severity: 3,
    cyclesLeft: 3, affectsMe: true, icon: '✊',
    summary: 'Workers across Caedoria have walked out, demanding higher wages. Output is throttled until the dispute resolves.',
    effects: ['Production −30% in Caedoria', 'Salary demands +12%', 'Resolves faster with high Negotiation'],
  ),
  _WorldEvent(
    id: 2, title: 'Technology Generation Shift', category: 'Technology', scope: 'Global', severity: 2,
    cyclesLeft: 5, affectsMe: true, icon: '💻',
    summary: 'A new hardware generation just shipped. Last-gen electronics inventory is losing value fast.',
    effects: ['Electronics resale −18%', 'Tech demand +25%', 'Restock at new cost basis'],
  ),
  _WorldEvent(
    id: 3, title: 'Logistics Disruption', category: 'Supply Chain', scope: 'Western', severity: 2,
    cyclesLeft: 2, affectsMe: false, icon: '🚧',
    summary: 'Freight corridors through the Western region are congested. Cross-country deliveries are delayed.',
    effects: ['Delivery time +1 cycle', 'Logistics surcharge +15%', 'Spoilage risk elevated'],
  ),
  _WorldEvent(
    id: 4, title: 'Fashion Shift', category: 'Fashion', scope: 'Global', severity: 1,
    cyclesLeft: 4, affectsMe: false, icon: '👗',
    summary: 'Consumer taste has moved. Clothing stocked to the old trend now sells at a discount.',
    effects: ['Out-of-trend apparel −10%', 'On-trend apparel +20%', 'Design & Aesthetics softens loss'],
  ),
  _WorldEvent(
    id: 5, title: 'Local Health Outbreak', category: 'Health', scope: 'Vareth', severity: 3,
    cyclesLeft: 6, affectsMe: false, icon: '🏥',
    summary: 'A health outbreak in Vareth is spiking demand for pharmacy and healthcare services.',
    effects: ['Pharmacy demand +40%', 'Workforce availability −15%', 'Health needs decay faster'],
  ),
  _WorldEvent(
    id: 6, title: 'Construction Boom', category: 'Natural', scope: 'Dalthorn', severity: 1,
    cyclesLeft: 7, affectsMe: false, icon: '🏗',
    summary: 'Public infrastructure investment in Dalthorn is driving a construction boom.',
    effects: ['Construction contracts +30%', 'Raw material demand +20%', 'Property values rising'],
  ),
  _WorldEvent(
    id: 7, title: 'Interest Rate Hike', category: 'Financial', scope: 'Global', severity: 2,
    cyclesLeft: 3, affectsMe: true, icon: '🏦',
    summary: 'The Central Bank raised base rates. New loans cost more; deposit yields improve.',
    effects: ['New loan rates +2%', 'Deposit yields +1.5%', 'Stock valuations compress'],
  ),
];

const _categories = ['All', 'Technology', 'Health', 'Fashion', 'Supply Chain', 'Financial', 'Labor', 'Natural', 'Regulatory'];

const _countries = <_WorldCountry>[
  _WorldCountry(id: 'caedoria', name: 'Caedoria', region: 'Central', tier: 'Industrial', living: '\$ 1,200', tax: '12%', wage: 'Medium', advantage: 'Food & Logistics', tags: ['Industrial', 'Low logistics cost', 'Medium wages'], isHome: true),
  _WorldCountry(id: 'nova',     name: 'Nova',     region: 'Central', tier: 'Starter',    living: '\$ 950',   tax: '10%', wage: 'Medium', advantage: 'Balanced',         tags: ['Balanced economy', 'Low competition', 'All sectors']),
  _WorldCountry(id: 'korr',     name: 'Korr',     region: 'Western', tier: 'Industrial', living: '\$ 800',   tax: '8%',  wage: 'Low',    advantage: 'Manufacturing',    tags: ['Manufacturing hub', 'Cheap labor', 'Resource-rich']),
  _WorldCountry(id: 'valen',    name: 'Valen',    region: 'Central', tier: 'Finance',    living: '\$ 1,800', tax: '18%', wage: 'High',   advantage: 'Finance',          tags: ['Finance hub', 'Strict regulation', 'High wages']),
  _WorldCountry(id: 'aurel',    name: 'Aurel',    region: 'Northern', tier: 'Premium',   living: '\$ 2,400', tax: '22%', wage: 'High',   advantage: 'Luxury Retail',    tags: ['Luxury market', 'High spending', 'Elite workforce']),
  _WorldCountry(id: 'kethos',   name: 'Kethos',   region: 'Eastern', tier: 'Mining',     living: '\$ 780',   tax: '7%',  wage: 'Low',    advantage: 'Mining',           tags: ['Mining', 'Metals & minerals', 'Low infrastructure']),
  _WorldCountry(id: 'solven',   name: 'Solven',   region: 'Central', tier: 'Pharma',     living: '\$ 1,500', tax: '14%', wage: 'High',   advantage: 'Pharmaceutical',   tags: ['Pharmaceutical', 'Healthcare', 'Skilled workforce']),
  _WorldCountry(id: 'pella',    name: 'Pella',    region: 'Eastern', tier: 'Tech',       living: '\$ 1,600', tax: '12%', wage: 'High',   advantage: 'Technology',       tags: ['Tech hub', 'High spending', 'Talent pool']),
  _WorldCountry(id: 'tyrn',     name: 'Tyrn',     region: 'Southern', tier: 'Frontier',  living: '\$ 750',   tax: '5%',  wage: 'Low',    advantage: 'Frontier',         tags: ['Raw frontier', '3 resources', 'Lowest tax']),
  _WorldCountry(id: 'dalthorn', name: 'Dalthorn', region: 'Western', tier: 'Resource',   living: '\$ 1,000', tax: '11%', wage: 'Medium', advantage: 'Construction',     tags: ['Resource-rich', 'Construction', 'Medium tax']),
  _WorldCountry(id: 'ventrex',  name: 'Ventrex',  region: 'Northern', tier: 'Finance',   living: '\$ 1,900', tax: '15%', wage: 'High',   advantage: 'Finance',          tags: ['High wages', 'Finance presence', 'Low tax']),
  _WorldCountry(id: 'morrath',  name: 'Morrath',  region: 'Northern', tier: 'Industrial', living: '\$ 820',  tax: '9%',  wage: 'Low',    advantage: 'Heavy Industry',   tags: ['Heavy industry', 'Low wages', 'Union-heavy']),
  _WorldCountry(id: 'brimark',  name: 'Brimark',  region: 'Central', tier: 'Logistics',  living: '\$ 1,300', tax: '12%', wage: 'Medium', advantage: 'Logistics',        tags: ['Logistics hub', 'Central location', 'Medium wages']),
  _WorldCountry(id: 'vareth',   name: 'Vareth',   region: 'Eastern', tier: 'Health',     living: '\$ 1,450', tax: '13%', wage: 'Medium', advantage: 'Healthcare',       tags: ['Healthcare', 'Pharmaceutical demand', 'Stable economy']),
  _WorldCountry(id: 'orvalle',  name: 'Orvalle',  region: 'Southern', tier: 'Mining',    living: '\$ 760',   tax: '8%',  wage: 'Low',    advantage: 'Mining',           tags: ['Mining', 'Raw materials', 'Low wages']),
  _WorldCountry(id: 'quelmont', name: 'Quelmont', region: 'Western', tier: 'Education',  living: '\$ 1,700', tax: '16%', wage: 'High',   advantage: 'Education',        tags: ['Education', 'Skilled workforce', 'High wages']),
  _WorldCountry(id: 'soltarn',  name: 'Soltarn',  region: 'Eastern', tier: 'Service',    living: '\$ 1,350', tax: '13%', wage: 'Medium', advantage: 'Hospitality',      tags: ['Tourism', 'Entertainment', 'Service economy']),
  _WorldCountry(id: 'halveth',  name: 'Halveth',  region: 'Southern', tier: 'Offshore',  living: '\$ 1,850', tax: '8%',  wage: 'High',   advantage: 'Offshore Finance', tags: ['Offshore banking', '8% tax', 'International']),
];

const _regions = ['All', 'Northern', 'Central', 'Western', 'Eastern', 'Southern'];

// ── Helpers ───────────────────────────────────────────────────────────────────

({String label, Color color}) _severityMeta(int s) {
  switch (s) {
    case 3:  return (label: 'MAJOR',    color: AppColors.crimson);
    case 2:  return (label: 'MODERATE', color: AppColors.amber);
    default: return (label: 'MINOR',    color: AppColors.sky);
  }
}

const _regionColors = <String, Color>{
  'Northern': AppColors.sky,
  'Central':  AppColors.gold,
  'Western':  AppColors.violet,
  'Eastern':  Color(0xFF4AE8C9),
  'Southern': AppColors.amber,
};

// ── WorldScreen ───────────────────────────────────────────────────────────────

class WorldScreen extends StatefulWidget {
  const WorldScreen({super.key});

  @override
  State<WorldScreen> createState() => _WorldScreenState();
}

class _WorldScreenState extends State<WorldScreen> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, AppSpacing.md, AppSpacing.screenH, AppSpacing.md),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('The World', style: AppTypography.displayM.copyWith(fontSize: 24)),
                const SizedBox(height: 2),
                Text('18 countries · one shared economy', style: AppTypography.labelCaps),
              ]),
              Semantics(
                label: 'Open notifications',
                button: true,
                child: GestureDetector(
                  onTap: () => context.push('/notifications'),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.bgSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary, size: 18),
                  ),
                ),
              ),
            ]),
          ),
          // Tabs
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
              tabs: const [Tab(text: 'Events'), Tab(text: 'Countries')],
            ),
          ),
          Expanded(child: TabBarView(
            controller: _tabs,
            children: const [_EventsFeed(), _CountryBrowser()],
          )),
        ]),
      ),
    );
  }
}

// ── Events Feed ───────────────────────────────────────────────────────────────

class _EventsFeed extends StatefulWidget {
  const _EventsFeed();
  @override
  State<_EventsFeed> createState() => _EventsFeedState();
}

class _EventsFeedState extends State<_EventsFeed> {
  String _cat = 'All';

  @override
  Widget build(BuildContext context) {
    final filtered = _events.where((e) => _cat == 'All' || e.category == _cat).toList()
      ..sort((a, b) => b.severity.compareTo(a.severity));
    final affecting = _events.where((e) => e.affectsMe).length;

    return Column(children: [
      // Summary strip
      Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH, vertical: 14),
        decoration: const BoxDecoration(
          color: AppColors.bgSurface,
          border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
        ),
        child: Row(children: [
          _SummaryStat(label: 'Active', value: '${_events.length}'),
          _VDivider(),
          _SummaryStat(label: 'Affecting You', value: '$affecting', valueColor: AppColors.amber),
          _VDivider(),
          _SummaryStat(label: 'Global', value: '${_events.where((e) => e.scope == 'Global').length}'),
        ]),
      ),
      // Category chips
      SizedBox(
        height: 54,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH, vertical: 12),
          children: [
            for (final c in _categories) ...[
              _FilterChip(label: c, active: _cat == c, onTap: () => setState(() => _cat = c)),
              const SizedBox(width: 6),
            ],
          ],
        ),
      ),
      // List
      Expanded(child: filtered.isEmpty
          ? const _Empty(icon: Icons.event_busy, message: 'No events in this category')
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 4, AppSpacing.screenH, AppSpacing.x3l),
              itemCount: filtered.length,
              itemBuilder: (_, i) => _EventCard(event: filtered[i]),
            )),
    ]);
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});
  final _WorldEvent event;

  @override
  Widget build(BuildContext context) {
    final sev = _severityMeta(event.severity);
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _EventDetailSheet(event: event),
      ),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: event.affectsMe ? sev.color.withValues(alpha: 0.45) : AppColors.borderSubtle),
          boxShadow: event.affectsMe ? [BoxShadow(color: sev.color.withValues(alpha: 0.06), blurRadius: 16)] : [],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Center(child: Text(event.icon, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: sev.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
                child: Text(sev.label, style: AppTypography.labelCaps.copyWith(color: sev.color, fontSize: 9, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 6),
              Text('${event.category} · ${event.scope}', style: AppTypography.labelCaps.copyWith(fontSize: 11)),
            ]),
            const SizedBox(height: 5),
            Text(event.title, style: AppTypography.headingS.copyWith(
              color: event.affectsMe ? AppColors.textPrimary : AppColors.textSecondary,
            )),
            const SizedBox(height: 3),
            Text(event.summary, style: AppTypography.bodyS.copyWith(fontSize: 11, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
            if (event.affectsMe) ...[
              const SizedBox(height: 6),
              Row(children: [
                Icon(Icons.warning_amber_rounded, size: 11, color: sev.color),
                const SizedBox(width: 4),
                Text('Affecting your companies', style: AppTypography.labelCaps.copyWith(color: sev.color, fontSize: 11)),
              ]),
            ],
          ])),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(6)),
            child: Column(children: [
              Text('${event.cyclesLeft}', style: AppTypography.dataM.copyWith(fontSize: 15)),
              Text('cycles', style: AppTypography.labelCaps.copyWith(fontSize: 9)),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _EventDetailSheet extends StatelessWidget {
  const _EventDetailSheet({required this.event});
  final _WorldEvent event;

  @override
  Widget build(BuildContext context) {
    final sev = _severityMeta(event.severity);
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
      ),
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 12, AppSpacing.screenH, 32),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.borderStrong, borderRadius: BorderRadius.circular(2)))),
        const SizedBox(height: 18),
        Row(children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(13), border: Border.all(color: AppColors.borderDefault)),
            child: Center(child: Text(event.icon, style: const TextStyle(fontSize: 26))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(event.title, style: AppTypography.headingL),
            Text('${event.category} · ${event.scope}', style: AppTypography.bodyM.copyWith(color: AppColors.textSecondary)),
          ])),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: sev.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6), border: Border.all(color: sev.color.withValues(alpha: 0.3))),
            child: Text('${sev.label} SEVERITY', style: AppTypography.label.copyWith(color: sev.color, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(6)),
            child: Text('${event.cyclesLeft} cycles left', style: AppTypography.dataS.copyWith(fontSize: 12)),
          ),
        ]),
        const SizedBox(height: 16),
        Text(event.summary, style: AppTypography.bodyM.copyWith(color: AppColors.textPrimary, height: 1.5)),
        const SizedBox(height: 18),
        Text('EFFECTS', style: AppTypography.labelCaps.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        for (final fx in event.effects)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.arrow_right_alt, size: 16, color: sev.color),
              const SizedBox(width: 8),
              Expanded(child: Text(fx, style: AppTypography.bodyM.copyWith(color: AppColors.textSecondary, fontSize: 13))),
            ]),
          ),
      ]),
    );
  }
}

// ── Country Browser ───────────────────────────────────────────────────────────

class _CountryBrowser extends StatefulWidget {
  const _CountryBrowser();
  @override
  State<_CountryBrowser> createState() => _CountryBrowserState();
}

class _CountryBrowserState extends State<_CountryBrowser> {
  String _region = 'All';

  @override
  Widget build(BuildContext context) {
    final filtered = _countries.where((c) => _region == 'All' || c.region == _region).toList();

    return Column(children: [
      SizedBox(
        height: 54,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH, vertical: 12),
          children: [
            for (final r in _regions) ...[
              _FilterChip(
                label: r,
                active: _region == r,
                accent: _regionColors[r] ?? AppColors.gold,
                onTap: () => setState(() => _region = r),
              ),
              const SizedBox(width: 6),
            ],
          ],
        ),
      ),
      Expanded(child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 4, AppSpacing.screenH, AppSpacing.x3l),
        itemCount: filtered.length,
        itemBuilder: (_, i) => _CountryCard(country: filtered[i]),
      )),
    ]);
  }
}

class _CountryCard extends StatelessWidget {
  const _CountryCard({required this.country});
  final _WorldCountry country;

  @override
  Widget build(BuildContext context) {
    final rc = _regionColors[country.region] ?? AppColors.gold;
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _CountryDetailSheet(country: country),
      ),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: country.isHome ? AppColors.gold.withValues(alpha: 0.4) : AppColors.borderSubtle),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(country.name, style: AppTypography.headingS.copyWith(
                  fontWeight: FontWeight.w700,
                  color: country.isHome ? AppColors.gold : AppColors.textPrimary,
                )),
                const SizedBox(width: 7),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(color: rc.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4), border: Border.all(color: rc.withValues(alpha: 0.3))),
                  child: Text(country.region.toUpperCase(), style: AppTypography.labelCaps.copyWith(fontSize: 9, fontWeight: FontWeight.w600, color: rc)),
                ),
                if (country.isHome) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
                    child: Text('HOME', style: AppTypography.labelCaps.copyWith(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.gold)),
                  ),
                ],
              ]),
              const SizedBox(height: 3),
              Text('${country.tier} · advantage: ${country.advantage}', style: AppTypography.bodyS.copyWith(fontSize: 11)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(country.living, style: AppTypography.dataS.copyWith(fontSize: 13, color: AppColors.gold)),
              Text('living/cycle', style: AppTypography.labelCaps.copyWith(fontSize: 9)),
            ]),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            _MiniMetric(label: 'Tax', value: country.tax),
            const SizedBox(width: 16),
            _MiniMetric(label: 'Wages', value: country.wage),
          ]),
        ]),
      ),
    );
  }
}

class _CountryDetailSheet extends StatelessWidget {
  const _CountryDetailSheet({required this.country});
  final _WorldCountry country;

  @override
  Widget build(BuildContext context) {
    final rc = _regionColors[country.region] ?? AppColors.gold;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
      ),
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 12, AppSpacing.screenH, 32),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.borderStrong, borderRadius: BorderRadius.circular(2)))),
        const SizedBox(height: 18),
        Row(children: [
          Text(country.name, style: AppTypography.displayM.copyWith(fontSize: 26)),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: rc.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6), border: Border.all(color: rc.withValues(alpha: 0.3))),
            child: Text(country.region, style: AppTypography.label.copyWith(color: rc, fontWeight: FontWeight.w600)),
          ),
        ]),
        const SizedBox(height: 4),
        Text('${country.tier} economy', style: AppTypography.bodyM),
        const SizedBox(height: 18),
        // Metrics grid
        Row(children: [
          Expanded(child: _DetailMetric(label: 'Cost of Living', value: '${country.living}/c', color: AppColors.gold)),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: _DetailMetric(label: 'Income Tax', value: country.tax, color: AppColors.textPrimary)),
        ]),
        const SizedBox(height: AppSpacing.md),
        Row(children: [
          Expanded(child: _DetailMetric(label: 'Wage Level', value: country.wage, color: AppColors.textPrimary)),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: _DetailMetric(label: 'Advantage', value: country.advantage, color: AppColors.emerald)),
        ]),
        const SizedBox(height: 18),
        Text('CHARACTERISTICS', style: AppTypography.labelCaps.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Wrap(spacing: 6, runSpacing: 6, children: country.tags.map((t) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: AppColors.bgInput, borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.borderSubtle)),
          child: Text(t, style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
        )).toList()),
        const SizedBox(height: 18),
        if (country.isHome)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.gold.withValues(alpha: 0.25))),
            child: Row(children: [
              const Icon(Icons.home_rounded, color: AppColors.gold, size: 18),
              const SizedBox(width: 10),
              Expanded(child: Text('You live and operate here. Relocating moves your residence and job market.', style: AppTypography.bodyS.copyWith(fontSize: 12))),
            ]),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderDefault)),
            child: Row(children: [
              const Icon(Icons.public, color: AppColors.sky, size: 18),
              const SizedBox(width: 10),
              Expanded(child: Text('Expand here by founding a company. Cross-country trade adds a logistics surcharge.', style: AppTypography.bodyS.copyWith(fontSize: 12))),
            ]),
          ),
      ]),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({required this.label, required this.value, this.valueColor = AppColors.textPrimary});
  final String label, value;
  final Color valueColor;
  @override
  Widget build(BuildContext context) => Expanded(child: Column(children: [
    Text(value, style: AppTypography.dataS.copyWith(color: valueColor, fontSize: 16)),
    const SizedBox(height: 2),
    Text(label, style: AppTypography.labelCaps.copyWith(fontSize: 10)),
  ]));
}

class _VDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 28, color: AppColors.borderSubtle, margin: const EdgeInsets.symmetric(horizontal: 8));
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.active, required this.onTap, this.accent = AppColors.gold});
  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color accent;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? accent.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? accent : AppColors.borderDefault),
        ),
        child: Text(label, style: AppTypography.label.copyWith(
          color: active ? accent : AppColors.textTertiary,
          fontWeight: FontWeight.w600,
        )),
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Row(children: [
    Text('$label ', style: AppTypography.labelCaps.copyWith(fontSize: 10)),
    Text(value, style: AppTypography.dataS.copyWith(fontSize: 12, color: AppColors.textSecondary)),
  ]);
}

class _DetailMetric extends StatelessWidget {
  const _DetailMetric({required this.label, required this.value, required this.color});
  final String label, value;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      color: AppColors.bgElevated,
      borderRadius: BorderRadius.circular(AppRadius.card),
      border: Border.all(color: AppColors.borderDefault),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTypography.labelCaps.copyWith(fontSize: 10)),
      const SizedBox(height: 6),
      Text(value, style: AppTypography.dataS.copyWith(fontSize: 14, color: color)),
    ]),
  );
}

class _Empty extends StatelessWidget {
  const _Empty({required this.icon, required this.message});
  final IconData icon;
  final String message;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: AppColors.textTertiary, size: 40),
      const SizedBox(height: 12),
      Text(message, style: AppTypography.bodyM.copyWith(color: AppColors.textTertiary)),
    ]),
  );
}
