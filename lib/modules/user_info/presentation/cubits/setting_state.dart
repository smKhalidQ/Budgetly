import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_state.freezed.dart';

enum SettingStatus { initial, loading, success, error }

enum SettingError { saveProfileFailed }

// run build_runner
@freezed
sealed class SettingState with _$SettingState {
  const factory SettingState({
    @Default(SettingStatus.initial) SettingStatus status,
    String? selectedCurrency,
    @Default(0) int monthlySalary,
    @Default('') String userName,
    SettingError? error,
  }) = _SettingState;
}

extension SettingStateX on SettingState {
  bool get isLoading => status == SettingStatus.loading;
}
