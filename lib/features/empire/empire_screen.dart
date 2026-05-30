import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

// ── Data models ───────────────────────────────────────────────────────────────

class _SectorData {
  const _SectorData({required this.id, required this.icon, required this.name, required this.desc, required this.cap, required this.diff});
  final String id, icon, name, desc, cap;
  final int diff;
}

class _TypeData {
  const _TypeData({required this.id, required this.icon, required this.name, required this.desc, required this.cap, required this.diff});
  final String id, icon, name, desc, cap;
  final int diff;
}

class _CountryData {
  const _CountryData({required this.id, required this.name, required this.region, required this.tags, required this.living});
  final String id, name, region, living;
  final List<String> tags;
}

class _PropertyData {
  const _PropertyData({required this.id, required this.name, required this.size, required this.sqm, required this.rent, required this.location, required this.dist});
  final int id, sqm, rent;
  final String name, size, location, dist;
}

const _sectors = [
  _SectorData(id: 'food',         icon: '🍽',  name: 'Food & Hospitality',        desc: 'Restaurants, cafés, catering, food production',    cap: '\$15K–80K',   diff: 1),
  _SectorData(id: 'logistics',    icon: '🚚',  name: 'Logistics & Transport',      desc: 'Delivery companies, freight, warehousing',         cap: '\$20K–60K',   diff: 2),
  _SectorData(id: 'retail',       icon: '🛍',  name: 'Retail',                     desc: 'Stores, electronics, clothing, pharmacy',          cap: '\$12K–50K',   diff: 1),
  _SectorData(id: 'construction', icon: '🏗',  name: 'Construction & Real Estate', desc: 'Building, property sales, management, storage',    cap: '\$40K–200K',  diff: 3),
  _SectorData(id: 'finance',      icon: '💰',  name: 'Finance',                    desc: 'Banking, investment, insurance, accounting',       cap: '\$100K+',     diff: 3),
  _SectorData(id: 'professional', icon: '⚖️', name: 'Professional Services',      desc: 'Legal firms & recruitment agencies',               cap: '\$10K–30K',   diff: 2),
  _SectorData(id: 'manufacturing',icon: '🏭',  name: 'Manufacturing',              desc: 'Electronics, textiles, pharmaceutical production', cap: '\$80K–300K',  diff: 3),
  _SectorData(id: 'technology',   icon: '💻',  name: 'Technology',                 desc: 'IT services, software, data analytics',            cap: '\$15K–60K',   diff: 2),
  _SectorData(id: 'education',    icon: '🎓',  name: 'Education & Training',       desc: 'Skill training centers, corporate programs',       cap: '\$8K–25K',    diff: 1),
  _SectorData(id: 'holding',      icon: '🏢',  name: 'Holding Company',            desc: 'Manage subsidiaries, consolidate ownership',       cap: '\$50K+',      diff: 3),
];

const _foodTypes = [
  _TypeData(id: 'restaurant', icon: '🍽',  name: 'Restaurant',         desc: 'Full-service dining. High revenue ceiling, high management complexity.',   cap: '\$40K–80K',  diff: 2),
  _TypeData(id: 'cafe',       icon: '☕',  name: 'Café',               desc: 'Coffee & light food. Lower entry cost, loyal repeat customer base.',       cap: '\$15K–30K',  diff: 1),
  _TypeData(id: 'catering',   icon: '🍱',  name: 'Catering Company',   desc: 'Event-based revenue. No fixed costs between contracts. Unpredictable.',   cap: '\$20K–40K',  diff: 2),
  _TypeData(id: 'food_mfg',   icon: '🏭',  name: 'Food Manufacturing', desc: 'B2B production. Supplies restaurants and supermarkets at scale.',         cap: '\$50K–120K', diff: 3),
  _TypeData(id: 'supermarket',icon: '🛒',  name: 'Supermarket',        desc: 'High-volume retail. Inventory management is the core challenge.',         cap: '\$60K–150K', diff: 3),
];

const _retailTypes = [
  _TypeData(id: 'general',    icon: '🏪',  name: 'General Store',     desc: 'Mixed inventory. Serves basic player needs. Low barrier to entry.',      cap: '\$12K–25K',  diff: 1),
  _TypeData(id: 'electronics',icon: '📱',  name: 'Electronics Store', desc: 'High-value items. Inventory risk. Premium margin with right supplier.',  cap: '\$30K–50K',  diff: 2),
  _TypeData(id: 'clothing',   icon: '👗',  name: 'Clothing Store',    desc: 'Affects player Charisma. Fashion cycle risk. Strong repeat demand.',      cap: '\$20K–40K',  diff: 2),
  _TypeData(id: 'pharmacy',   icon: '💊',  name: 'Pharmacy',          desc: 'Inelastic demand. Price ceiling enforced. Pharmacist gating mechanic.',  cap: '\$15K–30K',  diff: 2),
];

