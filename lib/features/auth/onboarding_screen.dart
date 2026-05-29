import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/supabase/supabase_client.dart';

// ── Country data ──────────────────────────────────────────────────────────────

class _Country {
  const _Country({
    required this.id, required this.name, required this.region,
    required this.tier, required this.tags, required this.living,
    required this.why, required this.px, required this.py,
  });
  final String id, name, region, tier, living, why;
  final List<String> tags;
  final double px, py;
}

const _kCountries = <_Country>[
  _Country(id:'nova',     name:'Nova',      region:'Central',  tier:'Starter',    living:'\$ 950',   px:.50,py:.42, why:'The balanced starter. No advantage, no penalty. Pure execution.',          tags:['Balanced economy','Low competition','All sectors']),
  _Country(id:'korr',     name:'Korr',      region:'Western',  tier:'Industrial', living:'\$ 800',   px:.18,py:.38, why:'Manufacturing capital. Best margins for production companies.',             tags:['Manufacturing hub','Cheap labor','Resource-rich']),
  _Country(id:'valen',    name:'Valen',     region:'Central',  tier:'Finance',    living:'\$ 1,800', px:.48,py:.28, why:'The world\'s banking center. Finance companies operate at peak here.',     tags:['Finance hub','Strict regulation','High wages']),
  _Country(id:'aurel',    name:'Aurel',     region:'Northern', tier:'Premium',    living:'\$ 2,400', px:.32,py:.16, why:'Highest consumer spending. Premium products find their best margins.',      tags:['Luxury market','High spending','Elite workforce']),
  _Country(id:'kethos',   name:'Kethos',    region:'Eastern',  tier:'Mining',     living:'\$ 780',   px:.78,py:.48, why:'Cheapest production costs. Logistics pain is the price you pay.',          tags:['Mining','Metals & minerals','Low infrastructure']),
  _Country(id:'solven',   name:'Solven',    region:'Central',  tier:'Pharma',     living:'\$ 1,500', px:.60,py:.50, why:'Pharma valley. The only country with a native pharmaceutical advantage.',  tags:['Pharmaceutical','Healthcare','Skilled workforce']),
  _Country(id:'pella',    name:'Pella',     region:'Eastern',  tier:'Tech',       living:'\$ 1,600', px:.82,py:.30, why:'Retail and tech synergy. Consumers spend more on tech-enabled businesses.',tags:['Tech hub','High spending','Talent pool']),
  _Country(id:'tyrn',     name:'Tyrn',      region:'Southern', tier:'Frontier',   living:'\$ 750',   px:.38,py:.80, why:'Cheapest country in the game. Hardest to succeed. High-risk high-reward.',  tags:['Raw frontier','3 resources','Lowest tax 5%']),
  _Country(id:'caedoria', name:'Caedoria',  region:'Central',  tier:'Industrial', living:'\$ 1,200', px:.50,py:.56, why:'Reliable, mid-tier. Strong for food, logistics, and professional services.',tags:['Industrial','Low logistics cost','Medium wages']),
  _Country(id:'dalthorn', name:'Dalthorn',  region:'Western',  tier:'Resource',   living:'\$ 1,000', px:.22,py:.54, why:'Construction and raw material exports. Cheap space, growing market.',       tags:['Resource-rich','Construction','Medium tax']),
  _Country(id:'ventrex',  name:'Ventrex',   region:'Northern', tier:'Finance',    living:'\$ 1,900', px:.60,py:.14, why:'Northern finance rival to Valen. High wages mean high-caliber workforce.',  tags:['High wages','Finance presence','Low tax']),
  _Country(id:'morrath',  name:'Morrath',   region:'Northern', tier:'Industrial', living:'\$ 820',   px:.22,py:.24, why:'Old industrial base. Low costs but union mechanics complicate hiring.',      tags:['Heavy industry','Low wages','Union-heavy']),
  _Country(id:'brimark',  name:'Brimark',   region:'Central',  tier:'Logistics',  living:'\$ 1,300', px:.36,py:.44, why:'Geographic center of the world. Freight companies thrive here.',            tags:['Logistics hub','Central location','Medium wages']),
  _Country(id:'vareth',   name:'Vareth',    region:'Eastern',  tier:'Health',     living:'\$ 1,450', px:.72,py:.62, why:'Strong healthcare demand. Pharmacies and medical services are premium.',    tags:['Healthcare','Pharmaceutical demand','Stable economy']),
  _Country(id:'orvalle',  name:'Orvalle',   region:'Southern', tier:'Mining',     living:'\$ 760',   px:.28,py:.70, why:'Resource extraction hub. Partners well with manufacturing in Korr.',         tags:['Mining','Raw materials','Low wages']),
  _Country(id:'quelmont', name:'Quelmont',  region:'Western',  tier:'Education',  living:'\$ 1,700', px:.14,py:.62, why:'Education capital. Skill training centers and corporate training peak here.', tags:['Education','Skilled workforce','High wages']),
  _Country(id:'soltarn',  name:'Soltarn',   region:'Eastern',  tier:'Service',    living:'\$ 1,350', px:.86,py:.64, why:'Service-based economy. Hospitality and retail outperform here.',            tags:['Tourism','Entertainment','Service economy']),
  _Country(id:'halveth',  name:'Halveth',   region:'Southern', tier:'Offshore',   living:'\$ 1,850', px:.62,py:.74, why:'The tax haven. Finance structures and holding companies find it ideal.',     tags:['Offshore banking','8% tax','International']),
];

