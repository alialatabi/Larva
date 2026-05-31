import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/supabase/supabase_client.dart';

/// One ledger row, shaped for the Transactions UI.
class TxRow {
  const TxRow({
    required this.type,
    required this.dir,
    required this.label,
    required this.sub,
    required this.time,
    required this.amount,
  });
  final String type, dir, label, sub, time;
  final int amount;
}

/// A group of rows that settled in the same economy cycle, with the cycle's
/// net movement (in − out) precomputed for the header.
class TxCycle {
  const TxCycle({required this.cycle, required this.net, required this.rows});
  final int cycle, net;
  final List<TxRow> rows;
}

/// Live transaction ledger for the signed-in player, grouped into economy
/// cycles (newest first). Streamed from Supabase Realtime
/// (`public.transactions`, migration 003).
///
/// Emits `null` when there is no session (debug preview / signed out) so the
/// UI can fall back to placeholder history instead of erroring.
///
/// Server-authoritative: the client only READS. Rows are written by the
/// `record_transaction` SQL function / Edge Functions, never the client.
final transactionCyclesProvider =
    StreamProvider.autoDispose<List<TxCycle>?>((ref) {
  // Recompute on sign-in / sign-out.
  ref.watch(authStateProvider);

  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return Stream<List<TxCycle>?>.value(null);

  return supabase
      .from('transactions')
      .stream(primaryKey: ['id'])
      .eq('user_id', userId)
      .order('created_at', ascending: true)
      .map<List<TxCycle>?>(_groupIntoCycles);
});

/// Folds flat ledger rows into cycle groups: cycles newest-first, rows within
/// a cycle kept in chronological (stream) order.
List<TxCycle> _groupIntoCycles(List<Map<String, dynamic>> rows) {
  final byCycle = <int, List<TxRow>>{};
  for (final r in rows) {
    final cycle = (r['cycle'] as num?)?.toInt() ?? 0;
    final created = DateTime.tryParse(r['created_at'] as String? ?? '')?.toLocal();
    byCycle.putIfAbsent(cycle, () => <TxRow>[]).add(TxRow(
          type: (r['type'] as String?) ?? 'transfer',
          dir: (r['direction'] as String?) ?? 'out',
          label: (r['label'] as String?) ?? '',
          sub: (r['sub'] as String?) ?? '',
          time: created != null ? DateFormat('HH:mm').format(created) : '--:--',
          amount: (r['amount'] as num?)?.toInt() ?? 0,
        ));
  }

  final cycles = byCycle.keys.toList()..sort((a, b) => b.compareTo(a));
  return [
    for (final c in cycles)
      TxCycle(
        cycle: c,
        net: byCycle[c]!.fold(0, (s, t) => s + (t.dir == 'in' ? t.amount : -t.amount)),
        rows: byCycle[c]!,
      ),
  ];
}
