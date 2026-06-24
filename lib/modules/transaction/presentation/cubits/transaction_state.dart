// run build_runner
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/subcategory/domain/models/subcategory.dart';
import 'package:budget_buddy/modules/transaction/domain/models/transaction.dart';

part 'transaction_state.freezed.dart';

enum TransactionStatus { initial, loading, success, error }

@freezed
sealed class TransactionState with _$TransactionState {
  const factory TransactionState({
    @Default(TransactionStatus.initial) TransactionStatus status,
    @Default([]) List<Transaction> transactions,
    @Default({}) Map<int, Category> categoriesById,
    @Default({}) Map<int, Subcategory> subcategoriesById,
    String? errorMessage,
    @Default(false) bool isEditMode,
  }) = _TransactionState;
}

extension TransactionStateX on TransactionState {
  bool get isLoading => status == TransactionStatus.loading;

  bool get isEmpty => transactions.isEmpty;

  /// Transactions grouped by calendar day, newest day first and newest
  /// transaction first within each day — the shape the list renders.
  List<MapEntry<DateTime, List<Transaction>>> get groupedByDay {
    final map = <DateTime, List<Transaction>>{};
    for (final t in transactions) {
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
}