const _kRegions = ['All', 'Northern', 'Central', 'Western', 'Eastern', 'Southern'];

const _kRegionColors = <String, Color>{
  'Northern': AppColors.sky,
  'Central':  AppColors.gold,
  'Western':  AppColors.violet,
  'Eastern':  Color(0xFF4AE8C9),
  'Southern': AppColors.amber,
};

// ── World Network Animation ───────────────────────────────────────────────────

class _Node {
  const _Node({
    required this.id, required this.bx, required this.by,
    required this.phase, required this.amp, required this.spd, required this.r,
  });
  final String id;
  final double bx, by, phase, amp, spd, r;
}

class _Edge {
  const _Edge(this.a, this.b);
  final int a, b;
}

class _Pulse {
  _Pulse({required this.edgeIdx, required this.reverse, required this.speed});
  final int edgeIdx;
  final bool reverse;
  final double speed;
  double t = 0.0;
}

List<_Node> _buildNodes() {
  final rand = math.Random(42);
  return _kCountries.asMap().entries.map((e) {
    final i = e.key;
    final c = e.value;
    return _Node(
      id:    c.id,
      bx:    c.px,
      by:    c.py,
      phase: (i * 2.39996) % (math.pi * 2),
      amp:   0.008 + rand.nextDouble() * 0.006,
      spd:   0.4   + rand.nextDouble() * 0.5,
      r:     (c.tier == 'Finance' || c.tier == 'Premium') ? 3.5 : 2.5,
    );
  }).toList();
}

List<_Edge> _buildEdges(List<_Node> nodes) {
  final edges = <_Edge>[];
  for (var i = 0; i < nodes.length; i++) {
    for (var j = i + 1; j < nodes.length; j++) {
      final a = nodes[i], b = nodes[j];
      final dx = a.bx - b.bx;
      final dy = (a.by - b.by) * 1.4;
      if (math.sqrt(dx * dx + dy * dy) < 0.26) {
        edges.add(_Edge(i, j));
      }
    }
  }
  return edges;
}

final _kNodes = _buildNodes();
final _kEdges = _buildEdges(_kNodes);

// ── World Network Widget ──────────────────────────────────────────────────────

class _WorldNetwork extends StatefulWidget {
  const _WorldNetwork({this.dim = 1.0, this.highlight});
  final double dim;
  final String? highlight;
  @override
  State<_WorldNetwork> createState() => _WorldNetworkState();
}

class _WorldNetworkState extends State<_WorldNetwork>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late final math.Random _rand;
  final List<_Pulse> _pulses = [];
  double _t = 0.0;
  Timer? _pulseTimer;

  @override
  void initState() {
    super.initState();
    _rand = math.Random();
    _ticker = createTicker((elapsed) {
      final newT = elapsed.inMilliseconds / 1000.0 * 0.36;
      for (final p in _pulses) { p.t += p.speed; }
      _pulses.removeWhere((p) => p.t > 1.0);
      setState(() => _t = newT);
    })..start();
    _schedulePulse();
  }

  void _schedulePulse() {
    _pulseTimer = Timer(Duration(milliseconds: 180 + _rand.nextInt(600)), () {
      if (!mounted) return;
      if (_rand.nextDouble() < 0.7 && _kEdges.isNotEmpty) {
        _pulses.add(_Pulse(
          edgeIdx: _rand.nextInt(_kEdges.length),
          reverse: _rand.nextBool(),
          speed:   0.012 + _rand.nextDouble() * 0.010,
        ));
      }
      _schedulePulse();
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    _pulseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _NetworkPainter(
        t: _t,
        pulses: List<_Pulse>.from(_pulses),
        highlight: widget.highlight,
        dim: widget.dim,
      ),
    );
  }
}

class _NetworkPainter extends CustomPainter {
  const _NetworkPainter({
    required this.t, required this.pulses,
    this.highlight, required this.dim,
  });
  final double t, dim;
  final List<_Pulse> pulses;
  final String? highlight;

