import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

// ── Deterministic price-history generator ────────────────────────────────────

double _rng(double seed) {
  final x = math.sin(seed) * 10000;
  return x - x.floor();
}

List<double> _makeHistory(double start, double vol, double trend, {int n = 60}) {
  final prices = [start];
  for (int i = 1; i < n; i++) {
    final drift = (_rng(start * 1000 + i) - 0.5) * vol + trend;
    prices.add(math.max(0.5, prices[i - 1] + drift));
  }
  return prices.map((p) => double.parse(p.toStringAsFixed(2))).toList();
}

// ── Data ──────────────────────────────────────────────────────────────────────

class _StockData {
  _StockData({
    required this.id, required this.name, required this.sector, required this.country,
    required this.price, required this.delta, required this.deltaPct,
    required this.vol, required this.mktCap, required this.pe, required this.yld,
    required this.history, this.watched = false,
  });
  final String id, name, sector, country, mktCap;
  final double price, delta, deltaPct, pe, yld;
  final int vol;
  final List<double> history;
  bool watched;
}

class _PositionData {
  const _PositionData({required this.id, required this.shares, required this.avgCost, required this.current});
  final String id;
  final int shares;
  final double avgCost, current;
}

final _stocks = [
  _StockData(id: 'VLTF', name: 'Volta Foods Inc.',     sector: 'Food & Hospitality', country: 'Caedoria', price: 12.40, delta: -0.30, deltaPct: -2.4, vol: 12400, mktCap: '\$12.4M', pe: 8.2,  yld: 3.4, history: _makeHistory(16, 0.45, -0.04), watched: false),
  _StockData(id: 'HAZT', name: 'Horizon Tech Ltd.',    sector: 'Technology',          country: 'Eltria',   price: 34.80, delta:  1.20, deltaPct:  3.6, vol: 8200,  mktCap: '\$34.8M', pe: 18.4, yld: 0.8, history: _makeHistory(22, 0.60,  0.13), watched: true),
  _StockData(id: 'CRMK', name: 'Caedoria Retail Mkts', sector: 'Retail',              country: 'Caedoria', price:  8.15, delta:  0.05, deltaPct:  0.6, vol: 4100,  mktCap: '\$8.2M',  pe: 11.2, yld: 5.1, history: _makeHistory( 8, 0.25,  0.003), watched: false),
  _StockData(id: 'NEXL', name: 'Nexlogic Freight',     sector: 'Logistics',           country: 'Brimark',  price: 21.60, delta: -0.80, deltaPct: -3.6, vol: 6800,  mktCap: '\$21.6M', pe: 14.1, yld: 2.2, history: _makeHistory(18, 0.90,  0.04), watched: false),
  _StockData(id: 'MFXA', name: 'Morrath Fabrication',  sector: 'Manufacturing',       country: 'Morrath',  price:  6.90, delta: -0.15, deltaPct: -2.1, vol: 3200,  mktCap: '\$6.9M',  pe: 7.8,  yld: 4.8, history: _makeHistory(10, 0.35, -0.01), watched: false),
];

const _portfolio = [
  _PositionData(id: 'HAZT', shares: 150, avgCost: 31.20, current: 34.80),
  _PositionData(id: 'CRMK', shares: 400, avgCost:  8.40, current:  8.15),
  _PositionData(id: 'VLTF', shares: 200, avgCost: 11.80, current: 12.40),
];

const _sectorFilters = ['All Sectors', 'Food & Hospitality', 'Technology', 'Retail', 'Logistics', 'Manufacturing'];

// ── WorldScreen ───────────────────────────────────────────────────────────────

class WorldScreen extends StatefulWidget {
  const WorldScreen({super.key});
  @override
  State<WorldScreen> createState() => _WorldScreenState();
}