const _countries = [
  _CountryData(id: 'caedoria', name: 'Caedoria',  region: 'Central', tags: ['Industrial', 'Low logistics cost', 'Medium wages'],  living: '\$1,200/cycle'),
  _CountryData(id: 'ventrex',  name: 'Ventrex',   region: 'Northern', tags: ['High wages', 'Finance hub', 'Low tax'],              living: '\$1,800/cycle'),
  _CountryData(id: 'dalthorn', name: 'Dalthorn',  region: 'Western',  tags: ['Manufacturing', 'Resource-rich', 'Medium tax'],      living: '\$1,000/cycle'),
  _CountryData(id: 'sorvane',  name: 'Sorvane',   region: 'Southern', tags: ['Retail strength', 'Tourism', 'High wages'],          living: '\$1,600/cycle'),
  _CountryData(id: 'eltria',   name: 'Eltria',    region: 'Eastern',  tags: ['Tech hub', 'Low tax', 'Talent pool'],                living: '\$1,400/cycle'),
];

const _propertiesMap = {
  'caedoria': [
    _PropertyData(id: 1, name: 'High Street Unit A',    size: 'Small',  sqm: 30,  rent: 500,  location: 'Central Caedoria',  dist: '2 min to CC offices'),
    _PropertyData(id: 2, name: 'Market Square Corner',  size: 'Medium', sqm: 55,  rent: 800,  location: 'Market District',   dist: '5 min to CC offices'),
    _PropertyData(id: 3, name: 'Business Park Suite 4', size: 'Large',  sqm: 120, rent: 1200, location: 'East Caedoria',     dist: '12 min to CC offices'),
  ],
  'ventrex': [
    _PropertyData(id: 4, name: 'Finance Quarter Unit',  size: 'Small',  sqm: 28,  rent: 700,  location: 'Downtown Ventrex',  dist: '1 min to CC offices'),
    _PropertyData(id: 5, name: 'Commerce Plaza A2',     size: 'Medium', sqm: 60,  rent: 1100, location: 'Commerce District', dist: '3 min to CC offices'),
  ],
  'dalthorn': [
    _PropertyData(id: 6, name: 'Industrial Park Bay 7', size: 'Large',  sqm: 200, rent: 900,  location: 'Industrial Zone',   dist: '8 min to CC offices'),
    _PropertyData(id: 7, name: 'Town Centre Unit',      size: 'Small',  sqm: 32,  rent: 420,  location: 'Town Centre',       dist: '4 min to CC offices'),
  ],
};

List<_TypeData> _typesFor(_SectorData? sector) {
  if (sector == null) return [];
  switch (sector.id) {
    case 'food': return _foodTypes;
    case 'retail': return _retailTypes;
    default: return [_TypeData(id: 'standard', icon: sector.icon, name: 'Standard ${sector.name}', desc: 'Full company type details in design doc.', cap: sector.cap, diff: 2)];
  }
}

List<_PropertyData> _propertiesFor(String? countryId) {
  return _propertiesMap[countryId] ?? _propertiesMap['caedoria']!;
}

// ── EmpireScreen ─────────────────────────────────────────────────────────────

enum _EmpireView { dashboard, wizard }

class EmpireScreen extends StatefulWidget {
  const EmpireScreen({super.key});

  @override
  State<EmpireScreen> createState() => _EmpireScreenState();
}

class _EmpireScreenState extends State<EmpireScreen> {
  _EmpireView _view = _EmpireView.dashboard;
  _CompanyResult? _newCompany;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Stack(children: [
        // Dashboard layer
        AnimatedOpacity(
          duration: const Duration(milliseconds: 320),
          opacity: _view == _EmpireView.dashboard ? 1 : 0,
          child: IgnorePointer(
            ignoring: _view != _EmpireView.dashboard,
            child: _EmpireDashboard(
              newCompany: _newCompany,
              onNewCompany: () => setState(() => _view = _EmpireView.wizard),
            ),
          ),
        ),
        // Wizard layer
        AnimatedSlide(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeInOut,
          offset: _view == _EmpireView.wizard ? Offset.zero : const Offset(1, 0),
          child: IgnorePointer(
            ignoring: _view != _EmpireView.wizard,
            child: _CompanyWizard(
              onClose: () => setState(() => _view = _EmpireView.dashboard),
              onComplete: (result) => setState(() {
                _newCompany = result;
                _view = _EmpireView.dashboard;
              }),
            ),
          ),
        ),
      ]),
    );
  }
}

// ── Company result ─────────────────────────────────────────────────────────

class _CompanyResult {
  _CompanyResult({required this.name, required this.icon});
  final String name, icon;
}

// ── Empire Dashboard ──────────────────────────────────────────────────────────

