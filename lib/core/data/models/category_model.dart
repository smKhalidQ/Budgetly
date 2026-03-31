import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    super.categoryId,
    required super.allocatedAmount,
    super.categoryIcon,
    super.categoryColor,
    required super.categoryName,
    super.storedSpentAmount
  });

  // Factory method to create CategoryModel from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json["categoryId"],
      allocatedAmount: json["allocatedAmount"] != null ? (json["allocatedAmount"] as num).toDouble() : 0.0,
      categoryName: json["categoryName"],
      categoryColor: json["categoryColor"],
      categoryIcon: json["categoryIcon"],
      storedSpentAmount: json["storedSpentAmount"],
    );
  }

  // Method to convert CategoryModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      "categoryName": categoryName,
      "categoryIcon": categoryIcon,
      "categoryColor": categoryColor,
      "allocatedAmount": allocatedAmount,
      "categoryId": categoryId,
      "storedSpentAmount": storedSpentAmount,
    };
  }
}
