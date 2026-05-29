import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

// ── Mock data ─────────────────────────────────────────────────────────────────

const _walletBalance = 84200;
const _creditScore = 720;

const _companyAccounts = [
  ('Volta Café',      12400),
  ('Volta Foods',     3200),
  ('Caedoria Retail', 5800),
];

const _loans = [
  _LoanData(id: 'L-001', lender: 'Central Bank', original: 50000, remaining: 38000, rate: 12, payment: 1200, issued: 30, matures: 70, nextDue: '1h 42m'),
];

const _deposits = [
  _DepositData(id: 'D-001', bank: 'Central Bank',    amount: 12000, rate: 8.4, cycles: 10, remaining: 6),
  _DepositData(id: 'D-002', bank: 'Ventrex Savings', amount: 8000,  rate: 9.1, cycles: 20, remaining: 14),
];

const _lenders = [
  _LenderData(id: 'cb',  name: 'Central Bank',    rate: 12.0, max: 100000, term: '20–60 cycles', minScore: 500, badge: 'official'),
  _LenderData(id: 'vnx', name: 'Ventrex Savings', rate: 9.5,  max: 60000,  term: '15–40 cycles', minScore: 680, badge: 'private'),
  _LenderData(id: 'mfi', name: 'Morrath Finance', rate: 16.0, max: 200000, term: '10–80 cycles', minScore: 400, badge: 'private'),
];

const _txCycles = [
  _TxCycle(cycle: 47, net: 2400, rows: [
    _TxRow(id: 1,  type: 'salary',   dir: 'in',  label: 'Salary received',            sub: 'Horizon Tech',               time: '09:14', amount: 8000),
    _TxRow(id: 2,  type: 'loan',     dir: 'out', label: 'Loan payment — Central Bank', sub: 'Auto-deducted cycle settle',  time: '00:00', amount: 1200),
    _TxRow(id: 3,  type: 'rent',     dir: 'out', label: 'Personal rent',               sub: 'Caedoria Apt. #14',           time: '00:00', amount: 3200),
    _TxRow(id: 4,  type: 'purchase', dir: 'out', label: 'Food purchase',               sub: 'Volta Café',                  time: '11:32', amount: 400),
    _TxRow(id: 5,  type: 'fee',      dir: 'out', label: 'Transaction fee',             sub: 'Applied on salary',           time: '09:14', amount: 200),
  ]),
  _TxCycle(cycle: 46, net: -800, rows: [
    _TxRow(id: 6,  type: 'salary',   dir: 'in',  label: 'Salary received',            sub: 'Horizon Tech',               time: '09:02', amount: 8000),
    _TxRow(id: 7,  type: 'loan',     dir: 'out', label: 'Loan payment — Central Bank', sub: 'Auto-deducted cycle settle',  time: '00:00', amount: 1200),
    _TxRow(id: 8,  type: 'rent',     dir: 'out', label: 'Personal rent',               sub: 'Caedoria Apt. #14',           time: '00:00', amount: 3200),
    _TxRow(id: 9,  type: 'purchase', dir: 'out', label: 'Clothing purchase',           sub: 'Caedoria Retail',             time: '14:55', amount: 2800),
    _TxRow(id: 10, type: 'fee',      dir: 'out', label: 'Transaction fee',             sub: 'Applied on salary',           time: '09:02', amount: 200),
    _TxRow(id: 12, type: 'salary',   dir: 'in',  label: 'Dividend — VLTF',            sub: 'Stock market',                time: '00:00', amount: 1000),
  ]),
  _TxCycle(cycle: 45, net: 5200, rows: [
    _TxRow(id: 13, type: 'salary',   dir: 'in',  label: 'Salary received',            sub: 'Horizon Tech',               time: '09:10', amount: 8000),
    _TxRow(id: 14, type: 'loan',     dir: 'out', label: 'Loan payment — Central Bank', sub: 'Auto-deducted cycle settle',  time: '00:00', amount: 1200),
    _TxRow(id: 15, type: 'rent',     dir: 'out', label: 'Personal rent',               sub: 'Caedoria Apt. #14',           time: '00:00', amount: 3200),
    _TxRow(id: 16, type: 'fee',      dir: 'out', label: 'Transaction fee',             sub: 'Applied on salary',           time: '09:10', amount: 200),
    _TxRow(id: 17, type: 'transfer', dir: 'in',  label: 'Contract payment received',  sub: 'Meridian Corp',               time: '12:30', amount: 1800),
  ]),
];