class _EmpireDashboard extends StatelessWidget {
  const _EmpireDashboard({required this.onNewCompany, this.newCompany});
  final VoidCallback onNewCompany;
  final _CompanyResult? newCompany;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, AppSpacing.md, AppSpacing.screenH, AppSpacing.md),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Good morning', style: AppTypography.labelCaps),
              const SizedBox(height: 2),
              Text('Alex Rivera', style: AppTypography.headingM),
            ]),
            Row(children: [
              GestureDetector(
                onTap: () => context.go('/empire/stocks'),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.bgSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: const Icon(Icons.bar_chart, color: AppColors.textPrimary, size: 18),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary, size: 18),
              ),
            ]),
          ]),
        ),
        // Net worth pill
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 0, AppSpacing.screenH, AppSpacing.xl),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(AppRadius.hero),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Net Worth', style: AppTypography.labelCaps),
              const SizedBox(height: 6),
              RichText(text: TextSpan(children: [
                TextSpan(text: '\$ ', style: AppTypography.displayL.copyWith(color: AppColors.gold)),
                TextSpan(text: newCompany != null ? '855,200' : '847,320', style: AppTypography.displayL),
              ])),
              const SizedBox(height: 6),
              Text(
                '+\$ ${newCompany != null ? '7,880' : '12,400'} since last cycle',
                style: AppTypography.dataS.copyWith(color: AppColors.emerald),
              ),
            ]),
          ),
        ),
        // Companies header
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 0, AppSpacing.screenH, AppSpacing.md),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('My Companies', style: AppTypography.labelCaps),
            Text('3 total', style: AppTypography.label.copyWith(color: AppColors.gold)),
          ]),
        ),
        // Company cards
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
            children: [
              _MiniCompanyCard(id: 1, name: 'Volta Café',      type: 'Café',        revenue: 4200,  icon: '☕', status: 'good'),
              const SizedBox(width: 12),
              _MiniCompanyCard(id: 2, name: 'Volta Foods',     type: 'Food Mfg',    revenue: -800,  icon: '🏭', status: 'warning'),
              const SizedBox(width: 12),
              _MiniCompanyCard(id: 3, name: 'Caedoria Retail', type: 'Electronics', revenue: 3100,  icon: '📱', status: 'good'),
              if (newCompany != null) ...[
                const SizedBox(width: 12),
                _MiniCompanyCard(id: 0, name: newCompany!.name, type: 'Café', revenue: 0, icon: newCompany!.icon, status: 'new'),
              ] else ...[
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: onNewCompany,
                  child: Container(
                    width: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(color: AppColors.borderStrong),
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.borderStrong)),
                        child: const Icon(Icons.add, color: AppColors.gold, size: 20),
                      ),
                      const SizedBox(height: 8),
                      Text('Start new company', style: AppTypography.labelCaps.copyWith(fontSize: 11), textAlign: TextAlign.center),
                    ]),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        // CTA button
        if (newCompany == null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
            child: GestureDetector(
              onTap: onNewCompany,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.gold.withOpacity(0.25)),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('🏢', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text('Create a new company', style: AppTypography.headingS.copyWith(color: AppColors.gold)),
                ]),
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.xl),
      ]),
    );
  }
}

class _MiniCompanyCard extends StatelessWidget {
  const _MiniCompanyCard({required this.id, required this.name, required this.type, required this.revenue, required this.icon, required this.status});
  final int id, revenue;
  final String name, type, icon, status;

  @override
  Widget build(BuildContext context) {
    final pos = revenue >= 0;
    final borderColor = status == 'warning'
        ? AppColors.amber.withValues(alpha: 0.4)
        : AppColors.borderSubtle;

    return GestureDetector(
      onTap: id > 0 ? () => context.go('/empire/company/$id') : null,
      child: Container(
        width: 186,
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 6),
          Text(name, style: AppTypography.bodyS.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary, fontSize: 13)),
          Text(type, style: AppTypography.labelCaps.copyWith(fontSize: 11)),
          const SizedBox(height: AppSpacing.md),
          Text(
            status == 'new' ? '● Just launched' :
            '${pos ? '+' : '−'}\$ ${NumberFormat.decimalPattern().format(revenue.abs())}',
            style: status == 'new'
                ? AppTypography.dataS.copyWith(color: AppColors.emerald, fontSize: 10)
                : AppTypography.dataM.copyWith(fontSize: 17, color: pos ? AppColors.emerald : AppColors.crimson),
          ),
        ]),
      ),
    );
  }
}

// ── 5-Step Company Wizard ─────────────────────────────────────────────────────

class _CompanyWizard extends StatefulWidget {
  const _CompanyWizard({required this.onClose, required this.onComplete});
  final VoidCallback onClose;
  final ValueChanged<_CompanyResult> onComplete;

  @override
  State<_CompanyWizard> createState() => _CompanyWizardState();
}

class _CompanyWizardState extends State<_CompanyWizard> {
  int _step = 1;
  _SectorData? _sector;
  _TypeData? _type;
  _CountryData _country = _countries.first;
  _PropertyData? _property;
  String _name = '';
  bool _launching = false;
  bool _launched = false;

