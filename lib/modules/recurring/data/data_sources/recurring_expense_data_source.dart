import 'package:sqflite/sqflite.dart';
import 'package:budget_buddy/core/database/database_helper.dart';

class RecurringExpenseDataSource {
  Future<List<Map<String, dynamic>>> getRecurringExpensesData() async {
    Database? myDb = await DatabaseHelper.db;
    try {
      return await myDb!.query('recurring_expense');
    } on DatabaseException catch (_) {
      throw Exception("data retrieval failed");
    }
  }

  Future<int> insertRecurringExpense({
    required int categoryId,
    int? subcategoryId,
    required double amount,
    String? note,
    required bool isActive,
  }) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      return await myDb!.insert('recurring_expense', {
        'categoryId': categoryId,
        'subcategoryId': subcategoryId,
        'amount': amount,
        'note': note,
        'isActive': isActive ? 1 : 0,
      });
    } on DatabaseException catch (_) {
      throw Exception("data insertion failed");
    }
  }

  Future<int> updateRecurringExpense({
    required int recurringId,
    required Map<String, dynamic> updatedFields,
  }) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      return await myDb!.update(
        'recurring_expense',
        updatedFields,
        where: 'recurringId = ?',
        whereArgs: [recurringId],
      );
    } on DatabaseException catch (_) {
      throw Exception("data update failed");
    }
  }

  Future<int> deleteRecurringExpense(int recurringId) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      return await myDb!.delete(
        'recurring_expense',
        where: 'recurringId = ?',
        whereArgs: [recurringId],
      );
    } on DatabaseException catch (_) {
      throw Exception("data deletion failed");
    }
  }
}
