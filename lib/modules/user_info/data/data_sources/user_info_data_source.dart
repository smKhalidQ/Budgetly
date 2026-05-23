import 'package:sqflite/sqflite.dart';
import 'package:budget_buddy/core/database/database_helper.dart';

class UserInfoDataSource {
  Future<List<Map<String, dynamic>>> getUserData() async {
    Database? myDb = await DatabaseHelper.db;
    try {
      return await myDb!.query("userInfo");
    } catch (_) {
      throw Exception("data retrieval failed");
    }
  }

  Future<void> insertUserData({
    required String userName,
    required String userImg,
    required String monthlySalary,
    required String currency,
  }) async {
    final db = await DatabaseHelper.db;
    try {
      await db!.delete('userInfo');
      await db.insert(
        'userInfo',
        {
          'userName': userName,
          'userImg': userImg,
          'monthlySalary': monthlySalary,
          'currency': currency,
          'storedSpentAmount': 0.0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {
      throw Exception("data insertion failed");
    }
  }

  Future<int> deleteUserData(String query) async {
    try {
      Database? myDb = await DatabaseHelper.db;
      return await myDb!.rawDelete(query);
    } catch (_) {
      throw Exception("data deletion failed");
    }
  }

  Future<int> updateUserData(String sql) async {
    try {
      Database? myDb = await DatabaseHelper.db;
      return await myDb!.rawUpdate(sql);
    } catch (_) {
      throw Exception("data update failed");
    }
  }
}