  bool get _canContinue {
    switch (_step) {
      case 1: return _sector != null;
      case 2: return _type != null;
      case 3: return _property != null;
      case 4: return true;
      case 5: return _name.trim().length >= 2;
      default: return false;
    }
  }

  void _handleContinue() {
    if (_step < 5) {
      setState(() => _step++);
    } else {
      setState(() => _launching = true);
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) setState(() { _launching = false; _launched = true; });
      });
    }
  }

  void _handleBack() {
    if (_step == 1) { widget.onClose(); }
    else { setState(() => _step--); }
  }

  static const _stepTitles = ['', 'Choose Sector', 'Company Type', 'Location', 'Review Costs', 'Name & Launch'];

  @override
  Widget build(BuildContext context) {
    if (_launched) {
      return _WizardSuccess(
        name: _name.isEmpty ? (_type?.name ?? 'New Company') : _name,
        icon: _type?.icon ?? '🏢',
        onDone: () => widget.onComplete(_CompanyResult(
          name: _name.isEmpty ? (_type?.name ?? 'New Company') : _name,
          icon: _type?.icon ?? '🏢',
        )),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Column(children: [
          // Header
          Container(
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderSubtle))),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  GestureDetector(
                    onTap: _handleBack,
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.bgSurface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 16),
                    ),
                  ),
                  Text(_stepTitles[_step], style: AppTypography.headingS),
                  GestureDetector(
                    onTap: widget.onClose,
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.bgSurface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: const Icon(Icons.close, color: AppColors.textSecondary, size: 14),
                    ),
                  ),
                ]),
              ),
              _StepBar(step: _step),
            ]),
          ),
          // Content
          Expanded(child: SingleChildScrollView(
            key: ValueKey(_step),
            child: _buildStep(),
          )),
          // Continue button
          Container(
            padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 12, AppSpacing.screenH, 28),
            decoration: const BoxDecoration(
              color: AppColors.bgBase,
              border: Border(top: BorderSide(color: AppColors.borderSubtle)),
            ),
            child: GestureDetector(
              onTap: (_canContinue && !_launching) ? _handleContinue : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: _canContinue ? AppColors.gold : AppColors.bgInput,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  if (_launching) ...[
                    const SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.bgBase),
                    ),
                    const SizedBox(width: 8),
                    Text('Launching…', style: AppTypography.headingS.copyWith(color: AppColors.bgBase)),
                  ] else
                    Text(
                      _step == 5 ? '🚀 Launch ${_name.isEmpty ? 'Company' : _name}' :
                      _step == 4 ? 'Name My Company →' : 'Continue →',
                      style: AppTypography.headingS.copyWith(
                        color: _canContinue ? AppColors.bgBase : AppColors.textTertiary,
                      ),
                    ),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 1: return _Step1(selected: _sector, onSelect: (s) => setState(() { _sector = s; _type = null; }));
      case 2: return _Step2(sector: _sector, selected: _type, onSelect: (t) => setState(() => _type = t));
      case 3: return _Step3(country: _country, property: _property,
        onCountry: (c) => setState(() { _country = c; _property = null; }),
        onProperty: (p) => setState(() => _property = p));
      case 4: return _Step4(type: _type, property: _property, country: _country);
      case 5: return _Step5(type: _type, sector: _sector, country: _country, property: _property,
        name: _name, onName: (n) => setState(() => _name = n));
      default: return const SizedBox.shrink();
    }
  }
}

// ── Step Bar ──────────────────────────────────────────────────────────────────

