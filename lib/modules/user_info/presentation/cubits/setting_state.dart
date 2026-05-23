import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_state.freezed.dart';

enum SettingStatus { initial, loading, success, error }

@freezed
sealed class SettingState with _$SettingState {
  const factory SettingState({
    @Default(SettingStatus.initial) SettingStatus status,
    String? selectedCurrency,
    @Default(0) int monthlySalary,
    String? errorMessage,
  }) = _SettingState;
}

extension SettingStateX on SettingState {
  bool get isLoading => status == SettingStatus.loading;
}
