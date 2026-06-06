import 'package:budget_buddy/core/utilities/listener_mixin.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/subcategory/domain/default_subcategories.dart';
import 'package:budget_buddy/modules/subcategory/domain/models/subcategory.dart';
import 'package:budget_buddy/modules/subcategory/domain/repositories/subcategory_repository.dart';
import 'package:budget_buddy/modules/subcategory/presentation/cubits/subcategory_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubcategoryCubit extends Cubit<SubcategoryState> with StreamListener {
  final SubcategoryRepository _repository;

  SubcategoryCubit(this._repository) : super(const SubcategoryState());

  static SubcategoryCubit get(context) => BlocProvider.of(context);

  void updateSubcategoryIcon(String icon) =>
      emit(state.copyWith(selectedIcon: icon));

  Future<void> fetchSubcategories() async {
    emit(state.copyWith(status: SubcategoryStatus.loading));
    try {
      final subcategories = await _repository.getAll();
      emit(state.copyWith(
        status: SubcategoryStatus.success,
        subcategories: subcategories,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: SubcategoryStatus.error,
        errorMessage: 'Failed to load subcategories.',
      ));
    }
  }

  Future<void> insertNewSubcategory(Subcategory item) async {
    emit(state.copyWith(subcategories: [...state.subcategories, item]));
    try {
      await _repository.insert(item);
      fetchSubcategories();
    } catch (_) {
      final rolledBack = state.subcategories.where((s) => s != item).toList();
      emit(state.copyWith(subcategories: rolledBack));
    }
  }

  Future<void> removeSubcategory(int id) async {
    final index = state.subcategories.indexWhere((s) => s.id == id);
    final removed = index != -1 ? state.subcategories[index] : null;
    if (index != -1) {
      final updated = List<Subcategory>.from(state.subcategories)..removeAt(index);
      emit(state.copyWith(subcategories: updated));
    }
    try {
      await _repository.delete(id);
    } catch (_) {
      if (removed != null && index != -1) {
        final restored = List<Subcategory>.from(state.subcategories)
          ..insert(index, removed);
        emit(state.copyWith(subcategories: restored));
      }
    }
  }

  Future<void> updateSubcategoryData(int id, Subcategory item) async {
    final index = state.subcategories.indexWhere((s) => s.id == id);
    final old = index != -1 ? state.subcategories[index] : null;
    if (index != -1) {
      final updated = List<Subcategory>.from(state.subcategories)..[index] = item;
      emit(state.copyWith(subcategories: updated));
    }
    try {
      await _repository.update(id, item);
    } catch (_) {
      if (old != null && index != -1) {
        final restored = List<Subcategory>.from(state.subcategories)..[index] = old;
        emit(state.copyWith(subcategories: restored));
      }
    }
  }

  void updateSubcategoryColor(Color color) => emit(state.copyWith(
      selectedColor:
          '0x${color.toARGB32().toRadixString(16).padLeft(8, '0')}'));

  void toggleSubCategoryEditModeState() =>
      emit(state.copyWith(isEditMode: !state.isEditMode));

  void togglePieChart() => emit(state.copyWith(showPieChart: !state.showPieChart));

  void resetScreenState() {
    emit(state.copyWith(isEditMode: false, showPieChart: false));
  }

  Future<void> fetchAndEnsureDefault(Category category) async {
    emit(state.copyWith(status: SubcategoryStatus.loading));
    try {
      final all = await _repository.getAll();
      final existing =
          all.where((s) => s.parentCategoryId == category.id).toList();

      final isPlaceholder =
          existing.length == 1 && existing.first.name == category.name;

      if (existing.isNotEmpty && !isPlaceholder) {
        emit(state.copyWith(
            status: SubcategoryStatus.success, subcategories: all));
        return;
      }

      if (isPlaceholder && existing.first.id != null) {
        await _repository.delete(existing.first.id!);
      }

      await _seedDefaults(category);

      final updated = await _repository.getAll();
      emit(state.copyWith(
          status: SubcategoryStatus.success, subcategories: updated));
    } catch (_) {
      emit(state.copyWith(
          status: SubcategoryStatus.error,
          errorMessage: 'Failed to load subcategories.'));
    }
  }

  Future<void> resetToDefaults(Category category) async {
    emit(state.copyWith(status: SubcategoryStatus.loading));
    try {
      final existing = state.subcategories
          .where((s) => s.parentCategoryId == category.id)
          .toList();
      for (final sub in existing) {
        if (sub.id != null) await _repository.delete(sub.id!);
      }
      await _seedDefaults(category);
      final updated = await _repository.getAll();
      emit(state.copyWith(
          status: SubcategoryStatus.success, subcategories: updated));
    } catch (_) {
      emit(state.copyWith(
          status: SubcategoryStatus.error,
          errorMessage: 'Failed to restore defaults.'));
    }
  }

  Future<void> _seedDefaults(Category category) async {
    final defaults = getDefaultSubcategories(category);
    if (defaults.isNotEmpty) {
      for (final sub in defaults) {
        await _repository.insert(sub.copyWith(parentCategoryId: category.id));
      }
    } else {
      await _repository.insert(Subcategory(
        name: category.name,
        color: category.color,
        icon: category.icon,
        parentCategoryId: category.id!,
        spentAmount: '0',
      ));
    }
  }
}