  Offset _pos(int i, Size size) {
    final n = _kNodes[i];
    return Offset(
      (n.bx + math.sin(t * n.spd + n.phase) * n.amp) * size.width,
      (n.by + math.cos(t * n.spd * 0.7 + n.phase) * n.amp * 0.65) * size.height,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final positions = List<Offset>.generate(
      _kNodes.length, (i) => _pos(i, size));

    // Edges
    for (final e in _kEdges) {
      final isHigh = highlight != null &&
          (_kNodes[e.a].id == highlight || _kNodes[e.b].id == highlight);
      canvas.drawLine(
        positions[e.a], positions[e.b],
        Paint()
          ..color = AppColors.gold.withOpacity(isHigh ? 0.45 * dim : 0.10 * dim)
          ..strokeWidth = isHigh ? 1.2 : 0.7
          ..style = PaintingStyle.stroke,
      );
    }

    // Pulses
    for (final p in pulses) {
      if (p.edgeIdx >= _kEdges.length) continue;
      final e = _kEdges[p.edgeIdx];
      final pa = positions[e.a], pb = positions[e.b];
      final frac = p.reverse ? 1.0 - p.t : p.t;
      final px = pa.dx + (pb.dx - pa.dx) * frac;
      final py = pa.dy + (pb.dy - pa.dy) * frac;
      final alpha = math.sin(p.t * math.pi) * 0.9 * dim;
      canvas.drawCircle(
        Offset(px, py), 2.5,
        Paint()..color = AppColors.goldBright.withOpacity(alpha),
      );
    }

    // Nodes
    for (var i = 0; i < _kNodes.length; i++) {
      final n  = _kNodes[i];
      final pos = positions[i];
      final isSel = highlight == n.id;
      final glowR = n.r * (isSel ? 7 : 5);

      final grd = RadialGradient(colors: [
        AppColors.gold.withOpacity((isSel ? 0.55 : 0.25) * dim),
        Colors.transparent,
      ]);
      canvas.drawCircle(pos, glowR,
        Paint()..shader = grd.createShader(
          Rect.fromCircle(center: pos, radius: glowR)));

      canvas.drawCircle(
        pos, isSel ? n.r * 1.6 : n.r,
        Paint()..color = isSel
          ? AppColors.goldBright
          : AppColors.gold.withOpacity(0.85 * dim),
      );
    }
  }

  @override
  bool shouldRepaint(_NetworkPainter old) => true;
}

// ── OnboardingScreen root ─────────────────────────────────────────────────────

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageCtrl = PageController();
  int _screen     = 0;
  _Country? _country;
  String   _name  = '';

  void _go(int target) {
    setState(() => _screen = target);
    _pageCtrl.animateToPage(target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic);
  }

  @override
  void dispose() { _pageCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: PageView(
              controller: _pageCtrl,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _SplashView(
                  onEnter:  () => _go(1),
                  onSignIn: () => context.go('/auth'),
                ),
                _CountryView(
                  onBack:     () => _go(0),
                  onContinue: (c) { setState(() => _country = c); _go(2); },
                ),
                _AccountView(
                  country:    _country,
                  onBack:     () => _go(1),
                  onSuccess:  (name) { setState(() => _name = name); _go(3); },
                ),
                _FirstDayView(
                  country: _country,
                  name:    _name,
                ),
              ],
            ),
          ),
          // Step dots (screens 1-3)
          if (_screen > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 16, top: 8),
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  final idx = i + 1;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width:  _screen == idx ? 20 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: idx < _screen
                        ? AppColors.emerald
                        : idx == _screen
                          ? AppColors.gold
                          : AppColors.borderDefault,
                    ),
                  );
                }),
              ),
            ),
        ]),
      ),
    );
  }
}

// ── Screen 0: Splash ─────────────────────────────────────────────────────────

