import 'package:budget_buddy/core/utilities/listener_mixin.dart';
import 'package:budget_buddy/modules/category/domain/repositories/category_repository.dart';
import 'package:budget_buddy/modules/subcategory/domain/repositories/subcategory_repository.dart';
import 'package:budget_buddy/modules/transaction/domain/models/transaction.dart';
import 'package:budget_buddy/modules/transaction/domain/models/transaction_coverage.dart';
import 'package:budget_buddy/modules/transaction/domain/repositories/transaction_repository.dart';
import 'package:budget_buddy/modules/transaction/domain/services/transaction_balance_service.dart';
import 'package:budget_buddy/modules/transaction/presentation/cubits/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionCubit extends Cubit<TransactionState> with StreamListener {
  final TransactionRepository _repository;
  final CategoryRepository _categoryRepository;
  final SubcategoryRepository _subcategoryRepository;
  final TransactionBalanceService _balanceService;

  TransactionCubit(
    this._repository,
    this._categoryRepository,
    this._subcategoryRepository,
    this._balanceService,
  ) : super(const TransactionState());

  static TransactionCubit get(context) => BlocProvider.of(context);

  void initialize() {
    listen(_repository.onTransactionAdded, (_) => _load());
    listen(_repository.onTransactionChanged, (_) => _load());
    listen(_categoryRepository.onCategoryChanged, (_) => _load());
    _load();
  }

  Future<void> _load() async {
    emit(state.copyWith(status: TransactionStatus.loading));
    try {
      final transactions = await _repository.getAll();
      final categories = await _categoryRepository.getAll();
      final subcategories = await _subcategoryRepository.getAll();

      emit(state.copyWith(
        status: TransactionStatus.success,
        transactions: transactions,
        categoriesById: {
          for (final c in categories)
            if (c.id != null) c.id!: c,
        },
        subcategoriesById: {
          for (final s in subcategories)
            if (s.id != null) s.id!: s,
        },
      ));
    } catch (_) {
      emit(state.copyWith(
        status: TransactionStatus.error,
        errorMessage: 'Failed to load transactions.',
      ));
    }
  }

  void toggleEditMode() => emit(state.copyWith(isEditMode: !state.isEditMode));

  Future<void> deleteTransaction(Transaction txn) async {
    if (txn.id == null) return;
    await _repository.delete(txn.id!);
    await _balanceService.reverseEffect(txn);
  }

  Future<void> restoreTransaction(Transaction txn) async {
    await _repository.add(txn.copyWith(id: null));
    await _balanceService.applyEffect(txn);
  }

  /// Edits an expense inline: reverses the old coverage back to baseline, then
  /// re-records the new amount with the new lender distribution ([sources] maps
  /// categoryId → amount taken). The income part of any old coverage is dropped.
  Future<void> editExpenseCoverage(
    Transaction txn,
    double newAmount,
    Map<int, double> sources,
    double income,
  ) async {
    await _balanceService.reverseCoverage(txn);

    final newSources = [
      for (final entry in sources.entries)
        if (entry.value > 0)
          CoverageSource(categoryId: entry.key, amount: entry.value),
    ];
    final coverage = newSources.isEmpty && income <= 0
        ? ''
        : TransactionCoverage(income: income, sources: newSources).encode();
    final updated = txn.copyWith(amount: newAmount, coverage: coverage);

    await _repository.edit(updated);
    await _balanceService.applyCoverage(updated);
    await _balanceService.recomputeSpent(txn.categoryId);
  }

  /// Edits an income amount inline: adjusts the category's allocated by the
  /// difference.
  Future<void> editIncomeAmount(Transaction txn, double newAmount) async {
    final delta = newAmount - txn.amount;
    await _repository.edit(txn.copyWith(amount: newAmount));
    await _balanceService.adjustAllocated(txn.categoryId, delta);
  }
}