const _txTypeFilters = ['All', 'Salary', 'Loans', 'Purchases', 'Transfers', 'Fees'];
const _txDirFilters  = ['All', 'In', 'Out'];

// ── Data classes ──────────────────────────────────────────────────────────────

class _LoanData {
  const _LoanData({required this.id, required this.lender, required this.original, required this.remaining, required this.rate, required this.payment, required this.issued, required this.matures, required this.nextDue});
  final String id, lender, nextDue;
  final int original, remaining, rate, payment, issued, matures;
}

class _DepositData {
  const _DepositData({required this.id, required this.bank, required this.amount, required this.rate, required this.cycles, required this.remaining});
  final String id, bank;
  final int amount, cycles, remaining;
  final double rate;
}

class _LenderData {
  const _LenderData({required this.id, required this.name, required this.rate, required this.max, required this.term, required this.minScore, required this.badge});
  final String id, name, term, badge;
  final double rate;
  final int max, minScore;
}

class _TxRow {
  const _TxRow({required this.id, required this.type, required this.dir, required this.label, required this.sub, required this.time, required this.amount});
  final int id, amount;
  final String type, dir, label, sub, time;
}

class _TxCycle {
  const _TxCycle({required this.cycle, required this.net, required this.rows});
  final int cycle, net;
  final List<_TxRow> rows;
}

// ── Helpers ───────────────────────────────────────────────────────────────────

({String label, Color color}) _creditBand(int score) {
  if (score >= 900) return (label: 'Excellent', color: AppColors.gold);
  if (score >= 750) return (label: 'Very Good', color: AppColors.sky);
  if (score >= 600) return (label: 'Good',      color: AppColors.emerald);
  if (score >= 400) return (label: 'Fair',       color: AppColors.amber);
  return                     (label: 'Poor',      color: AppColors.crimson);
}

String _txIcon(String type, String dir) {
  switch (type) {
    case 'salary':   return dir == 'in' ? '💼' : '👥';
    case 'loan':     return '🏦';
    case 'rent':     return '🏠';
    case 'purchase': return '🛍';
    case 'fee':      return '📋';
    case 'transfer': return '↔️';
    default:         return '💰';
  }
}

bool _txMatch(String type, String filterType) {
  if (filterType == 'All') return true;
  final map = {'Salary': 'salary', 'Loans': 'loan', 'Purchases': 'purchase', 'Transfers': 'transfer', 'Fees': 'fee'};
  return type == map[filterType];
}

// ── FinanceScreen ─────────────────────────────────────────────────────────────

enum _FinanceView { overview, txHistory, loans, deposits, loanApp }

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  _FinanceView _view = _FinanceView.overview;

  Widget _buildView() {
    switch (_view) {
      case _FinanceView.overview:
        return _WalletOverview(
          onTxHistory: () => setState(() => _view = _FinanceView.txHistory),
          onLoans: () => setState(() => _view = _FinanceView.loans),
          onDeposits: () => setState(() => _view = _FinanceView.deposits),
          onLoanApp: () => setState(() => _view = _FinanceView.loanApp),
        );
      case _FinanceView.txHistory:
        return _TxHistoryScreen(onBack: () => setState(() => _view = _FinanceView.overview));
      case _FinanceView.loans:
        return _LoansScreen(
          onBack: () => setState(() => _view = _FinanceView.overview),
          onApply: () => setState(() => _view = _FinanceView.loanApp),
        );
      case _FinanceView.deposits:
        return _DepositsScreen(onBack: () => setState(() => _view = _FinanceView.overview));
      case _FinanceView.loanApp:
        return _LoanWizardScreen(onClose: () => setState(() => _view = _FinanceView.overview));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(child: _buildView()),
    );
  }
}

// ── Live Balance Hero ─────────────────────────────────────────────────────────

class _LiveBalance extends StatefulWidget {
  const _LiveBalance();
  @override
  State<_LiveBalance> createState() => _LiveBalanceState();
}

