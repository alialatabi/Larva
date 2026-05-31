import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_client.dart';

final authStateProvider = StreamProvider<AuthState>((ref) {
  return supabase.auth.onAuthStateChange;
});

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<AsyncValue<AuthState>>(authStateProvider, (_, __) {
      notifyListeners();
    });
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final authAsync = _ref.read(authStateProvider);
    final isAuth = authAsync.valueOrNull?.session != null;
    final loc = state.matchedLocation;

    // Debug-only preview bypass: allow browsing the full app without a live
    // Supabase session so the UI can be reviewed. Release builds still gate.
    if (kDebugMode) return null;

    if (!isAuth) {
      if (loc != '/auth' && !loc.startsWith('/onboarding')) {
        return '/onboarding';
      }
      return null;
    }

    // Authenticated — redirect away from sign-in, but allow /onboarding (First Day)
    if (loc == '/auth') return '/home';
    return null;
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});
