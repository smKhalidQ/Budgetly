import 'package:slice_pay/l10n/app_localizations.dart';
import 'package:slice_pay/modules/category/domain/models/category.dart';

extension CategoryLocalization on Category {
  String localizedName(AppLocalizations t) {
    return switch (name) {
      'Housing' => t.housing,
      'Food & Drinks' => t.foodDrinks,
      'Transportation' => t.transportation,
      'Healthcare' => t.healthcare,
      'Entertainment' => t.entertainment,
      'Other' => t.other,
      'Saving & Goals' => t.savingGoals,
      _ => name,
    };
  }
}
