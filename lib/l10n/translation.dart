import 'package:slice_pay/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

extension Translation on BuildContext {
  AppLocalizations get tr => AppLocalizations.of(this)!;
}