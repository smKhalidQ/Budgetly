import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:budget_buddy/modules/transaction/domain/models/transaction.dart';

part 'transaction_state.freezed.dart';

enum TransactionStatus { initial, loading, success, error }

@freezed
sealed class TransactionState with _$TransactionState {
  const factory TransactionState({
    @Default(TransactionStatus.initial) TransactionStatus status,
    @Default([]) List<Transaction> transactions,
    String? errorMessage,
    @Default(false) bool isEditMode,
  }) = _TransactionState;
}

extension TransactionStateX on TransactionState {
  bool get isLoading => status == TransactionStatus.loading;
}
