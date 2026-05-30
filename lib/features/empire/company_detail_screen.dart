import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

// ── Mock data ─────────────────────────────────────────────────────────────────

class CompanySnapshot {
  const CompanySnapshot({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
    required this.sector,
    required this.country,
    required this.status,
    required this.cycleRevenue,
    required this.cycleExpenses,
    required this.cashBalance,
    required this.employeeCount,
    required this.employeeCapacity,
    required this.propertyName,
    required this.valuation,
    required this.listedOnStock,
    required this.foundedCycle,
  });
  final int id;
  final String name, icon, type, sector, country, status, propertyName;
  final int cycleRevenue, cycleExpenses, cashBalance;
  final int employeeCount, employeeCapacity;
  final int valuation, foundedCycle;
  final bool listedOnStock;

  int get netProfit => cycleRevenue - cycleExpenses;
}

class _EmployeeData {
  const _EmployeeData({required this.id, required this.name, required this.role, required this.salary, required this.skillLv, required this.sinceLabel, required this.isNpc});
  final int id, salary, skillLv;
  final String name, role, sinceLabel;
  final bool isNpc;
}

class _OrderData {
  const _OrderData({required this.id, required this.product, required this.qty, required this.unitPrice, required this.customer, required this.status, required this.cyclesLeft});
  final int id, qty, unitPrice, cyclesLeft;
  final String product, customer, status;
}

class _InventoryItem {
  const _InventoryItem({required this.id, required this.name, required this.icon, required this.stock, required this.reorderAt, required this.unitCost, required this.unitSell});
  final int id, stock, reorderAt, unitCost, unitSell;
  final String name, icon;
}

class _FinanceCycle {
  const _FinanceCycle({required this.label, required this.revenue, required this.expenses});
  final String label;
  final int revenue, expenses;
}

// Static mock data keyed by company id
const _companies = {
  1: CompanySnapshot(id: 1, name: 'Volta Café', icon: '☕', type: 'Café', sector: 'Food & Hospitality', country: 'Caedoria', status: 'good', cycleRevenue: 4200, cycleExpenses: 2800, cashBalance: 12400, employeeCount: 3, employeeCapacity: 5, propertyName: 'High Street Unit A', valuation: 38000, listedOnStock: false, foundedCycle: 14),
  2: CompanySnapshot(id: 2, name: 'Volta Foods', icon: '🏭', type: 'Food Manufacturing', sector: 'Food & Hospitality', country: 'Caedoria', status: 'warning', cycleRevenue: 5800, cycleExpenses: 6600, cashBalance: 3200, employeeCount: 5, employeeCapacity: 8, propertyName: 'Business Park Suite 4', valuation: 62000, listedOnStock: false, foundedCycle: 8),
  3: CompanySnapshot(id: 3, name: 'Caedoria Retail', icon: '📱', type: 'Electronics Store', sector: 'Retail', country: 'Caedoria', status: 'good', cycleRevenue: 3100, cycleExpenses: 1850, cashBalance: 5800, employeeCount: 4, employeeCapacity: 6, propertyName: 'Market Square Corner', valuation: 45000, listedOnStock: true, foundedCycle: 21),
};