class _LiveBalanceState extends State<_LiveBalance> {
  int _val = _walletBalance;
  bool _glowing = false;
  Timer? _repeatTimer;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2800), _fire);
    _repeatTimer = Timer.periodic(const Duration(milliseconds: 11000), (_) => _fire());
  }

  void _fire() {
    if (!mounted) return;
    final delta = 800 + (DateTime.now().millisecondsSinceEpoch % 1600);
    setState(() { _val += delta.toInt(); _glowing = true; });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _glowing = false);
    });
  }

  @override
  void dispose() { _repeatTimer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final band = _creditBand(_creditScore);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.hero),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: _glowing ? [
          BoxShadow(color: AppColors.gold.withOpacity(0.18), blurRadius: 50),
          BoxShadow(color: AppColors.gold.withOpacity(0.07), blurRadius: 100),
        ] : [],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Personal Wallet', style: AppTypography.labelCaps),
        const SizedBox(height: AppSpacing.sm),
        RichText(text: TextSpan(children: [
          TextSpan(text: '\$ ', style: AppTypography.displayXL.copyWith(color: AppColors.gold)),
          TextSpan(text: NumberFormat.decimalPattern().format(_val), style: AppTypography.displayXL),
        ])),
        if (_glowing) ...[
          const SizedBox(height: 4),
          Text('+\$ 1,200', style: AppTypography.dataS.copyWith(color: AppColors.emerald)),
        ],
        const SizedBox(height: AppSpacing.md),
        const Divider(color: AppColors.borderSubtle, height: 1),
        const SizedBox(height: AppSpacing.md),
        Row(children: [
          _SubStat2(label: 'Companies', val: '\$ ${NumberFormat.decimalPattern().format(_companyAccounts.fold(0, (s, c) => s + c.$2))}'),
          _StatDivider2(),
          const _SubStat2(label: 'Loans due', val: '\$ 1,200', color: AppColors.crimson),
          _StatDivider2(),
          _SubStat2(label: 'Credit', val: '$_creditScore ${band.label}', color: band.color),
        ]),
      ]),
    );
  }
}

class _SubStat2 extends StatelessWidget {
  const _SubStat2({required this.label, required this.val, this.color});
  final String label, val;
  final Color? color;
  @override
  Widget build(BuildContext context) => Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: AppTypography.labelCaps.copyWith(fontSize: 10)),
    const SizedBox(height: 3),
    Text(val, style: AppTypography.dataS.copyWith(fontSize: 12, color: color ?? AppColors.textPrimary)),
  ]));
}

class _StatDivider2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 32, color: AppColors.borderSubtle, margin: const EdgeInsets.symmetric(horizontal: 12));
}

// ── Wallet Overview ───────────────────────────────────────────────────────────

class _WalletOverview extends StatelessWidget {
  const _WalletOverview({required this.onTxHistory, required this.onLoans, required this.onDeposits, required this.onLoanApp});
  final VoidCallback onTxHistory, onLoans, onDeposits, onLoanApp;

