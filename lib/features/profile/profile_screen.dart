import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenH),
          children: [
            const SizedBox(height: AppSpacing.xl),
            // Avatar
            Center(
              child: Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gold.withOpacity(0.4), width: 2),
                ),
                child: const Center(child: Text('🧑', style: TextStyle(fontSize: 36))),
              ),
            ),
            const SizedBox(height: 12),
            Center(child: Text('Alex Rivera', style: AppTypography.displayM.copyWith(fontSize: 22))),
            Center(child: Text('Level 4 Entrepreneur · Caedoria', style: AppTypography.labelCaps.copyWith(fontSize: 11))),
            const SizedBox(height: AppSpacing.x2l),

            // Stats
            Container(
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Text('STATS', style: AppTypography.labelCaps.copyWith(fontSize: 10, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                const Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _StatPill(label: 'Cycles', val: '47'),
                  _StatPill(label: 'Companies', val: '3'),
                  _StatPill(label: 'Net Worth', val: '\$847K', color: AppColors.gold),
                ]),
              ]),
            ),
            const SizedBox(height: 14),

            // Skills
            Container(
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('SKILLS', style: AppTypography.labelCaps.copyWith(fontSize: 10, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                for (final skill in [
                  ('Management',  72),
                  ('Finance',     58),
                  ('Marketing',   44),
                  ('Operations',  81),
                  ('Negotiation', 35),
                ]) ...[
                  _SkillRow(label: skill.$1, val: skill.$2),
                  const SizedBox(height: 10),
                ],
              ]),
            ),
            const SizedBox(height: 14),

            // Partner program
            Container(
              decoration: BoxDecoration(
                color: AppColors.violet.withOpacity(0.05),
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.violet.withOpacity(0.3)),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                const Text('👑', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Partner Program', style: AppTypography.headingS.copyWith(color: AppColors.violet)),
                  const SizedBox(height: 2),
                  Text('Unlock partner status for exclusive perks and reduced fees.', style: AppTypography.bodyS.copyWith(fontSize: 11)),
                ])),
              ]),
            ),
            const SizedBox(height: 14),

            // Settings
            for (final item in [
              (Icons.settings_outlined,   'Settings'),
              (Icons.help_outline,        'Help & FAQ'),
              (Icons.logout,              'Sign out'),
            ])
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: ListTile(
                  leading: Icon(item.$1, color: AppColors.textSecondary, size: 20),
                  title: Text(item.$2, style: AppTypography.bodyS.copyWith(color: AppColors.textSecondary, fontSize: 14)),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 18),
                ),
              ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.label, required this.val, this.color});
  final String label, val;
  final Color? color;
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(val, style: AppTypography.dataM.copyWith(fontSize: 18, color: color ?? AppColors.textPrimary)),
    const SizedBox(height: 2),
    Text(label, style: AppTypography.labelCaps.copyWith(fontSize: 10)),
  ]);
}

class _SkillRow extends StatelessWidget {
  const _SkillRow({required this.label, required this.val});
  final String label;
  final int val;
  @override
  Widget build(BuildContext context) {
    final c = AppColors.needColor(val);
    return Row(children: [
      SizedBox(width: 90, child: Text(label, style: AppTypography.bodyS.copyWith(fontSize: 12))),
      Expanded(child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: SizedBox(height: 4, child: LinearProgressIndicator(
          value: val / 100.0,
          backgroundColor: AppColors.bgInput,
          valueColor: AlwaysStoppedAnimation(c),
        )),
      )),
      const SizedBox(width: 8),
      Text('$val', style: AppTypography.dataS.copyWith(fontSize: 11, color: c)),
    ]);
  }
}
