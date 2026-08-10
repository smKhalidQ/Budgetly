// run build_runner
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:slice_pay/modules/category/domain/models/category.dart';
import 'package:slice_pay/modules/recurring/domain/models/recurring_expense.dart';
import 'package:slice_pay/modules/subcategory/domain/models/subcategory.dart';

part 'recurring_state.freezed.dart';

enum RecurringStatus { initial, loading, success, error }

enum RecurringError { loadFailed }

@freezed
sealed class RecurringState with _$RecurringState {
  const factory RecurringState({
    @Default(RecurringStatus.initial) RecurringStatus status,
    @Default([]) List<RecurringExpense> items,
    @Default([]) List<Category> categories,
    @Default([]) List<Subcategory> subcategories,
    RecurringError? error,
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

  /// Total of the active fixed expenses â€” shown as the recurring monthly load.
  double get activeTotal => items
      .where((i) => i.isActive)
      .fold(0.0, (sum, i) => sum + i.amount);
}
