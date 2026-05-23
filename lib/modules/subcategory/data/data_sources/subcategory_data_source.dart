import 'package:sqflite/sqflite.dart';
import 'package:budget_buddy/core/database/database_helper.dart';

class SubcategoryDataSource {
  Future<List<Map<String, dynamic>>> getSubcategoriesData() async {
    Database? myDb = await DatabaseHelper.db;
    try {
      return await myDb!.query('subcategory');
    } on DatabaseException catch (_) {
      throw Exception("data retrieval failed");
    }
  }

  Future<int> insertNewSubcategory({
    required String subcategoryName,
    required String subcategoryColor,
    required String subcategoryIcon,
    required int parentCategoryId,
  }) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      return await myDb!.insert('subcategory', {
        'subcategoryName': subcategoryName,
        'subcategoryColor': subcategoryColor,
        'subcategoryIcon': subcategoryIcon,
        'subcategorySpentAmount': "0",
        'parentCategoryId': parentCategoryId,
      });
    } on DatabaseException catch (_) {
      throw Exception("data insertion failed");
    }
  }

  Future<int> deleteSubcategoryData(int subcategoryId) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      return await myDb!.delete(
        'subcategory',
        where: 'subcategoryId = ?',
        whereArgs: [subcategoryId],
      );
    } on DatabaseException catch (_) {
      throw Exception("data deletion failed");
    }
  }

  Future<int> updateSubcategoryData({
    required int subcategoryId,
    required Map<String, dynamic> updatedFields,
  }) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      return await myDb!.update(
        'subcategory',
        updatedFields,
        where: 'subcategoryId = ?',
        whereArgs: [subcategoryId],
      );
    } on DatabaseException catch (_) {
      throw Exception("data update failed");
    }
  }
}
