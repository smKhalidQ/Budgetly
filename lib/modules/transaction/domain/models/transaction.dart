import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';

@freezed
sealed class Transaction with _$Transaction {
  const factory Transaction({
    int? id,
    required int categoryId,
    required double amount,
    required DateTime date,
    String? note,
  }) = _Transaction;
}