class _StepBar extends StatelessWidget {
  const _StepBar({required this.step});
  final int step;
  static const _labels = ['Sector', 'Type', 'Location', 'Costs', 'Launch'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 14, AppSpacing.screenH, 12),
      child: Row(
        children: List.generate(_labels.length, (i) {
          final done = i + 1 < step;
          final active = i + 1 == step;
          return Expanded(child: Row(children: [
            Expanded(child: Column(children: [
              _StepDot(active: active, done: done, index: i + 1),
              const SizedBox(height: 4),
              Text(_labels[i], style: AppTypography.labelCaps.copyWith(
                color: active ? AppColors.gold : done ? AppColors.emerald : AppColors.textTertiary,
                fontSize: 9,
              )),
            ])),
            if (i < _labels.length - 1)
              Container(
                height: 2,
                width: 20,
                margin: const EdgeInsets.only(bottom: 14),
                color: done ? AppColors.emerald : AppColors.borderSubtle,
              ),
          ]));
        }),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.active, required this.done, required this.index});
  final bool active, done;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28, height: 28,
      decoration: BoxDecoration(
        color: done ? AppColors.emerald : active ? AppColors.gold : AppColors.bgInput,
        shape: BoxShape.circle,
        border: Border.all(color: done ? AppColors.emerald : active ? AppColors.gold : AppColors.borderDefault, width: 2),
      ),
      child: Center(
        child: Text(
          done ? '✓' : '$index',
          style: TextStyle(
            color: (done || active) ? AppColors.bgBase : AppColors.textTertiary,
            fontSize: 11, fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ── Step 1 — Sector ───────────────────────────────────────────────────────────

class _Step1 extends StatelessWidget {
  const _Step1({required this.selected, required this.onSelect});
  final _SectorData? selected;
  final ValueChanged<_SectorData> onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 4, AppSpacing.screenH, AppSpacing.xl),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Choose a sector', style: AppTypography.displayM.copyWith(fontSize: 22)),
        const SizedBox(height: 4),
        Text('Your sector determines available company types, supply chains, and which player needs you serve.',
            style: AppTypography.bodyM),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.1,
          children: _sectors.map((s) {
            final active = selected?.id == s.id;
            return GestureDetector(
              onTap: () => onSelect(s),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: active ? AppColors.gold.withOpacity(0.08) : AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: active ? AppColors.gold : AppColors.borderSubtle),
                  boxShadow: active ? [BoxShadow(color: AppColors.gold.withOpacity(0.1), blurRadius: 20)] : [],
                ),
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s.icon, style: const TextStyle(fontSize: 22)),
                  const SizedBox(height: 8),
                  Text(s.name, style: AppTypography.bodyS.copyWith(
                    fontWeight: FontWeight.w600, fontSize: 12,
                    color: active ? AppColors.gold : AppColors.textPrimary,
                  )),
                  const SizedBox(height: 4),
                  Expanded(child: Text(s.desc, style: AppTypography.labelCaps.copyWith(fontSize: 10), maxLines: 2, overflow: TextOverflow.ellipsis)),
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(s.cap, style: AppTypography.dataS.copyWith(fontSize: 10, color: AppColors.textTertiary)),
                    _DiffDots(n: s.diff),
                  ]),
                ]),
              ),
            );
          }).toList(),
        ),
      ]),
    );
  }
}

// ── Step 2 — Type ─────────────────────────────────────────────────────────────

class _Step2 extends StatelessWidget {
  const _Step2({required this.sector, required this.selected, required this.onSelect});
  final _SectorData? sector;
  final _TypeData? selected;
  final ValueChanged<_TypeData> onSelect;

  @override
  Widget build(BuildContext context) {
    final types = _typesFor(sector);
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 4, AppSpacing.screenH, AppSpacing.xl),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (sector != null) Row(children: [
          Text(sector!.icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(sector!.name, style: AppTypography.bodyS.copyWith(fontWeight: FontWeight.w500)),
        ]),
        const SizedBox(height: 6),
        Text('Choose company type', style: AppTypography.displayM.copyWith(fontSize: 22)),
        const SizedBox(height: 4),
        Text('Each type has distinct economics, supply chains, and employee requirements.', style: AppTypography.bodyM),
        const SizedBox(height: 16),
        ...types.map((t) {
          final active = selected?.id == t.id;
          return GestureDetector(
            onTap: () => onSelect(t),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: active ? AppColors.gold.withOpacity(0.07) : AppColors.bgSurface,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: active ? AppColors.gold : AppColors.borderSubtle),
              ),
              padding: const EdgeInsets.all(14),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: active ? AppColors.gold.withOpacity(0.12) : AppColors.bgInput,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: active ? AppColors.gold.withOpacity(0.3) : AppColors.borderSubtle),
                  ),
                  child: Center(child: Text(t.icon, style: const TextStyle(fontSize: 20))),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t.name, style: AppTypography.headingS.copyWith(color: active ? AppColors.gold : AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(t.desc, style: AppTypography.bodyS.copyWith(fontSize: 11)),
                  const SizedBox(height: 8),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(t.cap, style: AppTypography.dataS.copyWith(fontSize: 11, color: AppColors.textTertiary)),
                    Row(children: [
                      Text('Difficulty ', style: AppTypography.labelCaps.copyWith(fontSize: 10)),
                      _DiffDots(n: t.diff),
                    ]),
                  ]),
                ])),
                if (active) ...[
                  const SizedBox(width: 10),
                  Container(
                    width: 20, height: 20,
                    decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                    child: const Center(child: Text('✓', style: TextStyle(color: AppColors.bgBase, fontSize: 11, fontWeight: FontWeight.w700))),
                  ),
                ],
              ]),
            ),
          );
        }),
      ]),
    );
  }
}

// ── Step 3 — Location ─────────────────────────────────────────────────────────

class _Step3 extends StatelessWidget {
  const _Step3({required this.country, required this.property, required this.onCountry, required this.onProperty});
  final _CountryData country;
  final _PropertyData? property;
  final ValueChanged<_CountryData> onCountry;
  final ValueChanged<_PropertyData> onProperty;

