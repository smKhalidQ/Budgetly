import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:budget_buddy/core/services/month_cycle_service.dart';

part 'settings_state.freezed.dart';

enum SettingsStatus { initial, loading, success, error }

// run build_runner
@freezed
sealed class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(SettingsStatus.initial) SettingsStatus status,
    String? errorMessage,
    CycleSummary? lastCycle,
  }) = _SettingsState;
}

extension SettingsStateX on SettingsState {
  bool get isLoading => status == SettingsStatus.loading;
}
