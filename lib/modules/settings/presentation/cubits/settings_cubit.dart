import 'package:slice_pay/core/services/month_cycle_service.dart';
import 'package:slice_pay/core/utilities/cache_helper.dart';
import 'package:slice_pay/modules/category/domain/repositories/category_repository.dart';
import 'package:slice_pay/modules/settings/presentation/cubits/settings_state.dart';
import 'package:slice_pay/modules/subcategory/domain/repositories/subcategory_repository.dart';
import 'package:slice_pay/modules/transaction/domain/repositories/transaction_repository.dart';
import 'package:slice_pay/modules/transaction/domain/services/transaction_balance_service.dart';
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
        error: SettingsError.startNewMonthFailed,
      ));
    }
  }

  /// Resets all runtime data back to the post-setup state:
  /// restores original allocations (reverses income/rollover/coverage effects),
  /// clears every transaction, zeroes all spent amounts, and removes the active
  /// cycle â€” keeping user info, category config, and recurring expenses intact.
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
      emit(state.copyWith(status: SettingsStatus.success, wasReset: true));
    } catch (_) {
      emit(state.copyWith(
        status: SettingsStatus.error,
        error: SettingsError.resetFailed,
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
        error: SettingsError.clearCategoriesFailed,
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
        error: SettingsError.clearSubcategoriesFailed,
      ));
    }
  }
}