  @override
  Widget build(BuildContext context) {
    final band = _creditBand(_creditScore);
    final totalCompany = _companyAccounts.fold(0, (s, c) => s + c.$2);
    final totalDeposit = _deposits.fold(0, (s, d) => s + d.amount);
    final avgDepRate = (_deposits.fold(0.0, (s, d) => s + d.rate) / _deposits.length).toStringAsFixed(1);

    return ListView(padding: const EdgeInsets.all(AppSpacing.screenH), children: [
      const _LiveBalance(),
      const SizedBox(height: 14),

      // Quick actions
      Row(children: [
        const _QuickAction(label: 'Send Money',   icon: Icons.north_east,     color: AppColors.sky),
        const SizedBox(width: 10),
        _QuickAction(label: 'Transactions', icon: Icons.receipt_long,   color: AppColors.textSecondary, onTap: onTxHistory),
        const SizedBox(width: 10),
        _QuickAction(label: 'New Loan',     icon: Icons.add_circle_outline, color: AppColors.amber, onTap: onLoanApp),
      ]),
      const SizedBox(height: 14),

      // Company accounts
      Container(
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Company Accounts', style: AppTypography.labelCaps),
              Text('Manage →', style: AppTypography.label.copyWith(color: AppColors.gold)),
            ]),
          ),
          const Divider(color: AppColors.borderSubtle, height: 1),
          ..._companyAccounts.asMap().entries.map((e) => Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(e.value.$1, style: AppTypography.bodyS.copyWith(color: AppColors.textSecondary, fontSize: 13)),
                Text('\$ ${NumberFormat.decimalPattern().format(e.value.$2)}',
                    style: AppTypography.dataS.copyWith(fontSize: 13)),
              ]),
            ),
            if (e.key < _companyAccounts.length - 1) const Divider(color: AppColors.borderSubtle, height: 1),
          ])),
          const Divider(color: AppColors.borderSubtle, height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.04),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(AppRadius.card)),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Total company cash', style: AppTypography.bodyS.copyWith(fontWeight: FontWeight.w600, color: AppColors.textSecondary, fontSize: 13)),
              Text('\$ ${NumberFormat.decimalPattern().format(totalCompany)}',
                  style: AppTypography.dataS.copyWith(color: AppColors.gold, fontWeight: FontWeight.w600)),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 14),

      // Credit score
      Container(
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Credit Score', style: AppTypography.labelCaps),
            Row(children: [
              Text('$_creditScore', style: AppTypography.displayM.copyWith(color: band.color, fontSize: 22)),
              const SizedBox(width: 6),
              Text('${band.label} ↑', style: AppTypography.label.copyWith(color: band.color, fontWeight: FontWeight.w600)),
            ]),
          ]),
          const SizedBox(height: 10),
          SizedBox(
            height: 8,
            child: Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  decoration: const BoxDecoration(gradient: LinearGradient(colors: [
                    AppColors.crimson, AppColors.crimson,
                    AppColors.amber,   AppColors.amber,
                    AppColors.emerald, AppColors.emerald,
                    AppColors.sky,     AppColors.sky,
                    AppColors.gold,    AppColors.gold,
                  ], stops: [0, .4, .4, .6, .6, .75, .75, .9, .9, 1])),
                ),
              ),
              Opacity(opacity: 0.3, child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(color: AppColors.bgBase),
              )),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: FractionallySizedBox(
                  widthFactor: _creditScore / 1000,
                  child: Container(
                    decoration: BoxDecoration(
                      color: band.color,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [BoxShadow(color: band.color.withOpacity(0.4), blurRadius: 8)],
                    ),
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 8),
          Row(children: [
            for (final l in ['0', 'Poor', 'Fair', 'Good', 'V.Good', 'Exc.', '1000'])
              Expanded(child: Text(l, style: AppTypography.labelCaps.copyWith(fontSize: 9), textAlign: TextAlign.center)),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.emerald, shape: BoxShape.circle)),
            const SizedBox(width: 5),
            Text('+15 this cycle — 9 on-time loan payments', style: AppTypography.bodyS.copyWith(fontSize: 11)),
          ]),
        ]),
      ),
      const SizedBox(height: 14),

      // Loans summary
      GestureDetector(
        onTap: onLoans,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('My Loans', style: AppTypography.labelCaps),
              Text('See all →', style: AppTypography.label.copyWith(color: AppColors.gold)),
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Active loans', style: AppTypography.bodyS.copyWith(fontSize: 12)),
              Text('1 · \$ 38,000 remaining', style: AppTypography.dataS.copyWith(fontSize: 13)),
            ]),
            const SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Next payment', style: AppTypography.bodyS.copyWith(fontSize: 12)),
              Row(children: [
                Text('\$ 1,200', style: AppTypography.dataS.copyWith(fontSize: 13, color: AppColors.crimson)),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColors.amber.withOpacity(0.25)),
                  ),
                  child: Text('in 1h 42m', style: AppTypography.label.copyWith(color: AppColors.amber, fontWeight: FontWeight.w600, fontSize: 10)),
                ),
              ]),
            ]),
          ]),
        ),
      ),
      const SizedBox(height: 14),

      // Deposits summary
      GestureDetector(
        onTap: onDeposits,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('My Deposits', style: AppTypography.labelCaps),
              Text('See all →', style: AppTypography.label.copyWith(color: AppColors.gold)),
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('${_deposits.length} deposits', style: AppTypography.bodyS.copyWith(fontSize: 12)),
              Text('\$ ${NumberFormat.decimalPattern().format(totalDeposit)}', style: AppTypography.dataS.copyWith(fontSize: 13)),
            ]),
            const SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Avg rate', style: AppTypography.bodyS.copyWith(fontSize: 12)),
              Text('$avgDepRate% / cycle', style: AppTypography.dataS.copyWith(fontSize: 13, color: AppColors.emerald)),
            ]),
          ]),
        ),
      ),
      const SizedBox(height: AppSpacing.xl),
    ]);
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.label, required this.icon, required this.color, this.onTap});
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Column(children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(height: 5),
            Text(label, style: AppTypography.bodyS.copyWith(fontSize: 10), textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }
}

