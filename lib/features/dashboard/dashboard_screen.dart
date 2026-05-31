import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/pressable.dart';

// ── Static mock data ──────────────────────────────────────────────────────────

class _NeedData {
  const _NeedData({required this.label, required this.val, required this.trend, required this.icon, required this.color});
  final String label, trend, icon;
  final int val;
  final Color color;
}

class _CompanyData {
  const _CompanyData({required this.id, required this.name, required this.type, required this.revenue, required this.employees, required this.status, required this.icon});
  final int id, revenue, employees;
  final String name, type, status, icon;
}

class _EventData {
  const _EventData({required this.id, required this.title, required this.scope, required this.severity, required this.cyclesLeft, required this.affectsMe});
  final int id, cyclesLeft;
  final String title, scope, severity;
  final bool affectsMe;
}

const _needs = [
  _NeedData(label: 'Hunger',    val: 82, trend: 'stable', icon: '🍽',  color: AppColors.needHunger),
  _NeedData(label: 'Energy',    val: 61, trend: 'down',   icon: '⚡',  color: AppColors.needEnergy),
  _NeedData(label: 'Health',    val: 88, trend: 'stable', icon: '❤️', color: AppColors.needHealth),
  _NeedData(label: 'Happiness', val: 71, trend: 'up',     icon: '😊',  color: AppColors.needHappiness),
  _NeedData(label: 'Housing',   val: 90, trend: 'stable', icon: '🏠',  color: AppColors.needHousing),
  _NeedData(label: 'Transport', val: 85, trend: 'stable', icon: '🚗',  color: AppColors.needTransport),
  _NeedData(label: 'Ambition',  val: 65, trend: 'down',   icon: '🔥',  color: AppColors.needAmbition),
];

const _companies = [
  _CompanyData(id: 1, name: 'Volta Café',      type: 'Café',        revenue: 4200,  employees: 3, status: 'good',    icon: '☕'),
  _CompanyData(id: 2, name: 'Volta Foods',     type: 'Food Mfg',    revenue: -800,  employees: 5, status: 'warning', icon: '🏭'),
  _CompanyData(id: 3, name: 'Caedoria Retail', type: 'Electronics', revenue: 3100,  employees: 4, status: 'good',    icon: '📱'),
];

const _events = [
  _EventData(id: 1, title: 'Labor Strike',      scope: 'Caedoria', severity: 'major', cyclesLeft: 3, affectsMe: true),
  _EventData(id: 2, title: 'Supply Disruption', scope: 'Global',   severity: 'minor', cyclesLeft: 2, affectsMe: false),
];

// ── Staggered fade-in wrapper ─────────────────────────────────────────────────
// ui-ux-pro-max: stagger-sequence rule — 30–50ms per item entrance delay

class _FadeIn extends StatefulWidget {
  const _FadeIn({required this.child, required this.delay});
  final Widget child;
  final Duration delay;

  @override
  State<_FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<_FadeIn> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 380));
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(widget.delay, () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _opacity,
    child: SlideTransition(position: _slide, child: widget.child),
  );
}