class _WorldScreenState extends State<WorldScreen> {
  _StockData? _selectedStock;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: _selectedStock == null
            ? _MarketOverview(
                stocks: _stocks,
                onSelect: (s) => setState(() => _selectedStock = s),
                onToggleWatch: (id) => setState(() {
                  final s = _stocks.firstWhere((s) => s.id == id);
                  s.watched = !s.watched;
                }),
              )
            : _StockDetail(
                stock: _selectedStock!,
                onBack: () => setState(() => _selectedStock = null),
              ),
      ),
    );
  }
}

// ── Market Overview ───────────────────────────────────────────────────────────

class _MarketOverview extends StatefulWidget {
  const _MarketOverview({required this.stocks, required this.onSelect, required this.onToggleWatch});
  final List<_StockData> stocks;
  final ValueChanged<_StockData> onSelect;
  final ValueChanged<String> onToggleWatch;
  @override
  State<_MarketOverview> createState() => _MarketOverviewState();
}

class _MarketOverviewState extends State<_MarketOverview> {
  int _tab = 0; // 0=listed, 1=portfolio, 2=watchlist
  String _sectorFilter = 'All Sectors';

  @override
  Widget build(BuildContext context) {
    final upCount = widget.stocks.where((s) => s.deltaPct > 0).length;
    final sentiment = upCount / widget.stocks.length;

    final filtered = widget.stocks.where((s) {
      final sectorOk = _sectorFilter == 'All Sectors' || s.sector == _sectorFilter;
      final tabOk = _tab != 2 || s.watched;
      return sectorOk && tabOk;
    }).toList();

    final portVal  = _portfolio.fold(0.0, (s, p) => s + p.shares * p.current);
    final portCost = _portfolio.fold(0.0, (s, p) => s + p.shares * p.avgCost);
    final portGain = portVal - portCost;
    final portGainP = portCost > 0 ? (portGain / portCost * 100) : 0.0;

    return Column(children: [
      // Header + market stats
      Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, AppSpacing.md, AppSpacing.screenH, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Stock Market', style: AppTypography.displayM.copyWith(fontSize: 22)),
          const SizedBox(height: 12),
          Row(children: [
            _MarketStat(label: 'Market Cap',  val: '\$${(widget.stocks.fold(0.0, (s, st) => s + double.parse(st.mktCap.replaceAll(RegExp(r'[\$M]'), ''))) ).toStringAsFixed(1)}M'),
            _StatDivider3(),
            _MarketStat(label: 'Sentiment',   val: '${(sentiment * 100).round()}% ↑', color: sentiment > 0.5 ? AppColors.emerald : AppColors.crimson),
            _StatDivider3(),
            _MarketStat(label: 'Vol Today',   val: NumberFormat.compact().format(widget.stocks.fold(0, (s, st) => s + st.vol))),
          ]),
          const SizedBox(height: 14),
        ]),
      ),
      // Tabs
      Container(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderSubtle))),
        child: Row(children: [
          for (final t in ['Listed', 'Portfolio', 'Watchlist'])
            Expanded(child: GestureDetector(
              onTap: () => setState(() => _tab = ['Listed', 'Portfolio', 'Watchlist'].indexOf(t)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(
                  color: _tab == ['Listed', 'Portfolio', 'Watchlist'].indexOf(t) ? AppColors.gold : Colors.transparent,
                  width: 2,
                ))),
                child: Text(t, style: AppTypography.label.copyWith(
                  color: _tab == ['Listed', 'Portfolio', 'Watchlist'].indexOf(t) ? AppColors.gold : AppColors.textTertiary,
                  fontWeight: _tab == ['Listed', 'Portfolio', 'Watchlist'].indexOf(t) ? FontWeight.w600 : FontWeight.w400,
                ), textAlign: TextAlign.center),
              ),
            )),
        ]),
      ),
      // Sector filter
      Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, AppSpacing.md, AppSpacing.screenH, 0),
        child: SizedBox(
          height: 30,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _sectorFilters.map((f) => GestureDetector(
              onTap: () => setState(() => _sectorFilter = f),
              child: Container(
                margin: const EdgeInsets.only(right: 5),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _sectorFilter == f ? AppColors.gold.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _sectorFilter == f ? AppColors.gold : AppColors.borderDefault),
                ),
                child: Text(f, style: AppTypography.label.copyWith(
                  color: _sectorFilter == f ? AppColors.gold : AppColors.textTertiary,
                  fontWeight: FontWeight.w500, fontSize: 11,
                )),
              ),
            )).toList(),
          ),
        ),
      ),
      const SizedBox(height: 12),

      // Portfolio summary (when portfolio tab)
      if (_tab == 1) Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 0, AppSpacing.screenH, 12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Portfolio Value', style: AppTypography.labelCaps),
              RichText(text: TextSpan(children: [
                TextSpan(text: '\$ ', style: AppTypography.dataL.copyWith(color: AppColors.gold)),
                TextSpan(text: NumberFormat.decimalPattern().format(portVal.round()), style: AppTypography.dataL),
              ])),
            ]),
            const Spacer(),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(
                '${portGain >= 0 ? '+' : ''}\$ ${NumberFormat.decimalPattern().format(portGain.round())}',
                style: AppTypography.dataS.copyWith(color: portGain >= 0 ? AppColors.emerald : AppColors.crimson),
              ),
              Text(
                '${portGainP >= 0 ? '+' : ''}${portGainP.toStringAsFixed(1)}%',
                style: AppTypography.dataS.copyWith(color: portGain >= 0 ? AppColors.emerald : AppColors.crimson, fontSize: 11),
              ),
            ]),
          ]),
        ),
      ),

      // Stock list
      Expanded(child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
        children: [
          if (_tab == 1)
            ..._portfolio.map((pos) {
              final stock = widget.stocks.firstWhere((s) => s.id == pos.id);
              final gain = (pos.current - pos.avgCost) * pos.shares;
              return _StockCard(
                stock: stock,
                onTap: () => widget.onSelect(stock),
                onToggleWatch: () => widget.onToggleWatch(stock.id),
                extra: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('${pos.shares} shares', style: AppTypography.labelCaps.copyWith(fontSize: 10)),
                  Text(
                    '${gain >= 0 ? '+' : ''}\$ ${NumberFormat.decimalPattern().format(gain.round())}',
                    style: AppTypography.dataS.copyWith(fontSize: 11, color: gain >= 0 ? AppColors.emerald : AppColors.crimson),
                  ),
                ]),
              );
            })
          else
            ...filtered.map((s) => _StockCard(
              stock: s,
              onTap: () => widget.onSelect(s),
              onToggleWatch: () => widget.onToggleWatch(s.id),
            )),
          const SizedBox(height: AppSpacing.xl),
        ],
      )),
    ]);
  }
}

