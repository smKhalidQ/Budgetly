// run build_runner
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/subcategory/domain/models/subcategory.dart';
import 'package:budget_buddy/modules/transaction/domain/models/transaction.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_transaction_state.freezed.dart';

enum AddTransactionStatus { idle, loading, success, error }

class OverflowSplit {
  final Category category;
  final double available;
  final double amount;

  const OverflowSplit({
    required this.category,
    required this.available,
    this.amount = 0.0,
  });

  OverflowSplit withAmount(double newAmount) => OverflowSplit(
        category: category,
        available: available,
        amount: newAmount.clamp(0.0, available),
      );
}

@freezed
sealed class AddTransactionState with _$AddTransactionState {
  const factory AddTransactionState({
    @Default(TransactionType.expense) TransactionType transactionType,
    @Default([]) List<Category> categories,
    @Default({}) Map<int, List<Subcategory>> subcategoriesMap,
    int? expandedCategoryId,
    Category? selectedCategory,
    Subcategory? selectedSubcategory,
    @Default(false) bool subcategoryChosen,
    @Default('') String amountInput,
    double? pendingValue,
    String? pendingOperator,
    @Default('') String expressionLog,
    @Default('') String note,
    @Default(AddTransactionStatus.idle) AddTransactionStatus status,
    double? overflowDeficit,
    @Default([]) List<OverflowSplit> overflowSplits,
    @Default(0.0) double overflowIncome,
    Transaction? editingTransaction,
  }) = _AddTransactionState;
}

extension AddTransactionStateX on AddTransactionState {
  double get parsedAmount => double.tryParse(amountInput) ?? 0.0;
  bool get isLoading => status == AddTransactionStatus.loading;
  bool get isEditing => editingTransaction != null;
  bool get hasPendingOperation => pendingOperator != null;
  double get liveResult {
    final pending = pendingValue;
    if (pending == null) return parsedAmount;
    final current = double.tryParse(amountInput);
    if (current == null) return pending;
    return applyOperator(pending, current, pendingOperator!);
  }

  bool get canSubmit =>
      liveResult > 0 && selectedCategory != null && !isLoading;
  bool get showNumpad =>
      transactionType == TransactionType.income || subcategoryChosen;
  String get amountExpression =>
      amountInput.isEmpty ? expressionLog : '$expressionLog $amountInput';

  String get displayTotal {
    if (pendingValue == null) return amountInput.isEmpty ? '0' : amountInput;
    return _formatOperand(liveResult);
  }

  bool get isOverflow => overflowDeficit != null;
  double get overflowCovered =>
      overflowSplits.fold(0.0, (sum, s) => sum + s.amount) + overflowIncome;
  bool get overflowFullyCovered =>
      isOverflow && (overflowCovered - overflowDeficit!).abs() < 0.01;
}

String _formatOperand(double v) =>
    v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);

double applyOperator(double a, double b, String operator) {
  switch (operator) {
    case '+':
      return a + b;
    case '−':
      return a - b;
    case '×':
      return a * b;
    case '÷':
      return b == 0 ? a : a / b;
    default:
      return b;
  }
}