class _SplashView extends StatefulWidget {
  const _SplashView({required this.onEnter, required this.onSignIn});
  final VoidCallback onEnter, onSignIn;
  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView> {
  bool _v0 = false, _v1 = false, _v2 = false, _v3 = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400),  () { if (mounted) setState(() => _v0 = true); });
    Future.delayed(const Duration(milliseconds: 900),  () { if (mounted) setState(() => _v1 = true); });
    Future.delayed(const Duration(milliseconds: 1600), () { if (mounted) setState(() => _v2 = true); });
    Future.delayed(const Duration(milliseconds: 2000), () { if (mounted) setState(() => _v3 = true); });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      // Animated network
      const _WorldNetwork(dim: 0.9),

      // Radial gradient overlay
      Container(decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center, radius: 1.0,
          colors: [Color(0x1A080A0E), Color(0xA6080A0E)],
        ),
      )),
      // Bottom fade
      Positioned(bottom: 0, left: 0, right: 0, height: MediaQuery.sizeOf(context).height * 0.45,
        child: Container(decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter, end: Alignment.topCenter,
            colors: [AppColors.bgBase, Colors.transparent],
            stops: [0.2, 1.0],
          ),
        )),
      ),
      // Top fade
      Positioned(top: 0, left: 0, right: 0, height: MediaQuery.sizeOf(context).height * 0.20,
        child: Container(decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [AppColors.bgBase, Colors.transparent],
          ),
        )),
      ),

      // Center content
      Positioned.fill(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Title
          AnimatedOpacity(
            opacity: _v0 ? 1.0 : 0.0, duration: const Duration(milliseconds: 800),
            child: AnimatedSlide(
              offset: _v0 ? Offset.zero : const Offset(0, 0.08),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              child: Text('LARVA',
                style: GoogleFonts.syne(
                  fontSize: 64, fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary, letterSpacing: -0.03,
                  height: 1.0)),
            ),
          ),
          const SizedBox(height: 20),
          // Taglines
          AnimatedOpacity(
            opacity: _v1 ? 1.0 : 0.0, duration: const Duration(milliseconds: 700),
            child: AnimatedSlide(
              offset: _v1 ? Offset.zero : const Offset(0, 0.06),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              child: Column(children: [
                Text('A world economy.',
                  style: AppTypography.bodyL.copyWith(
                    color: AppColors.textSecondary, fontSize: 18)),
                const SizedBox(height: 6),
                Text('You start from zero.',
                  style: AppTypography.bodyL.copyWith(
                    color: AppColors.textSecondary, fontSize: 18)),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          // Sub-caption
          AnimatedOpacity(
            opacity: _v2 ? 1.0 : 0.0, duration: const Duration(milliseconds: 600),
            child: Text('18 countries · Thousands of players · One economy',
              style: AppTypography.labelCaps.copyWith(letterSpacing: 0.06)),
          ),
        ]),
      ),

      // Bottom CTA
      Positioned(
        bottom: 0, left: 0, right: 0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenH, 0, AppSpacing.screenH, 40),
          child: AnimatedOpacity(
            opacity: _v3 ? 1.0 : 0.0, duration: const Duration(milliseconds: 600),
            child: Column(children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onEnter,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.goldDim, AppColors.gold],
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withOpacity(0.3),
                          blurRadius: 40, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      child: Text('ENTER',
                        style: GoogleFonts.syne(
                          fontSize: 17, fontWeight: FontWeight.w800,
                          color: AppColors.bgBase, letterSpacing: 0.04)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: widget.onSignIn,
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: 'Already have an account? ',
                    style: AppTypography.bodyS.copyWith(fontSize: 11)),
                  TextSpan(text: 'Sign in',
                    style: AppTypography.bodyS.copyWith(
                      fontSize: 11, color: AppColors.gold,
                      fontWeight: FontWeight.w600)),
                ])),
              ),
            ]),
          ),
        ),
      ),
    ]);
  }
}

// ── Screen 1: Country ─────────────────────────────────────────────────────────

class _CountryView extends StatefulWidget {
  const _CountryView({required this.onBack, required this.onContinue});
  final VoidCallback onBack;
  final ValueChanged<_Country> onContinue;
  @override
  State<_CountryView> createState() => _CountryViewState();
}