const _employees = {
  1: [
    _EmployeeData(id: 1, name: 'Mara Lin',    role: 'Barista',        salary: 420, skillLv: 3, sinceLabel: 'Cycle 16', isNpc: true),
    _EmployeeData(id: 2, name: 'Tom Russo',   role: 'Barista',        salary: 390, skillLv: 2, sinceLabel: 'Cycle 19', isNpc: true),
    _EmployeeData(id: 3, name: 'Ines Vargas', role: 'Shift Manager',  salary: 600, skillLv: 4, sinceLabel: 'Cycle 14', isNpc: true),
  ],
  2: [
    _EmployeeData(id: 4, name: 'Dev Nair',    role: 'Line Worker',    salary: 380, skillLv: 2, sinceLabel: 'Cycle  9', isNpc: true),
    _EmployeeData(id: 5, name: 'Sasha Park',  role: 'Line Worker',    salary: 380, skillLv: 2, sinceLabel: 'Cycle  9', isNpc: true),
    _EmployeeData(id: 6, name: 'Karel Bos',   role: 'Line Worker',    salary: 380, skillLv: 2, sinceLabel: 'Cycle 11', isNpc: true),
    _EmployeeData(id: 7, name: 'Omar Diaby',  role: 'Supervisor',     salary: 560, skillLv: 3, sinceLabel: 'Cycle  8', isNpc: true),
    _EmployeeData(id: 8, name: 'Lily Chen',   role: 'QC Inspector',   salary: 500, skillLv: 3, sinceLabel: 'Cycle 12', isNpc: true),
  ],
  3: [
    _EmployeeData(id: 9,  name: 'Ryo Tanaka', role: 'Sales Associate', salary: 450, skillLv: 3, sinceLabel: 'Cycle 22', isNpc: true),
    _EmployeeData(id: 10, name: 'Priya Sen',  role: 'Sales Associate', salary: 450, skillLv: 2, sinceLabel: 'Cycle 24', isNpc: true),
    _EmployeeData(id: 11, name: 'Nik Storm',  role: 'Store Manager',   salary: 680, skillLv: 4, sinceLabel: 'Cycle 21', isNpc: true),
    _EmployeeData(id: 12, name: 'Zoe Klein',  role: 'Tech Support',    salary: 520, skillLv: 3, sinceLabel: 'Cycle 23', isNpc: true),
  ],
};

const _orders = {
  1: [
    _OrderData(id: 1, product: 'Espresso Blend ×50',  qty: 50,  unitPrice: 6,  customer: 'Walk-in',       status: 'active', cyclesLeft: 0),
    _OrderData(id: 2, product: 'Catering Package',     qty: 1,   unitPrice: 800, customer: 'Larva Corp',   status: 'pending', cyclesLeft: 2),
  ],
  2: [
    _OrderData(id: 3, product: 'Packaged Coffee ×200', qty: 200, unitPrice: 12, customer: 'Nord Retail',   status: 'active', cyclesLeft: 1),
    _OrderData(id: 4, product: 'Energy Bar ×500',      qty: 500, unitPrice: 4,  customer: 'Volta Stores',  status: 'active', cyclesLeft: 0),
    _OrderData(id: 5, product: 'Protein Mix ×100',     qty: 100, unitPrice: 18, customer: 'FitLife Club',  status: 'pending', cyclesLeft: 3),
  ],
  3: [
    _OrderData(id: 6, product: 'Laptop — Pro 14',      qty: 2,   unitPrice: 1400, customer: 'Zel Media',  status: 'active', cyclesLeft: 0),
    _OrderData(id: 7, product: 'Wireless Earbuds ×12', qty: 12,  unitPrice: 85,   customer: 'Walk-in',    status: 'active', cyclesLeft: 0),
  ],
};

const _inventory = {
  1: [
    _InventoryItem(id: 1, name: 'Coffee Beans', icon: '☕', stock: 14, reorderAt: 5, unitCost: 22, unitSell: 0),
    _InventoryItem(id: 2, name: 'Milk (L)',      icon: '🥛', stock: 30, reorderAt: 10, unitCost: 2, unitSell: 0),
    _InventoryItem(id: 3, name: 'Pastries',      icon: '🥐', stock: 24, reorderAt: 8, unitCost: 3, unitSell: 6),
  ],
  2: [
    _InventoryItem(id: 4, name: 'Raw Coffee',    icon: '🌱', stock: 60, reorderAt: 20, unitCost: 14, unitSell: 0),
    _InventoryItem(id: 5, name: 'Sugar (kg)',    icon: '🧂', stock: 45, reorderAt: 15, unitCost: 3, unitSell: 0),
    _InventoryItem(id: 6, name: 'Pkg. Coffee',   icon: '📦', stock: 3,  reorderAt: 10, unitCost: 0, unitSell: 12),
    _InventoryItem(id: 7, name: 'Energy Bar',    icon: '⚡', stock: 88, reorderAt: 30, unitCost: 0, unitSell: 4),
  ],
  3: [
    _InventoryItem(id: 8,  name: 'Laptops',        icon: '💻', stock: 5,  reorderAt: 2, unitCost: 900, unitSell: 1400),
    _InventoryItem(id: 9,  name: 'Earbuds',        icon: '🎧', stock: 22, reorderAt: 5, unitCost: 45,  unitSell: 85),
    _InventoryItem(id: 10, name: 'Cables & Acc.',  icon: '🔌', stock: 48, reorderAt: 15, unitCost: 8, unitSell: 18),
  ],
};

