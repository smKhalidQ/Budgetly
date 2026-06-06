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

  Future<int> deleteUserData(int userId) async {
    try {
      Database? myDb = await DatabaseHelper.db;
      return await myDb!.delete(
        'userInfo',
        where: 'userId = ?',
        whereArgs: [userId],
      );
    } catch (_) {
      throw Exception("data deletion failed");
    }
  }

  Future<int> updateUserData({
    required int userId,
    required String userName,
    required String userImg,
    required String monthlySalary,
    required String currency,
    required String spentAmount,
  }) async {
    try {
      Database? myDb = await DatabaseHelper.db;
      return await myDb!.update(
        'userInfo',
        {
          'userName': userName,
          'userImg': userImg,
          'monthlySalary': monthlySalary,
          'currency': currency,
          'storedSpentAmount': spentAmount,
        },
        where: 'userId = ?',
        whereArgs: [userId],
      );
    } catch (_) {
      throw Exception("data update failed");
    }
  }
}