class _CountryViewState extends State<_CountryView> {
  final _searchCtrl = TextEditingController();
  String    _region   = 'All';
  _Country? _selected;
  bool      _showInfo = false;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  List<_Country> get _filtered {
    final q = _searchCtrl.text.toLowerCase();
    return _kCountries.where((c) {
      final matchQ = q.isEmpty || c.name.toLowerCase().contains(q) ||
          c.tags.any((t) => t.toLowerCase().contains(q));
      final matchR = _region == 'All' || c.region == _region;
      return matchQ && matchR;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Mini map
      SizedBox(height: 140, child: Stack(children: [
        _WorldNetwork(dim: 0.6, highlight: _selected?.id),
        Container(decoration: const BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Color(0x80080A0E), Colors.transparent,
                   Colors.transparent, Color(0x99080A0E)],
          stops: [0, 0.4, 0.6, 1],
        ))),
        if (_selected != null)
          Positioned(
            bottom: 10, left: 0, right: 0,
            child: Center(child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.bgSurface.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: Text.rich(TextSpan(children: [
                TextSpan(text: _selected!.name,
                  style: AppTypography.headingS.copyWith(color: AppColors.gold)),
                TextSpan(text: ' · ${_selected!.region}',
                  style: AppTypography.bodyS.copyWith(
                    color: AppColors.textTertiary, fontSize: 11)),
              ])),
            )),
          ),
        Positioned(top: 12, left: 20, right: 20,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _BackButton(onTap: widget.onBack),
            GestureDetector(
              onTap: () => setState(() => _showInfo = !_showInfo),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.bgSurface.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Text('ⓘ Why does this matter?',
                  style: AppTypography.bodyS.copyWith(fontSize: 11)),
              ),
            ),
          ]),
        ),
      ])),

      // Info overlay
      if (_showInfo)
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.bgElevated,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderDefault),
            boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(0.6), blurRadius: 32)],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('Why your country matters',
                style: AppTypography.headingS),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _showInfo = false),
                child: Text('✕',
                  style: AppTypography.bodyS.copyWith(fontSize: 16))),
            ]),
            const SizedBox(height: 10),
            for (final item in [
              'Starting job opportunities and available salaries',
              'Tax rates (5%–22% across 18 countries)',
              'Cost of living and real estate prices',
              'Which sectors have a local competitive advantage',
              'Consumer spending power and demand levels',
            ]) ...[
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('→ ', style: AppTypography.bodyS.copyWith(
                  color: AppColors.gold, fontSize: 12)),
                Expanded(child: Text(item,
                  style: AppTypography.bodyS.copyWith(
                    fontSize: 12, height: 1.4))),
              ]),
              const SizedBox(height: 7),
            ],
          ]),
        ),

      // Header
      Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenH, 14, AppSpacing.screenH, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Where are you starting?', style: AppTypography.displayM.copyWith(fontSize: 22)),
          const SizedBox(height: 2),
          Text("This is where you'll live, work, and build your first company.",
            style: AppTypography.bodyM),
          const SizedBox(height: 12),

          // Search
          Container(
            decoration: BoxDecoration(
              color: AppColors.bgInput,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Row(children: [
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(Icons.search, color: AppColors.textTertiary, size: 16),
              ),
              Expanded(child: TextField(
                controller: _searchCtrl,
                style: GoogleFonts.dmSans(
                  fontSize: 13, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search countries or characteristics…',
                  hintStyle: GoogleFonts.dmSans(
                    fontSize: 13, color: AppColors.textTertiary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 12),
                ),
              )),
            ]),
          ),
          const SizedBox(height: 10),

          // Region tabs
          SizedBox(height: 32, child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _kRegions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 6),
            itemBuilder: (_, i) {
              final r = _kRegions[i];
              final active = _region == r;
              final rc = _kRegionColors[r] ?? AppColors.gold;
              return GestureDetector(
                onTap: () => setState(() => _region = r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: active ? rc.withOpacity(0.09) : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: active ? rc : AppColors.borderDefault),
                  ),
                  child: Text(r,
                    style: AppTypography.labelCaps.copyWith(
                      fontSize: 11, fontWeight: FontWeight.w600,
                      color: active ? rc : AppColors.textTertiary)),
                ),
              );
            },
          )),
          const SizedBox(height: 2),
        ]),
      ),

      // Country list
      Expanded(child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenH, 10, AppSpacing.screenH, 8),
        itemCount: _filtered.isEmpty ? 1 : _filtered.length,
        itemBuilder: (_, idx) {
          if (_filtered.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text('No countries match "${_searchCtrl.text}"',
                  style: AppTypography.bodyM.copyWith(
                    color: AppColors.textTertiary)),
              ),
            );
          }
          final c = _filtered[idx];
          final active = _selected?.id == c.id;
          final rc = _kRegionColors[c.region] ?? AppColors.gold;
          return GestureDetector(
            onTap: () => setState(() =>
              _selected = active ? null : c),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: active
                  ? AppColors.gold.withOpacity(0.07)
                  : AppColors.bgSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: active ? AppColors.gold : AppColors.borderSubtle),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(c.name,
                          style: AppTypography.headingS.copyWith(
                            fontSize: 15, fontWeight: FontWeight.w700,
                            color: active ? AppColors.gold : AppColors.textPrimary)),
                        const SizedBox(width: 7),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: rc.withOpacity(0.09),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: rc.withOpacity(0.3)),
                          ),
                          child: Text(c.region.toUpperCase(),
                            style: AppTypography.labelCaps.copyWith(
                              fontSize: 9, fontWeight: FontWeight.w600,
                              color: rc)),
                        ),
                      ]),
                      const SizedBox(height: 3),
                      Text(c.why,
                        style: AppTypography.bodyS.copyWith(
                          color: AppColors.textTertiary, fontSize: 11,
                          height: 1.4)),
                    ],
                  )),
                  const SizedBox(width: 10),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text(c.living,
                      style: AppTypography.dataS.copyWith(
                        fontSize: 13, fontWeight: FontWeight.w500,
                        color: active ? AppColors.gold : AppColors.textPrimary)),
                    Text('per cycle',
                      style: AppTypography.labelCaps.copyWith(fontSize: 9)),
                  ]),
                ]),
                const SizedBox(height: 8),
                Wrap(spacing: 5, runSpacing: 4, children: c.tags.map((tag) =>
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.bgInput,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Text(tag,
                      style: AppTypography.labelCaps.copyWith(
                        fontSize: 10, color: AppColors.textSecondary)),
                  )
                ).toList()),
              ]),
            ),
          );
        },
      )),

      // CTA
      Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenH, 10, AppSpacing.screenH, 28),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.borderSubtle)),
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selected != null
              ? () => widget.onContinue(_selected!)
              : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              disabledBackgroundColor: AppColors.bgInput,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              _selected != null
                ? 'Start in ${_selected!.name} →'
                : 'Select a country to continue',
              style: GoogleFonts.dmSans(
                fontSize: 16, fontWeight: FontWeight.w700,
                color: _selected != null
                  ? AppColors.bgBase
                  : AppColors.textTertiary),
            ),
          ),
        ),
      ),
    ]);
  }
}

