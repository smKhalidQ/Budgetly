import 'dart:convert';

import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/category/domain/repositories/category_repository.dart';
import 'package:budget_buddy/modules/subcategory/domain/default_subcategories.dart';
import 'package:budget_buddy/modules/subcategory/domain/models/subcategory.dart';
import 'package:budget_buddy/modules/subcategory/domain/repositories/subcategory_repository.dart';
import 'package:budget_buddy/modules/transaction/domain/models/transaction.dart';
import 'package:budget_buddy/modules/transaction/domain/repositories/transaction_repository.dart';
import 'package:budget_buddy/modules/transaction/domain/services/transaction_balance_service.dart';
import 'package:budget_buddy/modules/transaction/presentation/cubits/add_transaction/add_transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTransactionCubit extends Cubit<AddTransactionState> {
  final CategoryRepository _categoryRepository;
  final SubcategoryRepository _subcategoryRepository;
  final TransactionRepository _transactionRepository;
  final TransactionBalanceService _balanceService;

  AddTransactionCubit(
    this._categoryRepository,
    this._subcategoryRepository,
    this._transactionRepository,
    this._balanceService,
  ) : super(const AddTransactionState());

  Future<void> initialize() async {
    final categories = await _categoryRepository.getAll();
    var subcategories = await _subcategoryRepository.getAll();

    // Default subcategories are otherwise seeded lazily (only when a category's
    // detail screen is opened), so the picker would be empty for categories the
    // user never visited. Seed any missing defaults once, here.
    if (await _ensureDefaultSubcategories(categories, subcategories)) {
      subcategories = await _subcategoryRepository.getAll();
    }

    final map = <int, List<Subcategory>>{};
    for (final sub in subcategories) {
      if (sub.parentCategoryId != null) {
        map.putIfAbsent(sub.parentCategoryId!, () => []).add(sub);
      }
    }

    emit(state.copyWith(
      categories: categories,
      subcategoriesMap: map,
      topSubcategories: await _mostUsedSubcategories(subcategories),
    ));
  }

  Future<void> initializeForEdit(Transaction txn) async {
    final categories = await _categoryRepository.getAll();
    var subcategories = await _subcategoryRepository.getAll();
    if (await _ensureDefaultSubcategories(categories, subcategories)) {
      subcategories = await _subcategoryRepository.getAll();
    }

    final map = <int, List<Subcategory>>{};
    for (final sub in subcategories) {
      if (sub.parentCategoryId != null) {
        map.putIfAbsent(sub.parentCategoryId!, () => []).add(sub);
      }
    }

    final catIndex = categories.indexWhere((c) => c.id == txn.categoryId);
    final category = catIndex == -1 ? null : categories[catIndex];
    Subcategory? subcategory;
    if (txn.subcategoryId != null) {
      final subs = map[txn.categoryId] ?? [];
      final subIndex = subs.indexWhere((s) => s.id == txn.subcategoryId);
      if (subIndex != -1) subcategory = subs[subIndex];
    }

    emit(state.copyWith(
      categories: categories,
      subcategoriesMap: map,
      topSubcategories: await _mostUsedSubcategories(subcategories),
      transactionType: txn.type,
      selectedCategory: category,
      selectedSubcategory: subcategory,
      expandedCategoryId: txn.categoryId,
      amountInput: _formatAmount(txn.amount),
      note: txn.note ?? '',
      editingTransaction: txn,
    ));
  }

  String _formatAmount(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);

  Future<List<Subcategory>> _mostUsedSubcategories(
    List<Subcategory> subcategories,
  ) async {
    final transactions = await _transactionRepository.getAll();
    final usage = <int, int>{};
    for (final t in transactions) {
      if (t.type == TransactionType.expense && t.subcategoryId != null) {
        usage[t.subcategoryId!] = (usage[t.subcategoryId!] ?? 0) + 1;
      }
    }

    final subById = {
      for (final s in subcategories)
        if (s.id != null) s.id!: s,
    };

    final ranked = usage.entries
        .where((e) => subById.containsKey(e.key))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return ranked.take(10).map((e) => subById[e.key]!).toList();
  }

  void selectFromTop(Subcategory subcategory) {
    final parentId = subcategory.parentCategoryId;
    if (parentId == null) return;
    final index = state.categories.indexWhere((c) => c.id == parentId);
    if (index == -1) return;
    emit(state.copyWith(
      selectedCategory: state.categories[index],
      selectedSubcategory: subcategory,
      expandedCategoryId: parentId,
      amountInput: '',
    ));
  }

  /// Seeds default subcategories for any default category that has none yet.
  /// Returns true if anything was inserted (so callers can reload).
  Future<bool> _ensureDefaultSubcategories(
    List<Category> categories,
    List<Subcategory> existing,
  ) async {
    final parentsWithSubs =
        existing.map((s) => s.parentCategoryId).whereType<int>().toSet();

    var seeded = false;
    for (final category in categories) {
      if (category.id == null || parentsWithSubs.contains(category.id)) continue;
      for (final sub in getDefaultSubcategories(category)) {
        await _subcategoryRepository
            .insert(sub.copyWith(parentCategoryId: category.id));
        seeded = true;
      }
    }
    return seeded;
  }

  void setType(TransactionType type) => emit(state.copyWith(transactionType: type));

  /// Opening a category also selects it (so the submit action is enabled) and
  /// starts a fresh amount.
  void selectCategory(Category category) => emit(state.copyWith(
        selectedCategory: category,
        selectedSubcategory: null,
        expandedCategoryId: category.id,
        amountInput: '',
      ));

  /// Collapses the open category and clears the in-progress entry — closing the
  /// numpad resets the amount back to zero.
  void collapse() => emit(state.copyWith(
        expandedCategoryId: null,
        selectedCategory: null,
        selectedSubcategory: null,
        amountInput: '',
      ));

  void selectSubcategory(Subcategory? subcategory) =>
      emit(state.copyWith(selectedSubcategory: subcategory));

  void appendDigit(String digit) {
    final current = state.amountInput;
    if (current.contains('.') && current.split('.')[1].length >= 2) return;
    if (current == '0' && digit != '.') {
      emit(state.copyWith(amountInput: digit));
      return;
    }
    emit(state.copyWith(amountInput: current + digit));
  }

  void appendDecimal() {
    if (state.amountInput.contains('.')) return;
    final base = state.amountInput.isEmpty ? '0' : state.amountInput;
    emit(state.copyWith(amountInput: '$base.'));
  }

  void removeDigit() {
    final current = state.amountInput;
    if (current.isEmpty) return;
    emit(state.copyWith(
      amountInput: current.length == 1 ? '' : current.substring(0, current.length - 1),
    ));
  }

  void updateNote(String note) => emit(state.copyWith(note: note));

  void clearOverflow() => emit(state.copyWith(
        overflowDeficit: null,
        overflowSplits: [],
        overflowIncome: 0.0,
      ));

  void updateOverflowSplit(int categoryId, double amount) {
    final updated = state.overflowSplits.map((s) {
      return s.category.id == categoryId ? s.withAmount(amount) : s;
    }).toList();
    emit(state.copyWith(overflowSplits: updated));
  }

  void updateOverflowIncome(double amount) {
    final deficit = state.overflowDeficit;
    if (deficit == null) return;
    final fromSplits =
        state.overflowSplits.fold(0.0, (sum, s) => sum + s.amount);
    final maxIncome = (deficit - fromSplits).clamp(0.0, deficit);
    emit(state.copyWith(overflowIncome: amount.clamp(0.0, maxIncome)));
  }

  Future<void> submit() async {
    if (!state.canSubmit) return;

    final amount = state.parsedAmount;
    final category = state.selectedCategory!;

    if (state.transactionType == TransactionType.income) {
      await _persistIncome(category, amount);
      return;
    }

    var remaining = category.allocatedAmount - category.spentAmount;
    final editing = state.editingTransaction;
    if (editing != null &&
        editing.type == TransactionType.expense &&
        editing.categoryId == category.id) {
      remaining += editing.amount;
    }

    if (amount > remaining) {
      final deficit = amount - remaining;
      final sources = state.categories
          .where((c) => c.id != category.id)
          .where((c) => (c.allocatedAmount - c.spentAmount) > 0)
          .map((c) => OverflowSplit(
                category: c,
                available: c.allocatedAmount - c.spentAmount,
              ))
          .toList();
      emit(state.copyWith(overflowDeficit: deficit, overflowSplits: sources));
      return;
    }

    await _persistTransaction(category, amount, []);
  }

  Future<void> confirmOverflow() async {
    if (!state.overflowFullyCovered || state.selectedCategory == null) return;
    await _persistTransaction(
      state.selectedCategory!,
      state.parsedAmount,
      state.overflowSplits.where((s) => s.amount > 0).toList(),
      incomeContribution: state.overflowIncome,
    );
  }

  /// Income adds money to the picture: record it and grow the budget of the
  /// category the user chose (Saving counts as any other category).
  Future<void> _persistIncome(Category category, double amount) async {
    emit(state.copyWith(status: AddTransactionStatus.loading));
    try {
      final editing = state.editingTransaction;
      final txn = Transaction(
        id: editing?.id,
        categoryId: category.id!,
        subcategoryId: state.selectedSubcategory?.id,
        amount: amount,
        date: editing?.date ?? DateTime.now(),
        type: TransactionType.income,
        note: state.note.isEmpty ? null : state.note,
      );

      if (editing == null) {
        await _transactionRepository.add(txn);
      } else {
        await _transactionRepository.edit(txn);
        await _reverseOriginal(editing);
        await _balanceService.recomputeSpent(editing.categoryId);
      }

      await _balanceService.adjustAllocated(category.id!, amount);

      emit(state.copyWith(status: AddTransactionStatus.success));
    } catch (_) {
      emit(state.copyWith(status: AddTransactionStatus.error));
    }
  }

  Future<void> _persistTransaction(
    Category primary,
    double amount,
    List<OverflowSplit> splits, {
    double incomeContribution = 0.0,
  }) async {
    emit(state.copyWith(status: AddTransactionStatus.loading));
    try {
      final editing = state.editingTransaction;
      final txn = Transaction(
        id: editing?.id,
        categoryId: primary.id!,
        subcategoryId: state.selectedSubcategory?.id,
        amount: amount,
        date: editing?.date ?? DateTime.now(),
        type: state.transactionType,
        note: state.note.isEmpty ? null : state.note,
        coverage: _buildCoverage(splits, incomeContribution),
      );

      if (editing == null) {
        await _transactionRepository.add(txn);
      } else {
        await _transactionRepository.edit(txn);
        await _reverseOriginal(editing);
      }

      final transferred =
          splits.fold(0.0, (sum, split) => sum + split.amount);
      final primaryIncrease = transferred + incomeContribution;

      if (primaryIncrease > 0) {
        for (final split in splits) {
          if (split.amount <= 0) continue;
          await _balanceService.adjustAllocated(split.category.id!, -split.amount);
        }
        await _balanceService.adjustAllocated(primary.id!, primaryIncrease);
      }

      await _balanceService.recomputeSpent(primary.id!);
      if (editing != null && editing.categoryId != primary.id) {
        await _balanceService.recomputeSpent(editing.categoryId);
      }

      emit(state.copyWith(status: AddTransactionStatus.success));
    } catch (_) {
      emit(state.copyWith(status: AddTransactionStatus.error));
    }
  }

  Future<void> _reverseOriginal(Transaction original) async {
    if (original.type == TransactionType.income) {
      await _balanceService.adjustAllocated(original.categoryId, -original.amount);
    }
  }

  String? _buildCoverage(List<OverflowSplit> splits, double income) {
    final positive = splits.where((s) => s.amount > 0).toList();
    if (positive.isEmpty && income <= 0) return null;
    return jsonEncode({
      'income': income,
      'splits': [
        for (final s in positive) {'c': s.category.id, 'a': s.amount},
      ],
    });
  }
}
