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
    @Default([]) List<Subcategory> topSubcategories,
    int? expandedCategoryId,
    Category? selectedCategory,
    Subcategory? selectedSubcategory,
    @Default('') String amountInput,
    @Default('') String note,
    @Default(AddTransactionStatus.idle) AddTransactionStatus status,
    double? overflowDeficit,
    @Default([]) List<OverflowSplit> overflowSplits,
    @Default(0.0) double overflowIncome,
  }) = _AddTransactionState;
}

extension AddTransactionStateX on AddTransactionState {
  double get parsedAmount => double.tryParse(amountInput) ?? 0.0;
  bool get isLoading => status == AddTransactionStatus.loading;
  bool get canSubmit => parsedAmount > 0 && selectedCategory != null && !isLoading;
  bool get isOverflow => overflowDeficit != null;
  double get overflowCovered =>
      overflowSplits.fold(0.0, (sum, s) => sum + s.amount) + overflowIncome;
  bool get overflowFullyCovered =>
      isOverflow && (overflowCovered - overflowDeficit!).abs() < 0.01;
}