// ── Transaction History ───────────────────────────────────────────────────────

class _TxHistoryScreen extends StatefulWidget {
  const _TxHistoryScreen({required this.onBack});
  final VoidCallback onBack;
  @override
  State<_TxHistoryScreen> createState() => _TxHistoryScreenState();
}

class _TxHistoryScreenState extends State<_TxHistoryScreen> {
  String _typeF = 'All';
  String _dirF  = 'All';

  List<_TxCycle> get _filtered {
    return _txCycles.map((cyc) => _TxCycle(
      cycle: cyc.cycle,
      net: cyc.net,
      rows: cyc.rows.where((r) {
        final tMatch = _txMatch(r.type, _typeF);
        final dMatch = _dirF == 'All' || (_dirF == 'In' && r.dir == 'in') || (_dirF == 'Out' && r.dir == 'out');
        return tMatch && dMatch;
      }).toList(),
    )).where((c) => c.rows.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Header
      Container(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderSubtle))),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        child: Column(children: [
          Row(children: [
            GestureDetector(
              onTap: widget.onBack,
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: AppColors.bgSurface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.borderSubtle)),
                child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 16),
              ),
            ),
            const SizedBox(width: 12),
            Text('Transactions', style: AppTypography.headingL.copyWith(fontSize: 18)),
          ]),
          const SizedBox(height: 12),
          // Type filter chips
          SizedBox(
            height: 30,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _txTypeFilters.map((t) => GestureDetector(
                onTap: () => setState(() => _typeF = t),
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _typeF == t ? AppColors.gold.withOpacity(0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _typeF == t ? AppColors.gold : AppColors.borderDefault),
                  ),
                  child: Text(t, style: AppTypography.label.copyWith(color: _typeF == t ? AppColors.gold : AppColors.textTertiary, fontWeight: FontWeight.w600, fontSize: 11)),
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // Dir filter
          Row(children: _txDirFilters.map((d) => GestureDetector(
            onTap: () => setState(() => _dirF = d),
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: _dirF == d ? AppColors.sky.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _dirF == d ? AppColors.sky : AppColors.borderDefault),
              ),
              child: Text(d, style: AppTypography.label.copyWith(color: _dirF == d ? AppColors.sky : AppColors.textTertiary, fontWeight: FontWeight.w600, fontSize: 11)),
            ),
          )).toList()),
          const SizedBox(height: 12),
        ]),
      ),
      // Transaction list
      Expanded(child: ListView.builder(
        itemCount: _filtered.length,
        itemBuilder: (_, i) {
          final cyc = _filtered[i];
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Cycle ${cyc.cycle}', style: AppTypography.labelCaps.copyWith(fontWeight: FontWeight.w600)),
                Row(children: [
                  Icon(cyc.net >= 0 ? Icons.arrow_upward : Icons.arrow_downward, size: 9, color: cyc.net >= 0 ? AppColors.emerald : AppColors.crimson),
                  const SizedBox(width: 4),
                  Text(
                    '${cyc.net >= 0 ? '+' : '-'}\$ ${NumberFormat.decimalPattern().format(cyc.net.abs())} net',
                    style: AppTypography.dataS.copyWith(fontSize: 11, color: cyc.net >= 0 ? AppColors.emerald : AppColors.crimson),
                  ),
                ]),
              ]),
            ),
            ...cyc.rows.map((row) => Container(
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderSubtle))),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: AppColors.bgSurface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.borderSubtle)),
                  child: Center(child: Text(_txIcon(row.type, row.dir), style: const TextStyle(fontSize: 14))),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(row.label, style: AppTypography.bodyS.copyWith(fontWeight: FontWeight.w500, color: AppColors.textPrimary, fontSize: 13), overflow: TextOverflow.ellipsis),
                  Text('${row.sub} · ${row.time}', style: AppTypography.labelCaps.copyWith(fontSize: 11)),
                ])),
                Text(
                  '${row.dir == 'in' ? '+' : '-'}\$ ${NumberFormat.decimalPattern().format(row.amount)}',
                  style: AppTypography.dataS.copyWith(fontSize: 14, color: row.dir == 'in' ? AppColors.emerald : AppColors.crimson),
                ),
              ]),
            )),
          ]);
        },
      )),
    ]);
  }
}