  @override
  Widget build(BuildContext context) {
    final props = _propertiesFor(country.id);
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 4, AppSpacing.screenH, AppSpacing.xl),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Choose location', style: AppTypography.displayM.copyWith(fontSize: 22)),
        const SizedBox(height: 4),
        Text('Country affects tax rates, wages, and available customers.', style: AppTypography.bodyM),
        const SizedBox(height: 16),
        Text('COUNTRY', style: AppTypography.labelCaps),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _countries.map((c) {
              final active = country.id == c.id;
              return GestureDetector(
                onTap: () => onCountry(c),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 140,
                  margin: const EdgeInsets.only(right: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: active ? AppColors.gold.withOpacity(0.07) : AppColors.bgSurface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: active ? AppColors.gold : AppColors.borderSubtle),
                  ),
                  padding: const EdgeInsets.all(11),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(c.name, style: AppTypography.bodyS.copyWith(fontWeight: FontWeight.w600, fontSize: 13, color: active ? AppColors.gold : AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text(c.region, style: AppTypography.labelCaps.copyWith(fontSize: 10)),
                    const SizedBox(height: 6),
                    Wrap(spacing: 4, runSpacing: 3, children: c.tags.take(2).map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(color: AppColors.bgInput, borderRadius: BorderRadius.circular(4)),
                      child: Text(tag, style: AppTypography.labelCaps.copyWith(fontSize: 9, color: AppColors.textSecondary)),
                    )).toList()),
                  ]),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        Text('AVAILABLE PROPERTIES IN ${country.name.toUpperCase()}', style: AppTypography.labelCaps),
        const SizedBox(height: 10),
        ...props.map((p) {
          final active = property?.id == p.id;
          return GestureDetector(
            onTap: () => onProperty(p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: active ? AppColors.gold.withOpacity(0.07) : AppColors.bgSurface,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: active ? AppColors.gold : AppColors.borderSubtle),
              ),
              padding: const EdgeInsets.all(13),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p.name, style: AppTypography.bodyS.copyWith(fontWeight: FontWeight.w600, fontSize: 13, color: active ? AppColors.gold : AppColors.textPrimary)),
                  const SizedBox(height: 3),
                  Text(p.location, style: AppTypography.bodyS.copyWith(fontSize: 11)),
                  const SizedBox(height: 3),
                  Text('🏢 ${p.sqm}m² · ${p.dist}', style: AppTypography.labelCaps.copyWith(fontSize: 10)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('\$ ${NumberFormat.decimalPattern().format(p.rent)}',
                      style: AppTypography.dataM.copyWith(fontSize: 15, color: active ? AppColors.gold : AppColors.textPrimary)),
                  Text('per cycle', style: AppTypography.labelCaps.copyWith(fontSize: 10)),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: active ? AppColors.gold.withOpacity(0.15) : AppColors.bgInput,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(p.size.toUpperCase(), style: AppTypography.labelCaps.copyWith(fontSize: 9)),
                  ),
                ]),
              ]),
            ),
          );
        }),
      ]),
    );
  }
}

// ── Step 4 — Review Costs ─────────────────────────────────────────────────────

class _Step4 extends StatelessWidget {
  const _Step4({required this.type, required this.property, required this.country});
  final _TypeData? type;
  final _PropertyData? property;
  final _CountryData country;

