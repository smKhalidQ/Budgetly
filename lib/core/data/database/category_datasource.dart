import 'package:sqflite/sqflite.dart';
import '../../domain/entities/category_entity.dart';
import 'database_helper.dart';
import '../../error/exceptions.dart';

class CategoryManagementDataSource {

  Future<List<Map<String, dynamic>>> getCategoriesData() async {
    Database? myDb = await DatabaseHelper.db;
    try {
      return await myDb!.query('category');
    } on DatabaseException catch (e) {
      throw DataRetrievalException("Failed to retrieve category data: ${e.toString()}");
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
      int response = await myDb!.insert('category', {
        'categoryId': categoryId,
        'categoryName': categoryName,
        'categoryColor': categoryColor,
        'categoryIcon': categoryIcon,
        'allocatedAmount': allocatedAmount.toString(),
        'storedSpentAmount': 0.0,
      });
      print("Category data inserted with custom ID");
      return response;
    } on DatabaseException catch (e) {
      throw DataInsertionException("Failed to insert category data: ${e.toString()}");
    }
  }

  Future<int> deleteCategoryData(int categoryId) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      int response = await myDb!.delete(
        'category',
        where: 'categoryId = ?',
        whereArgs: [categoryId],
      );
      print("Category data deleted");
      return response;
    } on DatabaseException catch (e) {
      throw DataDeletionException("Failed to delete category data: ${e.toString()}");
    }
  }

  Future<int> updateCategoryData({
    required int categoryId,
    required Map<String, dynamic> updatedFields,
  }) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      int response = await myDb!.update(
        'category',
        updatedFields,
        where: 'categoryId = ?',
        whereArgs: [categoryId],
      );
      print("Category data updated with fields: $updatedFields");
      return response;
    } on DatabaseException catch (e) {
      throw DataUpdateException("Failed to update category data: ${e.toString()}");
    }
  }

  Future<int> initializeCategoriesData({
    required List<CategoryEntity> categories,
  }) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      Batch batch = myDb!.batch();

      for (var category in categories) {
        final existingCategory = await myDb.query(
          'category',
          where: 'categoryId = ?',
          whereArgs: [category.categoryId],
        );

        if (existingCategory.isNotEmpty) {
          batch.update(
            'category',
            {
              'categoryName': category.categoryName,
              'categoryColor': category.categoryColor,
              'categoryIcon': category.categoryIcon,
              'allocatedAmount': category.allocatedAmount.toString(),
              'storedSpentAmount': category.storedSpentAmount.toString(),
            },
            where: 'categoryId = ?',
            whereArgs: [category.categoryId],
          );
        } else {
          batch.insert(
            'category',
            {
              'categoryId': category.categoryId,
              'categoryName': category.categoryName,
              'categoryColor': category.categoryColor,
              'categoryIcon': category.categoryIcon,
              'allocatedAmount': category.allocatedAmount.toString(),
              'storedSpentAmount': category.storedSpentAmount.toString(),
            },
          );
        }
      }

      await batch.commit(noResult: true);
      print("All categories initialized/updated successfully");
      return categories.length;
    } on DatabaseException catch (e) {
      throw DataInsertionException("Failed to initialize categories data: ${e.toString()}");
    }
  }

  Future<int> updateSpentAmount({
    required int categoryId,
    required double storedSpentAmount,
  }) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      int response = await myDb!.update(
        'category',
        {
          'storedSpentAmount': storedSpentAmount,
        },
        where: 'categoryId = ?',
        whereArgs: [categoryId],
      );
      print("Spent amount updated");
      return response;
    } on DatabaseException catch (e) {
      throw DataUpdateException("Failed to update spent amount: ${e.toString()}");
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
      if (response.isNotEmpty) {
        return response.first;
      } else {
        return null;
      }
    } on DatabaseException catch (e) {
      throw DataRetrievalException("Failed to retrieve category by ID: ${e.toString()}");
    }
  }
}