// ── Loans Screen ──────────────────────────────────────────────────────────────

class _LoansScreen extends StatelessWidget {
  const _LoansScreen({required this.onBack, required this.onApply});
  final VoidCallback onBack, onApply;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        child: Row(children: [
          GestureDetector(
            onTap: onBack,
            child: Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.bgSurface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.borderSubtle)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 16)),
          ),
          const SizedBox(width: 12),
          Text('My Loans', style: AppTypography.headingL.copyWith(fontSize: 18)),
          const Spacer(),
          GestureDetector(
            onTap: onApply,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.gold.withOpacity(0.3))),
              child: Text('+ Apply', style: AppTypography.label.copyWith(color: AppColors.gold, fontWeight: FontWeight.w700)),
            ),
          ),
        ]),
      ),
      Expanded(child: ListView(padding: const EdgeInsets.all(AppSpacing.screenH), children: [
        ..._loans.map((loan) {
          final progress = 1 - (loan.remaining / loan.original);
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(loan.lender, style: AppTypography.headingS),
                  Text('${loan.id} · ${loan.rate}% per cycle', style: AppTypography.labelCaps.copyWith(fontSize: 11)),
                ]),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.amber.withOpacity(0.3))),
                  child: Text('Due ${loan.nextDue}', style: AppTypography.label.copyWith(color: AppColors.amber, fontWeight: FontWeight.w600, fontSize: 10)),
                ),
              ]),
              const SizedBox(height: 14),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Remaining', style: AppTypography.labelCaps.copyWith(fontSize: 10)),
                  Text('\$ ${NumberFormat.decimalPattern().format(loan.remaining)}', style: AppTypography.dataM.copyWith(fontSize: 20, color: AppColors.crimson)),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('Payment', style: AppTypography.labelCaps.copyWith(fontSize: 10)),
                  Text('\$ ${NumberFormat.decimalPattern().format(loan.payment)}/cycle', style: AppTypography.dataS.copyWith(color: AppColors.amber)),
                ]),
              ]),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: SizedBox(height: 4, child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.bgInput,
                  valueColor: const AlwaysStoppedAnimation(AppColors.emerald),
                )),
              ),
              const SizedBox(height: 6),
              Text('Cycle ${loan.issued} → ${loan.matures} · ${loan.matures - loan.issued} cycles total', style: AppTypography.labelCaps.copyWith(fontSize: 10)),
              const SizedBox(height: 14),
              // Payment history dots
              _HeartbeatDots(history: List.generate(9, (_) => 1), total: 40),
            ]),
          );
        }),
      ])),
    ]);
  }
}

class _HeartbeatDots extends StatelessWidget {
  const _HeartbeatDots({required this.history, required this.total});
  final List<int> history;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Wrap(spacing: 4, runSpacing: 4, children: List.generate(total, (i) {
        final h = i < history.length ? history[i] : -1;
        final color = h == 1 ? AppColors.emerald : h == 0 ? AppColors.crimson : AppColors.borderDefault;
        return Container(
          width: 10, height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: h >= 0 ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 6)] : [],
          ),
        );
      })),
      const SizedBox(height: 6),
      Row(children: [
        Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.emerald, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text('${history.where((h) => h == 1).length} on-time', style: AppTypography.labelCaps.copyWith(fontSize: 10)),
        const SizedBox(width: 12),
        Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.borderDefault, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text('${total - history.length} remaining', style: AppTypography.labelCaps.copyWith(fontSize: 10)),
      ]),
    ]);
  }
}

// ── Deposits Screen ───────────────────────────────────────────────────────────

