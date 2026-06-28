import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

@freezed
sealed class Category with _$Category {
  const factory Category({
    int? id,
    required String name,
    required String color,
    required String icon,
    required double allocatedAmount,
    @Default(0.0) double baseAllocation,
    @Default(0.0) double spentAmount,
  }) = _Category;
}
