import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/supabase/supabase_client.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailCtrl = TextEditingController();
  final _pwCtrl    = TextEditingController();
  bool _loading    = false;
  bool _showPw     = false;
  String? _error;
  String? _focused;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _emailCtrl.text.contains('@') && _pwCtrl.text.length >= 6;

  Future<void> _signIn() async {
    setState(() { _loading = true; _error = null; });
    try {
      await supabase.auth.signInWithPassword(
        email: _emailCtrl.text.trim(),
        password: _pwCtrl.text,
      );
      // RouterNotifier triggers redirect to /home
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenH, vertical: 14),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
              ),
              child: Row(children: [
                Text(
                  'LAR',
                  style: AppTypography.displayM.copyWith(letterSpacing: -0.02),
                ),
                Text(
                  'VA',
                  style: AppTypography.displayM.copyWith(
                    letterSpacing: -0.02, color: AppColors.gold),
                ),
              ]),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.screenH),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.x2l),
                    Text('Welcome back.',
                      style: AppTypography.displayM),
                    const SizedBox(height: 6),
                    Text('Sign in to your account.',
                      style: AppTypography.bodyM.copyWith(
                        color: AppColors.textSecondary)),
                    const SizedBox(height: AppSpacing.x2l),

                    // Email
                    const _FieldLabel('Email'),
                    const SizedBox(height: 7),
                    _InputField(
                      controller: _emailCtrl,
                      focused: _focused == 'email',
                      onFocus: (v) => setState(() => _focused = v ? 'email' : null),
                      keyboardType: TextInputType.emailAddress,
                      placeholder: 'you@example.com',
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Password
                    const _FieldLabel('Password'),
                    const SizedBox(height: 7),
                    _InputField(
                      controller: _pwCtrl,
                      focused: _focused == 'password',
                      onFocus: (v) => setState(() => _focused = v ? 'password' : null),
                      obscureText: !_showPw,
                      placeholder: 'Your password',
                      onChanged: (_) => setState(() {}),
                      trailing: GestureDetector(
                        onTap: () => setState(() => _showPw = !_showPw),
                        child: Text(_showPw ? 'hide' : 'show',
                          style: AppTypography.bodyS.copyWith(
                            color: AppColors.textTertiary, fontSize: 12)),
                      ),
                    ),

                    if (_error != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.all(12),
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
                    ],
                  ],
                ),
              ),
            ),

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
                  child: AnimatedOpacity(
                    opacity: _canSubmit ? 1 : 0.4,
                    duration: const Duration(milliseconds: 200),
                    child: ElevatedButton(
                      onPressed: (_canSubmit && !_loading) ? _signIn : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        disabledBackgroundColor: AppColors.bgInput,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _loading
                        ? const SizedBox(width: 20, height: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.bgBase, strokeWidth: 2))
                        : Text('Sign in',
                            style: GoogleFonts.dmSans(
                              fontSize: 16, fontWeight: FontWeight.w700,
                              color: AppColors.bgBase)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => context.go('/onboarding'),
                  child: Text.rich(TextSpan(children: [
                    TextSpan(
                      text: "Don't have an account? ",
                      style: AppTypography.bodyS.copyWith(
                        color: AppColors.textTertiary, fontSize: 12)),
                    TextSpan(
                      text: 'Create one',
                      style: AppTypography.bodyS.copyWith(
                        color: AppColors.gold, fontSize: 12,
                        fontWeight: FontWeight.w600)),
                  ])),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared helpers ─────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(text,
    style: AppTypography.bodyS.copyWith(
      color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500));
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.focused,
    required this.onFocus,
    required this.placeholder,
    required this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.trailing,
  });
  final TextEditingController controller;
  final bool focused;
  final ValueChanged<bool> onFocus;
  final String placeholder;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: onFocus,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.bgInput,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: focused
              ? AppColors.gold
              : controller.text.isNotEmpty
                ? AppColors.borderDefault
                : AppColors.borderSubtle,
            width: focused ? 1.5 : 1,
          ),
          boxShadow: focused
            ? [BoxShadow(
                color: AppColors.gold.withOpacity(0.12),
                blurRadius: 12, spreadRadius: 0)]
            : [],
        ),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              onChanged: onChanged,
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
            ),
          ),
          if (trailing != null)
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: trailing!,
            ),
          if (trailing == null && controller.text.isNotEmpty && !obscureText)
            const Padding(
              padding: EdgeInsets.only(right: 14),
              child: Text('✓',
                style: TextStyle(color: AppColors.emerald, fontSize: 14)),
            ),
        ]),
      ),
    );
  }
}