// ── DashboardScreen ───────────────────────────────────────────────────────────

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            _Header(),
            _FadeIn(delay: Duration(milliseconds: 60),  child: _NetWorthHero()),
            _FadeIn(delay: Duration(milliseconds: 110), child: _CycleCard()),
            _FadeIn(delay: Duration(milliseconds: 160), child: _NeedsSection()),
            _FadeIn(delay: Duration(milliseconds: 200), child: _CompaniesSection()),
            _FadeIn(delay: Duration(milliseconds: 240), child: _EventsSection()),
            _FadeIn(delay: Duration(milliseconds: 280), child: _PortfolioCard()),
            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, AppSpacing.md, AppSpacing.screenH, AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Good morning', style: AppTypography.labelCaps),
            const SizedBox(height: 2),
            Text('Alex Rivera', style: AppTypography.headingM),
          ]),
          // ui-ux-pro-max: Semantics label on icon-only button
          Semantics(
            label: '3 unread notifications',
            button: true,
            child: Stack(clipBehavior: Clip.none, children: [
              Pressable(
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
              Positioned(
                top: -4, right: -4,
                child: Container(
                  width: 18, height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.crimson,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.bgBase, width: 2),
                  ),
                  child: Center(
                    child: Text('3', style: AppTypography.labelCaps.copyWith(
                      color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700,
                    )),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// ── Net Worth Hero ────────────────────────────────────────────────────────────

class _NetWorthHero extends StatefulWidget {
  const _NetWorthHero();

  @override
  State<_NetWorthHero> createState() => _NetWorthHeroState();
}

class _NetWorthHeroState extends State<_NetWorthHero> with SingleTickerProviderStateMixin {
  static const int _target   = 847320;
  static const int _startVal = _target - 12400;

  late AnimationController _ctrl;
  late Animation<double> _anim;
  bool _glow = false;
  bool _showToast = false;
  int _walletBalance = 84200;
  int _delta = 12400;
  Timer? _repeatTimer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _ctrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 3500), _fire);
    _repeatTimer = Timer.periodic(const Duration(milliseconds: 12000), (_) => _fire());
  }

  void _fire() {
    if (!mounted) return;
    setState(() { _glow = true; _showToast = true; _walletBalance += 1200; _delta += 1200; });
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() { _glow = false; _showToast = false; });
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _repeatTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, AppSpacing.sm, AppSpacing.screenH, AppSpacing.md),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          // frontend-design: gradient background for atmosphere + depth
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.bgElevated,
              AppColors.bgSurface,
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.hero),
          border: Border.all(
            color: _glow
                ? AppColors.gold.withValues(alpha: 0.35)
                : AppColors.borderSubtle,
          ),
          // ui-ux-pro-max: gold ambient glow on balance increase
          boxShadow: _glow
              ? [
                  BoxShadow(color: AppColors.gold.withValues(alpha: 0.18), blurRadius: 50),
                  BoxShadow(color: AppColors.gold.withValues(alpha: 0.07), blurRadius: 100),
                ]
              : [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 20, offset: const Offset(0, 4)),
                ],
        ),
        child: Stack(clipBehavior: Clip.none, children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Net Worth', style: AppTypography.labelCaps),
              const SizedBox(height: AppSpacing.sm),
              // RepaintBoundary isolates the animating number from the rest
              RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _anim,
                  builder: (_, __) {
                    final val = (_startVal + (_target - _startVal) * _anim.value).round();
                    return RichText(
                      text: TextSpan(children: [
                        TextSpan(text: '\$ ', style: AppTypography.displayXL.copyWith(color: AppColors.gold)),
                        TextSpan(text: NumberFormat.decimalPattern().format(val), style: AppTypography.displayXL),
                      ]),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.emeraldSurface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.emerald.withValues(alpha: 0.2)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.arrow_upward, color: AppColors.emerald, size: 10),
                  const SizedBox(width: 4),
                  Text(
                    '+\$ ${NumberFormat.decimalPattern().format(_delta)} since last cycle',
                    style: AppTypography.dataS.copyWith(color: AppColors.emerald, fontSize: 12),
                  ),
                ]),
              ),
              const SizedBox(height: AppSpacing.md),
              const Divider(color: AppColors.borderSubtle, height: 1),
              const SizedBox(height: AppSpacing.md),
              Row(children: [
                _SubStat(label: 'Wallet',     val: '\$ ${NumberFormat.decimalPattern().format(_walletBalance)}', highlight: true),
                const _StatDivider(),
                const _SubStat(label: 'Companies', val: '\$ 15,600'),
                const _StatDivider(),
                const _SubStat(label: 'Portfolio',  val: '\$ 120,400'),
              ]),
            ]),
          ),
          // Income toast
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            top: _showToast ? 14 : 4,
            right: 14,
            child: AnimatedOpacity(
              opacity: _showToast ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.emerald.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.emerald.withValues(alpha: 0.3)),
                ),
                child: Text('+\$ 1,200', style: AppTypography.dataS.copyWith(color: AppColors.emerald)),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _SubStat extends StatelessWidget {
  const _SubStat({required this.label, required this.val, this.highlight = false});
  final String label, val;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTypography.labelCaps.copyWith(fontSize: 10)),
      const SizedBox(height: 3),
      Text(val, style: AppTypography.dataS.copyWith(color: highlight ? AppColors.gold : AppColors.textPrimary)),
    ]));
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: AppColors.borderSubtle, margin: const EdgeInsets.symmetric(horizontal: 12));
  }
}

// ── Cycle Card ────────────────────────────────────────────────────────────────