const _finances = {
  1: [
    _FinanceCycle(label: 'C-24', revenue: 3800, expenses: 2650),
    _FinanceCycle(label: 'C-25', revenue: 4100, expenses: 2700),
    _FinanceCycle(label: 'C-26', revenue: 3950, expenses: 2750),
    _FinanceCycle(label: 'C-27', revenue: 4400, expenses: 2820),
    _FinanceCycle(label: 'C-28', revenue: 4200, expenses: 2800),
  ],
  2: [
    _FinanceCycle(label: 'C-24', revenue: 6200, expenses: 5800),
    _FinanceCycle(label: 'C-25', revenue: 5900, expenses: 6100),
    _FinanceCycle(label: 'C-26', revenue: 5600, expenses: 6200),
    _FinanceCycle(label: 'C-27', revenue: 6100, expenses: 6500),
    _FinanceCycle(label: 'C-28', revenue: 5800, expenses: 6600),
  ],
  3: [
    _FinanceCycle(label: 'C-24', revenue: 2800, expenses: 1700),
    _FinanceCycle(label: 'C-25', revenue: 3050, expenses: 1780),
    _FinanceCycle(label: 'C-26', revenue: 3200, expenses: 1820),
    _FinanceCycle(label: 'C-27', revenue: 2950, expenses: 1840),
    _FinanceCycle(label: 'C-28', revenue: 3100, expenses: 1850),
  ],
};

// ── Screen ────────────────────────────────────────────────────────────────────

class CompanyDetailScreen extends StatefulWidget {
  const CompanyDetailScreen({super.key, required this.companyId});
  final int companyId;

  @override
  State<CompanyDetailScreen> createState() => _CompanyDetailScreenState();
}

class _CompanyDetailScreenState extends State<CompanyDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  CompanySnapshot get _company => _companies[widget.companyId] ?? _companies[1]!;

  @override
  Widget build(BuildContext context) {
    final c = _company;
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          _CompanyAppBar(company: c),
          _TabBarSliver(controller: _tabs),
        ],
        body: TabBarView(
          controller: _tabs,
          children: [
            _OverviewTab(company: c),
            _EmployeesTab(companyId: widget.companyId, company: c),
            _OrdersTab(companyId: widget.companyId),
            _InventoryTab(companyId: widget.companyId),
            _FinancesTab(companyId: widget.companyId, company: c),
          ],
        ),
      ),
    );
  }
}

// ── App Bar ───────────────────────────────────────────────────────────────────

class _CompanyAppBar extends StatelessWidget {
  const _CompanyAppBar({required this.company});
  final CompanySnapshot company;

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (company.status) {
      'warning'  => AppColors.amber,
      'critical' => AppColors.crimson,
      _          => AppColors.emerald,
    };
    final statusLabel = switch (company.status) {
      'warning'  => 'Issue',
      'critical' => 'Critical',
      _          => 'Operating',
    };

    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.bgBase,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(company.name, style: AppTypography.headingM),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_horiz, color: AppColors.textSecondary, size: 22),
          onPressed: () {},
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.bgBase,
            border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
          ),
          padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 0, AppSpacing.screenH, 16),
          child: Row(children: [
            // Company icon
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: Center(child: Text(company.icon, style: const TextStyle(fontSize: 26))),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(company.type,    style: AppTypography.bodyM.copyWith(color: AppColors.textSecondary)),
                const Text(' · ', style: TextStyle(color: AppColors.textTertiary)),
                Text(company.country, style: AppTypography.bodyM.copyWith(color: AppColors.textSecondary)),
              ]),
              const SizedBox(height: 4),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                    border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(width: 5, height: 5, decoration: BoxDecoration(shape: BoxShape.circle, color: statusColor)),
                    const SizedBox(width: 5),
                    Text(statusLabel, style: AppTypography.label.copyWith(color: statusColor)),
                  ]),
                ),
                if (company.listedOnStock) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.sky.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.chip),
                      border: Border.all(color: AppColors.sky.withValues(alpha: 0.25)),
                    ),
                    child: Text('Listed', style: AppTypography.label.copyWith(color: AppColors.sky)),
                  ),
                ],
              ]),
            ])),
          ]),
        ),
      ),
    );
  }
}

