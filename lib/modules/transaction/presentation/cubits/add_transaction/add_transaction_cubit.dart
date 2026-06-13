import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/category/domain/repositories/category_repository.dart';
import 'package:budget_buddy/modules/subcategory/domain/default_subcategories.dart';
import 'package:budget_buddy/modules/subcategory/domain/models/subcategory.dart';
import 'package:budget_buddy/modules/subcategory/domain/repositories/subcategory_repository.dart';
import 'package:budget_buddy/modules/transaction/domain/models/transaction.dart';
import 'package:budget_buddy/modules/transaction/domain/repositories/transaction_repository.dart';
import 'package:budget_buddy/modules/transaction/presentation/cubits/add_transaction/add_transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTransactionCubit extends Cubit<AddTransactionState> {
  final CategoryRepository _categoryRepository;
  final SubcategoryRepository _subcategoryRepository;
  final TransactionRepository _transactionRepository;

  AddTransactionCubit(
    this._categoryRepository,
    this._subcategoryRepository,
    this._transactionRepository,
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

    emit(state.copyWith(categories: categories, subcategoriesMap: map));
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
      ));

  void updateOverflowSplit(int categoryId, double amount) {
    final updated = state.overflowSplits.map((s) {
      return s.category.id == categoryId ? s.withAmount(amount) : s;
    }).toList();
    emit(state.copyWith(overflowSplits: updated));
  }

  Future<void> submit() async {
    if (!state.canSubmit) return;

    final amount = state.parsedAmount;
    final category = state.selectedCategory!;

    if (state.transactionType == TransactionType.income) {
      await _persistIncome(category, amount);
      return;
    }

    final remaining = category.allocatedAmount - category.spentAmount;

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
    );
  }

  /// Income adds money to the picture: record it and grow the budget of the
  /// category the user chose (Saving counts as any other category).
  Future<void> _persistIncome(Category category, double amount) async {
    emit(state.copyWith(status: AddTransactionStatus.loading));
    try {
      await _transactionRepository.add(Transaction(
        categoryId: category.id!,
        subcategoryId: state.selectedSubcategory?.id,
        amount: amount,
        date: DateTime.now(),
        type: TransactionType.income,
        note: state.note.isEmpty ? null : state.note,
      ));

      await _categoryRepository.update(
        category.id!,
        category.copyWith(
          allocatedAmount: category.allocatedAmount + amount,
        ),
      );

      emit(state.copyWith(status: AddTransactionStatus.success));
    } catch (_) {
      emit(state.copyWith(status: AddTransactionStatus.error));
    }
  }

  Future<void> _persistTransaction(
    Category primary,
    double amount,
    List<OverflowSplit> splits,
  ) async {
    emit(state.copyWith(status: AddTransactionStatus.loading));
    try {
      await _transactionRepository.add(Transaction(
        categoryId: primary.id!,
        subcategoryId: state.selectedSubcategory?.id,
        amount: amount,
        date: DateTime.now(),
        type: state.transactionType,
        note: state.note.isEmpty ? null : state.note,
      ));

      final usedFromPrimary =
          amount.clamp(0.0, primary.allocatedAmount - primary.spentAmount);
      await _categoryRepository.updateSpentAmount(
        primary.id!,
        primary.spentAmount + usedFromPrimary,
      );

      for (final split in splits) {
        await _categoryRepository.updateSpentAmount(
          split.category.id!,
          split.category.spentAmount + split.amount,
        );
      }

      emit(state.copyWith(status: AddTransactionStatus.success));
    } catch (_) {
      emit(state.copyWith(status: AddTransactionStatus.error));
    }
  }
}
