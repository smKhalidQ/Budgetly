import 'dart:async';
import 'package:budget_buddy/modules/transaction/data/data_sources/transaction_data_source.dart';
import 'package:budget_buddy/modules/transaction/domain/models/transaction.dart';

class TransactionAddedEvent {
  final Transaction transaction;
  const TransactionAddedEvent(this.transaction);
}

class TransactionRepository {
  final TransactionDataSource _dataSource;

  TransactionRepository(this._dataSource);

  final _addedController = StreamController<TransactionAddedEvent>.broadcast();
  Stream<TransactionAddedEvent> get onTransactionAdded => _addedController.stream;

  Future<List<Transaction>> getAll() async {
    final rows = await _dataSource.fetchTransactions();
    return rows.map(_fromRow).toList();
  }

  Future<void> add(Transaction item) async {
    await _dataSource.addTransaction(
      categoryId: item.categoryId,
      amount: item.amount,
      date: item.date,
      note: item.note,
    );
    _addedController.add(TransactionAddedEvent(item));
  }

  Future<void> edit(Transaction item) async {
    await _dataSource.editTransaction(
      item.id!,
      categoryId: item.categoryId,
      amount: item.amount,
      date: item.date,
      note: item.note,
    );
  }

  Future<void> delete(int id) async {
    await _dataSource.deleteTransaction(id);
  }

  Transaction _fromRow(Map<String, dynamic> row) => Transaction(
        id: row['transactionId'] as int?,
        categoryId: row['categoryId'] as int,
        amount: (row['amount'] as num).toDouble(),
        date: DateTime.parse(row['date'] as String),
        note: row['note'] as String?,
      );
}