// ── Tab Bar ───────────────────────────────────────────────────────────────────

class _TabBarSliver extends StatelessWidget {
  const _TabBarSliver({required this.controller});
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TabBarDelegate(
        TabBar(
          controller: controller,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: AppColors.gold,
          unselectedLabelColor: AppColors.textTertiary,
          labelStyle: AppTypography.bodyS.copyWith(fontWeight: FontWeight.w600),
          unselectedLabelStyle: AppTypography.bodyS,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: AppColors.gold, width: 2),
            insets: EdgeInsets.symmetric(horizontal: 8),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH - 8),
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Employees'),
            Tab(text: 'Orders'),
            Tab(text: 'Inventory'),
            Tab(text: 'Finances'),
          ],
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  const _TabBarDelegate(this.tabBar);
  final TabBar tabBar;

  @override double get minExtent => 46;
  @override double get maxExtent => 46;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.bgBase,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate old) => old.tabBar != tabBar;
}

// ── Overview Tab ──────────────────────────────────────────────────────────────

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.company});
  final CompanySnapshot company;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.decimalPattern();
    final netPositive = company.netProfit >= 0;

    return ListView(padding: const EdgeInsets.all(AppSpacing.screenH), children: [
      // KPI row
      Row(children: [
        Expanded(child: _KpiCard(label: 'Cycle Revenue', value: '\$ ${fmt.format(company.cycleRevenue)}', valueColor: AppColors.gold)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: _KpiCard(label: 'Cycle Expenses', value: '\$ ${fmt.format(company.cycleExpenses)}', valueColor: AppColors.textPrimary)),
      ]),
      const SizedBox(height: AppSpacing.md),
      Row(children: [
        Expanded(child: _KpiCard(
          label: 'Net Profit',
          value: '${netPositive ? '+' : '−'}\$ ${fmt.format(company.netProfit.abs())}',
          valueColor: netPositive ? AppColors.emerald : AppColors.crimson,
        )),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: _KpiCard(label: 'Cash Balance', value: '\$ ${fmt.format(company.cashBalance)}', valueColor: AppColors.gold)),
      ]),
      const SizedBox(height: AppSpacing.xl),

      // Company info section
      Text('Company Info', style: AppTypography.labelCaps),
      const SizedBox(height: AppSpacing.md),
      _InfoCard(rows: [
        _InfoRow(label: 'Sector',     value: company.sector),
        _InfoRow(label: 'Type',       value: company.type),
        _InfoRow(label: 'Country',    value: company.country),
        _InfoRow(label: 'Property',   value: company.propertyName),
        _InfoRow(label: 'Founded',    value: 'Cycle ${company.foundedCycle}'),
        _InfoRow(label: 'Valuation',  value: '\$ ${fmt.format(company.valuation)}', isGold: true),
      ]),
      const SizedBox(height: AppSpacing.xl),

      // Capacity
      Text('Capacity', style: AppTypography.labelCaps),
      const SizedBox(height: AppSpacing.md),
      _CapacityCard(company: company),
      const SizedBox(height: AppSpacing.xl),

      // Quick actions
      if (company.status == 'warning')
        _IssuesBanner(),
      const SizedBox(height: AppSpacing.xl),

      // Actions row
      Text('Actions', style: AppTypography.labelCaps),
      const SizedBox(height: AppSpacing.md),
      Row(children: [
        Expanded(child: _ActionButton(icon: Icons.trending_up, label: 'List on Stock\nMarket', onTap: () => context.go('/empire/stocks'))),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: _ActionButton(icon: Icons.account_balance_outlined, label: 'Apply for\nLoan', onTap: () {})),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: _ActionButton(icon: Icons.sell_outlined, label: 'Transfer\nCompany', onTap: () {})),
      ]),
      const SizedBox(height: AppSpacing.x3l),
    ]);
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.label, required this.value, required this.valueColor});
  final String label, value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: AppTypography.label.copyWith(color: AppColors.textTertiary)),
        const SizedBox(height: 6),
        Text(value, style: AppTypography.dataM.copyWith(color: valueColor, fontSize: 18)),
      ]),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.rows});
  final List<_InfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(children: rows.asMap().entries.map((e) {
        final isLast = e.key == rows.length - 1;
        final row = e.value;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 12),
          decoration: BoxDecoration(
            border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.borderSubtle)),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(row.label, style: AppTypography.bodyM.copyWith(color: AppColors.textSecondary)),
            Text(row.value, style: AppTypography.bodyM.copyWith(
              color: row.isGold ? AppColors.gold : AppColors.textPrimary,
              fontFamily: row.isGold ? 'DMMono' : null,
            )),
          ]),
        );
      }).toList()),
    );
  }
}

