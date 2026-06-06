import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

enum SettingsStatus { initial, loading, success, error }

// run build_runner
@freezed
sealed class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(SettingsStatus.initial) SettingsStatus status,
    String? errorMessage,
  }) = _SettingsState;
}

extension SettingsStateX on SettingsState {
  bool get isLoading => status == SettingsStatus.loading;
}
