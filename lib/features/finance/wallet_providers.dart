import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/supabase/supabase_client.dart';

/// Live wallet balance for the signed-in player, streamed from Supabase
/// Realtime (`public.wallets`, migration 002).
///
/// Emits `null` when there is no session (debug preview / signed out) so the
/// UI can show a placeholder instead of erroring.
///
/// Server-authoritative: the client only READS this value. Balance mutations
/// happen in Edge Functions / SQL via the service role — never the client.
final walletBalanceProvider = StreamProvider.autoDispose<int?>((ref) {
  // Recompute on sign-in / sign-out.
  ref.watch(authStateProvider);

  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return Stream<int?>.value(null);

  return supabase
      .from('wallets')
      .stream(primaryKey: ['id'])
      .eq('user_id', userId)
      .map<int?>((rows) => rows.isEmpty ? null : (rows.first['balance'] as num).toInt());
});