class _InfoRow {
  const _InfoRow({required this.label, required this.value, this.isGold = false});
  final String label, value;
  final bool isGold;
}

class _CapacityCard extends StatelessWidget {
  const _CapacityCard({required this.company});
  final CompanySnapshot company;

  @override
  Widget build(BuildContext context) {
    final pct = company.employeeCount / company.employeeCapacity;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Employees', style: AppTypography.bodyM.copyWith(color: AppColors.textSecondary)),
          Text('${company.employeeCount} / ${company.employeeCapacity}',
              style: AppTypography.dataM.copyWith(color: AppColors.textPrimary)),
        ]),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 4,
            backgroundColor: AppColors.bgElevated,
            valueColor: AlwaysStoppedAnimation(pct >= 1.0 ? AppColors.amber : AppColors.emerald),
          ),
        ),
      ]),
    );
  }
}

class _IssuesBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.amber.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.warning_amber_rounded, color: AppColors.amber, size: 18),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Expense Warning', style: AppTypography.bodyM.copyWith(color: AppColors.amber, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Cycle expenses exceed revenue. Review your supplier contracts and staffing costs.', style: AppTypography.bodyM.copyWith(color: AppColors.textSecondary)),
        ])),
      ]),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: AppColors.textSecondary, size: 20),
          const SizedBox(height: 6),
          Text(label, style: AppTypography.label.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

// ── Employees Tab ─────────────────────────────────────────────────────────────

class _EmployeesTab extends StatelessWidget {
  const _EmployeesTab({required this.companyId, required this.company});
  final int companyId;
  final CompanySnapshot company;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.decimalPattern();
    final emps = _employees[companyId] ?? [];
    final canHire = company.employeeCount < company.employeeCapacity;

    return ListView(padding: const EdgeInsets.all(AppSpacing.screenH), children: [
      // Summary row
      Row(children: [
        Expanded(child: _KpiCard(label: 'Headcount', value: '${company.employeeCount}', valueColor: AppColors.textPrimary)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: _KpiCard(
          label: 'Total Payroll',
          value: '\$ ${fmt.format(emps.fold<int>(0, (s, e) => s + e.salary))} /c',
          valueColor: AppColors.gold,
        )),
      ]),
      const SizedBox(height: AppSpacing.xl),

      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Staff (${emps.length})', style: AppTypography.labelCaps),
        if (canHire)
          GestureDetector(
            onTap: () {},
            child: Text('+ Hire', style: AppTypography.label.copyWith(color: AppColors.gold)),
          ),
      ]),
      const SizedBox(height: AppSpacing.md),

      Container(
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(children: emps.asMap().entries.map((e) {
          final isLast = e.key == emps.length - 1;
          final emp = e.value;
          return _EmployeeRow(emp: emp, isLast: isLast, onFire: () {});
        }).toList()),
      ),

      if (!canHire) ...[
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Row(children: [
            const Icon(Icons.lock_outline, color: AppColors.textTertiary, size: 16),
            const SizedBox(width: 8),
            Expanded(child: Text(
              'Capacity full. Upgrade your property to hire more staff.',
              style: AppTypography.bodyM.copyWith(color: AppColors.textTertiary),
            )),
          ]),
        ),
      ],
      const SizedBox(height: AppSpacing.x3l),
    ]);
  }
}