class _MarketStat extends StatelessWidget {
  const _MarketStat({required this.label, required this.val, this.color});
  final String label, val;
  final Color? color;
  @override
  Widget build(BuildContext context) => Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: AppTypography.labelCaps.copyWith(fontSize: 10)),
    const SizedBox(height: 3),
    Text(val, style: AppTypography.dataS.copyWith(fontSize: 13, color: color ?? AppColors.textPrimary)),
  ]));
}

class _StatDivider3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 28, color: AppColors.borderSubtle, margin: const EdgeInsets.symmetric(horizontal: 12));
}

// ── Stock Card ────────────────────────────────────────────────────────────────

class _StockCard extends StatelessWidget {
  const _StockCard({required this.stock, required this.onTap, required this.onToggleWatch, this.extra});
  final _StockData stock;
  final VoidCallback onTap, onToggleWatch;
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    final up = stock.deltaPct >= 0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(stock.id, style: AppTypography.dataS.copyWith(fontSize: 13, color: AppColors.gold)),
                const SizedBox(width: 6),
                const Text('·', style: TextStyle(color: AppColors.textTertiary, fontSize: 11)),
                const SizedBox(width: 6),
                Expanded(child: Text(stock.name, style: AppTypography.bodyS.copyWith(fontSize: 12), overflow: TextOverflow.ellipsis)),
              ]),
              const SizedBox(height: 3),
              Text('${stock.sector} · ${stock.country}', style: AppTypography.labelCaps.copyWith(fontSize: 11)),
            ])),
            GestureDetector(
              onTap: onToggleWatch,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(stock.watched ? '★' : '☆', style: TextStyle(color: stock.watched ? AppColors.gold : AppColors.borderStrong, fontSize: 16)),
              ),
            ),
          ]),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('\$ ${stock.price.toStringAsFixed(2)}', style: AppTypography.dataL.copyWith(fontSize: 22)),
              const SizedBox(height: 3),
              Row(children: [
                Text('${up ? '+' : ''}${stock.delta.toStringAsFixed(2)}', style: AppTypography.dataS.copyWith(fontSize: 12, color: up ? AppColors.emerald : AppColors.crimson)),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: (up ? AppColors.emerald : AppColors.crimson).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(children: [
                    Icon(up ? Icons.arrow_upward : Icons.arrow_downward, size: 9, color: up ? AppColors.emerald : AppColors.crimson),
                    Text('${stock.deltaPct.abs().toStringAsFixed(1)}%', style: AppTypography.dataS.copyWith(fontSize: 11, color: up ? AppColors.emerald : AppColors.crimson)),
                  ]),
                ),
              ]),
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('Vol ${NumberFormat.compact().format(stock.vol)}', style: AppTypography.labelCaps.copyWith(fontSize: 10)),
              Text('Cap ${stock.mktCap}', style: AppTypography.bodyS.copyWith(fontSize: 11)),
              const SizedBox(height: 3),
              Row(children: [
                Text('P/E ', style: AppTypography.labelCaps.copyWith(fontSize: 10)),
                Text('${stock.pe}', style: AppTypography.dataS.copyWith(fontSize: 10, color: AppColors.textSecondary)),
                const SizedBox(width: 10),
                Text('Yld ', style: AppTypography.labelCaps.copyWith(fontSize: 10)),
                Text('${stock.yld}%', style: AppTypography.dataS.copyWith(fontSize: 10, color: AppColors.emerald)),
              ]),
              if (extra != null) ...[const SizedBox(height: 4), extra!],
            ]),
          ]),
        ]),
      ),
    );
  }
}

