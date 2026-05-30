import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

// ── Mock data ─────────────────────────────────────────────────────────────────

class _StockListing {
  const _StockListing({
    required this.ticker,
    required this.name,
    required this.icon,
    required this.sector,
    required this.country,
    required this.price,
    required this.change,
    required this.changePct,
    required this.volume,
    required this.marketCap,
    required this.sharesTotal,
    required this.sharesFloat,
    required this.dividendYield,
    required this.pe,
    required this.ownedShares,
    required this.isOwner,
    required this.priceHistory,
  });
  final String ticker, name, icon, sector, country;
  final double price, change, changePct, dividendYield, pe;
  final int volume, marketCap, sharesTotal, sharesFloat, ownedShares;
  final bool isOwner;
  final List<double> priceHistory; // last 12 cycles
}

const _listings = [
  _StockListing(
    ticker: 'CRT', name: 'Caedoria Retail', icon: '📱', sector: 'Retail', country: 'Caedoria',
    price: 4.20, change: 0.18, changePct: 4.48, volume: 84200, marketCap: 420000,
    sharesTotal: 100000, sharesFloat: 30000, dividendYield: 3.2, pe: 12.4,
    ownedShares: 12000, isOwner: true,
    priceHistory: [3.40, 3.55, 3.70, 3.60, 3.85, 3.90, 4.05, 3.95, 4.10, 4.00, 4.02, 4.20],
  ),
  _StockListing(
    ticker: 'VNX', name: 'Ventrex Capital', icon: '💰', sector: 'Finance', country: 'Ventrex',
    price: 18.50, change: -0.35, changePct: -1.86, volume: 32100, marketCap: 1850000,
    sharesTotal: 100000, sharesFloat: 45000, dividendYield: 5.8, pe: 9.2,
    ownedShares: 0, isOwner: false,
    priceHistory: [17.20, 17.80, 18.40, 18.90, 19.20, 19.10, 18.80, 18.60, 18.90, 18.70, 18.85, 18.50],
  ),
  _StockListing(
    ticker: 'NRD', name: 'Nord Logistics', icon: '🚚', sector: 'Logistics', country: 'Dalthorn',
    price: 7.85, change: 0.42, changePct: 5.65, volume: 56400, marketCap: 785000,
    sharesTotal: 100000, sharesFloat: 25000, dividendYield: 1.4, pe: 22.1,
    ownedShares: 5000, isOwner: false,
    priceHistory: [6.80, 6.95, 7.10, 7.00, 7.20, 7.35, 7.50, 7.40, 7.60, 7.70, 7.43, 7.85],
  ),
  _StockListing(
    ticker: 'ELT', name: 'Eltria Tech', icon: '💻', sector: 'Technology', country: 'Eltria',
    price: 31.20, change: 1.60, changePct: 5.41, volume: 21800, marketCap: 3120000,
    sharesTotal: 100000, sharesFloat: 20000, dividendYield: 0.0, pe: 38.5,
    ownedShares: 0, isOwner: false,
    priceHistory: [25.40, 26.80, 28.10, 27.60, 29.00, 30.20, 29.50, 30.80, 31.50, 30.90, 29.60, 31.20],
  ),
  _StockListing(
    ticker: 'SRV', name: 'Sorvane Resorts', icon: '🏨', sector: 'Hospitality', country: 'Sorvane',
    price: 12.40, change: -0.80, changePct: -6.06, volume: 18300, marketCap: 1240000,
    sharesTotal: 100000, sharesFloat: 35000, dividendYield: 7.1, pe: 14.8,
    ownedShares: 0, isOwner: false,
    priceHistory: [13.80, 13.50, 13.20, 13.40, 13.10, 13.00, 12.80, 13.20, 13.40, 13.10, 13.20, 12.40],
  ),
  _StockListing(
    ticker: 'DTH', name: 'Dalthorn Mining', icon: '⛏', sector: 'Manufacturing', country: 'Dalthorn',
    price: 9.10, change: 0.05, changePct: 0.55, volume: 44700, marketCap: 910000,
    sharesTotal: 100000, sharesFloat: 40000, dividendYield: 4.3, pe: 7.6,
    ownedShares: 0, isOwner: false,
    priceHistory: [9.00, 8.90, 9.10, 9.05, 8.95, 9.00, 9.10, 9.05, 9.00, 9.05, 9.05, 9.10],
  ),
];

