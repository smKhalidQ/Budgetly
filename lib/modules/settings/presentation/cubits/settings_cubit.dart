import 'package:budget_buddy/core/database/database_helper.dart';
import 'package:budget_buddy/modules/category/domain/repositories/category_repository.dart';
import 'package:budget_buddy/modules/settings/presentation/cubits/settings_state.dart';
import 'package:budget_buddy/modules/subcategory/domain/repositories/subcategory_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final CategoryRepository _categoryRepository;
  final SubcategoryRepository _subcategoryRepository;

  SettingsCubit(this._categoryRepository, this._subcategoryRepository)
      : super(const SettingsState());

  Future<void> clearCategories() async {
    emit(state.copyWith(status: SettingsStatus.loading));
    try {
      await _categoryRepository.clearAll();
      emit(state.copyWith(status: SettingsStatus.success));
    } catch (_) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to clear categories.',
      ));
    }
  }

  Future<void> clearSubcategories() async {
    emit(state.copyWith(status: SettingsStatus.loading));
    try {
      await _subcategoryRepository.clearAll();
      emit(state.copyWith(status: SettingsStatus.success));
    } catch (_) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to clear subcategories.',
      ));
    }
  }

  Future<void> clearAllData() async {
    emit(state.copyWith(status: SettingsStatus.loading));
    try {
      await DatabaseHelper.removeDatabase();
      emit(state.copyWith(status: SettingsStatus.success));
    } catch (_) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to delete database.',
      ));
    }
  }
}