class _CycleCard extends StatefulWidget {
  const _CycleCard();
  @override
  State<_CycleCard> createState() => _CycleCardState();
}

class _CycleCardState extends State<_CycleCard> {
  static const int _total = 21600;
  late int _secs;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final s = now.hour * 3600 + now.minute * 60 + now.second;
    _secs = _total - (s % _total);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() { _secs = _secs > 0 ? _secs - 1 : _total; });
    });
  }

  @override
  void dispose() { _timer.cancel(); super.dispose(); }

  String get _label {
    final h = _secs ~/ 3600;
    final m = (_secs % 3600) ~/ 60;
    if (h > 0) return '${h}h ${m.toString().padLeft(2, '0')}m';
    final s = _secs % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  bool get _low => _secs < 1800;
  double get _pct => (_total - _secs) / _total;

  @override
  Widget build(BuildContext context) {
    final timerColor = _low ? AppColors.amber : AppColors.textPrimary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 0, AppSpacing.screenH, AppSpacing.md),
      // RepaintBoundary: timer ticks every second; isolate repaints from siblings
      child: RepaintBoundary(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: _low ? AppColors.amber.withValues(alpha: 0.5) : AppColors.borderSubtle),
            boxShadow: _low ? [BoxShadow(color: AppColors.amber.withValues(alpha: 0.08), blurRadius: 24)] : [],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                Icon(Icons.access_time, size: 14, color: _low ? AppColors.amber : AppColors.textSecondary),
                const SizedBox(width: 6),
                Text('Next Settlement', style: AppTypography.labelCaps),
              ]),
              Text(_label, style: AppTypography.dataM.copyWith(fontSize: 19, color: timerColor)),
            ]),
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: SizedBox(
                height: 4,
                child: LinearProgressIndicator(
                  value: _pct,
                  backgroundColor: AppColors.bgInput,
                  valueColor: AlwaysStoppedAnimation(_low ? AppColors.amber : AppColors.gold),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Row(children: [
              _CycleStat(label: 'Salary', val: '\$ 12,200', positive: true),
              SizedBox(width: 14),
              _CycleStat(label: 'Rent',   val: '\$ 4,500',  positive: false),
              SizedBox(width: 14),
              _CycleStat(label: 'Loan',   val: '\$ 1,200',  positive: false),
            ]),
          ]),
        ),
      ),
    );
  }
}

class _CycleStat extends StatelessWidget {
  const _CycleStat({required this.label, required this.val, required this.positive});
  final String label, val;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text(label, style: AppTypography.labelCaps.copyWith(fontSize: 11)),
      const SizedBox(width: 5),
      Text(val, style: AppTypography.dataS.copyWith(fontSize: 11, color: positive ? AppColors.emerald : AppColors.crimson)),
    ]);
  }
}

// ── Needs Section ─────────────────────────────────────────────────────────────

class _NeedsSection extends StatefulWidget {
  const _NeedsSection();
  @override
  State<_NeedsSection> createState() => _NeedsSectionState();
}

class _NeedsSectionState extends State<_NeedsSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final visible = _expanded ? _needs : _needs.sublist(0, 4);
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 0, AppSpacing.screenH, AppSpacing.md),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('My Needs', style: AppTypography.labelCaps),
              Pressable(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Text(
                  _expanded ? 'Collapse' : 'See all',
                  style: AppTypography.label.copyWith(color: AppColors.gold),
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Column(children: [
              for (int i = 0; i < visible.length; i++) ...[
                _NeedRow(need: visible[i]),
                if (i < visible.length - 1) const SizedBox(height: 10),
              ],
            ]),
          ),
        ]),
      ),
    );
  }
}

