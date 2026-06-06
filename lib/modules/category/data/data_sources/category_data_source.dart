import 'package:sqflite/sqflite.dart';
import 'package:budget_buddy/core/database/database_helper.dart';

class CategoryManagementDataSource {
  Future<List<Map<String, dynamic>>> getCategoriesData() async {
    Database? myDb = await DatabaseHelper.db;
    try {
      return await myDb!.query('category');
    } on DatabaseException catch (_) {
      throw Exception("data retrieval failed");
    }
  }

  Future<int> insertNewCategory({
    required int categoryId,
    required String categoryName,
    required String categoryColor,
    required String categoryIcon,
    required double allocatedAmount,
  }) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      return await myDb!.insert('category', {
        'categoryId': categoryId,
        'categoryName': categoryName,
        'categoryColor': categoryColor,
        'categoryIcon': categoryIcon,
        'allocatedAmount': allocatedAmount.toString(),
        'storedSpentAmount': 0.0,
      });
    } on DatabaseException catch (_) {
      throw Exception("data insertion failed");
    }
  }

  Future<int> deleteCategoryData(int categoryId) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      return await myDb!.delete(
        'category',
        where: 'categoryId = ?',
        whereArgs: [categoryId],
      );
    } on DatabaseException catch (_) {
      throw Exception("data deletion failed");
    }
  }

  Future<int> updateCategoryData({
    required int categoryId,
    required Map<String, dynamic> updatedFields,
  }) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      return await myDb!.update(
        'category',
        updatedFields,
        where: 'categoryId = ?',
        whereArgs: [categoryId],
      );
    } on DatabaseException catch (_) {
      throw Exception("data update failed");
    }
  }

  Future<int> initializeCategoriesData({
    required List<Map<String, dynamic>> categories,
  }) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      Batch batch = myDb!.batch();
      for (var category in categories) {
        final existing = await myDb.query(
          'category',
          where: 'categoryId = ?',
          whereArgs: [category['categoryId']],
        );
        if (existing.isNotEmpty) {
          batch.update(
            'category',
            {
              'categoryName': category['categoryName'],
              'categoryColor': category['categoryColor'],
              'categoryIcon': category['categoryIcon'],
              'allocatedAmount': category['allocatedAmount'].toString(),
              'storedSpentAmount': category['storedSpentAmount'].toString(),
            },
            where: 'categoryId = ?',
            whereArgs: [category['categoryId']],
          );
        } else {
          batch.insert('category', {
            'categoryId': category['categoryId'],
            'categoryName': category['categoryName'],
            'categoryColor': category['categoryColor'],
            'categoryIcon': category['categoryIcon'],
            'allocatedAmount': category['allocatedAmount'].toString(),
            'storedSpentAmount': category['storedSpentAmount'].toString(),
          });
        }
      }
      await batch.commit(noResult: true);
      return categories.length;
    } on DatabaseException catch (_) {
      throw Exception("data insertion failed");
    }
  }

  Future<int> updateSpentAmount({
    required int categoryId,
    required double storedSpentAmount,
  }) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      return await myDb!.update(
        'category',
        {'storedSpentAmount': storedSpentAmount},
        where: 'categoryId = ?',
        whereArgs: [categoryId],
      );
    } on DatabaseException catch (_) {
      throw Exception("data update failed");
    }
  }

  Future<void> clearAll() async {
    Database? myDb = await DatabaseHelper.db;
    try {
      await myDb!.delete('category');
    } on DatabaseException catch (_) {
      throw Exception("data deletion failed");
    }
  }

  Future<Map<String, dynamic>?> getCategoryById(int categoryId) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      final response = await myDb!.query(
        'category',
        where: 'categoryId = ?',
        whereArgs: [categoryId],
      );
      return response.isNotEmpty ? response.first : null;
    } on DatabaseException catch (_) {
      throw Exception("data retrieval failed");
    }
  }
}
