import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:budget_buddy/modules/subcategory/domain/models/subcategory.dart';

part 'subcategory_state.freezed.dart';

enum SubcategoryStatus { initial, loading, success, error }

@freezed
sealed class SubcategoryState with _$SubcategoryState {
  const factory SubcategoryState({
    @Default(SubcategoryStatus.initial) SubcategoryStatus status,
    @Default([]) List<Subcategory> subcategories,
    String? errorMessage,
    @Default('') String selectedIcon,
    @Default('Color(0xff2196f3)') String selectedColor,
    @Default(false) bool isEditMode,
    @Default(false) bool showPieChart,
    @Default({}) Map<int, double> spentBySubcategory,
    @Default(0.0) double generalSpent,
  }) = _SubcategoryState;
}

extension SubcategoryStateX on SubcategoryState {
  bool get isLoading => status == SubcategoryStatus.loading;
  bool get hasError => status == SubcategoryStatus.error;
}
