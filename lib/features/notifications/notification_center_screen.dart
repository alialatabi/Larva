import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

// ── Model ─────────────────────────────────────────────────────────────────────

enum _NotifKind { cycle, salary, event, loan, market, partner, system }

class _Notif {
  const _Notif({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.time,
    required this.unread,
    this.group = 'Today',
  });
  final int id;
  final _NotifKind kind;
  final String title, body, time, group;
  final bool unread;
}

const _notifs = <_Notif>[
  _Notif(id: 1, kind: _NotifKind.cycle, title: 'Cycle 48 settled', body: 'Net +\$ 2,400 this cycle. Salaries paid, rent collected, loan deducted.', time: 'just now', unread: true),
  _Notif(id: 2, kind: _NotifKind.salary, title: 'Salary received', body: '+\$ 8,000 from Horizon Tech credited to your wallet.', time: '2m ago', unread: true),
  _Notif(id: 3, kind: _NotifKind.event, title: 'Labor Strike — Caedoria', body: 'A major strike is throttling production at your companies for 3 cycles.', time: '14m ago', unread: true),
  _Notif(id: 4, kind: _NotifKind.market, title: 'Buy order filled', body: 'Bought 150 HAZT shares at \$ 34.80. Position now 300 shares.', time: '1h ago', unread: false),
  _Notif(id: 5, kind: _NotifKind.loan, title: 'Loan payment due soon', body: 'Central Bank installment of \$ 1,200 auto-deducts at next settlement.', time: '1h ago', unread: false),
  _Notif(id: 6, kind: _NotifKind.system, title: 'Volta Foods needs attention', body: 'Cycle expenses exceeded revenue. Review staffing and supplier contracts.', time: '3h ago', unread: false, group: 'Earlier'),
  _Notif(id: 7, kind: _NotifKind.partner, title: 'Partner tier progress', body: 'You are 2 qualifying cycles away from Bronze partner status.', time: '6h ago', unread: false, group: 'Earlier'),
  _Notif(id: 8, kind: _NotifKind.market, title: 'Dividend paid', body: '+\$ 1,000 dividend from VLTF holdings credited at settlement.', time: '8h ago', unread: false, group: 'Earlier'),
  _Notif(id: 9, kind: _NotifKind.cycle, title: 'Cycle 47 settled', body: 'Net −\$ 800 this cycle. Higher discretionary spending detected.', time: '14h ago', unread: false, group: 'Earlier'),
];

const _filters = ['All', 'Economy', 'Companies', 'Market', 'System'];

// ── Helpers ───────────────────────────────────────────────────────────────────

({IconData icon, Color color}) _kindMeta(_NotifKind k) {
  switch (k) {
    case _NotifKind.cycle:   return (icon: Icons.autorenew, color: AppColors.gold);
    case _NotifKind.salary:  return (icon: Icons.payments_outlined, color: AppColors.emerald);
    case _NotifKind.event:   return (icon: Icons.warning_amber_rounded, color: AppColors.amber);
    case _NotifKind.loan:    return (icon: Icons.account_balance_outlined, color: AppColors.crimson);
    case _NotifKind.market:  return (icon: Icons.show_chart, color: AppColors.sky);
    case _NotifKind.partner: return (icon: Icons.workspace_premium_outlined, color: AppColors.violet);
    case _NotifKind.system:  return (icon: Icons.info_outline, color: AppColors.textSecondary);
  }
}

bool _matchesFilter(_NotifKind k, String f) {
  switch (f) {
    case 'Economy':   return k == _NotifKind.cycle || k == _NotifKind.salary || k == _NotifKind.loan;
    case 'Companies': return k == _NotifKind.system || k == _NotifKind.partner;
    case 'Market':    return k == _NotifKind.market;
    case 'System':    return k == _NotifKind.system || k == _NotifKind.event;
    default:          return true;
  }
}