class _EmployeeRow extends StatelessWidget {
  const _EmployeeRow({required this.emp, required this.isLast, required this.onFire});
  final _EmployeeData emp;
  final bool isLast;
  final VoidCallback onFire;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.decimalPattern();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 14),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(children: [
        // Avatar initial
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: AppColors.bgElevated,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text(emp.name[0], style: AppTypography.bodyM.copyWith(fontWeight: FontWeight.w600))),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(emp.name, style: AppTypography.bodyM.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Row(children: [
            Text(emp.role, style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
            const Text(' · ', style: TextStyle(color: AppColors.textTertiary, fontSize: 11)),
            Text('Lv ${emp.skillLv}', style: AppTypography.label.copyWith(color: AppColors.sky)),
          ]),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('\$ ${fmt.format(emp.salary)}/c', style: AppTypography.dataS.copyWith(color: AppColors.gold)),
          const SizedBox(height: 2),
          Text('Since ${emp.sinceLabel}', style: AppTypography.label.copyWith(color: AppColors.textTertiary, fontSize: 10)),
        ]),
        const SizedBox(width: AppSpacing.sm),
        GestureDetector(
          onTap: onFire,
          child: Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: const Icon(Icons.close, size: 14, color: AppColors.textTertiary),
          ),
        ),
      ]),
    );
  }
}

// ── Orders Tab ────────────────────────────────────────────────────────────────

class _OrdersTab extends StatelessWidget {
  const _OrdersTab({required this.companyId});
  final int companyId;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.decimalPattern();
    final orders = _orders[companyId] ?? [];
    final active  = orders.where((o) => o.status == 'active').toList();
    final pending = orders.where((o) => o.status == 'pending').toList();

    return ListView(padding: const EdgeInsets.all(AppSpacing.screenH), children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Active Orders (${active.length})', style: AppTypography.labelCaps),
        GestureDetector(
          onTap: () {},
          child: Text('+ New Order', style: AppTypography.label.copyWith(color: AppColors.gold)),
        ),
      ]),
      const SizedBox(height: AppSpacing.md),
      if (active.isEmpty)
        _EmptyState(icon: Icons.receipt_long_outlined, message: 'No active orders')
      else
        _OrderList(orders: active, fmt: fmt),

      if (pending.isNotEmpty) ...[
        const SizedBox(height: AppSpacing.xl),
        Text('Pending (${pending.length})', style: AppTypography.labelCaps),
        const SizedBox(height: AppSpacing.md),
        _OrderList(orders: pending, fmt: fmt),
      ],
      const SizedBox(height: AppSpacing.x3l),
    ]);
  }
}

class _OrderList extends StatelessWidget {
  const _OrderList({required this.orders, required this.fmt});
  final List<_OrderData> orders;
  final NumberFormat fmt;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(children: orders.asMap().entries.map((e) {
        final isLast = e.key == orders.length - 1;
        final o = e.value;
        final total = o.qty * o.unitPrice;
        final isPending = o.status == 'pending';
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 14),
          decoration: BoxDecoration(
            border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.borderSubtle)),
          ),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(o.product, style: AppTypography.bodyM.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
              const SizedBox(height: 3),
              Row(children: [
                const Icon(Icons.person_outline, size: 12, color: AppColors.textTertiary),
                const SizedBox(width: 4),
                Text(o.customer, style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
                if (isPending) ...[
                  const Text(' · ', style: TextStyle(color: AppColors.textTertiary, fontSize: 11)),
                  Text('in ${o.cyclesLeft}c', style: AppTypography.label.copyWith(color: AppColors.amber)),
                ],
              ]),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('\$ ${fmt.format(total)}', style: AppTypography.dataS.copyWith(color: AppColors.gold)),
              const SizedBox(height: 2),
              Text('×${o.qty} units', style: AppTypography.label.copyWith(color: AppColors.textTertiary, fontSize: 10)),
            ]),
          ]),
        );
      }).toList()),
    );
  }
}

