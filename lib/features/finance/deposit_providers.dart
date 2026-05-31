import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/supabase/supabase_client.dart';

/// One term deposit, shaped for the My Deposits UI.
class DepositData {
  const DepositData({
    required this.ref,
    required this.bank,
    required this.amount,
    required this.rate,
    required this.cycles,
    required this.remaining,
  });
  final String ref, bank;
  final int amount, cycles, remaining;
  final double rate; // % per cycle

  factory DepositData.fromRow(Map<String, dynamic> r) => DepositData(
        ref: (r['deposit_ref'] as String?) ?? '',
        bank: (r['bank'] as String?) ?? '',
        amount: (r['amount'] as num?)?.toInt() ?? 0,
        rate: (r['rate'] as num?)?.toDouble() ?? 0,
        cycles: (r['cycles'] as num?)?.toInt() ?? 0,
        remaining: (r['remaining'] as num?)?.toInt() ?? 0,
      );
}

/// Live deposits for the signed-in player, streamed from Supabase Realtime
/// (`public.deposits`, migration 004).
///
/// Emits `null` when there is no session (debug preview / signed out) so the
/// UI can fall back to placeholder deposits instead of erroring.
///
/// Server-authoritative: the client only READS. Interest accrual and maturity
/// happen in the reconciliation cycle.
final depositsProvider = StreamProvider.autoDispose<List<DepositData>?>((ref) {
  ref.watch(authStateProvider);

  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return Stream<List<DepositData>?>.value(null);

  return supabase
      .from('deposits')
      .stream(primaryKey: ['id'])
      .eq('user_id', userId)
      .order('created_at', ascending: true)
      .map<List<DepositData>?>((rows) => rows.map(DepositData.fromRow).toList());
});
