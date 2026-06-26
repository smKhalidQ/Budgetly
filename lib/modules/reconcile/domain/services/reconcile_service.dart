import 'package:budget_buddy/core/services/month_cycle_service.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/category/domain/repositories/category_repository.dart';
import 'package:budget_buddy/modules/transaction/domain/models/transaction.dart';
import 'package:budget_buddy/modules/transaction/domain/repositories/transaction_repository.dart';
import 'package:budget_buddy/modules/transaction/domain/services/transaction_balance_service.dart';

class ReconcileService {
  final CategoryRepository _categoryRepository;
  final TransactionRepository _transactionRepository;
  final TransactionBalanceService _balanceService;
  final MonthCycleService _monthCycleService;

  ReconcileService(
    this._categoryRepository,
    this._transactionRepository,
    this._balanceService,
    this._monthCycleService,
  );

  Future<List<Category>> categories() => _categoryRepository.getAll();

  Future<void> applySpending(Map<int, double> amounts) async {
    for (final entry in amounts.entries) {
      if (entry.value <= 0) continue;
      await _transactionRepository.add(Transaction(
        categoryId: entry.key,
        amount: entry.value,
        date: DateTime.now(),
        type: TransactionType.expense,
        note: 'Reconcile',
      ));
      await _balanceService.recomputeSpent(entry.key);
    }
  }

  Future<void> applyIncome(Map<int, double> amounts) async {
    for (final entry in amounts.entries) {
      if (entry.value <= 0) continue;
      await _transactionRepository.add(Transaction(
        categoryId: entry.key,
        amount: entry.value,
        date: DateTime.now(),
        type: TransactionType.income,
        note: 'Reconcile',
      ));
      await _balanceService.adjustAllocated(entry.key, entry.value);
    }
  }

  Future<void> freshStart(double actual) async {
    final cats = await _categoryRepository.getAll();
    final totalAllocated =
        cats.fold<double>(0.0, (sum, c) => sum + c.allocatedAmount);

    for (final c in cats) {
      if (c.id == null) continue;
      final newAllocated = totalAllocated > 0
          ? actual * (c.allocatedAmount / totalAllocated)
          : (cats.isEmpty ? 0.0 : actual / cats.length);
      await _categoryRepository.update(
        c.id!,
        c.copyWith(allocatedAmount: newAllocated),
      );
      await _categoryRepository.updateSpentAmount(c.id!, 0);
    }

    await _monthCycleService.markCycleStart(DateTime.now());
  }
}