// ── Stock Detail Screen ───────────────────────────────────────────────────────

class _StockDetail extends StatefulWidget {
  const _StockDetail({required this.stock, required this.onBack});
  final _StockData stock;
  final VoidCallback onBack;
  @override
  State<_StockDetail> createState() => _StockDetailState();
}

class _StockDetailState extends State<_StockDetail> {
  int _range = 60;
  bool _showTradeSheet = false;
  bool _isBuy = true;
  int _qty = 10;

  @override
  Widget build(BuildContext context) {
    final s = widget.stock;
    final up = s.deltaPct >= 0;
    final pos = _portfolio.where((p) => p.id == s.id).firstOrNull;

    return Stack(children: [
      Column(children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
          child: Row(children: [
            GestureDetector(
              onTap: widget.onBack,
              child: Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.bgSurface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.borderSubtle)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 16)),
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.id, style: AppTypography.headingM.copyWith(color: AppColors.gold)),
              Text(s.name, style: AppTypography.labelCaps.copyWith(fontSize: 11)),
            ]),
          ]),
        ),

        Expanded(child: ListView(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH), children: [
          // Price hero
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('\$ ${s.price.toStringAsFixed(2)}', style: AppTypography.displayL),
            const SizedBox(height: 4),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: (up ? AppColors.emerald : AppColors.crimson).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Row(children: [
                  Icon(up ? Icons.arrow_upward : Icons.arrow_downward, size: 10, color: up ? AppColors.emerald : AppColors.crimson),
                  const SizedBox(width: 4),
                  Text('${up ? '+' : ''}${s.delta.toStringAsFixed(2)} (${s.deltaPct.toStringAsFixed(1)}%)', style: AppTypography.dataS.copyWith(fontSize: 12, color: up ? AppColors.emerald : AppColors.crimson)),
                ]),
              ),
            ]),
          ]),
          const SizedBox(height: 16),

          // Range selector
          Row(children: [
            for (final r in [10, 30, 60]) GestureDetector(
              onTap: () => setState(() => _range = r),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _range == r ? AppColors.gold.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _range == r ? AppColors.gold : AppColors.borderDefault),
                ),
                child: Text('${r}C', style: AppTypography.label.copyWith(color: _range == r ? AppColors.gold : AppColors.textTertiary, fontWeight: FontWeight.w600)),
              ),
            ),
          ]),
          const SizedBox(height: 12),

          // Price chart
          _PriceChart(history: s.history, range: _range),
          const SizedBox(height: 16),

          // Key stats
          Container(
            decoration: BoxDecoration(color: AppColors.bgSurface, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderSubtle)),
            padding: const EdgeInsets.all(14),
            child: Column(children: [
              for (final row in [
                ('Market Cap',   s.mktCap,                           AppColors.textPrimary),
                ('P/E Ratio',    s.pe.toString(),                    AppColors.textPrimary),
                ('Div. Yield',   '${s.yld}%',                        AppColors.emerald),
                ('Volume',       NumberFormat.decimalPattern().format(s.vol), AppColors.textPrimary),
                ('Sector',       s.sector,                           AppColors.textSecondary),
                ('Country',      s.country,                          AppColors.textSecondary),
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(row.$1, style: AppTypography.bodyS.copyWith(fontSize: 12)),
                    Text(row.$2, style: AppTypography.dataS.copyWith(fontSize: 12, color: row.$3)),
                  ]),
                ),
            ]),
          ),
          const SizedBox(height: 12),

          // My position (if any)
          if (pos != null) Container(
            decoration: BoxDecoration(
              color: AppColors.bgSurface, borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('My Position', style: AppTypography.labelCaps),
                Text('${pos.shares} shares', style: AppTypography.dataS.copyWith(fontSize: 12, color: AppColors.gold)),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                _PosStat(label: 'Avg cost',     val: '\$ ${pos.avgCost.toStringAsFixed(2)}'),
                _PosStat(label: 'Current',      val: '\$ ${pos.current.toStringAsFixed(2)}'),
                _PosStat(
                  label: 'Gain/Loss',
                  val: '${(pos.current - pos.avgCost) * pos.shares >= 0 ? '+' : ''}\$ ${NumberFormat.decimalPattern().format(((pos.current - pos.avgCost) * pos.shares).round())}',
                  color: (pos.current - pos.avgCost) >= 0 ? AppColors.emerald : AppColors.crimson,
                ),
              ]),
            ]),
          ),
          const SizedBox(height: 80),
        ])),
      ]),

      // Sticky buy/sell footer
      Positioned(
        bottom: 0, left: 0, right: 0,
        child: Container(
          padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 12, AppSpacing.screenH, 24),
          decoration: const BoxDecoration(
            color: AppColors.bgBase,
            border: Border(top: BorderSide(color: AppColors.borderSubtle)),
          ),
          child: Row(children: [
            Expanded(child: GestureDetector(
              onTap: () => setState(() { _isBuy = true; _showTradeSheet = true; }),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.emerald.withOpacity(0.12), borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.emerald.withOpacity(0.4))),
                child: Center(child: Text('Buy', style: AppTypography.headingS.copyWith(color: AppColors.emerald))),
              ),
            )),
            const SizedBox(width: 10),
            Expanded(child: GestureDetector(
              onTap: () => setState(() { _isBuy = false; _showTradeSheet = true; }),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.crimson.withOpacity(0.12), borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.crimson.withOpacity(0.4))),
                child: Center(child: Text('Sell', style: AppTypography.headingS.copyWith(color: AppColors.crimson))),
              ),
            )),
          ]),
        ),
      ),

      // Trade sheet
      if (_showTradeSheet)
        _TradeSheet(
          stock: widget.stock,
          isBuy: _isBuy,
          qty: _qty,
          onQtyChange: (q) => setState(() => _qty = q),
          onClose: () => setState(() => _showTradeSheet = false),
          onConfirm: () => setState(() => _showTradeSheet = false),
        ),
    ]);
  }
}