  @override
  Widget build(BuildContext context) {
    final rent = property?.rent ?? 800;
    final deposit = rent * 2;
    final inventory = type?.id == 'cafe' ? 3000 : type?.id == 'restaurant' ? 6000 : 5000;
    final equipment = type?.id == 'cafe' ? 5000 : type?.id == 'restaurant' ? 12000 : 8000;
    final upfront = deposit + inventory + equipment;
    final minSalary = type?.id == 'cafe' ? 800 : 900;
    final replenish = (inventory * 0.13).round();
    final burnPerCycle = rent + minSalary + replenish + 40;
    const wallet = 84200;
    final runway = wallet ~/ burnPerCycle;
    final runwayColor = runway > 15 ? AppColors.emerald : runway > 6 ? AppColors.amber : AppColors.crimson;
    final runwayLabel = runway > 15 ? 'Healthy' : runway > 6 ? 'Caution' : 'Risky';

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 4, AppSpacing.screenH, AppSpacing.xl),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Review costs', style: AppTypography.displayM.copyWith(fontSize: 22)),
        const SizedBox(height: 4),
        Text('Understand your financial exposure before committing.', style: AppTypography.bodyM),
        const SizedBox(height: 14),
        // Runway hero
        Container(
          decoration: BoxDecoration(
            color: runwayColor.withOpacity(0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: runwayColor.withOpacity(0.25)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Runway without revenue', style: AppTypography.labelCaps),
                const SizedBox(height: 4),
                Text('~$runway cycles', style: AppTypography.displayM.copyWith(color: runwayColor, fontSize: 28)),
                const SizedBox(height: 2),
                Text('≈ ${(runway / 4).round()} real days before zero', style: AppTypography.bodyS.copyWith(fontSize: 12)),
              ]),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: runwayColor.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                child: Text(runwayLabel, style: AppTypography.label.copyWith(color: runwayColor, fontWeight: FontWeight.w700)),
              ),
            ]),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: SizedBox(
                height: 6,
                child: LinearProgressIndicator(
                  value: (runway / 40).clamp(0.0, 1.0),
                  backgroundColor: AppColors.bgInput,
                  valueColor: AlwaysStoppedAnimation(runwayColor),
                ),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 12),
        // Upfront costs
        _CostTable(
          title: 'UPFRONT COSTS',
          rows: [
            _CostRow('Rent deposit (2 cycles × \$${NumberFormat.decimalPattern().format(rent)})', deposit),
            _CostRow('Starting inventory estimate', inventory),
            _CostRow('Equipment & setup', equipment),
          ],
          total: _CostRow('Total upfront', upfront, color: AppColors.crimson),
        ),
        const SizedBox(height: 12),
        _CostTable(
          title: 'ONGOING (PER CYCLE)',
          rows: [
            _CostRow('Rent', rent),
            _CostRow('Min. salary (1 NPC)', minSalary),
            _CostRow('Inventory replenishment', replenish),
            const _CostRow('Transaction fees (est.)', 40),
          ],
          total: _CostRow('Monthly burn', burnPerCycle, suffix: '/cycle', color: AppColors.amber),
        ),
        const SizedBox(height: 12),
        // Wallet check
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Your current wallet', style: AppTypography.bodyS.copyWith(fontSize: 12)),
              Text('\$ ${NumberFormat.decimalPattern().format(wallet)}',
                  style: AppTypography.dataS.copyWith(color: AppColors.gold)),
            ]),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('After upfront costs', style: AppTypography.bodyS.copyWith(fontSize: 12)),
              Text('\$ ${NumberFormat.decimalPattern().format(wallet - upfront)}',
                  style: AppTypography.dataS.copyWith(color: (wallet - upfront) > 0 ? AppColors.emerald : AppColors.crimson)),
            ]),
          ]),
        ),
      ]),
    );
  }
}

class _CostRow {
  const _CostRow(this.label, this.amount, {this.suffix = '', this.color});
  final String label, suffix;
  final int amount;
  final Color? color;
}

class _CostTable extends StatelessWidget {
  const _CostTable({required this.title, required this.rows, required this.total});
  final String title;
  final List<_CostRow> rows;
  final _CostRow total;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Column(children: [
            Row(children: [Text(title, style: AppTypography.labelCaps.copyWith(fontSize: 10, fontWeight: FontWeight.w700))]),
            const SizedBox(height: 10),
            ...rows.map((r) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: Text(r.label, style: AppTypography.bodyS.copyWith(fontSize: 12))),
                const SizedBox(width: 8),
                Text('\$ ${NumberFormat.decimalPattern().format(r.amount)}',
                    style: AppTypography.dataS.copyWith(fontSize: 13)),
              ]),
            )),
          ]),
        ),
        const Divider(color: AppColors.borderSubtle, height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(total.label, style: AppTypography.headingS.copyWith(fontSize: 13)),
            Text('\$ ${NumberFormat.decimalPattern().format(total.amount)}${total.suffix}',
                style: AppTypography.dataS.copyWith(fontSize: 14, fontWeight: FontWeight.w600, color: total.color ?? AppColors.textPrimary)),
          ]),
        ),
      ]),
    );
  }
}

// ── Step 5 — Name & Confirm ───────────────────────────────────────────────────

class _Step5 extends StatelessWidget {
  const _Step5({required this.type, required this.sector, required this.country, required this.property, required this.name, required this.onName});
  final _TypeData? type;
  final _SectorData? sector;
  final _CountryData country;
  final _PropertyData? property;
  final String name;
  final ValueChanged<String> onName;

