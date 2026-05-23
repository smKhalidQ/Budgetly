import 'package:freezed_annotation/freezed_annotation.dart';

part 'subcategory.freezed.dart';

@freezed
sealed class Subcategory with _$Subcategory {
  const factory Subcategory({
    int? id,
    int? parentCategoryId,
    required String name,
    required String color,
    required String icon,
    String? spentAmount,
  }) = _Subcategory;
}