class _PosStat extends StatelessWidget {
  const _PosStat({required this.label, required this.val, this.color});
  final String label, val;
  final Color? color;
  @override
  Widget build(BuildContext context) => Expanded(child: Column(children: [
    Text(label, style: AppTypography.labelCaps.copyWith(fontSize: 9)),
    Text(val, style: AppTypography.dataS.copyWith(fontSize: 11, color: color ?? AppColors.textPrimary)),
  ]));
}

// ── Price Chart ───────────────────────────────────────────────────────────────

class _PriceChart extends StatefulWidget {
  const _PriceChart({required this.history, required this.range});
  final List<double> history;
  final int range;
  @override
  State<_PriceChart> createState() => _PriceChartState();
}

class _PriceChartState extends State<_PriceChart> {
  int? _hoverIdx;

  List<double> get _data {
    final n = widget.history.length;
    final start = (n - widget.range).clamp(0, n);
    return widget.history.sublist(start);
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    final n = data.length;
    final isUp = n > 0 && data.last >= data.first;
    final lineColor = isUp ? AppColors.emerald : AppColors.crimson;

    return Column(children: [
      if (_hoverIdx != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(children: [
            Text('Cycle ${widget.history.length - n + _hoverIdx! + 1}', style: AppTypography.labelCaps.copyWith(fontSize: 10)),
            const SizedBox(width: 12),
            Text('\$ ${data[_hoverIdx!].toStringAsFixed(2)}', style: AppTypography.dataS.copyWith(fontSize: 14)),
          ]),
        ),
      GestureDetector(
        onPanUpdate: (d) {
          final box = context.findRenderObject() as RenderBox?;
          if (box == null) return;
          final localX = box.globalToLocal(d.globalPosition).dx;
          final idx = ((localX / box.size.width) * (n - 1)).round().clamp(0, n - 1);
          setState(() => _hoverIdx = idx);
        },
        onPanEnd: (_) => setState(() => _hoverIdx = null),
        child: SizedBox(
          height: 140,
          child: CustomPaint(
            size: const Size(double.infinity, 140),
            painter: _ChartPainter(data: data, hoverIdx: _hoverIdx, lineColor: lineColor),
          ),
        ),
      ),
    ]);
  }
}