// ── Inventory Tab ─────────────────────────────────────────────────────────────

class _InventoryTab extends StatelessWidget {
  const _InventoryTab({required this.companyId});
  final int companyId;

  @override
  Widget build(BuildContext context) {
    final items = _inventory[companyId] ?? [];

    return ListView(padding: const EdgeInsets.all(AppSpacing.screenH), children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Stock (${items.length} items)', style: AppTypography.labelCaps),
        GestureDetector(
          onTap: () {},
          child: Text('Restock All', style: AppTypography.label.copyWith(color: AppColors.gold)),
        ),
      ]),
      const SizedBox(height: AppSpacing.md),
      Container(
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(children: items.asMap().entries.map((e) {
          final isLast = e.key == items.length - 1;
          return _InventoryRow(item: e.value, isLast: isLast);
        }).toList()),
      ),
      const SizedBox(height: AppSpacing.x3l),
    ]);
  }
}

class _InventoryRow extends StatelessWidget {
  const _InventoryRow({required this.item, required this.isLast});
  final _InventoryItem item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.decimalPattern();
    final low = item.stock <= item.reorderAt;
    final stockColor = low ? AppColors.amber : AppColors.textPrimary;
    final pct = item.reorderAt > 0 ? (item.stock / (item.reorderAt * 4)).clamp(0.0, 1.0) : 1.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 14),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(item.icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(child: Text(item.name, style: AppTypography.bodyM.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500))),
          if (low)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.amber.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text('Low', style: AppTypography.label.copyWith(color: AppColors.amber)),
            ),
          const SizedBox(width: 8),
          Text('${item.stock} units', style: AppTypography.dataS.copyWith(color: stockColor, fontSize: 13)),
        ]),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 3,
            backgroundColor: AppColors.bgElevated,
            valueColor: AlwaysStoppedAnimation(low ? AppColors.amber : AppColors.emerald),
          ),
        ),
        const SizedBox(height: 6),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Reorder at ${item.reorderAt}', style: AppTypography.label.copyWith(color: AppColors.textTertiary, fontSize: 10)),
          Row(children: [
            if (item.unitCost > 0) Text('Cost \$ ${fmt.format(item.unitCost)}', style: AppTypography.label.copyWith(color: AppColors.textTertiary, fontSize: 10)),
            if (item.unitCost > 0 && item.unitSell > 0) const Text(' · ', style: TextStyle(color: AppColors.textTertiary, fontSize: 10)),
            if (item.unitSell > 0) Text('Sell \$ ${fmt.format(item.unitSell)}', style: AppTypography.label.copyWith(color: AppColors.gold, fontSize: 10)),
          ]),
        ]),
      ]),
    );
  }
}

// ── Finances Tab ──────────────────────────────────────────────────────────────

class _FinancesTab extends StatelessWidget {
  const _FinancesTab({required this.companyId, required this.company});
  final int companyId;
  final CompanySnapshot company;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.decimalPattern();
    final cycles = _finances[companyId] ?? [];
    final netPositive = company.netProfit >= 0;

