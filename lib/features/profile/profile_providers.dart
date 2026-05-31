import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/supabase/supabase_client.dart';

// ── Models ────────────────────────────────────────────────────────────────────

class PlayerProfile {
  const PlayerProfile({
    required this.displayName,
    required this.countryId,
    required this.cycleCount,
    required this.creditScore,
    required this.isPartner,
  });
  final String displayName, countryId;
  final int cycleCount, creditScore;
  final bool isPartner;

  factory PlayerProfile.fromRow(Map<String, dynamic> r) => PlayerProfile(
        displayName: (r['display_name'] as String?) ?? 'Player',
        countryId: (r['country_id'] as String?) ?? 'nova',
        cycleCount: (r['cycle_count'] as num?)?.toInt() ?? 0,
        creditScore: (r['credit_score'] as num?)?.toInt() ?? 500,
        isPartner: (r['is_partner'] as bool?) ?? false,
      );
}

class PlayerNeedsData {
  const PlayerNeedsData(this.values);
  final Map<String, int> values; // keyed by need id

  factory PlayerNeedsData.fromRow(Map<String, dynamic> r) => PlayerNeedsData({
        for (final id in const ['hunger', 'energy', 'health', 'happiness', 'housing', 'transportation', 'drive'])
          id: (r[id] as num?)?.toInt() ?? 0,
      });
}

class PlayerSkill {
  const PlayerSkill({
    required this.id,
    required this.name,
    required this.tier,
    required this.level,
    required this.unlocked,
    this.prerequisite,
  });
  final String id, name, tier; // tier: foundation | free_domain | gated_domain
  final int level;
  final bool unlocked;
  final String? prerequisite;

  factory PlayerSkill.fromRow(Map<String, dynamic> r) {
    final s = (r['skills'] as Map?) ?? const {};
    return PlayerSkill(
      id: (s['id'] as String?) ?? '',
      name: (s['name'] as String?) ?? '',
      tier: (s['tier'] as String?) ?? 'foundation',
      level: (r['level'] as num?)?.toInt() ?? 0,
      unlocked: (r['unlocked'] as bool?) ?? true,
      prerequisite: s['prerequisite'] as String?,
    );
  }
}

// ── Providers ─────────────────────────────────────────────────────────────────
//
// Profile data lives in the canonical `larva_core` schema (exposed via PostgREST,
// migration 009) and changes only at cycle settlement — so these are one-shot
// FutureProviders (the larva_* tables aren't in the realtime publication yet).
// All emit `null`/empty when there's no session so the UI falls back to a preview.

final playerProfileProvider = FutureProvider.autoDispose<PlayerProfile?>((ref) async {
  ref.watch(authStateProvider);
  final uid = supabase.auth.currentUser?.id;
  if (uid == null) return null;
  final row = await supabase
      .schema('larva_core')
      .from('players')
      .select('display_name,country_id,cycle_count,credit_score,is_partner')
      .eq('auth_user_id', uid)
      .maybeSingle();
  return row == null ? null : PlayerProfile.fromRow(row);
});

/// id → display name for all 18 countries (`larva_world.countries`, read-all).
final countryNamesProvider = FutureProvider.autoDispose<Map<String, String>>((ref) async {
  final rows = await supabase.schema('larva_world').from('countries').select('id,name');
  return {for (final r in (rows as List)) r['id'] as String: r['name'] as String};
});

final playerNeedsProvider = FutureProvider.autoDispose<PlayerNeedsData?>((ref) async {
  ref.watch(authStateProvider);
  final uid = supabase.auth.currentUser?.id;
  if (uid == null) return null;
  final row = await supabase
      .schema('larva_core')
      .from('player_needs')
      .select('hunger,energy,health,happiness,housing,transportation,drive')
      .eq('player_id', uid)
      .maybeSingle();
  return row == null ? null : PlayerNeedsData.fromRow(row);
});

final playerSkillsProvider = FutureProvider.autoDispose<List<PlayerSkill>?>((ref) async {
  ref.watch(authStateProvider);
  final uid = supabase.auth.currentUser?.id;
  if (uid == null) return null;
  final rows = await supabase
      .schema('larva_core')
      .from('player_skills')
      .select('level,unlocked,skills(id,name,tier,prerequisite)')
      .eq('player_id', uid);
  return (rows as List).map((r) => PlayerSkill.fromRow(r as Map<String, dynamic>)).toList();
});

/// Count of companies the player owns (`larva_economy.companies`). 0 until the
/// economy is populated.
final playerCompanyCountProvider = FutureProvider.autoDispose<int>((ref) async {
  ref.watch(authStateProvider);
  final uid = supabase.auth.currentUser?.id;
  if (uid == null) return 0;
  final rows = await supabase
      .schema('larva_economy')
      .from('companies')
      .select('id')
      .eq('owner_player', uid);
  return (rows as List).length;
});