class _ChartPainter extends CustomPainter {
  const _ChartPainter({required this.data, required this.hoverIdx, required this.lineColor});
  final List<double> data;
  final int? hoverIdx;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final n = data.length;
    const pad = EdgeInsets.fromLTRB(0, 12, 8, 20);
    final iW = size.width - pad.left - pad.right;
    final iH = size.height - pad.top - pad.bottom;
    final minY = data.reduce(math.min) * 0.97;
    final maxY = data.reduce(math.max) * 1.03;
    final range = (maxY - minY).clamp(0.01, double.infinity);

    double xScale(int i) => pad.left + (i / (n - 1)) * iW;
    double yScale(double v) => pad.top + iH - ((v - minY) / range) * iH;

    final linePts = List.generate(n, (i) => Offset(xScale(i), yScale(data[i])));
    final path = Path()..moveTo(linePts[0].dx, linePts[0].dy);
    for (int i = 1; i < n; i++) { path.lineTo(linePts[i].dx, linePts[i].dy); }

    // Gradient fill
    final fillPath = Path.from(path)
      ..lineTo(linePts.last.dx, size.height - pad.bottom)
      ..lineTo(pad.left, size.height - pad.bottom)
      ..close();
    canvas.drawPath(fillPath, Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [lineColor.withOpacity(0.22), lineColor.withOpacity(0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));

    // Grid lines
    final gridPaint = Paint()..color = AppColors.borderSubtle..strokeWidth = 0.5;
    for (final t in [0.0, 0.25, 0.5, 0.75, 1.0]) {
      final y = pad.top + iH * (1 - t);
      canvas.drawLine(Offset(pad.left, y), Offset(size.width - pad.right, y), gridPaint);
    }

    // Line
    canvas.drawPath(path, Paint()
      ..color = lineColor..strokeWidth = 1.8..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round);

    // Crosshair
    if (hoverIdx != null && hoverIdx! < n) {
      final cx = xScale(hoverIdx!);
      final cy = yScale(data[hoverIdx!]);
      canvas.drawLine(Offset(cx, pad.top), Offset(cx, size.height - pad.bottom),
          Paint()..color = AppColors.borderStrong..strokeWidth = 1..style = PaintingStyle.stroke..isAntiAlias = true
            ..shader = null..maskFilter = null
          );
      canvas.drawCircle(Offset(cx, cy), 5, Paint()..color = lineColor);
      canvas.drawCircle(Offset(cx, cy), 5, Paint()..color = AppColors.bgBase..style = PaintingStyle.stroke..strokeWidth = 2);
    }
  }

