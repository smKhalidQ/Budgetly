import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/subcategory/domain/models/subcategory.dart';
import 'package:budget_buddy/modules/transaction/domain/models/transaction.dart';

enum TransactionStatus { initial, loading, success, error }

enum TransactionPeriod { today, week, month }

enum TransactionGrouping { byDate, byCategory }

enum TransactionError { loadFailed }

class TransactionState {
  final TransactionStatus status;
  final List<Transaction> transactions;
  final Map<int, Category> categoriesById;
  final Map<int, Subcategory> subcategoriesById;
  final TransactionError? error;
  final bool isEditMode;
  final TransactionPeriod period;
  final TransactionGrouping grouping;

  const TransactionState({
    this.status = TransactionStatus.initial,
    this.transactions = const [],
    this.categoriesById = const {},
    this.subcategoriesById = const {},
    this.error,
    this.isEditMode = false,
    this.period = TransactionPeriod.today,
    this.grouping = TransactionGrouping.byDate,
  });

  TransactionState copyWith({
    TransactionStatus? status,
    List<Transaction>? transactions,
    Map<int, Category>? categoriesById,
    Map<int, Subcategory>? subcategoriesById,
    TransactionError? error,
    bool? isEditMode,
    TransactionPeriod? period,
    TransactionGrouping? grouping,
  }) {
    return TransactionState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      categoriesById: categoriesById ?? this.categoriesById,
      subcategoriesById: subcategoriesById ?? this.subcategoriesById,
      error: error ?? this.error,
      isEditMode: isEditMode ?? this.isEditMode,
      period: period ?? this.period,
      grouping: grouping ?? this.grouping,
    );
  }
}

extension TransactionStateX on TransactionState {
  bool get isLoading => status == TransactionStatus.loading;

  bool get isEmpty => transactions.isEmpty;

  // All transactions grouped by day — used by the home tab (no period filter)
  List<MapEntry<DateTime, List<Transaction>>> get groupedByDay {
    final filtered = transactions
        .where((t) => t.type != TransactionType.rollover)
        .toList();
    final map = <DateTime, List<Transaction>>{};
    for (final t in filtered) {
      final day = DateTime(t.date.year, t.date.month, t.date.day);
      map.putIfAbsent(day, () => []).add(t);
    }
    final entries = map.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    for (final entry in entries) {
      entry.value.sort((a, b) => b.date.compareTo(a.date));
    }
    return entries;
  }

  // Period-filtered transactions — used by the reports page
  List<Transaction> get filteredTransactions {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final from = switch (period) {
      TransactionPeriod.today => today,
      TransactionPeriod.week => today.subtract(const Duration(days: 6)),
      TransactionPeriod.month => DateTime(now.year, now.month, 1),
    };
    return transactions
        .where((t) =>
            t.type != TransactionType.rollover && !t.date.isBefore(from))
        .toList();
  }

  double get filteredExpense => filteredTransactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (s, t) => s + t.amount);

  double get filteredIncome => filteredTransactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (s, t) => s + t.amount);

  List<MapEntry<DateTime, List<Transaction>>> get filteredGroupedByDay {
    final map = <DateTime, List<Transaction>>{};
    for (final t in filteredTransactions) {
      final day = DateTime(t.date.year, t.date.month, t.date.day);
      map.putIfAbsent(day, () => []).add(t);
    }
    final entries = map.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    for (final entry in entries) {
      entry.value.sort((a, b) => b.date.compareTo(a.date));
    }
    return entries;
  }

  List<MapEntry<Category, List<Transaction>>> get filteredGroupedByCategory {
    final map = <int, List<Transaction>>{};
    for (final t in filteredTransactions) {
      map.putIfAbsent(t.categoryId, () => []).add(t);
    }
    final entries = <MapEntry<Category, List<Transaction>>>[];
    for (final entry in map.entries) {
      final cat = categoriesById[entry.key];
      if (cat == null) continue;
      entry.value.sort((a, b) => b.date.compareTo(a.date));
      entries.add(MapEntry(cat, entry.value));
    }
    entries.sort((a, b) {
      final sumA = a.value.fold(0.0, (s, t) => s + t.amount);
      final sumB = b.value.fold(0.0, (s, t) => s + t.amount);
      return sumB.compareTo(sumA);
    });
    return entries;
  }
}
