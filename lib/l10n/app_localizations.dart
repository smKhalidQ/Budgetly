import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Plan Your Budget'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Set your monthly budget\nand allocate funds to what matters most'**
  String get onboarding1Subtitle;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Track Your Spending'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Log every expense and see\nwhere your money goes in real time'**
  String get onboarding2Subtitle;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Stay in Control'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay on top of your budget\nand reach your saving goals'**
  String get onboarding3Subtitle;

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Get Started'**
  String get setupTitle;

  /// No description provided for @setupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A few details and you\'re ready to go'**
  String get setupSubtitle;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @yourNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Mohamed'**
  String get yourNameHint;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @monthlySalary.
  ///
  /// In en, this message translates to:
  /// **'Monthly Salary'**
  String get monthlySalary;

  /// No description provided for @salaryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5000'**
  String get salaryHint;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// No description provided for @pleaseEnterSalary.
  ///
  /// In en, this message translates to:
  /// **'Please enter your monthly salary'**
  String get pleaseEnterSalary;

  /// No description provided for @invalidSalary.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get invalidSalary;

  /// No description provided for @distributeYourBudget.
  ///
  /// In en, this message translates to:
  /// **'Distribute Your Monthly Budget'**
  String get distributeYourBudget;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @confirmBudget.
  ///
  /// In en, this message translates to:
  /// **'Confirm Budget'**
  String get confirmBudget;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add New Category'**
  String get addCategory;

  /// No description provided for @noCategoriesFound.
  ///
  /// In en, this message translates to:
  /// **'No categories found.\nAdd categories using the + button below.'**
  String get noCategoriesFound;

  /// No description provided for @insufficientBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Insufficient Balance'**
  String get insufficientBudgetTitle;

  /// No description provided for @insufficientBudgetMsg.
  ///
  /// In en, this message translates to:
  /// **'You\'ve exceeded your monthly budget. Please adjust the allocation.'**
  String get insufficientBudgetMsg;

  /// No description provided for @savingReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget Saving!'**
  String get savingReminderTitle;

  /// No description provided for @savingReminderMsg.
  ///
  /// In en, this message translates to:
  /// **'You still have remaining budget. Consider adding it to Saving.'**
  String get savingReminderMsg;

  /// No description provided for @continueAnyway.
  ///
  /// In en, this message translates to:
  /// **'Continue Anyway'**
  String get continueAnyway;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @adjustBudget.
  ///
  /// In en, this message translates to:
  /// **'Adjust'**
  String get adjustBudget;

  /// No description provided for @addToSavings.
  ///
  /// In en, this message translates to:
  /// **'Add to Savings'**
  String get addToSavings;

  /// No description provided for @remainingBalance.
  ///
  /// In en, this message translates to:
  /// **'Remaining Balance'**
  String get remainingBalance;

  /// No description provided for @youHaveRemainingOf.
  ///
  /// In en, this message translates to:
  /// **'You still have'**
  String get youHaveRemainingOf;

  /// No description provided for @unallocated.
  ///
  /// In en, this message translates to:
  /// **'unallocated'**
  String get unallocated;

  /// No description provided for @editCategoriesLater.
  ///
  /// In en, this message translates to:
  /// **'You can edit categories later from Settings'**
  String get editCategoriesLater;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @clearCategories.
  ///
  /// In en, this message translates to:
  /// **'Clear Categories'**
  String get clearCategories;

  /// No description provided for @clearSubcategories.
  ///
  /// In en, this message translates to:
  /// **'Clear Subcategories'**
  String get clearSubcategories;

  /// No description provided for @deleteDatabase.
  ///
  /// In en, this message translates to:
  /// **'Delete Database'**
  String get deleteDatabase;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @irreversibleAction.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get irreversibleAction;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @allocated.
  ///
  /// In en, this message translates to:
  /// **'Allocated'**
  String get allocated;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving'**
  String get saving;

  /// No description provided for @housing.
  ///
  /// In en, this message translates to:
  /// **'Housing'**
  String get housing;

  /// No description provided for @foodDrinks.
  ///
  /// In en, this message translates to:
  /// **'Food & Drinks'**
  String get foodDrinks;

  /// No description provided for @transportation.
  ///
  /// In en, this message translates to:
  /// **'Transportation'**
  String get transportation;

  /// No description provided for @healthcare.
  ///
  /// In en, this message translates to:
  /// **'Healthcare'**
  String get healthcare;

  /// No description provided for @entertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get entertainment;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
