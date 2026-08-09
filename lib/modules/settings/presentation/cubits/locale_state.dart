import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'locale_state.freezed.dart';

// run build_runner
@freezed
sealed class LocaleState with _$LocaleState {
  const factory LocaleState({
    @Default(Locale('en')) Locale locale,
  }) = _LocaleState;
}