    return ListView(padding: const EdgeInsets.all(AppSpacing.screenH), children: [
      // Current cycle summary
      Text('Current Cycle', style: AppTypography.labelCaps),
      const SizedBox(height: AppSpacing.md),
      Row(children: [
        Expanded(child: _KpiCard(label: 'Revenue',  value: '\$ ${fmt.format(company.cycleRevenue)}',  valueColor: AppColors.gold)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: _KpiCard(label: 'Expenses', value: '\$ ${fmt.format(company.cycleExpenses)}', valueColor: AppColors.textPrimary)),
      ]),
      const SizedBox(height: AppSpacing.md),
      Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: netPositive ? AppColors.emeraldSurface : AppColors.crimsonSurface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: (netPositive ? AppColors.emerald : AppColors.crimson).withValues(alpha: 0.25)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Net Profit', style: AppTypography.bodyM.copyWith(color: AppColors.textSecondary)),
          Text(
            '${netPositive ? '+' : '−'}\$ ${fmt.format(company.netProfit.abs())}',
            style: AppTypography.dataM.copyWith(color: netPositive ? AppColors.emerald : AppColors.crimson, fontSize: 20),
          ),
        ]),
      ),

      const SizedBox(height: AppSpacing.xl),
      Text('History (Last 5 Cycles)', style: AppTypography.labelCaps),
      const SizedBox(height: AppSpacing.md),

      // Chart
      _BarChart(cycles: cycles),

      const SizedBox(height: AppSpacing.xl),

      // Table
      Container(
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 10),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderSubtle))),
            child: Row(children: [
              SizedBox(width: 56, child: Text('Cycle', style: AppTypography.label.copyWith(color: AppColors.textTertiary))),
              Expanded(child: Text('Revenue', style: AppTypography.label.copyWith(color: AppColors.textTertiary), textAlign: TextAlign.right)),
              Expanded(child: Text('Expenses', style: AppTypography.label.copyWith(color: AppColors.textTertiary), textAlign: TextAlign.right)),
              Expanded(child: Text('Net', style: AppTypography.label.copyWith(color: AppColors.textTertiary), textAlign: TextAlign.right)),
            ]),
          ),
          ...cycles.asMap().entries.map((e) {
            final isLast = e.key == cycles.length - 1;
            final cy = e.value;
            final net = cy.revenue - cy.expenses;
            final pos = net >= 0;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 12),
              decoration: BoxDecoration(
                border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.borderSubtle)),
              ),
              child: Row(children: [
                SizedBox(width: 56, child: Text(cy.label, style: AppTypography.dataS.copyWith(color: AppColors.textSecondary, fontSize: 12))),
                Expanded(child: Text('\$ ${fmt.format(cy.revenue)}',  style: AppTypography.dataS.copyWith(color: AppColors.gold, fontSize: 12), textAlign: TextAlign.right)),
                Expanded(child: Text('\$ ${fmt.format(cy.expenses)}', style: AppTypography.dataS.copyWith(color: AppColors.textPrimary, fontSize: 12), textAlign: TextAlign.right)),
                Expanded(child: Text(
                  '${pos ? '+' : '−'}\$ ${fmt.format(net.abs())}',
                  style: AppTypography.dataS.copyWith(color: pos ? AppColors.emerald : AppColors.crimson, fontSize: 12),
                  textAlign: TextAlign.right,
                )),
              ]),
            );
          }),
        ]),
      ),
      const SizedBox(height: AppSpacing.x3l),
    ]);
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart({required this.cycles});
  final List<_FinanceCycle> cycles;

  @override
  Widget build(BuildContext context) {
    if (cycles.isEmpty) return const SizedBox.shrink();
    final maxVal = cycles.fold<int>(0, (m, c) => [m, c.revenue, c.expenses].reduce((a, b) => a > b ? a : b));

    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: cycles.map((cy) {
          final revH = maxVal > 0 ? (cy.revenue / maxVal * 80).clamp(4.0, 80.0) : 4.0;
          final expH = maxVal > 0 ? (cy.expenses / maxVal * 80).clamp(4.0, 80.0) : 4.0;
          return Column(mainAxisSize: MainAxisSize.min, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Container(width: 8, height: revH, decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: 0.7),    borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 2),
              Container(width: 8, height: expH, decoration: BoxDecoration(color: AppColors.crimson.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(2))),
            ]),
            const SizedBox(height: 4),
            Text(cy.label, style: AppTypography.label.copyWith(color: AppColors.textTertiary, fontSize: 9)),
          ]);
        }).toList(),
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.message});
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x2l),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: AppColors.textTertiary, size: 32),
        const SizedBox(height: AppSpacing.md),
        Text(message, style: AppTypography.bodyM.copyWith(color: AppColors.textTertiary)),
      ]),
    );
  }
}
