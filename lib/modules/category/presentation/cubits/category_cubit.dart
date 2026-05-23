import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/core/utilities/listener_mixin.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/category/domain/repositories/category_repository.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCubit extends Cubit<CategoryState> with StreamListener {
  final CategoryRepository _repository;

  final Map<int, int> _allocatedBudgetMap = {};
  int _totalAllocatedBudgetBasedOnMap = 0;

  CategoryCubit(this._repository) : super(const CategoryState());

  static CategoryCubit get(context) => BlocProvider.of(context);

  Color get categoryColor => parseColorFromString(state.selectedColor);
  String get categoryIcon => state.selectedIcon.isEmpty
      ? Icons.category.codePoint.toString()
      : state.selectedIcon;
  int get totalAllocatedBudgetBasedOnMap => _totalAllocatedBudgetBasedOnMap;
  Map<int, int> get allocatedBudgetMap => _allocatedBudgetMap;

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
      final categories = await _repository.getAll();
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

  void updateCategoryColor(Color color) =>
      emit(state.copyWith(selectedColor: color.toString()));

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
      color: state.selectedColor,
      icon: state.selectedIcon.isEmpty ? item.icon : state.selectedIcon,
      spentAmount: item.spentAmount,
    );
    updateCategoryData(item.id!, updatedItem);
  }

  Future<void> initializeCategoriesStage(List<Category> categories) async {
    emit(state.copyWith(status: CategoryStatus.loading));
    try {
      await _repository.initializeAll(categories);
      emit(state.copyWith(status: CategoryStatus.success));
      fetchCategories();
    } catch (_) {
      emit(state.copyWith(
        status: CategoryStatus.error,
        errorMessage: 'Failed to initialize categories.',
      ));
    }
  }

  void updateLocalCategory(int id, Category updated) {
    final index = state.categories.indexWhere((c) => c.id == id);
    if (index == -1) return;
    final list = List<Category>.from(state.categories)..[index] = updated;
    emit(state.copyWith(categories: _sortWithSavingLast(list)));
  }

  void setRemainingBudget(int value) => emit(state.copyWith(remainingBudget: value));

  void updateRemainingBudgetForProgressBarInSettingUpstage(int difference) {
    emit(state.copyWith(remainingBudget: state.remainingBudget + difference));
  }

  void updateCategoryAllocationAndTotalBudgetInSettingUpstage(int index, int value) {
    _allocatedBudgetMap[index] = (_allocatedBudgetMap[index] ?? 0) + value;
    _totalAllocatedBudgetBasedOnMap = 0;
    _allocatedBudgetMap.forEach((key, val) {
      if (key != index) _totalAllocatedBudgetBasedOnMap += val;
    });
  }
}
