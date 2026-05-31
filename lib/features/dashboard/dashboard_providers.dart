import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/supabase/supabase_client.dart';

// ── Models ────────────────────────────────────────────────────────────────────

class DashCompany {
  const DashCompany({required this.name, required this.typeName, required this.status, required this.valuation});
  final String name, typeName, status;
  final int valuation;

  factory DashCompany.fromRow(Map<String, dynamic> r) {
    final ct = (r['company_types'] as Map?) ?? const {};
    return DashCompany(
      name: (r['name'] as String?) ?? '',
      typeName: (ct['name'] as String?) ?? '',
      status: (r['status'] as String?) ?? 'active',
      valuation: (r['valuation'] as num?)?.toInt() ?? 0,
    );
  }
}

class DashEvent {
  const DashEvent({required this.title, required this.scope, required this.severity, required this.cyclesLeft, required this.affectsMe});
  final String title, scope, severity;
  final int cyclesLeft;
  final bool affectsMe;

  factory DashEvent.fromRow(Map<String, dynamic> r) {
    final ends = (r['ends_cycle'] as num?)?.toInt();
    final start = (r['started_cycle'] as num?)?.toInt();
    return DashEvent(
      title: (r['title'] as String?) ?? '',
      scope: (r['scope'] as String?) ?? '',
      severity: (r['severity'] as String?) ?? 'minor',
      cyclesLeft: (ends != null && start != null) ? (ends - start).clamp(0, 999) : (ends ?? 0),
      affectsMe: false, // requires company/country matching — server-side later
    );
  }
}

// ── Providers ─────────────────────────────────────────────────────────────────
// One-shot FutureProviders against the canonical exposed schemas (not streamed —
// larva_* isn't in the realtime publication). All emit null/empty with no session
// so the dashboard falls back to a preview.

/// Companies the player owns (`larva_economy.companies` + type name). Empty until
/// the economy is populated by Edge Functions.
final dashboardCompaniesProvider = FutureProvider.autoDispose<List<DashCompany>?>((ref) async {
  ref.watch(authStateProvider);
  final uid = supabase.auth.currentUser?.id;
  if (uid == null) return null;
  final rows = await supabase
      .schema('larva_economy')
      .from('companies')
      .select('name,status,valuation,company_types(name)')
      .eq('owner_player', uid)
      .order('valuation', ascending: false);
  return (rows as List).map((r) => DashCompany.fromRow(r as Map<String, dynamic>)).toList();
});

/// Active world events (`larva_world.events`, read-all). Empty until the event
/// roller runs.
final activeEventsProvider = FutureProvider.autoDispose<List<DashEvent>?>((ref) async {
  ref.watch(authStateProvider);
  if (supabase.auth.currentUser == null) return null;
  final rows = await supabase
      .schema('larva_world')
      .from('events')
      .select('title,scope,severity,started_cycle,ends_cycle')
      .eq('status', 'active')
      .order('severity');
  return (rows as List).map((r) => DashEvent.fromRow(r as Map<String, dynamic>)).toList();
});

/// Total market value of the player's share holdings (`larva_market.holdings` ×
/// listing last price). 0 until any IPOs/trades exist.
final portfolioValueProvider = FutureProvider.autoDispose<int?>((ref) async {
  ref.watch(authStateProvider);
  final uid = supabase.auth.currentUser?.id;
  if (uid == null) return null;
  final rows = await supabase
      .schema('larva_market')
      .from('holdings')
      .select('shares,listings(last_price)')
      .eq('holder', uid);
  var total = 0;
  for (final r in (rows as List)) {
    final shares = (r['shares'] as num?)?.toInt() ?? 0;
    final lst = (r['listings'] as Map?) ?? const {};
    total += shares * ((lst['last_price'] as num?)?.toInt() ?? 0);
  }
  return total;
});
