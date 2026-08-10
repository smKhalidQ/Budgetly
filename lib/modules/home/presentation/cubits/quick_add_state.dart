// run build_runner
import 'package:slice_pay/l10n/app_localizations.dart';
import 'package:slice_pay/modules/category/domain/models/category.dart';
import 'package:slice_pay/modules/category/domain/models/category_localization.dart';
import 'package:slice_pay/modules/subcategory/domain/models/subcategory.dart';
import 'package:slice_pay/modules/subcategory/domain/models/subcategory_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'quick_add_state.freezed.dart';

class QuickAddItem {
  final Category category;
  final Subcategory? subcategory;

  const QuickAddItem({required this.category, this.subcategory});

  String label(AppLocalizations t) =>
      subcategory?.localizedName(t) ?? category.localizedName(t);
  String get icon => subcategory?.icon ?? category.icon;
  String get color => subcategory?.color ?? category.color;
}

@freezed
sealed class QuickAddState with _$QuickAddState {
  const factory QuickAddState({
    @Default([]) List<QuickAddItem> items,
  }) = _QuickAddState;
}
