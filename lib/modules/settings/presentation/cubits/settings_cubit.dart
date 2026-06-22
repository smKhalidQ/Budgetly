import 'package:budget_buddy/core/database/database_helper.dart';
import 'package:budget_buddy/core/services/month_cycle_service.dart';
import 'package:budget_buddy/modules/category/domain/repositories/category_repository.dart';
import 'package:budget_buddy/modules/settings/presentation/cubits/settings_state.dart';
import 'package:budget_buddy/modules/subcategory/domain/repositories/subcategory_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final CategoryRepository _categoryRepository;
  final SubcategoryRepository _subcategoryRepository;
  final MonthCycleService _monthCycleService;

  SettingsCubit(
    this._categoryRepository,
    this._subcategoryRepository,
    this._monthCycleService,
  ) : super(const SettingsState());

  /// Closes the current month: sweeps leftover into Saving and posts the active
  /// fixed expenses. The resulting summary is held in state for the screen to
  /// surface.
  Future<void> startNewMonth() async {
    emit(state.copyWith(status: SettingsStatus.loading, lastCycle: null));
    try {
      final summary = await _monthCycleService.startNewCycle();
      emit(state.copyWith(
        status: SettingsStatus.success,
        lastCycle: summary,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to start a new month.',
      ));
    }
  }

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
