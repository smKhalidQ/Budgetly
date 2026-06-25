import 'dart:convert';

/// How an overflow expense was covered: a list of lender categories (each with
/// the amount borrowed) plus any amount taken from new income. Persisted on the
/// transaction as JSON so the coverage can be shown and reversed later.
class CoverageSource {
  final int categoryId;
  final double amount;

  const CoverageSource({required this.categoryId, required this.amount});
}

class TransactionCoverage {
  final double income;
  final List<CoverageSource> sources;

  const TransactionCoverage({required this.income, required this.sources});

  double get borrowed =>
      income + sources.fold(0.0, (sum, s) => sum + s.amount);

  static TransactionCoverage? parse(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return TransactionCoverage(
      income: (data['income'] as num?)?.toDouble() ?? 0,
      sources: [
        for (final s in (data['splits'] as List? ?? []))
          CoverageSource(
            categoryId: (s as Map)['c'] as int,
            amount: (s['a'] as num).toDouble(),
          ),
      ],
    );
  }

  String encode() => jsonEncode({
        'income': income,
        'splits': [
          for (final s in sources) {'c': s.categoryId, 'a': s.amount},
        ],
      });
}