class _DepositsScreen extends StatelessWidget {
  const _DepositsScreen({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        child: Row(children: [
          GestureDetector(
            onTap: onBack,
            child: Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.bgSurface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.borderSubtle)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 16)),
          ),
          const SizedBox(width: 12),
          Text('My Deposits', style: AppTypography.headingL.copyWith(fontSize: 18)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(color: AppColors.emerald.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.emerald.withOpacity(0.3))),
            child: Text('+ New Deposit', style: AppTypography.label.copyWith(color: AppColors.emerald, fontWeight: FontWeight.w700)),
          ),
        ]),
      ),
      Expanded(child: ListView(padding: const EdgeInsets.all(AppSpacing.screenH), children: [
        ..._deposits.map((dep) {
          final progress = 1 - (dep.remaining / dep.cycles);
          final earned = (dep.amount * dep.rate / 100 * (dep.cycles - dep.remaining)).round();
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(dep.bank, style: AppTypography.headingS),
                  Text('${dep.id} · ${dep.cycles} cycles total', style: AppTypography.labelCaps.copyWith(fontSize: 11)),
                ]),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.emerald.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text('${dep.rate}%/cycle', style: AppTypography.dataS.copyWith(color: AppColors.emerald, fontSize: 11)),
                ),
              ]),
              const SizedBox(height: 14),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Principal', style: AppTypography.labelCaps.copyWith(fontSize: 10)),
                  Text('\$ ${NumberFormat.decimalPattern().format(dep.amount)}', style: AppTypography.dataM.copyWith(fontSize: 20, color: AppColors.gold)),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('Earned so far', style: AppTypography.labelCaps.copyWith(fontSize: 10)),
                  Text('\$ ${NumberFormat.decimalPattern().format(earned)}', style: AppTypography.dataS.copyWith(color: AppColors.emerald)),
                ]),
              ]),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: SizedBox(height: 4, child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.bgInput,
                  valueColor: const AlwaysStoppedAnimation(AppColors.emerald),
                )),
              ),
              const SizedBox(height: 6),
              Text('${dep.remaining} cycles remaining', style: AppTypography.labelCaps.copyWith(fontSize: 10)),
            ]),
          );
        }),
      ])),
    ]);
  }
}

// ── Loan Wizard (3-step: Lender → Terms → Confirm) ────────────────────────────

class _LoanWizardScreen extends StatefulWidget {
  const _LoanWizardScreen({required this.onClose});
  final VoidCallback onClose;
  @override
  State<_LoanWizardScreen> createState() => _LoanWizardScreenState();
}

class _LoanWizardScreenState extends State<_LoanWizardScreen> {
  int _step = 1;
  _LenderData? _lender;
  double _amount = 10000;
  int _term = 20;