// ── Stock Market Overview ─────────────────────────────────────────────────────

class StockMarketScreen extends StatefulWidget {
  const StockMarketScreen({super.key});

  @override
  State<StockMarketScreen> createState() => _StockMarketScreenState();
}

class _StockMarketScreenState extends State<StockMarketScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  String _sort = 'change'; // 'change', 'cap', 'volume'

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

  List<_StockListing> get _sortedListings {
    final list = [..._listings];
    switch (_sort) {
      case 'cap':    list.sort((a, b) => b.marketCap.compareTo(a.marketCap));
      case 'volume': list.sort((a, b) => b.volume.compareTo(a.volume));
      default:       list.sort((a, b) => b.changePct.abs().compareTo(a.changePct.abs()));
    }
    return list;
  }

  List<_StockListing> get _portfolio =>
      _listings.where((l) => l.ownedShares > 0).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgBase,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Stock Market', style: TextStyle(color: AppColors.textPrimary, fontFamily: 'Syne', fontWeight: FontWeight.w700, fontSize: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textSecondary, size: 22),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(46),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
            ),
            child: TabBar(
              controller: _tabs,
              labelColor: AppColors.gold,
              unselectedLabelColor: AppColors.textTertiary,
              labelStyle: AppTypography.bodyS.copyWith(fontWeight: FontWeight.w600),
              unselectedLabelStyle: AppTypography.bodyS,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(color: AppColors.gold, width: 2),
              ),
              tabs: const [Tab(text: 'Market'), Tab(text: 'My Portfolio')],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _MarketTab(listings: _sortedListings, currentSort: _sort, onSort: (s) => setState(() => _sort = s), onTap: _openDetail),
          _PortfolioTab(holdings: _portfolio, onTap: _openDetail),
        ],
      ),
    );
  }

  void _openDetail(_StockListing listing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ListingDetailSheet(listing: listing),
    );
  }
}

// ── Market Tab ────────────────────────────────────────────────────────────────

class _MarketTab extends StatelessWidget {
  const _MarketTab({required this.listings, required this.currentSort, required this.onSort, required this.onTap});
  final List<_StockListing> listings;
  final String currentSort;
  final ValueChanged<String> onSort;
  final ValueChanged<_StockListing> onTap;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.decimalPattern();
    // Market summary
    final gainers = listings.where((l) => l.change >= 0).length;
    final losers  = listings.length - gainers;

    return ListView(children: [
      // Market summary strip
      Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH, vertical: 14),
        decoration: const BoxDecoration(
          color: AppColors.bgSurface,
          border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
        ),
        child: Row(children: [
          _MktStat(label: 'Listed', value: '${listings.length}'),
          _Divider(),
          _MktStat(label: 'Gainers', value: '$gainers', valueColor: AppColors.emerald),
          _Divider(),
          _MktStat(label: 'Losers', value: '$losers', valueColor: AppColors.crimson),
          _Divider(),
          _MktStat(label: 'Volume', value: '${fmt.format(listings.fold<int>(0, (s, l) => s + l.volume))}'),
        ]),
      ),

      // Sort chips
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 14, AppSpacing.screenH, 6),
        child: Row(children: [
          _SortChip(label: 'Most Active', value: 'change',  current: currentSort, onTap: onSort),
          const SizedBox(width: 8),
          _SortChip(label: 'Market Cap',  value: 'cap',     current: currentSort, onTap: onSort),
          const SizedBox(width: 8),
          _SortChip(label: 'Volume',      value: 'volume',  current: currentSort, onTap: onSort),
        ]),
      ),

      // Listing rows
      ...listings.map((l) => _ListingRow(listing: l, onTap: () => onTap(l))),
      const SizedBox(height: AppSpacing.x3l),
    ]);
  }
}

