import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/supabase/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  // Debug-only: auto sign-in a dev account so the app boots straight into live,
  // server-authoritative data (wallet + transactions) instead of the mock
  // "Preview" state — no need to tap through the auth screen each run. Release
  // builds are unaffected. Remove once real auth onboarding is wired.
  if (kDebugMode) {
    final client = Supabase.instance.client;
    if (client.auth.currentSession == null) {
      try {
        await client.auth.signInWithPassword(
          email: 'dev@larva.app',
          password: 'LarvaDev!2026',
        );
      } catch (e) {
        debugPrint('Dev auto-login failed: $e');
      }
    }
  }

  runApp(
    const ProviderScope(
      child: LarvaApp(),
    ),
  );
}

class LarvaApp extends ConsumerWidget {
  const LarvaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Larva',
      theme: AppTheme.dark,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
