import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/core/utilities/listener_mixin.dart';
import 'package:budget_buddy/modules/subcategory/domain/models/subcategory.dart';
import 'package:budget_buddy/modules/subcategory/domain/repositories/subcategory_repository.dart';
import 'package:budget_buddy/modules/subcategory/presentation/cubits/subcategory_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubcategoryCubit extends Cubit<SubcategoryState> with StreamListener {
  final SubcategoryRepository _repository;

  SubcategoryCubit(this._repository) : super(const SubcategoryState());

  static SubcategoryCubit get(context) => BlocProvider.of(context);

  Color get subcategoryColor => parseColorFromString(state.selectedColor);
  String get subcategoryIcon => state.selectedIcon.isEmpty
      ? Icons.category.codePoint.toString()
      : state.selectedIcon;

  set subcategoryIcon(String value) => emit(state.copyWith(selectedIcon: value));

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

  void updateSubcategoryColor(Color color) =>
      emit(state.copyWith(selectedColor: color.toString()));

  void toggleSubCategoryEditModeState() =>
      emit(state.copyWith(isEditMode: !state.isEditMode));

  void togglePieChart() => emit(state.copyWith(showPieChart: !state.showPieChart));
}