class _MktStat extends StatelessWidget {
  const _MktStat({required this.label, required this.value, this.valueColor = AppColors.textPrimary});
  final String label, value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Column(children: [
      Text(value, style: AppTypography.dataS.copyWith(color: valueColor, fontSize: 14)),
      const SizedBox(height: 2),
      Text(label, style: AppTypography.label.copyWith(color: AppColors.textTertiary, fontSize: 10)),
    ]));
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 28, color: AppColors.borderSubtle, margin: const EdgeInsets.symmetric(horizontal: 4));
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({required this.label, required this.value, required this.current, required this.onTap});
  final String label, value, current;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final active = current == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.gold.withValues(alpha: 0.12) : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(color: active ? AppColors.gold.withValues(alpha: 0.4) : AppColors.borderDefault),
        ),
        child: Text(label, style: AppTypography.label.copyWith(color: active ? AppColors.gold : AppColors.textSecondary)),
      ),
    );
  }
}

class _ListingRow extends StatelessWidget {
  const _ListingRow({required this.listing, required this.onTap});
  final _StockListing listing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0.00');
    final pos = listing.change >= 0;
    final changeColor = pos ? AppColors.emerald : AppColors.crimson;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH, vertical: 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
        ),
        child: Row(children: [
          // Icon + ticker
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Center(child: Text(listing.icon, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(listing.ticker, style: AppTypography.bodyM.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(width: 6),
              if (listing.isOwner)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.violet.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text('Owner', style: AppTypography.label.copyWith(color: AppColors.violet, fontSize: 9)),
                )
              else if (listing.ownedShares > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.sky.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text('Holding', style: AppTypography.label.copyWith(color: AppColors.sky, fontSize: 9)),
                ),
            ]),
            const SizedBox(height: 2),
            Text(listing.name, style: AppTypography.label.copyWith(color: AppColors.textTertiary)),
          ])),
          // Mini sparkline
          _Sparkline(history: listing.priceHistory, positive: pos, width: 52, height: 28),
          const SizedBox(width: 12),
          // Price + change
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('\$ ${fmt.format(listing.price)}', style: AppTypography.dataS.copyWith(color: AppColors.gold, fontSize: 15)),
            const SizedBox(height: 2),
            Text(
              '${pos ? '+' : ''}${listing.changePct.toStringAsFixed(2)}%',
              style: AppTypography.label.copyWith(color: changeColor),
            ),
          ]),
        ]),
      ),
    );
  }
}

// ── Portfolio Tab ─────────────────────────────────────────────────────────────

class _PortfolioTab extends StatelessWidget {
  const _PortfolioTab({required this.holdings, required this.onTap});
  final List<_StockListing> holdings;
  final ValueChanged<_StockListing> onTap;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.decimalPattern();
    final fmtPrice = NumberFormat('#,##0.00');

