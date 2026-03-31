
abstract class SubcategoryEntity {
  final int? subcategoryId;
  final int? parentCategoryId;
  final String? subcategoryName;
  final String? subcategoryColor;
  final String? subcategoryIcon;
  final String? subcategorySpentAmount;



  SubcategoryEntity({
    this.parentCategoryId,
    this.subcategoryId,
    this.subcategorySpentAmount,
    this.subcategoryIcon,
    this.subcategoryColor,
    required this.subcategoryName,
  });
}
