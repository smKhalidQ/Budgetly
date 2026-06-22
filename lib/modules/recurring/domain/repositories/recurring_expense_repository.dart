import 'package:budget_buddy/modules/recurring/data/data_sources/recurring_expense_data_source.dart';
import 'package:budget_buddy/modules/recurring/domain/models/recurring_expense.dart';

class RecurringExpenseRepository {
  final RecurringExpenseDataSource _dataSource;

  RecurringExpenseRepository(this._dataSource);

  Future<List<RecurringExpense>> getAll() async {
    final rows = await _dataSource.getRecurringExpensesData();
    return rows.map(_fromRow).toList();
  }

  Future<void> insert(RecurringExpense item) async {
    await _dataSource.insertRecurringExpense(
      categoryId: item.categoryId,
      subcategoryId: item.subcategoryId,
      amount: item.amount,
      note: item.note,
      isActive: item.isActive,
    );
  }

  Future<void> update(int id, RecurringExpense item) async {
    await _dataSource.updateRecurringExpense(
      recurringId: id,
      updatedFields: {
        'categoryId': item.categoryId,
        'subcategoryId': item.subcategoryId,
        'amount': item.amount,
        'note': item.note,
        'isActive': item.isActive ? 1 : 0,
      },
    );
  }

  Future<void> delete(int id) async {
    await _dataSource.deleteRecurringExpense(id);
  }

  RecurringExpense _fromRow(Map<String, dynamic> row) => RecurringExpense(
        id: row['recurringId'] as int?,
        categoryId: row['categoryId'] as int,
        subcategoryId: row['subcategoryId'] as int?,
        amount: (row['amount'] as num).toDouble(),
        note: row['note'] as String?,
        isActive: (row['isActive'] as int? ?? 1) == 1,
      );
}