  @override
  Widget build(BuildContext context) {
    final rent = property?.rent ?? 800;
    final burnPerCycle = rent + (type?.id == 'cafe' ? 800 : 900) + 430 + 40;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 4, AppSpacing.screenH, AppSpacing.xl),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Name your company', style: AppTypography.displayM.copyWith(fontSize: 22)),
        const SizedBox(height: 4),
        Text('This is how you\'ll appear in the market.', style: AppTypography.bodyM),
        const SizedBox(height: 20),
        Text('Company name', style: AppTypography.bodyS.copyWith(fontSize: 12)),
        const SizedBox(height: 8),
        TextField(
          onChanged: onName,
          maxLength: 40,
          style: AppTypography.headingM,
          decoration: InputDecoration(
            hintText: 'Enter company name…',
            hintStyle: AppTypography.headingM.copyWith(color: AppColors.textTertiary),
            filled: true,
            fillColor: AppColors.bgInput,
            counterStyle: AppTypography.dataS.copyWith(color: AppColors.textTertiary, fontSize: 11),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: name.isNotEmpty ? AppColors.gold : AppColors.borderDefault),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: name.isNotEmpty ? AppColors.gold : AppColors.borderDefault),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.gold),
            ),
          ),
        ),
        if (name.isNotEmpty) ...[
          const SizedBox(height: 6),
          RichText(text: TextSpan(children: [
            TextSpan(text: 'Will appear as: ', style: AppTypography.labelCaps.copyWith(fontSize: 11)),
            TextSpan(text: '"$name"', style: AppTypography.label.copyWith(color: AppColors.gold, fontWeight: FontWeight.w600)),
            TextSpan(text: ' in ${country.name}', style: AppTypography.labelCaps.copyWith(fontSize: 11)),
          ])),
        ],
        const SizedBox(height: 20),
        // Summary card
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Text('COMPANY SUMMARY', style: AppTypography.labelCaps.copyWith(fontSize: 10, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                for (final r in [
                  ('🏷', 'Type',     '${type?.icon ?? ''} ${type?.name ?? '—'}'),
                  ('🗂', 'Sector',   sector?.name ?? '—'),
                  ('📍', 'Location', '${property?.name ?? '—'}, ${country.name}'),
                  ('🏢', 'Space',    '${property?.sqm ?? '—'}m² · ${property?.size ?? '—'}'),
                  ('💸', 'Rent',     '\$ ${NumberFormat.decimalPattern().format(property?.rent ?? 0)}/cycle'),
                ]) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(r.$1, style: const TextStyle(fontSize: 13)),
                      const SizedBox(width: 10),
                      SizedBox(width: 60, child: Text(r.$2, style: AppTypography.bodyS.copyWith(fontSize: 12))),
                      Expanded(child: Text(r.$3, style: AppTypography.bodyS.copyWith(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w500))),
                    ]),
                  ),
                ],
              ]),
            ),
            const Divider(color: AppColors.borderSubtle, height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Monthly burn', style: AppTypography.bodyS.copyWith(fontSize: 12)),
                Text('\$ ${NumberFormat.decimalPattern().format(burnPerCycle)}/cycle',
                    style: AppTypography.dataS.copyWith(color: AppColors.amber, fontWeight: FontWeight.w600)),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ── Wizard Success ────────────────────────────────────────────────────────────

class _WizardSuccess extends StatefulWidget {
  const _WizardSuccess({required this.name, required this.icon, required this.onDone});
  final String name, icon;
  final VoidCallback onDone;
  @override
  State<_WizardSuccess> createState() => _WizardSuccessState();
}

class _WizardSuccessState extends State<_WizardSuccess> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _scale = CurvedAnimation(parent: _ctrl, curve: const Cubic(0.34, 1.56, 0.64, 1));
    Future.microtask(() { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Stack(children: [
        // Radial glow background
        Container(decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.1),
            radius: 0.8,
            colors: [Color(0x1E00C97A), Colors.transparent],
          ),
        )),
        SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                ScaleTransition(
                  scale: _scale,
                  child: Column(children: [
                    Container(
                      width: 88, height: 88,
                      decoration: BoxDecoration(
                        color: AppColors.emerald.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.emerald.withOpacity(0.35), width: 2),
                        boxShadow: [BoxShadow(color: AppColors.emerald.withOpacity(0.2), blurRadius: 40)],
                      ),
                      child: Center(child: Text(widget.icon, style: const TextStyle(fontSize: 38))),
                    ),
                    const SizedBox(height: 20),
                    Text(widget.name, style: AppTypography.displayM.copyWith(fontSize: 26)),
                    const SizedBox(height: 6),
                    Text('is now live', style: AppTypography.headingM.copyWith(color: AppColors.emerald)),
                    const SizedBox(height: 8),
                    Text(
                      'Your company is registered, your space is leased, and your first NPC is hired. Revenue starts next cycle.',
                      style: AppTypography.bodyM,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    for (final r in [
                      ('First cycle settlement',    'In ~2h 31m',        AppColors.amber),
                      ('Revenue target (break-even)', 'Next 3 cycles',   AppColors.emerald),
                      ('Recommended first action',  'Post job listing',  AppColors.sky),
                    ])
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(r.$1, style: AppTypography.bodyS.copyWith(fontSize: 12)),
                          Text(r.$2, style: AppTypography.label.copyWith(color: r.$3, fontWeight: FontWeight.w600)),
                        ]),
                      ),
                  ]),
                ),
                const SizedBox(height: 24),
                FadeTransition(
                  opacity: _scale,
                  child: GestureDetector(
                    onTap: widget.onDone,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(AppRadius.card)),
                      child: Text('View Company →', style: AppTypography.headingS.copyWith(color: AppColors.bgBase)),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}

// ── Difficulty dots ────────────────────────────────────────────────────────────

class _DiffDots extends StatelessWidget {
  const _DiffDots({required this.n});
  final int n;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) => Container(
        width: 6, height: 6,
        margin: const EdgeInsets.only(left: 3),
        decoration: BoxDecoration(
          color: i < n ? AppColors.gold : AppColors.borderDefault,
          shape: BoxShape.circle,
        ),
      )),
    );
  }
}