  static const _stepTitles = ['', 'Choose Lender', 'Set Terms', 'Confirm'];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Header
      Container(
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderSubtle))),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          GestureDetector(
            onTap: _step == 1 ? widget.onClose : () => setState(() => _step--),
            child: Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.bgSurface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.borderSubtle)), child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 16)),
          ),
          Text(_stepTitles[_step], style: AppTypography.headingS),
          GestureDetector(
            onTap: widget.onClose,
            child: Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.bgSurface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.borderSubtle)), child: const Icon(Icons.close, color: AppColors.textSecondary, size: 14)),
          ),
        ]),
      ),
      // Step indicator
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _step == i + 1 ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: i < _step ? AppColors.gold : AppColors.borderDefault,
            borderRadius: BorderRadius.circular(4),
          ),
        ))),
      ),
      Expanded(child: SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenH),
        child: _step == 1
            ? _buildLenderStep()
            : _step == 2
            ? _buildTermsStep()
            : _buildConfirmStep(),
      ))),
      // Continue button
      Container(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 12, AppSpacing.screenH, 28),
        decoration: const BoxDecoration(color: AppColors.bgBase, border: Border(top: BorderSide(color: AppColors.borderSubtle))),
        child: GestureDetector(
          onTap: _step < 3 ? () => setState(() => _step++) : widget.onClose,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: (_step == 1 && _lender == null) ? AppColors.bgInput : AppColors.gold,
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: Center(child: Text(
              _step == 3 ? 'Confirm Loan Application' : 'Continue →',
              style: AppTypography.headingS.copyWith(color: (_step == 1 && _lender == null) ? AppColors.textTertiary : AppColors.bgBase),
            )),
          ),
        ),
      ),
    ]);
  }

  Widget _buildLenderStep() {
    return Column(children: _lenders.map((l) {
      final active = _lender?.id == l.id;
      final canApply = _creditScore >= l.minScore;
      return GestureDetector(
        onTap: canApply ? () => setState(() => _lender = l) : null,
        child: Opacity(
          opacity: canApply ? 1.0 : 0.5,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: active ? AppColors.gold.withOpacity(0.07) : AppColors.bgSurface,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: active ? AppColors.gold : AppColors.borderSubtle),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(l.name, style: AppTypography.headingS.copyWith(color: active ? AppColors.gold : AppColors.textPrimary)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: l.badge == 'official' ? AppColors.gold.withOpacity(0.1) : AppColors.bgInput,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(l.badge.toUpperCase(), style: AppTypography.labelCaps.copyWith(
                    color: l.badge == 'official' ? AppColors.gold : AppColors.textTertiary, fontSize: 9,
                  )),
                ),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                _LenderStat(label: 'Rate',   val: '${l.rate}%/cycle'),
                _LenderStat(label: 'Max',    val: '\$ ${NumberFormat.compact().format(l.max)}'),
                _LenderStat(label: 'Term',   val: l.term),
                _LenderStat(label: 'Min score', val: '${l.minScore}'),
              ]),
            ]),
          ),
        ),
      );
    }).toList());
  }

  Widget _buildTermsStep() {
    final payment = (_amount * (_lender!.rate / 100) + _amount / _term).round();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Loan amount', style: AppTypography.bodyS.copyWith(fontSize: 12)),
      const SizedBox(height: 8),
      Text('\$ ${NumberFormat.decimalPattern().format(_amount.round())}', style: AppTypography.displayM.copyWith(color: AppColors.gold)),
      Slider(
        value: _amount,
        min: 1000, max: _lender!.max.toDouble(), divisions: 99,
        activeColor: AppColors.gold,
        inactiveColor: AppColors.bgInput,
        onChanged: (v) => setState(() => _amount = v),
      ),
      const SizedBox(height: 16),
      Text('Repayment term', style: AppTypography.bodyS.copyWith(fontSize: 12)),
      const SizedBox(height: 8),
      Text('$_term cycles', style: AppTypography.dataM.copyWith(fontSize: 18, color: AppColors.textPrimary)),
      Slider(
        value: _term.toDouble(),
        min: 10, max: 60, divisions: 50,
        activeColor: AppColors.sky,
        inactiveColor: AppColors.bgInput,
        onChanged: (v) => setState(() => _term = v.round()),
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.bgSurface, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderSubtle)),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Est. payment/cycle', style: AppTypography.bodyS.copyWith(fontSize: 12)),
            Text('\$ ${NumberFormat.decimalPattern().format(payment)}', style: AppTypography.dataS.copyWith(color: AppColors.amber)),
          ]),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Total cost', style: AppTypography.bodyS.copyWith(fontSize: 12)),
            Text('\$ ${NumberFormat.decimalPattern().format(payment * _term)}', style: AppTypography.dataS.copyWith(color: AppColors.crimson)),
          ]),
        ]),
      ),
    ]);
  }

  Widget _buildConfirmStep() {
    final payment = (_amount * (_lender!.rate / 100) + _amount / _term).round();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Confirm application', style: AppTypography.displayM.copyWith(fontSize: 22)),
      const SizedBox(height: 4),
      Text('Review and confirm your loan application.', style: AppTypography.bodyM),
      const SizedBox(height: 20),
      Container(
        decoration: BoxDecoration(color: AppColors.bgSurface, borderRadius: BorderRadius.circular(AppRadius.card), border: Border.all(color: AppColors.borderSubtle)),
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          for (final r in [
            ('Lender',       _lender!.name),
            ('Amount',       '\$ ${NumberFormat.decimalPattern().format(_amount.round())}'),
            ('Rate',         '${_lender!.rate}% per cycle'),
            ('Term',         '$_term cycles'),
            ('Payment/cycle', '\$ ${NumberFormat.decimalPattern().format(payment)}'),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(r.$1, style: AppTypography.bodyS.copyWith(fontSize: 12)),
                Text(r.$2, style: AppTypography.dataS.copyWith(fontSize: 13, color: AppColors.textPrimary)),
              ]),
            ),
        ]),
      ),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.amberSurface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.amber.withOpacity(0.3))),
        child: Text(
          'Loan payments are automatically deducted each cycle settlement. Missing a payment will reduce your credit score.',
          style: AppTypography.bodyS.copyWith(color: AppColors.amber, fontSize: 11),
        ),
      ),
    ]);
  }
}

class _LenderStat extends StatelessWidget {
  const _LenderStat({required this.label, required this.val});
  final String label, val;
  @override
  Widget build(BuildContext context) => Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: AppTypography.labelCaps.copyWith(fontSize: 9)),
    Text(val, style: AppTypography.dataS.copyWith(fontSize: 11, color: AppColors.textPrimary)),
  ]));
}
