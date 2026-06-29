// run build_runner
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';

part 'manage_categories_state.freezed.dart';

enum ManageCategoriesStatus { initial, loading, saving, success, error }

@freezed
sealed class ManageCategoriesState with _$ManageCategoriesState {
  const factory ManageCategoriesState({
    @Default(ManageCategoriesStatus.initial) ManageCategoriesStatus status,
    @Default([]) List<Category> categories,
    @Default({}) Map<int, double> newBases,
    @Default(0.0) double newSalary,
    @Default([]) List<String> deferredNames,
    String? errorMessage,
  }) = _ManageCategoriesState;
}

extension ManageCategoriesStateX on ManageCategoriesState {
  double get originalSalary =>
      categories.fold(0.0, (s, c) => s + c.baseAllocation);

  double get totalAssigned =>
      newBases.values.fold(0.0, (s, v) => s + v);

  double get remaining => newSalary - totalAssigned;

  bool get isOver => remaining < -0.01;

  bool get canSave => !isOver;

  bool get isLoading => status == ManageCategoriesStatus.loading || status == ManageCategoriesStatus.saving;

  double baseFor(Category c) => c.id != null ? (newBases[c.id!] ?? c.baseAllocation) : c.baseAllocation;

  bool isDeferredFor(Category c) => baseFor(c) < c.spentAmount;
}