    if (holdings.isEmpty) {
      return const Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.bar_chart, color: AppColors.textTertiary, size: 48),
          SizedBox(height: 16),
          Text('No holdings yet', style: TextStyle(color: AppColors.textTertiary, fontFamily: 'DMSans', fontSize: 16)),
          SizedBox(height: 6),
          Text('Buy shares from the Market tab', style: TextStyle(color: AppColors.textTertiary, fontFamily: 'DMSans', fontSize: 13)),
        ]),
      );
    }

    final totalValue = holdings.fold<double>(0, (s, l) => s + l.price * l.ownedShares);

    return ListView(padding: const EdgeInsets.all(AppSpacing.screenH), children: [
      // Portfolio value
      Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Portfolio Value', style: AppTypography.labelCaps),
          const SizedBox(height: 6),
          Text('\$ ${fmt.format(totalValue.round())}', style: AppTypography.displayM.copyWith(color: AppColors.gold)),
        ]),
      ),
      const SizedBox(height: AppSpacing.xl),

      Text('Holdings (${holdings.length})', style: AppTypography.labelCaps),
      const SizedBox(height: AppSpacing.md),

      Container(
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(children: holdings.asMap().entries.map((e) {
          final isLast = e.key == holdings.length - 1;
          final l = e.value;
          final pos = l.change >= 0;
          final value = l.price * l.ownedShares;
          return GestureDetector(
            onTap: () => onTap(l),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 14),
              decoration: BoxDecoration(
                border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.borderSubtle)),
              ),
              child: Row(children: [
                Text(l.icon, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.ticker, style: AppTypography.bodyM.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  Text('${fmt.format(l.ownedShares)} shares', style: AppTypography.label.copyWith(color: AppColors.textTertiary)),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('\$ ${fmt.format(value.round())}', style: AppTypography.dataS.copyWith(color: AppColors.gold, fontSize: 14)),
                  Text(
                    '${pos ? '+' : ''}${l.changePct.toStringAsFixed(2)}% @ \$${fmtPrice.format(l.price)}',
                    style: AppTypography.label.copyWith(color: pos ? AppColors.emerald : AppColors.crimson, fontSize: 10),
                  ),
                ]),
              ]),
            ),
          );
        }).toList()),
      ),
      const SizedBox(height: AppSpacing.x3l),
    ]);
  }
}

// ── Listing Detail Bottom Sheet ───────────────────────────────────────────────

class _ListingDetailSheet extends StatefulWidget {
  const _ListingDetailSheet({required this.listing});
  final _StockListing listing;

  @override
  State<_ListingDetailSheet> createState() => _ListingDetailSheetState();
}

class _ListingDetailSheetState extends State<_ListingDetailSheet> {
  bool _showTradeSheet = false;
  bool _isBuying = true;

  @override
  Widget build(BuildContext context) {
    return _showTradeSheet
        ? _TradeSheet(listing: widget.listing, isBuying: _isBuying, onClose: () => setState(() => _showTradeSheet = false))
        : _DetailContent(
            listing: widget.listing,
            onBuy:  () => setState(() { _isBuying = true;  _showTradeSheet = true; }),
            onSell: () => setState(() { _isBuying = false; _showTradeSheet = true; }),
          );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.listing, required this.onBuy, required this.onSell});
  final _StockListing listing;
  final VoidCallback onBuy, onSell;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.decimalPattern();
    final fmtPrice = NumberFormat('#,##0.00');
    final pos = listing.change >= 0;
    final changeColor = pos ? AppColors.emerald : AppColors.crimson;

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
          ),
          child: Column(children: [
            // Handle
            const SizedBox(height: 12),
            Container(width: 36, height: 3, decoration: BoxDecoration(color: AppColors.borderStrong, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
              child: Row(children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.bgElevated,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: AppColors.borderDefault),
                  ),
                  child: Center(child: Text(listing.icon, style: const TextStyle(fontSize: 24))),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${listing.ticker} · ${listing.name}', style: AppTypography.headingM),
                  Text('${listing.sector} · ${listing.country}', style: AppTypography.bodyM.copyWith(color: AppColors.textSecondary)),
                ])),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textTertiary, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ]),
            ),
            const SizedBox(height: 16),

            // Price hero
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('\$ ${fmtPrice.format(listing.price)}', style: AppTypography.displayL.copyWith(color: AppColors.gold)),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '${pos ? '+' : ''}${fmtPrice.format(listing.change)} (${pos ? '+' : ''}${listing.changePct.toStringAsFixed(2)}%)',
                    style: AppTypography.bodyM.copyWith(color: changeColor),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),

            // Chart
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
              child: _PriceChart(history: listing.priceHistory, positive: pos),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Stats grid
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
                children: [
                  _StatGrid(rows: [
                    _StatRow('Market Cap',    '\$ ${fmt.format(listing.marketCap)}'),
                    _StatRow('Volume',        fmt.format(listing.volume)),
                    _StatRow('Shares Total',  fmt.format(listing.sharesTotal)),
                    _StatRow('Float',         fmt.format(listing.sharesFloat)),
                    _StatRow('Div. Yield',    '${listing.dividendYield.toStringAsFixed(1)}%'),
                    _StatRow('P/E Ratio',     listing.pe.toStringAsFixed(1)),
                  ]),
                  if (listing.ownedShares > 0) ...[
                    const SizedBox(height: AppSpacing.xl),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.bgElevated,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        border: Border.all(color: AppColors.borderDefault),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Your Position', style: AppTypography.labelCaps),
                          const SizedBox(height: 4),
                          Text('${fmt.format(listing.ownedShares)} shares', style: AppTypography.dataM.copyWith(color: AppColors.textPrimary)),
                        ]),
                        Text(
                          '\$ ${fmt.format((listing.price * listing.ownedShares).round())}',
                          style: AppTypography.dataL.copyWith(color: AppColors.gold),
                        ),
                      ]),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),

            // CTA buttons
            Container(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 12, AppSpacing.screenH, 28),
              decoration: const BoxDecoration(
                color: AppColors.bgSurface,
                border: Border(top: BorderSide(color: AppColors.borderSubtle)),
              ),
              child: Row(children: [
                Expanded(child: _CtaButton(label: 'Buy Shares', color: AppColors.emerald, onTap: onBuy)),
                if (listing.ownedShares > 0) ...[
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: _CtaButton(label: 'Sell Shares', color: AppColors.crimson, onTap: onSell)),
                ],
              ]),
            ),
          ]),
        );
      },
    );
  }
}