  @override
  bool shouldRepaint(_ChartPainter old) => old.hoverIdx != hoverIdx || old.data != data;
}

// ── Trade Sheet ───────────────────────────────────────────────────────────────

class _TradeSheet extends StatelessWidget {
  const _TradeSheet({required this.stock, required this.isBuy, required this.qty, required this.onQtyChange, required this.onClose, required this.onConfirm});
  final _StockData stock;
  final bool isBuy;
  final int qty;
  final ValueChanged<int> onQtyChange;
  final VoidCallback onClose, onConfirm;

  @override
  Widget build(BuildContext context) {
    final total = stock.price * qty;
    final color = isBuy ? AppColors.emerald : AppColors.crimson;
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
                border: Border(top: BorderSide(color: AppColors.borderDefault)),
              ),
              padding: const EdgeInsets.all(AppSpacing.screenH),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.borderStrong, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 14),
                Text('${isBuy ? 'Buy' : 'Sell'} ${stock.id}', style: AppTypography.headingM),
                const SizedBox(height: 16),
                // Qty
                Container(
                  decoration: BoxDecoration(color: AppColors.bgSurface, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderDefault)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Quantity', style: AppTypography.bodyS.copyWith(fontSize: 12)),
                    Row(children: [
                      GestureDetector(onTap: () => onQtyChange((qty - 1).clamp(1, 9999)), child: Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.bgInput, borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.remove, size: 14, color: AppColors.textPrimary))),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 14), child: Text('$qty', style: AppTypography.dataM.copyWith(fontSize: 18))),
                      GestureDetector(onTap: () => onQtyChange(qty + 1), child: Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.bgInput, borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.add, size: 14, color: AppColors.textPrimary))),
                    ]),
                  ]),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(color: AppColors.bgSurface, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderDefault)),
                  padding: const EdgeInsets.all(14),
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Price per share', style: AppTypography.bodyS.copyWith(fontSize: 12)),
                      Text('\$ ${stock.price.toStringAsFixed(2)}', style: AppTypography.dataS.copyWith(fontSize: 13)),
                    ]),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Total', style: AppTypography.bodyS.copyWith(fontWeight: FontWeight.w600, fontSize: 13)),
                      Text('\$ ${total.toStringAsFixed(2)}', style: AppTypography.dataS.copyWith(fontSize: 14, color: color, fontWeight: FontWeight.w600)),
                    ]),
                  ]),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: onConfirm,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppRadius.card)),
                    child: Center(child: Text(
                      '${isBuy ? 'Buy' : 'Sell'} $qty shares — \$ ${total.toStringAsFixed(2)}',
                      style: AppTypography.headingS.copyWith(color: Colors.white),
                    )),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isBuy ? 'Order executes at next cycle settlement.' : 'Proceeds credited at next settlement.',
                  style: AppTypography.labelCaps.copyWith(fontSize: 10),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
