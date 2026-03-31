import '../../domain/entities/subcategory-entity.dart';

class SubcategoryModel extends SubcategoryEntity {
  SubcategoryModel({
    super.subcategoryId,
    super.parentCategoryId,
    required super.subcategoryIcon,
    required super.subcategoryColor,
    super.subcategorySpentAmount,
    required super.subcategoryName,
  });

  // Factory method to create CategoryModel from JSON
  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
        parentCategoryId:json["parentCategoryId"],
      subcategoryId: json["subcategoryId"],
      subcategoryIcon: json["subCategoryIcon"],
      subcategoryColor: json["subCategoryColor"],
      subcategoryName: json["subCategoryName"],
      subcategorySpentAmount: json["subcategorySpentAmount"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "parentCategoryId":parentCategoryId,
      "subcategoryName": subcategoryName,
      "subcategoryIcon": subcategoryIcon,
      "subcategoryColor": subcategoryColor ,
      "subcategoryId": subcategoryId,
      "subcategorySpentAmount": subcategorySpentAmount,
    };
  }
}
