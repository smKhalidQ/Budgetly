// run build_runner
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';

enum TransactionType { income, expense, rollover }

@freezed
sealed class Transaction with _$Transaction {
  const factory Transaction({
    int? id,
    required int categoryId,
    int? subcategoryId,
    required double amount,
    required DateTime date,
    @Default(TransactionType.expense) TransactionType type,
    String? note,
    String? coverage,
  }) = _Transaction;
}
