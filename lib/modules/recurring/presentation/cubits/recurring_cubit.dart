import 'package:budget_buddy/modules/category/domain/repositories/category_repository.dart';
import 'package:budget_buddy/modules/recurring/domain/models/recurring_expense.dart';
import 'package:budget_buddy/modules/recurring/domain/repositories/recurring_expense_repository.dart';
import 'package:budget_buddy/modules/recurring/presentation/cubits/recurring_state.dart';
import 'package:budget_buddy/modules/subcategory/domain/repositories/subcategory_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecurringCubit extends Cubit<RecurringState> {
  final RecurringExpenseRepository _repository;
  final CategoryRepository _categoryRepository;
  final SubcategoryRepository _subcategoryRepository;

  RecurringCubit(
    this._repository,
    this._categoryRepository,
    this._subcategoryRepository,
  ) : super(const RecurringState());

  Future<void> initialize() async {
    emit(state.copyWith(status: RecurringStatus.loading));
    try {
      final items = await _repository.getAll();
      final categories = await _categoryRepository.getAll();
      final subcategories = await _subcategoryRepository.getAll();
      emit(state.copyWith(
        status: RecurringStatus.success,
        items: items,
        categories: categories,
        subcategories: subcategories,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: RecurringStatus.error,
        errorMessage: 'Failed to load fixed expenses.',
      ));
    }
  }

  Future<void> addExpense(RecurringExpense item) async {
    await _repository.insert(item);
    await _reload();
  }

  Future<void> updateExpense(int id, RecurringExpense item) async {
    await _repository.update(id, item);
    await _reload();
  }

  Future<void> removeExpense(int id) async {
    final remaining = state.items.where((i) => i.id != id).toList();
    emit(state.copyWith(items: remaining));
    try {
      await _repository.delete(id);
    } catch (_) {
      await _reload();
    }
  }

  Future<void> toggleActive(RecurringExpense item) async {
    if (item.id == null) return;
    await _repository.update(item.id!, item.copyWith(isActive: !item.isActive));
    await _reload();
  }

  Future<void> _reload() async {
    final items = await _repository.getAll();
    emit(state.copyWith(items: items));
  }
}
