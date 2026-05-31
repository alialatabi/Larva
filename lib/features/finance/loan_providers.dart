import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/supabase/supabase_client.dart';

/// One active loan, shaped for the My Loans UI.
class LoanData {
  const LoanData({
    required this.ref,
    required this.lender,
    required this.original,
    required this.remaining,
    required this.rate,
    required this.payment,
    required this.issued,
    required this.matures,
    required this.nextDue,
    required this.paymentsMade,
    required this.paymentsOnTime,
  });
  final String ref, lender, nextDue;
  final int original, remaining, payment, issued, matures, paymentsMade, paymentsOnTime;
  final double rate; // % per cycle

  factory LoanData.fromRow(Map<String, dynamic> r) => LoanData(
        ref: (r['loan_ref'] as String?) ?? '',
        lender: (r['lender'] as String?) ?? '',
        original: (r['original'] as num?)?.toInt() ?? 0,
        remaining: (r['remaining'] as num?)?.toInt() ?? 0,
        rate: (r['rate'] as num?)?.toDouble() ?? 0,
        payment: (r['payment'] as num?)?.toInt() ?? 0,
        issued: (r['issued_cycle'] as num?)?.toInt() ?? 0,
        matures: (r['matures_cycle'] as num?)?.toInt() ?? 0,
        nextDue: (r['next_due_label'] as String?) ?? '',
        paymentsMade: (r['payments_made'] as num?)?.toInt() ?? 0,
        paymentsOnTime: (r['payments_on_time'] as num?)?.toInt() ?? 0,
      );
}

/// Live loans for the signed-in player, streamed from Supabase Realtime
/// (`public.loans`, migration 004).
///
/// Emits `null` when there is no session (debug preview / signed out) so the
/// UI can fall back to placeholder loans instead of erroring.
///
/// Server-authoritative: the client only READS. Issuance and per-cycle
/// repayment happen in the loan-apply Edge Function / reconciliation cycle.
final loansProvider = StreamProvider.autoDispose<List<LoanData>?>((ref) {
  ref.watch(authStateProvider);

  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return Stream<List<LoanData>?>.value(null);

  return supabase
      .from('loans')
      .stream(primaryKey: ['id'])
      .eq('user_id', userId)
      .order('created_at', ascending: true)
      .map<List<LoanData>?>((rows) => rows.map(LoanData.fromRow).toList());
});
