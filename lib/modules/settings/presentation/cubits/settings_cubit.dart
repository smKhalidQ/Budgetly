import 'package:budget_buddy/core/services/month_cycle_service.dart';
import 'package:budget_buddy/core/utilities/cache_helper.dart';
import 'package:budget_buddy/modules/category/domain/repositories/category_repository.dart';
import 'package:budget_buddy/modules/settings/presentation/cubits/settings_state.dart';
import 'package:budget_buddy/modules/subcategory/domain/repositories/subcategory_repository.dart';
import 'package:budget_buddy/modules/transaction/domain/repositories/transaction_repository.dart';
import 'package:budget_buddy/modules/transaction/domain/services/transaction_balance_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final CategoryRepository _categoryRepository;
  final SubcategoryRepository _subcategoryRepository;
  final TransactionRepository _transactionRepository;
  final TransactionBalanceService _balanceService;
  final MonthCycleService _monthCycleService;

  SettingsCubit(
    this._categoryRepository,
    this._subcategoryRepository,
    this._transactionRepository,
    this._balanceService,
    this._monthCycleService,
  ) : super(const SettingsState());

  Future<void> startNewMonth() async {
    emit(state.copyWith(status: SettingsStatus.loading, lastCycle: null));
    try {
      final summary = await _monthCycleService.startNewCycle();
      emit(state.copyWith(
        status: SettingsStatus.success,
        lastCycle: summary,
        wasReset: false,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to start a new month.',
      ));
    }
  }

  /// Resets all runtime data back to the post-setup state:
  /// restores original allocations (reverses income/rollover/coverage effects),
  /// clears every transaction, zeroes all spent amounts, and removes the active
  /// cycle — keeping user info, category config, and recurring expenses intact.
  Future<void> resetToPostSetup() async {
    emit(state.copyWith(status: SettingsStatus.loading, wasReset: false));
    try {
      await _balanceService.resetAllocationsToSetup();
      await Future.wait([
        _transactionRepository.clearAll(),
        _categoryRepository.resetAllSpentAmounts(),
        _subcategoryRepository.resetAllSpentAmounts(),
      ]);
      CacheHelper.removeData(key: 'cycle_start');
      CacheHelper.removeData(key: 'vault_total');
      emit(state.copyWith(status: SettingsStatus.success, wasReset: true));
    } catch (_) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to reset data.',
        wasReset: false,
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
}