// ── Screen 2: Create Account ──────────────────────────────────────────────────

class _AccountView extends StatefulWidget {
  const _AccountView({
    required this.country, required this.onBack, required this.onSuccess});
  final _Country? country;
  final VoidCallback onBack;
  final ValueChanged<String> onSuccess;
  @override
  State<_AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<_AccountView> {
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _pwCtrl    = TextEditingController();
  bool _loading    = false;
  bool _showPw     = false;
  String? _error;
  String? _focused;

  @override
  void initState() {
    super.initState();
    for (final c in [_nameCtrl, _emailCtrl, _pwCtrl]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _pwCtrl.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
    _nameCtrl.text.trim().length >= 2 &&
    _emailCtrl.text.contains('@') &&
    _pwCtrl.text.length >= 6;

  int get _pwStrength {
    final pw = _pwCtrl.text;
    if (pw.length >= 12) return 4;
    if (pw.length >= 9)  return 3;
    if (pw.length >= 6)  return 2;
    if (pw.length >= 3)  return 1;
    return 0;
  }

  Future<void> _createAccount() async {
    setState(() { _loading = true; _error = null; });
    try {
      final res = await supabase.auth.signUp(
        email: _emailCtrl.text.trim(),
        password: _pwCtrl.text,
        data: {
          'display_name': _nameCtrl.text.trim(),
          'country_id':   widget.country?.id ?? 'nova',
        },
      );
      if (res.user != null && mounted) {
        widget.onSuccess(_nameCtrl.text.trim());
      }
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _field({
    required String label,
    required TextEditingController ctrl,
    required String focusKey,
    required String placeholder,
    TextInputType? keyboardType,
    bool isPassword = false,
  }) {
    final isFocused = _focused == focusKey;
    final hasValue  = ctrl.text.isNotEmpty;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTypography.bodyS.copyWith(
        color: AppColors.textSecondary, fontSize: 12,
        fontWeight: FontWeight.w500)),
      const SizedBox(height: 7),
      Focus(
        onFocusChange: (v) => setState(() => _focused = v ? focusKey : null),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppColors.bgInput,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isFocused ? AppColors.gold
                : hasValue ? AppColors.borderDefault
                : AppColors.borderSubtle,
              width: isFocused ? 1.5 : 1,
            ),
            boxShadow: isFocused ? [BoxShadow(
              color: AppColors.gold.withOpacity(0.12), blurRadius: 12)] : [],
          ),
          child: Row(children: [
            Expanded(child: TextField(
              controller: ctrl,
              keyboardType: keyboardType,
              obscureText: isPassword && !_showPw,
              style: GoogleFonts.dmSans(
                fontSize: 15, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: GoogleFonts.dmSans(
                  fontSize: 15, color: AppColors.textTertiary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              ),
            )),
            if (isPassword)
              GestureDetector(
                onTap: () => setState(() => _showPw = !_showPw),
                child: Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Text(_showPw ? 'hide' : 'show',
                    style: AppTypography.bodyS.copyWith(
                      color: AppColors.textTertiary, fontSize: 12)),
                ),
              )
            else if (hasValue)
              const Padding(
                padding: EdgeInsets.only(right: 14),
                child: Text('✓',
                  style: TextStyle(color: AppColors.emerald, fontSize: 14)),
              ),
          ]),
        ),
      ),
      // Password strength bar
      if (isPassword && ctrl.text.isNotEmpty) ...[
        const SizedBox(height: 6),
        Row(children: List.generate(4, (i) => Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 3,
            margin: EdgeInsets.only(right: i < 3 ? 3 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: _pwStrength > i
                ? (_pwStrength >= 4 ? AppColors.emerald : AppColors.amber)
                : AppColors.bgInput,
            ),
          ),
        ))),
      ],
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Header
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenH, vertical: 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
        ),
        child: Row(children: [
          _BackButton(onTap: widget.onBack),
          const SizedBox(width: 12),
          Text('Create account', style: AppTypography.headingM),
          if (widget.country != null) ...[
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.10),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.gold.withOpacity(0.2)),
              ),
              child: Text('📍 ${widget.country!.name}',
                style: AppTypography.labelCaps.copyWith(
                  color: AppColors.gold, fontSize: 11,
                  fontWeight: FontWeight.w600)),
            ),
          ],
        ]),
      ),

      Expanded(child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenH),
        child: Column(children: [
          // Logo
          const SizedBox(height: 28),
          Text.rich(TextSpan(children: [
            TextSpan(text: 'LAR',
              style: GoogleFonts.syne(
                fontSize: 32, fontWeight: FontWeight.w800,
                color: AppColors.textPrimary, letterSpacing: -0.02)),
            TextSpan(text: 'VA',
              style: GoogleFonts.syne(
                fontSize: 32, fontWeight: FontWeight.w800,
                color: AppColors.gold, letterSpacing: -0.02)),
          ])),
          const SizedBox(height: 4),
          Text('Your account. Your economy.',
            style: AppTypography.labelCaps.copyWith(fontSize: 12)),
          const SizedBox(height: 28),

          _field(label: 'Your name',    ctrl: _nameCtrl,  focusKey: 'name',
            placeholder: 'How others will know you'),
          const SizedBox(height: 16),
          _field(label: 'Email',        ctrl: _emailCtrl, focusKey: 'email',
            placeholder: 'you@example.com',
            keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 16),
          _field(label: 'Password',     ctrl: _pwCtrl,    focusKey: 'password',
            placeholder: 'At least 6 characters', isPassword: true),
          const SizedBox(height: 16),

          if (_error != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.crimsonSurface,
                borderRadius: BorderRadius.circular(AppRadius.chip),
                border: Border.all(
                  color: AppColors.crimson.withOpacity(0.4)),
              ),
              child: Text(_error!,
                style: AppTypography.bodyS.copyWith(
                  color: AppColors.crimson, fontSize: 13)),
            ),

          Text.rich(TextSpan(children: [
            TextSpan(text: 'By continuing you agree to the ',
              style: AppTypography.bodyS.copyWith(
                color: AppColors.textTertiary, fontSize: 11, height: 1.6)),
            TextSpan(text: 'Terms of Service',
              style: AppTypography.bodyS.copyWith(
                color: AppColors.gold, fontSize: 11)),
            TextSpan(text: ' and ',
              style: AppTypography.bodyS.copyWith(
                color: AppColors.textTertiary, fontSize: 11)),
            TextSpan(text: 'Privacy Policy',
              style: AppTypography.bodyS.copyWith(
                color: AppColors.gold, fontSize: 11)),
            TextSpan(text: '.',
              style: AppTypography.bodyS.copyWith(
                color: AppColors.textTertiary, fontSize: 11)),
          ])),
        ]),
      )),

      // CTA
      Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenH, 10, AppSpacing.screenH, 28),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.borderSubtle)),
        ),
        child: Column(children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_canSubmit && !_loading) ? _createAccount : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                disabledBackgroundColor: AppColors.bgInput,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              ),
              child: _loading
                ? const SizedBox(width: 20, height: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.bgBase, strokeWidth: 2))
                : Text('Create Account →',
                    style: GoogleFonts.dmSans(
                      fontSize: 16, fontWeight: FontWeight.w700,
                      color: _canSubmit
                        ? AppColors.bgBase
                        : AppColors.textTertiary)),
            ),
          ),
          const SizedBox(height: 12),
          Text.rich(TextSpan(children: [
            TextSpan(text: 'Already have an account? ',
              style: AppTypography.bodyS.copyWith(
                color: AppColors.textTertiary, fontSize: 12)),
            WidgetSpan(child: GestureDetector(
              onTap: widget.onBack,
              child: Text('Sign in',
                style: AppTypography.bodyS.copyWith(
                  color: AppColors.gold, fontSize: 12,
                  fontWeight: FontWeight.w600)),
            )),
          ])),
        ]),
      ),
    ]);
  }
}

