
abstract class CategoryEntity {
  final int? categoryId;
  final String? categoryName;
  final String? categoryColor;
  final String? categoryIcon;
  final double? allocatedAmount;
  final double storedSpentAmount;


  CategoryEntity({
    this.categoryId,
    required this.allocatedAmount,
    this.storedSpentAmount=0,
    this.categoryIcon,
    this.categoryColor,
    required this.categoryName,
  });
}
