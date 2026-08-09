import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:budget_buddy/core/services/locale_service.dart';
import 'package:budget_buddy/modules/settings/presentation/cubits/locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final LocaleService _localeService;

  LocaleCubit(this._localeService) : super(const LocaleState());

  void initialize() {
    final saved = _localeService.loadSavedLocale();
    if (saved != null) emit(state.copyWith(locale: saved));
  }

  Future<void> changeLocale(Locale locale) async {
    emit(state.copyWith(locale: locale));
    await _localeService.saveLocale(locale);
  }
}
