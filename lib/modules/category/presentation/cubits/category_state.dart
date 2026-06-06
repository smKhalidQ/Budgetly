import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';

part 'category_state.freezed.dart';

enum CategoryStatus { initial, loading, success, error }

// run build_runner
@freezed
sealed class CategoryState with _$CategoryState {
  const factory CategoryState({
    @Default(CategoryStatus.initial) CategoryStatus status,
    @Default([]) List<Category> categories,
    String? errorMessage,
    @Default('') String selectedIcon,
    @Default('Color(0xff2196f3)') String selectedColor,
    @Default(0) int remainingBudget,
    @Default(<int, int>{}) Map<int, int> allocations,
  }) = _CategoryState;
}

extension CategoryStateX on CategoryState {
  bool get isLoading => status == CategoryStatus.loading;
  bool get hasError => status == CategoryStatus.error;
}