// ── Trade Sheet ───────────────────────────────────────────────────────────────

class _TradeSheet extends StatefulWidget {
  const _TradeSheet({required this.listing, required this.isBuying, required this.onClose});
  final _StockListing listing;
  final bool isBuying;
  final VoidCallback onClose;

  @override
  State<_TradeSheet> createState() => _TradeSheetState();
}

class _TradeSheetState extends State<_TradeSheet> {
  int _qty = 100;

  double get _total => _qty * widget.listing.price;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.decimalPattern();
    final fmtPrice = NumberFormat('#,##0.00');
    final accentColor = widget.isBuying ? AppColors.emerald : AppColors.crimson;
    final action = widget.isBuying ? 'Buy' : 'Sell';

    final maxAffordable = widget.isBuying
        ? (84200 / widget.listing.price).floor() // mock wallet balance
        : widget.listing.ownedShares;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
      ),
      padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 16, AppSpacing.screenH, 32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Handle
        Center(child: Container(width: 36, height: 3, decoration: BoxDecoration(color: AppColors.borderStrong, borderRadius: BorderRadius.circular(2)))),
        const SizedBox(height: 20),

        // Title row
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('$action ${widget.listing.ticker}', style: AppTypography.headingL),
          GestureDetector(
            onTap: widget.onClose,
            child: const Icon(Icons.close, color: AppColors.textTertiary, size: 20),
          ),
        ]),
        const SizedBox(height: 6),
        Text('\$ ${fmtPrice.format(widget.listing.price)} per share', style: AppTypography.bodyM.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.xl),

        // Qty stepper
        Row(children: [
          Text('Quantity', style: AppTypography.bodyM.copyWith(color: AppColors.textSecondary)),
          const Spacer(),
          _QtyButton(icon: Icons.remove, onTap: () { if (_qty > 1) setState(() => _qty = math.max(1, _qty - 100)); }),
          const SizedBox(width: AppSpacing.md),
          SizedBox(
            width: 80,
            child: Text(fmt.format(_qty), style: AppTypography.dataL.copyWith(color: AppColors.textPrimary, fontSize: 22), textAlign: TextAlign.center),
          ),
          const SizedBox(width: AppSpacing.md),
          _QtyButton(icon: Icons.add, onTap: () { if (_qty < maxAffordable) setState(() => _qty = math.min(maxAffordable, _qty + 100)); }),
        ]),
        const SizedBox(height: AppSpacing.lg),

        // Quick qty chips
        Row(children: [
          for (final pct in [0.25, 0.5, 0.75, 1.0]) ...[
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _qty = math.max(1, (maxAffordable * pct).floor())),
                child: Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.bgElevated,
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                    border: Border.all(color: AppColors.borderDefault),
                  ),
                  child: Text('${(pct * 100).round()}%', style: AppTypography.label.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
                ),
              ),
            ),
          ],
        ]),
        const SizedBox(height: AppSpacing.xl),

        // Total line
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: accentColor.withValues(alpha: 0.2)),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Total', style: AppTypography.bodyM.copyWith(color: AppColors.textSecondary)),
            Text('\$ ${fmt.format(_total.round())}', style: AppTypography.dataL.copyWith(color: accentColor)),
          ]),
        ),
        const SizedBox(height: AppSpacing.xl),

        // CTA — consequence label per CLAUDE.md rule
        _CtaButton(
          label: '$action ${fmt.format(_qty)} shares — \$ ${fmt.format(_total.round())}',
          color: accentColor,
          onTap: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('$action order placed: ${fmt.format(_qty)} ${widget.listing.ticker} shares'),
              backgroundColor: AppColors.bgElevated,
              behavior: SnackBarBehavior.floating,
            ));
          },
        ),
      ]),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: AppColors.bgElevated,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 18),
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  const _CtaButton({required this.label, required this.color, required this.onTap});
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Center(
          child: Text(label, style: AppTypography.headingS.copyWith(color: color), textAlign: TextAlign.center),
        ),
      ),
    );
  }
}

