import 'package:sqflite/sqflite.dart';
import 'package:budget_buddy/core/database/database_helper.dart';

class TransactionDataSource {
  Future<List<Map<String, dynamic>>> fetchTransactions() async {
    Database? myDb = await DatabaseHelper.db;
    try {
      return await myDb!.query('transaction');
    } on DatabaseException catch (_) {
      throw Exception("data retrieval failed");
    }
  }

  Future<int> addTransaction({
    required int categoryId,
    required double amount,
    required DateTime date,
    String? note,
  }) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      return await myDb!.insert('transaction', {
        'categoryId': categoryId,
        'amount': amount,
        'date': date.toIso8601String(),
        'note': note,
      });
    } on DatabaseException catch (_) {
      throw Exception("data insertion failed");
    }
  }

  Future<int> editTransaction(
    int transactionId, {
    required int categoryId,
    required double amount,
    required DateTime date,
    String? note,
  }) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      return await myDb!.update(
        'transaction',
        {
          'categoryId': categoryId,
          'amount': amount,
          'date': date.toIso8601String(),
          'note': note,
        },
        where: 'transactionId = ?',
        whereArgs: [transactionId],
      );
    } on DatabaseException catch (_) {
      throw Exception("data update failed");
    }
  }

  Future<int> deleteTransaction(int transactionId) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      return await myDb!.delete(
        'transaction',
        where: 'transactionId = ?',
        whereArgs: [transactionId],
      );
    } on DatabaseException catch (_) {
      throw Exception("data deletion failed");
    }
  }
}