// ── Screen ────────────────────────────────────────────────────────────────────

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() => _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  String _filter = 'All';
  late List<int> _readIds;

  @override
  void initState() {
    super.initState();
    _readIds = _notifs.where((n) => !n.unread).map((n) => n.id).toList();
  }

  bool _isUnread(_Notif n) => !_readIds.contains(n.id);

  @override
  Widget build(BuildContext context) {
    final visible = _notifs.where((n) => _matchesFilter(n.kind, _filter)).toList();
    final today = visible.where((n) => n.group == 'Today').toList();
    final earlier = visible.where((n) => n.group == 'Earlier').toList();
    final unreadCount = _notifs.where(_isUnread).length;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Column(children: [
          // Header
          Container(
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderSubtle))),
            padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 10, AppSpacing.screenH, 12),
            child: Column(children: [
              Row(children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(color: AppColors.bgSurface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.borderSubtle)),
                    child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 16),
                  ),
                ),
                const SizedBox(width: 12),
                Text('Notifications', style: AppTypography.headingL.copyWith(fontSize: 18)),
                if (unreadCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.crimson, borderRadius: BorderRadius.circular(10)),
                    child: Text('$unreadCount', style: AppTypography.labelCaps.copyWith(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                  ),
                ],
                const Spacer(),
                GestureDetector(
                  onTap: unreadCount == 0 ? null : () => setState(() => _readIds = _notifs.map((n) => n.id).toList()),
                  child: Text('Mark all read', style: AppTypography.label.copyWith(
                    color: unreadCount == 0 ? AppColors.textTertiary : AppColors.gold,
                    fontWeight: FontWeight.w600,
                  )),
                ),
              ]),
              const SizedBox(height: 12),
              SizedBox(
                height: 30,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final f in _filters) ...[
                      GestureDetector(
                        onTap: () => setState(() => _filter = f),
                        child: Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: _filter == f ? AppColors.gold.withValues(alpha: 0.1) : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _filter == f ? AppColors.gold : AppColors.borderDefault),
                          ),
                          child: Text(f, style: AppTypography.label.copyWith(
                            color: _filter == f ? AppColors.gold : AppColors.textTertiary,
                            fontWeight: FontWeight.w600,
                          )),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ]),
          ),
          // List
          Expanded(child: visible.isEmpty
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.notifications_off_outlined, color: AppColors.textTertiary, size: 40),
                  const SizedBox(height: 12),
                  Text('Nothing here', style: AppTypography.bodyM.copyWith(color: AppColors.textTertiary)),
                ]))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.screenH, 14, AppSpacing.screenH, AppSpacing.x3l),
                  children: [
                    if (today.isNotEmpty) ...[
                      Text('TODAY', style: AppTypography.labelCaps.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      for (final n in today) _NotifTile(notif: n, unread: _isUnread(n), onTap: () => setState(() => _readIds = [..._readIds, n.id])),
                    ],
                    if (earlier.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      Text('EARLIER', style: AppTypography.labelCaps.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      for (final n in earlier) _NotifTile(notif: n, unread: _isUnread(n), onTap: () => setState(() => _readIds = [..._readIds, n.id])),
                    ],
                  ],
                )),
        ]),
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  const _NotifTile({required this.notif, required this.unread, required this.onTap});
  final _Notif notif;
  final bool unread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final meta = _kindMeta(notif.kind);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: unread ? AppColors.bgElevated : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: unread ? meta.color.withValues(alpha: 0.3) : AppColors.borderSubtle),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: meta.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(meta.icon, color: meta.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(notif.title, style: AppTypography.bodyM.copyWith(
                color: AppColors.textPrimary,
                fontWeight: unread ? FontWeight.w600 : FontWeight.w500,
              ))),
              if (unread) Container(width: 8, height: 8, margin: const EdgeInsets.only(left: 6, top: 4), decoration: BoxDecoration(color: meta.color, shape: BoxShape.circle)),
            ]),
            const SizedBox(height: 3),
            Text(notif.body, style: AppTypography.bodyS.copyWith(fontSize: 12, height: 1.4)),
            const SizedBox(height: 6),
            Text(notif.time, style: AppTypography.labelCaps.copyWith(fontSize: 10)),
          ])),
        ]),
      ),
    );
  }
}
