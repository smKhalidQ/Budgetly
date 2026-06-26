import 'package:budget_buddy/core/utilities/cache_helper.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/category/domain/repositories/category_repository.dart';
import 'package:budget_buddy/modules/recurring/domain/repositories/recurring_expense_repository.dart';
import 'package:budget_buddy/modules/transaction/domain/models/transaction.dart';
import 'package:budget_buddy/modules/transaction/domain/repositories/transaction_repository.dart';

/// Outcome of starting a new month — surfaced to the user as a summary.
class CycleSummary {
  final double savedToSaving;
  final int recurringPosted;
  final int recurringFlagged;

  const CycleSummary({
    required this.savedToSaving,
    required this.recurringPosted,
    required this.recurringFlagged,
  });
}

/// Owns the monthly budget cycle. The cycle is advanced **manually** by the
/// user (via Settings) when their salary arrives — salaries don't always land
/// on the 1st, so the calendar can't be trusted to decide.
///
/// Starting a new month, in order:
///   1. sweep every spending category's leftover (allocated − spent) into Saving
///   2. reset spend counters to zero (the allocation plan carries over)
///   3. post the active fixed expenses against their fresh envelopes
///
/// The sweep is recorded as one income transaction on Saving so it shows in the
/// history. [currentCycleStart] anchors the active cycle and scopes the
/// per-cycle spending shown on the category detail screen.
class MonthCycleService {
  final CategoryRepository _categoryRepository;
  final TransactionRepository _transactionRepository;
  final RecurringExpenseRepository _recurringRepository;

  MonthCycleService(
    this._categoryRepository,
    this._transactionRepository,
    this._recurringRepository,
  );

  static const _cycleStartKey = 'cycle_start';

  static const _savingName = 'Saving';

  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  /// First day of the currently active cycle, or null before the user has ever
  /// started a month. Read synchronously from cache (SharedPreferences is
  /// already loaded at startup).
  static DateTime? currentCycleStart() {
    final raw = CacheHelper.getData(key: _cycleStartKey) as String?;
    return raw == null ? null : DateTime.tryParse(raw);
  }

  Future<void> markCycleStart(DateTime when) => CacheHelper.saveData(
        key: _cycleStartKey,
        value: when.toIso8601String(),
      );

  /// Closes the current month and opens a fresh one. Safe to call any time the
  /// user's income lands.
  Future<CycleSummary> startNewCycle() async {
    final endedCycleStart = currentCycleStart() ?? DateTime.now();
    final categories = await _categoryRepository.getAll();

    final saved = await _sweepLeftoverToSaving(categories, endedCycleStart);
    final (posted, flagged) = await _postRecurringExpenses();

    await _setCycleStart(DateTime.now());

    return CycleSummary(
      savedToSaving: saved,
      recurringPosted: posted,
      recurringFlagged: flagged,
    );
  }

  /// Returns the leftover amount swept into Saving (0 if none).
  Future<double> _sweepLeftoverToSaving(
    List<Category> categories,
    DateTime endedCycleStart,
  ) async {
    var leftover = 0.0;
    for (final category in categories) {
      if (category.name == _savingName) continue;
      final remaining = category.allocatedAmount - category.spentAmount;
      if (remaining > 0) leftover += remaining;
    }

    // Fresh month: spend resets to zero, the allocation plan stays.
    for (final category in categories) {
      if (category.id == null || category.name == _savingName) continue;
      if (category.spentAmount != 0) {
        await _categoryRepository.updateSpentAmount(category.id!, 0);
      }
    }

    if (leftover <= 0) return 0;

    final savingIndex = categories.indexWhere((c) => c.name == _savingName);
    if (savingIndex == -1 || categories[savingIndex].id == null) return 0;
    final saving = categories[savingIndex];

    await _transactionRepository.add(Transaction(
      categoryId: saving.id!,
      amount: leftover,
      date: DateTime.now(),
      type: TransactionType.rollover,
      note: 'Month-end savings · ${_monthLabel(endedCycleStart)}',
    ));
    await _categoryRepository.update(
      saving.id!,
      saving.copyWith(allocatedAmount: saving.allocatedAmount + leftover),
    );
    return leftover;
  }

  /// Posts each active fixed expense against its (freshly reset) envelope.
  /// Returns (posted count, flagged count) where flagged means the envelope
  /// couldn't fully cover the bill — we never push a category below zero.
  Future<(int, int)> _postRecurringExpenses() async {
    final recurrings = await _recurringRepository.getAll();
    final actives = recurrings.where((r) => r.isActive).toList();
    if (actives.isEmpty) return (0, 0);

    final fresh = await _categoryRepository.getAll();
    final allocatedById = {
      for (final c in fresh)
        if (c.id != null) c.id!: c.allocatedAmount,
    };

    final runningSpent = <int, double>{};
    var posted = 0;
    var flagged = 0;

    for (final r in actives) {
      final allocated = allocatedById[r.categoryId];
      if (allocated == null) continue; // category was deleted

      final already = runningSpent[r.categoryId] ?? 0;
      final available = allocated - already;
      if (available <= 0) {
        flagged++;
        continue;
      }

      final post = r.amount <= available ? r.amount : available;
      await _transactionRepository.add(Transaction(
        categoryId: r.categoryId,
        subcategoryId: r.subcategoryId,
        amount: post,
        date: DateTime.now(),
        type: TransactionType.expense,
        note: r.note,
      ));
      runningSpent[r.categoryId] = already + post;
      posted++;
      if (post < r.amount) flagged++;
    }

    for (final entry in runningSpent.entries) {
      await _categoryRepository.updateSpentAmount(entry.key, entry.value);
    }

    return (posted, flagged);
  }

  Future<void> _setCycleStart(DateTime month) => CacheHelper.saveData(
        key: _cycleStartKey,
        value: DateTime(month.year, month.month).toIso8601String(),
      );

  String _monthLabel(DateTime date) =>
      '${_monthNames[date.month - 1]} ${date.year}';
}
