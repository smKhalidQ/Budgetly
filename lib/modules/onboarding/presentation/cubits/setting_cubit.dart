import 'package:budget_buddy/core/utilities/listener_mixin.dart';
import 'package:budget_buddy/modules/user_info/domain/models/user_info.dart';
import 'package:budget_buddy/modules/user_info/domain/repositories/user_info_repository.dart';
import 'package:budget_buddy/modules/onboarding/presentation/cubits/setting_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingCubit extends Cubit<SettingState> with StreamListener {
  final UserInfoRepository _repository;

  SettingCubit(this._repository) : super(const SettingState());

  static SettingCubit get(context) => BlocProvider.of(context);

  Future<void> insertUserInfo(UserInfo user) async {
    emit(state.copyWith(status: SettingStatus.loading));
    try {
      await _repository.insert(user);
      emit(state.copyWith(status: SettingStatus.success));
    } catch (_) {
      emit(state.copyWith(
        status: SettingStatus.error,
        errorMessage: 'Failed to save profile.',
      ));
    }
  }

  void selectCurrency(String value) => emit(state.copyWith(selectedCurrency: value));

  void setMonthlySalary(int value) => emit(state.copyWith(monthlySalary: value));
}
