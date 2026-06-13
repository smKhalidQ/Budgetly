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
    int? subcategoryId,
    required double amount,
    required DateTime date,
    required String type,
    String? note,
  }) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      return await myDb!.insert('transaction', {
        'categoryId': categoryId,
        'subcategoryId': subcategoryId,
        'amount': amount,
        'date': date.toIso8601String(),
        'type': type,
        'note': note,
      });
    } on DatabaseException catch (_) {
      throw Exception("data insertion failed");
    }
  }

  Future<int> editTransaction(
    int transactionId, {
    required int categoryId,
    int? subcategoryId,
    required double amount,
    required DateTime date,
    required String type,
    String? note,
  }) async {
    Database? myDb = await DatabaseHelper.db;
    try {
      return await myDb!.update(
        'transaction',
        {
          'categoryId': categoryId,
          'subcategoryId': subcategoryId,
          'amount': amount,
          'date': date.toIso8601String(),
          'type': type,
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