// ── Shared chart widgets ──────────────────────────────────────────────────────

class _PriceChart extends StatelessWidget {
  const _PriceChart({required this.history, required this.positive});
  final List<double> history;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: CustomPaint(
        painter: _LinePainter(data: history, color: positive ? AppColors.emerald : AppColors.crimson),
        size: Size.infinite,
      ),
    );
  }
}

class _Sparkline extends StatelessWidget {
  const _Sparkline({required this.history, required this.positive, required this.width, required this.height});
  final List<double> history;
  final bool positive;
  final double width, height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width, height: height,
      child: CustomPaint(
        painter: _LinePainter(data: history, color: positive ? AppColors.emerald : AppColors.crimson),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  const _LinePainter({required this.data, required this.color});
  final List<double> data;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;
    final min = data.reduce(math.min);
    final max = data.reduce(math.max);
    final range = (max - min).abs();
    if (range == 0) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final x = i / (data.length - 1) * size.width;
      final y = size.height - (data[i] - min) / range * size.height;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_LinePainter old) => old.data != data;
}

// ── Stat grid ─────────────────────────────────────────────────────────────────

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.rows});
  final List<_StatRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Wrap(
        children: rows.asMap().entries.map((e) {
          final last = e.key == rows.length - 1;
          final even = rows.length % 2 == 0;
          final lastRow = last || (even && e.key == rows.length - 2);
          return SizedBox(
            width: MediaQuery.of(context).size.width / 2 - AppSpacing.screenH,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: lastRow ? BorderSide.none : const BorderSide(color: AppColors.borderSubtle),
                  right: e.key.isEven ? const BorderSide(color: AppColors.borderSubtle) : BorderSide.none,
                ),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(e.value.label, style: AppTypography.label.copyWith(color: AppColors.textTertiary, fontSize: 10)),
                const SizedBox(height: 4),
                Text(e.value.value, style: AppTypography.dataS.copyWith(color: AppColors.textPrimary, fontSize: 13)),
              ]),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StatRow {
  const _StatRow(this.label, this.value);
  final String label, value;
}