class _NeedRow extends StatelessWidget {
  const _NeedRow({required this.need});
  final _NeedData need;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.needColor(need.val);
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          // Needs use emoji as decorative content indicators, not structural icons — acceptable
          Text(need.icon, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 6),
          Text(need.label, style: AppTypography.bodyS.copyWith(
            fontWeight: FontWeight.w500,
            color: need.val < 40 ? AppColors.crimson : AppColors.textSecondary,
          )),
          if (need.val < 40) ...[
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.crimson.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text('CRITICAL', style: AppTypography.labelCaps.copyWith(
                color: AppColors.crimson, fontSize: 9, fontWeight: FontWeight.w700,
              )),
            ),
          ],
        ]),
        Row(children: [
          // ui-ux-pro-max: color-not-only — add icon alongside color to convey trend
          if (need.trend == 'down') const Icon(Icons.trending_down, size: 12, color: AppColors.crimson),
          if (need.trend == 'up')   const Icon(Icons.trending_up,   size: 12, color: AppColors.emerald),
          const SizedBox(width: 4),
          Text('${need.val}%', style: AppTypography.dataS.copyWith(fontSize: 12, color: c)),
        ]),
      ]),
      const SizedBox(height: 5),
      ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: SizedBox(
          height: 4,
          child: LinearProgressIndicator(
            value: need.val / 100.0,
            backgroundColor: AppColors.bgInput,
            valueColor: AlwaysStoppedAnimation(c),
          ),
        ),
      ),
    ]);
  }
}

// ── Companies Section ─────────────────────────────────────────────────────────

class _CompaniesSection extends StatelessWidget {
  const _CompaniesSection();

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 0, AppSpacing.screenH, AppSpacing.md),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Companies', style: AppTypography.labelCaps),
          Text('${_companies.length} total →', style: AppTypography.label.copyWith(color: AppColors.gold)),
        ]),
      ),
      SizedBox(
        height: 160,
        // Flutter skill: ListView for horizontal scroll is fine here (small fixed list)
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
          children: [
            for (final co in _companies) ...[
              _CompanyCard(co: co),
              const SizedBox(width: 12),
            ],
            const _AddCompanyCard(),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.md),
    ]);
  }
}

class _CompanyCard extends StatelessWidget {
  const _CompanyCard({required this.co});
  final _CompanyData co;

  @override
  Widget build(BuildContext context) {
    final isWarning = co.status == 'warning';
    final pos = co.revenue >= 0;

    return Pressable(
      onTap: () {},
      semanticLabel: '${co.name}, ${co.type}, ${pos ? "profit" : "loss"} this cycle',
      child: Container(
        width: 186,
        decoration: BoxDecoration(
          // frontend-design: gradient gives depth, not flat surface
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isWarning
                ? [AppColors.bgElevated, AppColors.bgSurface]
                : [AppColors.bgSurface, AppColors.bgBase],
          ),
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: isWarning
                ? AppColors.amber.withValues(alpha: 0.45)
                : AppColors.borderSubtle,
          ),
          boxShadow: isWarning
              ? [BoxShadow(color: AppColors.amber.withValues(alpha: 0.06), blurRadius: 16)]
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, 3))],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(co.icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 5),
              Text(co.name, style: AppTypography.bodyS.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary, fontSize: 13)),
              Text(co.type, style: AppTypography.labelCaps.copyWith(fontSize: 11)),
            ]),
            // ui-ux-pro-max: replace emoji ⚠️ with proper icon
            if (isWarning)
              const Icon(Icons.warning_amber_rounded, color: AppColors.amber, size: 16)
            else
              Container(
                width: 8, height: 8,
                margin: const EdgeInsets.only(top: 3),
                decoration: BoxDecoration(
                  color: AppColors.emerald,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: AppColors.emerald.withValues(alpha: 0.6), blurRadius: 7)],
                ),
              ),
          ]),
          const Spacer(),
          Text(
            '${pos ? '+' : '−'}\$ ${NumberFormat.decimalPattern().format(co.revenue.abs())}',
            style: AppTypography.dataM.copyWith(fontSize: 18, color: pos ? AppColors.emerald : AppColors.crimson),
          ),
          Text('this cycle', style: AppTypography.labelCaps.copyWith(fontSize: 11)),
          const Divider(color: AppColors.bgInput, height: 20),
          // ui-ux-pro-max: replace 👥 emoji with Material icon
          Row(children: [
            const Icon(Icons.people_outline, size: 12, color: AppColors.textTertiary),
            const SizedBox(width: 4),
            Text('${co.employees} staff', style: AppTypography.labelCaps.copyWith(fontSize: 11)),
          ]),
        ]),
      ),
    );
  }
}

