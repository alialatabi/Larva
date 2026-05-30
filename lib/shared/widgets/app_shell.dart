import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const int _cycleDurationSeconds = 21600; // 6 hours

  late Timer _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    // Start from a fixed point so the timer is deterministic; in production
    // this would be seeded from the server's cycle start time.
    final now = DateTime.now();
    final secondsIntoDay = now.hour * 3600 + now.minute * 60 + now.second;
    _remainingSeconds = _cycleDurationSeconds - (secondsIntoDay % _cycleDurationSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  void _onTick(Timer _) {
    setState(() {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
      } else {
        _remainingSeconds = _cycleDurationSeconds;
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatCountdown() {
    final h = _remainingSeconds ~/ 3600;
    final m = (_remainingSeconds % 3600) ~/ 60;
    if (h > 0) {
      return '${h}h ${m.toString().padLeft(2, '0')}m';
    }
    final s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  bool get _isUrgent => _remainingSeconds < 1800; // < 30 minutes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.shell,
      bottomNavigationBar: _AppBottomNav(
        currentIndex: widget.shell.currentIndex,
        onTap: (i) => widget.shell.goBranch(i, initialLocation: i == widget.shell.currentIndex),
        countdownLabel: _formatCountdown(),
        isUrgent: _isUrgent,
      ),
    );
  }
}

class _AppBottomNav extends StatelessWidget {
  const _AppBottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.countdownLabel,
    required this.isUrgent,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final String countdownLabel;
  final bool isUrgent;

  static const _tabs = [
    _TabItem(icon: Icons.home_outlined,      activeIcon: Icons.home,          label: 'Home'),
    _TabItem(icon: Icons.business_outlined,  activeIcon: Icons.business,      label: 'Empire'),
    _TabItem(icon: Icons.credit_card_outlined, activeIcon: Icons.credit_card, label: 'Finance'),
    _TabItem(icon: Icons.language_outlined,  activeIcon: Icons.language,      label: 'World'),
    _TabItem(icon: Icons.person_outline,     activeIcon: Icons.person,        label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final chipColor = isUrgent ? AppColors.amber : AppColors.textTertiary;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgBase,
        border: Border(top: BorderSide(color: AppColors.borderSubtle, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.sm),
            // RepaintBoundary: isolates per-second repaints from the tab row
            RepaintBoundary(child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.bgElevated,
                borderRadius: BorderRadius.circular(AppRadius.chip),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_time, size: 12, color: chipColor),
                  const SizedBox(width: AppSpacing.xs),
                  Text(countdownLabel, style: AppTypography.labelCaps.copyWith(color: chipColor)),
                ],
              ),
            )),
            const SizedBox(height: AppSpacing.sm),
            // Tab row — ui-ux-pro-max: Semantics label + touch target ≥44pt
            SizedBox(
              height: 52,
              child: Row(
                children: List.generate(_tabs.length, (i) {
                  final tab = _tabs[i];
                  final active = i == currentIndex;
                  return Expanded(
                    child: Semantics(
                      label: tab.label,
                      selected: active,
                      button: true,
                      child: GestureDetector(
                        onTap: () => onTap(i),
                        behavior: HitTestBehavior.opaque,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOutCubic,
                              height: 2,
                              width: active ? 24 : 0,
                              decoration: BoxDecoration(
                                color: AppColors.gold,
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                active ? tab.activeIcon : tab.icon,
                                key: ValueKey('${tab.label}_$active'),
                                size: 22,
                                color: active ? AppColors.gold : AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({required this.icon, required this.activeIcon, required this.label});
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