// ── Screen 3: First Day ───────────────────────────────────────────────────────

class _FirstDayView extends StatefulWidget {
  const _FirstDayView({required this.country, required this.name});
  final _Country? country;
  final String name;
  @override
  State<_FirstDayView> createState() => _FirstDayViewState();
}

class _FirstDayViewState extends State<_FirstDayView> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300),
      () { if (mounted) setState(() => _visible = true); });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 700),
      child: Column(children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenH, vertical: 12),
          child: Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Day 1',
                style: AppTypography.labelCaps.copyWith(
                  textBaseline: TextBaseline.alphabetic)),
              Text(widget.name.isNotEmpty ? widget.name : 'Player',
                style: AppTypography.displayM.copyWith(fontSize: 18)),
            ]),
            const Spacer(),
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: const Icon(Icons.notifications_outlined,
                color: AppColors.textSecondary, size: 18),
            ),
          ]),
        ),

        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
          child: Column(children: [
            // CC Welcome card
            Container(
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderDefault),
                boxShadow: [BoxShadow(
                  color: AppColors.gold.withOpacity(0.08), blurRadius: 30)],
              ),
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Color(0x0FC9A54A),
                    border: Border(bottom: BorderSide(
                      color: AppColors.borderDefault)),
                  ),
                  child: Row(children: [
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.bgInput,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderDefault),
                      ),
                      child: const Center(child: Text('🏛', style: TextStyle(fontSize: 13))),
                    ),
                    const SizedBox(width: 8),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('The Central Corporation',
                        style: AppTypography.labelCaps.copyWith(
                          color: AppColors.gold, fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.06)),
                      Text(widget.country != null
                          ? '${widget.country!.name} Office'
                          : 'Global Office',
                        style: AppTypography.labelCaps.copyWith(fontSize: 10)),
                    ]),
                    const Spacer(),
                    Text('Just now',
                      style: AppTypography.labelCaps.copyWith(fontSize: 10)),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to ${widget.country?.name ?? 'the world'}.',
                        style: AppTypography.headingM),
                      const SizedBox(height: 8),
                      Text(
                        'You have no income yet. The economy runs every 6 hours. '
                        'Find a job before the first cycle settles.',
                        style: AppTypography.bodyM.copyWith(height: 1.6)),
                      const Divider(
                        color: AppColors.borderSubtle, height: 24),
                      Row(children: [
                        const Icon(Icons.work_outline,
                          color: AppColors.gold, size: 14),
                        const SizedBox(width: 6),
                        Text('Browse available jobs',
                          style: AppTypography.headingS.copyWith(
                            color: AppColors.gold, fontSize: 13,
                            fontWeight: FontWeight.w600)),
                      ]),
                    ],
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 20),

            // Empty wallet
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(AppRadius.hero),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Net Worth', style: AppTypography.labelCaps),
                const SizedBox(height: 8),
                Text.rich(TextSpan(children: [
                  TextSpan(text: '\$ ',
                    style: GoogleFonts.syne(
                      fontSize: 40, fontWeight: FontWeight.w700,
                      color: AppColors.gold, letterSpacing: -0.02, height: 1)),
                  TextSpan(text: '0.00',
                    style: GoogleFonts.syne(
                      fontSize: 40, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.02, height: 1)),
                ])),
                const SizedBox(height: 8),
                Text('Get a job to start building.',
                  style: AppTypography.bodyM.copyWith(
                    color: AppColors.textTertiary, fontSize: 12)),
                const SizedBox(height: 16),
                Row(children: ['Salary', 'Companies', 'Portfolio'].map((l) =>
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.toUpperCase(), style: AppTypography.labelCaps.copyWith(fontSize: 9)),
                        const SizedBox(height: 4),
                        Container(height: 14,
                          decoration: BoxDecoration(
                            color: AppColors.bgElevated.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4))),
                      ]),
                    ),
                  )).toList()),
              ]),
            ),
            const SizedBox(height: 16),

            // Skeleton sections
            const _SkeletonCard(rows: 3),
            const SizedBox(height: 12),

            // Location pill
            if (widget.country != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(children: [
                  const Icon(Icons.location_on_outlined,
                    color: AppColors.textSecondary, size: 14),
                  const SizedBox(width: 6),
                  Text.rich(TextSpan(children: [
                    TextSpan(text: 'Living in ',
                      style: AppTypography.bodyS.copyWith(fontSize: 12)),
                    TextSpan(text: widget.country!.name,
                      style: AppTypography.bodyS.copyWith(
                        fontSize: 12, color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600)),
                    TextSpan(text: ' · ${widget.country!.region}',
                      style: AppTypography.bodyS.copyWith(fontSize: 12)),
                  ])),
                  const Spacer(),
                  Wrap(spacing: 4, children: widget.country!.tags.take(2).map((t) =>
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.bgInput,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(t,
                        style: AppTypography.labelCaps.copyWith(
                          fontSize: 9, color: AppColors.textTertiary)),
                    )
                  ).toList()),
                ]),
              ),
            const SizedBox(height: 24),
          ]),
        )),

        // Get started CTA
        Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenH, 10, AppSpacing.screenH, 28),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.borderSubtle)),
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go('/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Enter the World →',
                style: GoogleFonts.dmSans(
                  fontSize: 16, fontWeight: FontWeight.w700,
                  color: AppColors.bgBase)),
            ),
          ),
        ),
      ]),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 32, height: 32,
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: const Icon(Icons.chevron_left,
        color: AppColors.textPrimary, size: 20),
    ),
  );
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.rows});
  final int rows;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.bgSurface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.borderSubtle),
    ),
    child: Column(children: [
      Container(height: 9, width: 60,
        decoration: BoxDecoration(
          color: AppColors.bgElevated.withOpacity(0.25),
          borderRadius: BorderRadius.circular(4))),
      ...List.generate(rows, (_) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(height: 9, width: 80,
              decoration: BoxDecoration(
                color: AppColors.bgElevated.withOpacity(0.20),
                borderRadius: BorderRadius.circular(4))),
            Container(height: 9, width: 30,
              decoration: BoxDecoration(
                color: AppColors.bgElevated.withOpacity(0.20),
                borderRadius: BorderRadius.circular(4))),
          ]),
          const SizedBox(height: 6),
          Container(height: 4,
            decoration: BoxDecoration(
              color: AppColors.bgElevated.withOpacity(0.15),
              borderRadius: BorderRadius.circular(2))),
        ]),
      )),
    ]),
  );
}
