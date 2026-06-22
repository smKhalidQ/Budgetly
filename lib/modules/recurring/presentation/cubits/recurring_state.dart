// run build_runner
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/recurring/domain/models/recurring_expense.dart';
import 'package:budget_buddy/modules/subcategory/domain/models/subcategory.dart';

part 'recurring_state.freezed.dart';

enum RecurringStatus { initial, loading, success, error }

@freezed
sealed class RecurringState with _$RecurringState {
  const factory RecurringState({
    @Default(RecurringStatus.initial) RecurringStatus status,
    @Default([]) List<RecurringExpense> items,
    @Default([]) List<Category> categories,
    @Default([]) List<Subcategory> subcategories,
    String? errorMessage,
  }) = _RecurringState;
}

extension RecurringStateX on RecurringState {
  bool get isLoading => status == RecurringStatus.loading;

  bool get isEmpty => items.isEmpty;

  Map<int, Category> get categoriesById => {
        for (final c in categories)
          if (c.id != null) c.id!: c,
      };

  Map<int, Subcategory> get subcategoriesById => {
        for (final s in subcategories)
          if (s.id != null) s.id!: s,
      };

  List<Subcategory> subcategoriesFor(int categoryId) => subcategories
      .where((s) => s.parentCategoryId == categoryId)
      .toList();

  /// Total of the active fixed expenses — shown as the recurring monthly load.
  double get activeTotal => items
      .where((i) => i.isActive)
      .fold(0.0, (sum, i) => sum + i.amount);
}