class _AddCompanyCard extends StatelessWidget {
  const _AddCompanyCard();

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: () {},
      semanticLabel: 'Create a new company',
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.borderStrong)),
            child: const Icon(Icons.add, color: AppColors.textTertiary, size: 18),
          ),
          const SizedBox(height: 8),
          Text('New company', style: AppTypography.labelCaps.copyWith(fontSize: 11), textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

// ── Events Section ────────────────────────────────────────────────────────────

class _EventsSection extends StatelessWidget {
  const _EventsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 0, AppSpacing.screenH, AppSpacing.md),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Active Events', style: AppTypography.labelCaps),
          Text('See all →', style: AppTypography.label.copyWith(color: AppColors.gold)),
        ]),
        const SizedBox(height: AppSpacing.md),
        for (final ev in _events) ...[
          _EventCard(event: ev),
          const SizedBox(height: AppSpacing.sm),
        ],
      ]),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});
  final _EventData event;

  @override
  Widget build(BuildContext context) {
    final isMajor = event.severity == 'major';
    final severityColor = isMajor ? AppColors.amber : AppColors.sky;
    return Opacity(
      opacity: event.affectsMe ? 1.0 : 0.55,
      child: Pressable(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: event.affectsMe ? AppColors.amber.withValues(alpha: 0.35) : AppColors.borderSubtle,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: severityColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(event.severity.toUpperCase(), style: AppTypography.labelCaps.copyWith(
                    color: severityColor, fontSize: 9, fontWeight: FontWeight.w700,
                  )),
                ),
                const SizedBox(width: 6),
                Text(event.scope, style: AppTypography.labelCaps.copyWith(fontSize: 11)),
              ]),
              const SizedBox(height: 5),
              Text(event.title, style: AppTypography.bodyS.copyWith(
                fontWeight: FontWeight.w600,
                color: event.affectsMe ? AppColors.textPrimary : AppColors.textSecondary,
                fontSize: 13,
              )),
              if (event.affectsMe) ...[
                const SizedBox(height: 3),
                // ui-ux-pro-max: replace ⚠ emoji with icon
                Row(children: [
                  const Icon(Icons.warning_amber_rounded, size: 11, color: AppColors.amber),
                  const SizedBox(width: 4),
                  Text('Affecting your companies', style: AppTypography.labelCaps.copyWith(
                    color: AppColors.amber, fontSize: 11,
                  )),
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
      ),
    );
  }
}

// ── Portfolio Card ────────────────────────────────────────────────────────────

class _PortfolioCard extends StatelessWidget {
  const _PortfolioCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 0, AppSpacing.screenH, AppSpacing.sm),
      child: Pressable(
        onTap: () {},
        semanticLabel: 'Portfolio value 120,400 dollars, up 2.4 percent',
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Portfolio', style: AppTypography.labelCaps),
              const SizedBox(height: 6),
              RichText(text: TextSpan(children: [
                TextSpan(text: '\$ ', style: AppTypography.dataL.copyWith(color: AppColors.gold)),
                const TextSpan(text: '120,400', style: TextStyle(
                  fontFamily: 'DMSans', fontSize: 20, fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                )),
              ])),
              const SizedBox(height: 5),
              Row(children: [
                Text('+2.4%', style: AppTypography.dataS.copyWith(color: AppColors.emerald, fontSize: 12)),
                const SizedBox(width: 4),
                const Icon(Icons.trending_up, size: 12, color: AppColors.emerald),
                const SizedBox(width: 4),
                Text('this cycle · 3 positions', style: AppTypography.labelCaps.copyWith(fontSize: 11)),
              ]),
            ]),
            const RepaintBoundary(
              child: CustomPaint(size: Size(72, 32), painter: _SparklinePainter()),
            ),
          ]),
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  const _SparklinePainter();
  static const _pts = [28.0, 22, 24, 16, 12, 8, 4];

  @override
  void paint(Canvas canvas, Size size) {
    final n = _pts.length;
    final minY = _pts.reduce(math.min);
    final maxY = _pts.reduce(math.max);
    final range = (maxY - minY).clamp(1.0, double.infinity);

    final linePaint = Paint()
      ..color = AppColors.emerald
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (int i = 0; i < n; i++) {
      final x = (i / (n - 1)) * size.width;
      final y = size.height - ((_pts[i] - minY) / range) * size.height;
      if (i == 0) { path.moveTo(x, y); } else { path.lineTo(x, y); }
    }
    canvas.drawPath(path, linePaint);

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.emerald.withValues(alpha: 0.35), AppColors.emerald.withValues(alpha: 0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
