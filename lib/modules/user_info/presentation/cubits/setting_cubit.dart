import 'package:budget_buddy/core/utilities/cache_helper.dart';
import 'package:budget_buddy/core/utilities/listener_mixin.dart';
import 'package:budget_buddy/modules/user_info/domain/models/user_info.dart';
import 'package:budget_buddy/modules/user_info/domain/repositories/user_info_repository.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingCubit extends Cubit<SettingState> with StreamListener {
  final UserInfoRepository _repository;

  SettingCubit(this._repository) : super(const SettingState());

  static SettingCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> loadUserInfo() async {
    try {
      final users = await _repository.getAll();
      if (users.isNotEmpty) {
        final user = users.first;
        emit(state.copyWith(
          userName: user.name,
          monthlySalary: int.tryParse(user.monthlySalary) ?? 0,
          selectedCurrency: user.currency,
          status: SettingStatus.success,
        ));
      }
    } catch (_) {}
  }

  Future<void> insertUserInfo(UserInfo user) async {
    emit(state.copyWith(status: SettingStatus.loading));
    try {
      await _repository.insert(user);
      emit(state.copyWith(
        status: SettingStatus.success,
        userName: user.name,
        monthlySalary: int.tryParse(user.monthlySalary) ?? state.monthlySalary,
        selectedCurrency: user.currency,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: SettingStatus.error,
        errorMessage: 'Failed to save profile.',
      ));
    }
  }

  Future<void> markOnboardingSeen() =>
      CacheHelper.saveData(key: 'onboarding_seen', value: true);

  void selectCurrency(String value) => emit(state.copyWith(selectedCurrency: value));

  void setMonthlySalary(int value) => emit(state.copyWith(monthlySalary: value));
}

