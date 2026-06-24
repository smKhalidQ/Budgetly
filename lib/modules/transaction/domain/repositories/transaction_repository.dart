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

  final _changedController = StreamController<void>.broadcast();
  Stream<void> get onTransactionChanged => _changedController.stream;

  Future<List<Transaction>> getAll() async {
    final rows = await _dataSource.fetchTransactions();
    return rows.map(_fromRow).toList();
  }

  Future<void> add(Transaction item) async {
    await _dataSource.addTransaction(
      categoryId: item.categoryId,
      subcategoryId: item.subcategoryId,
      amount: item.amount,
      date: item.date,
      type: item.type.name,
      note: item.note,
      coverage: item.coverage,
    );
    _addedController.add(TransactionAddedEvent(item));
  }

  Future<void> edit(Transaction item) async {
    await _dataSource.editTransaction(
      item.id!,
      categoryId: item.categoryId,
      subcategoryId: item.subcategoryId,
      amount: item.amount,
      date: item.date,
      type: item.type.name,
      note: item.note,
      coverage: item.coverage,
    );
    _changedController.add(null);
  }

  Future<void> delete(int id) async {
    await _dataSource.deleteTransaction(id);
    _changedController.add(null);
  }

  Transaction _fromRow(Map<String, dynamic> row) {
    final typeStr = row['type'] as String? ?? 'expense';
    return Transaction(
      id: row['transactionId'] as int?,
      categoryId: row['categoryId'] as int,
      subcategoryId: row['subcategoryId'] as int?,
      amount: (row['amount'] as num).toDouble(),
      date: DateTime.parse(row['date'] as String),
      type: TransactionType.values.firstWhere(
        (t) => t.name == typeStr,
        orElse: () => TransactionType.expense,
      ),
      note: row['note'] as String?,
      coverage: row['coverage'] as String?,
    );
  }
}
