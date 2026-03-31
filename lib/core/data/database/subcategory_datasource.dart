import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import '../../error/exceptions.dart';

class SubcategoryDataSource {
  Future<List<Map<String, dynamic>>> getSubcategoriesData() async {
    Database? myDb = await DatabaseHelper.db;
    try {
      return await myDb!.query('subcategory');
    } on DatabaseException catch (e) {
      throw DataRetrievalException("Failed to retrieve sub-category data: ${e.toString()}");
    }
  }

  // إدراج فئة فرعية جديدة
  Future<int> insertNewSubcategory({
    required String subcategoryName,
    required String subcategoryColor,
    required String subcategoryIcon,
    required int parentCategoryId,
  }) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      int response = await myDb!.insert('subcategory', {
        'subcategoryName': subcategoryName,
        'subcategoryColor': subcategoryColor,
        'subcategoryIcon': subcategoryIcon,
        'subcategorySpentAmount': "0",
        'parentCategoryId': parentCategoryId,
      });
      print("Subcategory data inserted");
      return response;
    } on DatabaseException catch (e) {
      throw DataInsertionException("Failed to insert sub-category data: ${e.toString()}");
    }
  }

  // حذف فئة فرعية بناءً على معرفها
  Future<int> deleteSubcategoryData(int subcategoryId) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      int response = await myDb!.delete(
        'subcategory',
        where: 'subcategoryId = ?',
        whereArgs: [subcategoryId],
      );
      print("Sub-category data deleted");
      return response;
    } on DatabaseException catch (e) {
      throw DataDeletionException("Failed to delete sub-category data: ${e.toString()}");
    }
  }

  // تحديث بيانات فئة فرعية
  Future<int> updateSubcategoryData({
    required int subcategoryId,
    required Map<String, dynamic> updatedFields,
  }) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      // تحديث الحقول المحددة فقط
      int response = await myDb!.update(
        'subcategory',
        updatedFields,
        where: 'subcategoryId = ?',
        whereArgs: [subcategoryId],
      );
      print("Sub-category data updated with fields: $updatedFields");
      return response;
    } on DatabaseException catch (e) {
      throw DataUpdateException("Failed to update sub-category data: ${e.toString()}");
    }
  }

  // استرداد فئة فرعية بناءً على معرفها
  // Future<Map<String, dynamic>?> getSubcategoryById(int subcategoryId) async {
  //   Database? myDb = await DatabaseHelper.db;
  //   try {
  //     final response = await myDb!.query(
  //       'subcategory',
  //       where: 'subcategoryId = ?',
  //       whereArgs: [subcategoryId],
  //     );
  //     if (response.isNotEmpty) {
  //       return response.first;
  //     } else {
  //       return null;
  //     }
  //   } on DatabaseException catch (e) {
  //     throw DataRetrievalException("Failed to retrieve sub-category by ID: ${e.toString()}");
  //   }
  // }


}