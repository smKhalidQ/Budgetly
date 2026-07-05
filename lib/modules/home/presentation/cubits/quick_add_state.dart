// run build_runner
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/subcategory/domain/models/subcategory.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'quick_add_state.freezed.dart';

class QuickAddItem {
  final Category category;
  final Subcategory? subcategory;

  const QuickAddItem({required this.category, this.subcategory});

  String get label => subcategory?.name ?? category.name;
  String get icon => subcategory?.icon ?? category.icon;
  String get color => subcategory?.color ?? category.color;
}

@freezed
sealed class QuickAddState with _$QuickAddState {
  const factory QuickAddState({
    @Default([]) List<QuickAddItem> items,
  }) = _QuickAddState;
}
