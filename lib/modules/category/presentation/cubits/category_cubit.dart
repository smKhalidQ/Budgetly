import 'package:budget_buddy/core/utilities/cache_helper.dart';
import 'package:budget_buddy/core/utilities/listener_mixin.dart';
import 'package:budget_buddy/modules/category/domain/default_categories.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/category/domain/repositories/category_repository.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCubit extends Cubit<CategoryState> with StreamListener {
  final CategoryRepository _repository;

  CategoryCubit(this._repository) : super(const CategoryState());

  static CategoryCubit get(BuildContext context) => BlocProvider.of(context);

  List<Category> _sortWithSavingLast(List<Category> list) {
    final savingIndex = list.indexWhere((c) => c.name == 'Saving');
    if (savingIndex == -1 || savingIndex == list.length - 1) return list;
    final sorted = List<Category>.from(list)
      ..removeAt(savingIndex)
      ..add(list[savingIndex]);
    return sorted;
  }

  Future<void> fetchCategories() async {
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      List<Category> categories = await _repository.getAll();
      if (categories.isEmpty) {
        await _repository.initializeAll(defaultCategories);
        categories = await _repository.getAll();
      }
      emit(state.copyWith(
        status: CategoryStatus.success,
        categories: _sortWithSavingLast(categories),
      ));
    } catch (_) {
      emit(state.copyWith(
        status: CategoryStatus.error,
        errorMessage: 'Failed to load categories.',
      ));
    }
  }

  Future<void> insertNewCategory(Category item) async {
    final tempId = DateTime.now().millisecondsSinceEpoch;
    final tempCategory = item.copyWith(id: tempId);
    emit(state.copyWith(
      categories: _sortWithSavingLast([...state.categories, tempCategory]),
    ));
    try {
      await _repository.insert(item);
      await fetchCategories();
    } catch (_) {
      final rolledBack = state.categories.where((c) => c.id != tempId).toList();
      emit(state.copyWith(categories: rolledBack));
    }
  }

  Future<void> removeCategory(int id) async {
    final index = state.categories.indexWhere((c) => c.id == id);
    final removed = index != -1 ? state.categories[index] : null;
    if (index != -1) {
      final updated = List<Category>.from(state.categories)..removeAt(index);
      emit(state.copyWith(categories: updated));
    }
    try {
      await _repository.delete(id);
    } catch (_) {
      if (removed != null && index != -1) {
        final restored = List<Category>.from(state.categories)
          ..insert(index, removed);
        emit(state.copyWith(categories: restored));
      }
    }
  }

  Future<void> updateCategoryData(int id, Category item) async {
    final index = state.categories.indexWhere((c) => c.id == id);
    final old = index != -1 ? state.categories[index] : null;
    if (index != -1) {
      final updated = List<Category>.from(state.categories)..[index] = item;
      emit(state.copyWith(categories: _sortWithSavingLast(updated)));
    }
    try {
      await _repository.update(id, item);
    } catch (_) {
      if (old != null && index != -1) {
        final restored = List<Category>.from(state.categories)..[index] = old;
        emit(state.copyWith(categories: _sortWithSavingLast(restored)));
      }
    }
  }

  void updateCategoryIcon(String icon) => emit(state.copyWith(selectedIcon: icon));

  void updateCategoryColor(Color color) => emit(state.copyWith(
      selectedColor:
          '0x${color.toARGB32().toRadixString(16).padLeft(8, '0')}'));

  void addNewSettingUpCategory(Category category) {
    emit(state.copyWith(
      categories: _sortWithSavingLast([...state.categories, category]),
    ));
  }

  void saveUpdatedCategory(String nameController, Category item, String budgetController) {
    final updatedName = nameController.isEmpty ? item.name : nameController;
    final updatedAmount = budgetController.isEmpty
        ? item.allocatedAmount
        : double.tryParse(budgetController) ?? item.allocatedAmount;
    final updatedItem = Category(
      id: item.id,
      name: updatedName,
      allocatedAmount: updatedAmount,
      baseAllocation: updatedAmount,
      color: state.selectedColor,
      icon: state.selectedIcon.isEmpty ? item.icon : state.selectedIcon,
      spentAmount: item.spentAmount,
    );
    updateCategoryData(item.id!, updatedItem);
  }

  List<Category> _withBaseFromAllocated(List<Category> list) => list
      .map((c) => c.copyWith(baseAllocation: c.allocatedAmount))
      .toList();

  void updateLocalCategory(int id, Category updated) {
    final index = state.categories.indexWhere((c) => c.id == id);
    if (index == -1) return;
    final list = List<Category>.from(state.categories)..[index] = updated;
    emit(state.copyWith(categories: _sortWithSavingLast(list)));
  }

  void setRemainingBudget(int value) => emit(state.copyWith(remainingBudget: value));

  // --- Onboarding allocation methods ---

  /// Updates the allocation for [listIndex] to [newAllocation].
  /// Returns false if remaining budget would go negative (show alert dialog).
  bool updateAllocation(int listIndex, int newAllocation, Category category) {
    final current = state.allocations[listIndex] ?? 0;
    final delta = newAllocation - current;
    if (state.remainingBudget - delta < 0) return false;

    final updatedAllocations =
        Map<int, int>.from(state.allocations)..[listIndex] = newAllocation;
    final catIdx = state.categories.indexWhere((c) => c.id == category.id);
    final updatedCategories = catIdx == -1
        ? state.categories
        : (List<Category>.from(state.categories)
          ..[catIdx] = category.copyWith(allocatedAmount: newAllocation.toDouble()));

    emit(state.copyWith(
      allocations: updatedAllocations,
      remainingBudget: state.remainingBudget - delta,
      categories: updatedCategories,
    ));
    return true;
  }

  /// Clears the allocation for [listIndex] back to 0.
  void clearAllocation(int listIndex) {
    final current = state.allocations[listIndex] ?? 0;
    if (current == 0) return;
    final updatedAllocations =
        Map<int, int>.from(state.allocations)..[listIndex] = 0;
    final updatedCategories = listIndex < state.categories.length
        ? (List<Category>.from(state.categories)
          ..[listIndex] =
              state.categories[listIndex].copyWith(allocatedAmount: 0))
        : state.categories;
    emit(state.copyWith(
      allocations: updatedAllocations,
      remainingBudget: state.remainingBudget + current,
      categories: updatedCategories,
    ));
  }

  /// Sets the allocation for [listIndex] to [maxAvailable].
  void setAllocationToMax(int listIndex, int maxAvailable) {
    final current = state.allocations[listIndex] ?? 0;
    final updatedAllocations =
        Map<int, int>.from(state.allocations)..[listIndex] = maxAvailable;
    final updatedCategories = listIndex < state.categories.length
        ? (List<Category>.from(state.categories)
          ..[listIndex] = state.categories[listIndex]
              .copyWith(allocatedAmount: maxAvailable.toDouble()))
        : state.categories;
    emit(state.copyWith(
      allocations: updatedAllocations,
      remainingBudget: state.remainingBudget + current - maxAvailable,
      categories: updatedCategories,
    ));
  }

  /// Completes the setup flow. Returns false if budget is not fully allocated.
  Future<bool> completeSetup() async {
    if (state.remainingBudget > 0) return false;
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      await _repository.initializeAll(_withBaseFromAllocated(state.categories));
      await CacheHelper.saveData(key: 'setup_done', value: true);
      emit(state.copyWith(status: CategoryStatus.success));
      return true;
    } catch (_) {
      emit(state.copyWith(
        status: CategoryStatus.error,
        errorMessage: 'Failed to initialize categories.',
      ));
      return false;
    }
  }

  /// Allocates remaining budget to the Saving category, then completes setup.
  Future<void> allocateRemainingToSavings() async {
    final savingIdx = state.categories.indexWhere((c) => c.name == 'Saving');
    if (savingIdx != -1 && state.remainingBudget > 0) {
      final remaining = state.remainingBudget;
      final saving = state.categories[savingIdx];
      final updatedAllocations = Map<int, int>.from(state.allocations)
        ..[savingIdx] = (state.allocations[savingIdx] ?? 0) + remaining;
      final updatedCategories = List<Category>.from(state.categories)
        ..[savingIdx] = saving.copyWith(
          allocatedAmount: saving.allocatedAmount + remaining.toDouble(),
        );
      emit(state.copyWith(
        allocations: updatedAllocations,
        remainingBudget: 0,
        categories: updatedCategories,
      ));
    }
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      await _repository.initializeAll(_withBaseFromAllocated(state.categories));
      await CacheHelper.saveData(key: 'setup_done', value: true);
      emit(state.copyWith(status: CategoryStatus.success));
    } catch (_) {
      emit(state.copyWith(
        status: CategoryStatus.error,
        errorMessage: 'Failed to initialize categories.',
      ));
    }
  }
}
