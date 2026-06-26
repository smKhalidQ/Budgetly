import 'package:budget_buddy/core/services/month_cycle_service.dart';
import 'package:budget_buddy/modules/category/domain/repositories/category_repository.dart';
import 'package:budget_buddy/modules/transaction/domain/models/transaction.dart';
import 'package:budget_buddy/modules/transaction/domain/models/transaction_coverage.dart';
import 'package:budget_buddy/modules/transaction/domain/repositories/transaction_repository.dart';

/// Shared rules for keeping category balances in sync with transactions.
/// Spending is always re-derived from the expense transactions of the current
/// cycle (so add/edit/delete stay exact); income moves allocated by a delta.
class TransactionBalanceService {
  final CategoryRepository _categoryRepository;
  final TransactionRepository _transactionRepository;

  TransactionBalanceService(
    this._categoryRepository,
    this._transactionRepository,
  );

  Future<void> recomputeSpent(int categoryId) async {
    final transactions = await _transactionRepository.getAll();
    final cycleStart = MonthCycleService.currentCycleStart();
    var spent = 0.0;
    for (final t in transactions) {
      if (t.type != TransactionType.expense || t.categoryId != categoryId) {
        continue;
      }
      if (cycleStart != null && t.date.isBefore(cycleStart)) continue;
      spent += t.amount;
    }
    await _categoryRepository.updateSpentAmount(categoryId, spent);
  }

  Future<void> adjustAllocated(int categoryId, double delta) async {
    final categories = await _categoryRepository.getAll();
    final index = categories.indexWhere((c) => c.id == categoryId);
    if (index == -1) return;
    final category = categories[index];
    final next = category.allocatedAmount + delta;
    await _categoryRepository.update(
      categoryId,
      category.copyWith(allocatedAmount: next < 0 ? 0 : next),
    );
  }

  /// Undo a transaction's effect after its row has been removed. For an
  /// overflow expense this also gives every lender category its money back and
  /// strips the borrowed budget from the spending category.
  Future<void> reverseEffect(Transaction txn) async {
    if (txn.type == TransactionType.income) {
      await adjustAllocated(txn.categoryId, -txn.amount);
    } else if (txn.type == TransactionType.expense) {
      await reverseCoverage(txn);
      await recomputeSpent(txn.categoryId);
    }
  }

  /// Re-apply a transaction's effect after its row has been re-inserted.
  Future<void> applyEffect(Transaction txn) async {
    if (txn.type == TransactionType.income) {
      await adjustAllocated(txn.categoryId, txn.amount);
    } else if (txn.type == TransactionType.expense) {
      await applyCoverage(txn);
      await recomputeSpent(txn.categoryId);
    }
  }

  /// Returns the borrowed budget: lenders get their amounts back, and the
  /// spending category loses the coverage it received.
  Future<void> reverseCoverage(Transaction txn) async {
    final coverage = TransactionCoverage.parse(txn.coverage);
    if (coverage == null) return;
    for (final source in coverage.sources) {
      await adjustAllocated(source.categoryId, source.amount);
    }
    if (coverage.borrowed > 0) {
      await adjustAllocated(txn.categoryId, -coverage.borrowed);
    }
  }

  /// Re-takes the coverage: lenders lose their amounts again and the spending
  /// category regains the borrowed budget.
  Future<void> applyCoverage(Transaction txn) async {
    final coverage = TransactionCoverage.parse(txn.coverage);
    if (coverage == null) return;
    for (final source in coverage.sources) {
      await adjustAllocated(source.categoryId, -source.amount);
    }
    if (coverage.borrowed > 0) {
      await adjustAllocated(txn.categoryId, coverage.borrowed);
    }
  }

  /// Restores every category's allocatedAmount to what it was immediately after
  /// setup by reversing all income, rollover, and coverage effects.
  Future<void> resetAllocationsToSetup() async {
    final transactions = await _transactionRepository.getAll();
    final categories = await _categoryRepository.getAll();

    // Net amount that was ADDED to each category's allocatedAmount since setup.
    final netDelta = <int, double>{};

    for (final txn in transactions) {
      switch (txn.type) {
        case TransactionType.income:
        case TransactionType.rollover:
          netDelta[txn.categoryId] = (netDelta[txn.categoryId] ?? 0) + txn.amount;
        case TransactionType.expense:
          final coverage = TransactionCoverage.parse(txn.coverage);
          if (coverage == null) break;
          // Lenders had their allocated reduced — we'll add it back.
          for (final source in coverage.sources) {
            netDelta[source.categoryId] =
                (netDelta[source.categoryId] ?? 0) - source.amount;
          }
          // Primary gained total coverage (borrowed + income contribution).
          if (coverage.borrowed > 0) {
            netDelta[txn.categoryId] =
                (netDelta[txn.categoryId] ?? 0) + coverage.borrowed;
          }
      }
    }

    for (final category in categories) {
      if (category.id == null) continue;
      final delta = netDelta[category.id!] ?? 0.0;
      if (delta == 0) continue;
      final original = (category.allocatedAmount - delta).clamp(0.0, double.infinity);
      await _categoryRepository.update(
        category.id!,
        category.copyWith(allocatedAmount: original),
      );
    }
  }
}
