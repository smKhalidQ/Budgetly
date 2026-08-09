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

  /// No description provided for @budgetOverview.
  ///
  /// In en, this message translates to:
  /// **'Budget Overview'**
  String get budgetOverview;

  /// No description provided for @totalBudget.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalBudget;

  /// No description provided for @noTransactionsYet.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactionsYet;

  /// No description provided for @startTracking.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your expenses'**
  String get startTracking;

  /// No description provided for @myBudget.
  ///
  /// In en, this message translates to:
  /// **'My Budget'**
  String get myBudget;

  /// No description provided for @monthlyBudget.
  ///
  /// In en, this message translates to:
  /// **'Monthly Budget'**
  String get monthlyBudget;

  /// No description provided for @leftOf.
  ///
  /// In en, this message translates to:
  /// **'left of'**
  String get leftOf;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving'**
  String get saving;

  /// No description provided for @savingGoals.
  ///
  /// In en, this message translates to:
  /// **'Saving & Goals'**
  String get savingGoals;

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

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rent;

  /// No description provided for @utilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get utilities;

  /// No description provided for @internet.
  ///
  /// In en, this message translates to:
  /// **'Internet'**
  String get internet;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @furniture.
  ///
  /// In en, this message translates to:
  /// **'Furniture'**
  String get furniture;

  /// No description provided for @restaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get restaurants;

  /// No description provided for @groceries.
  ///
  /// In en, this message translates to:
  /// **'Groceries'**
  String get groceries;

  /// No description provided for @coffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get coffee;

  /// No description provided for @snacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get snacks;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @fuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get fuel;

  /// No description provided for @publicTransit.
  ///
  /// In en, this message translates to:
  /// **'Public Transit'**
  String get publicTransit;

  /// No description provided for @parking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get parking;

  /// No description provided for @taxiRide.
  ///
  /// In en, this message translates to:
  /// **'Taxi / Ride'**
  String get taxiRide;

  /// No description provided for @carService.
  ///
  /// In en, this message translates to:
  /// **'Car Service'**
  String get carService;

  /// No description provided for @doctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// No description provided for @medicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get medicine;

  /// No description provided for @gym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get gym;

  /// No description provided for @dentist.
  ///
  /// In en, this message translates to:
  /// **'Dentist'**
  String get dentist;

  /// No description provided for @pharmacy.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy'**
  String get pharmacy;

  /// No description provided for @movies.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get movies;

  /// No description provided for @gaming.
  ///
  /// In en, this message translates to:
  /// **'Gaming'**
  String get gaming;

  /// No description provided for @streaming.
  ///
  /// In en, this message translates to:
  /// **'Streaming'**
  String get streaming;

  /// No description provided for @books.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get books;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @shopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shopping;

  /// No description provided for @gifts.
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get gifts;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @personalCare.
  ///
  /// In en, this message translates to:
  /// **'Personal Care'**
  String get personalCare;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @emergencyFund.
  ///
  /// In en, this message translates to:
  /// **'Emergency Fund'**
  String get emergencyFund;

  /// No description provided for @investment.
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get investment;

  /// No description provided for @travelFund.
  ///
  /// In en, this message translates to:
  /// **'Travel Fund'**
  String get travelFund;

  /// No description provided for @retirement.
  ///
  /// In en, this message translates to:
  /// **'Retirement'**
  String get retirement;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @changeAppLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change the app language'**
  String get changeAppLanguage;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @resetToInitialStateTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset to initial state?'**
  String get resetToInitialStateTitle;

  /// No description provided for @resetToInitialStateMsg.
  ///
  /// In en, this message translates to:
  /// **'All transactions will be deleted and spending will be zeroed. Your salary, category allocations, and fixed expenses are kept.'**
  String get resetToInitialStateMsg;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @resetCompleteMsg.
  ///
  /// In en, this message translates to:
  /// **'Reset complete — back to post-setup state'**
  String get resetCompleteMsg;

  /// No description provided for @manageCategories.
  ///
  /// In en, this message translates to:
  /// **'Manage categories'**
  String get manageCategories;

  /// No description provided for @manageCategoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Redistribute budget or add a new category'**
  String get manageCategoriesSubtitle;

  /// No description provided for @fixedExpenses.
  ///
  /// In en, this message translates to:
  /// **'Fixed expenses'**
  String get fixedExpenses;

  /// No description provided for @manageFixedExpenses.
  ///
  /// In en, this message translates to:
  /// **'Manage fixed expenses'**
  String get manageFixedExpenses;

  /// No description provided for @manageFixedExpensesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bills & start a new month'**
  String get manageFixedExpensesSubtitle;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @reconcileBalance.
  ///
  /// In en, this message translates to:
  /// **'Reconcile balance'**
  String get reconcileBalance;

  /// No description provided for @reconcileBalanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Match the app to the money you actually have'**
  String get reconcileBalanceSubtitle;

  /// No description provided for @debug.
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get debug;

  /// No description provided for @resetToPostSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset to post-setup state'**
  String get resetToPostSetupTitle;

  /// No description provided for @resetToPostSetupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Wipe all transactions & spending — keeps salary and allocations'**
  String get resetToPostSetupSubtitle;

  /// No description provided for @selectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select Currency'**
  String get selectCurrency;

  /// No description provided for @setAmount.
  ///
  /// In en, this message translates to:
  /// **'Set {amount}'**
  String setAmount(String amount);

  /// No description provided for @everyDollarHasJob.
  ///
  /// In en, this message translates to:
  /// **'Every {symbol} has a job — you\'re ready to go.'**
  String everyDollarHasJob(String symbol);

  /// No description provided for @splitAcrossCategories.
  ///
  /// In en, this message translates to:
  /// **'Split your {symbol}{salary} across the categories below.'**
  String splitAcrossCategories(String symbol, String salary);

  /// No description provided for @remainingOverBudget.
  ///
  /// In en, this message translates to:
  /// **'{remaining} · over budget'**
  String remainingOverBudget(String remaining);

  /// No description provided for @salary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salary;

  /// No description provided for @addIncome.
  ///
  /// In en, this message translates to:
  /// **'Add Income'**
  String get addIncome;

  /// No description provided for @quickAdd.
  ///
  /// In en, this message translates to:
  /// **'Quick Add'**
  String get quickAdd;

  /// No description provided for @failedToLoadCategories.
  ///
  /// In en, this message translates to:
  /// **'Failed to load categories.'**
  String get failedToLoadCategories;

  /// No description provided for @failedToInitializeCategories.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize categories.'**
  String get failedToInitializeCategories;

  /// No description provided for @failedToLoadSubcategories.
  ///
  /// In en, this message translates to:
  /// **'Failed to load subcategories.'**
  String get failedToLoadSubcategories;

  /// No description provided for @failedToRestoreDefaults.
  ///
  /// In en, this message translates to:
  /// **'Failed to restore defaults.'**
  String get failedToRestoreDefaults;

  /// No description provided for @failedToLoadTransactions.
  ///
  /// In en, this message translates to:
  /// **'Failed to load transactions.'**
  String get failedToLoadTransactions;

  /// No description provided for @failedToLoadFixedExpenses.
  ///
  /// In en, this message translates to:
  /// **'Failed to load fixed expenses.'**
  String get failedToLoadFixedExpenses;

  /// No description provided for @failedToLoadBalance.
  ///
  /// In en, this message translates to:
  /// **'Failed to load balance.'**
  String get failedToLoadBalance;

  /// No description provided for @reconcileFailed.
  ///
  /// In en, this message translates to:
  /// **'Reconcile failed.'**
  String get reconcileFailed;

  /// No description provided for @failedToSaveProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to save profile.'**
  String get failedToSaveProfile;

  /// No description provided for @failedToStartNewMonth.
  ///
  /// In en, this message translates to:
  /// **'Failed to start a new month.'**
  String get failedToStartNewMonth;

  /// No description provided for @failedToResetData.
  ///
  /// In en, this message translates to:
  /// **'Failed to reset data.'**
  String get failedToResetData;

  /// No description provided for @failedToClearCategories.
  ///
  /// In en, this message translates to:
  /// **'Failed to clear categories.'**
  String get failedToClearCategories;

  /// No description provided for @failedToClearSubcategories.
  ///
  /// In en, this message translates to:
  /// **'Failed to clear subcategories.'**
  String get failedToClearSubcategories;

  /// No description provided for @failedToSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Failed to save changes.'**
  String get failedToSaveChanges;

  /// No description provided for @failedToAddCategory.
  ///
  /// In en, this message translates to:
  /// **'Failed to add category.'**
  String get failedToAddCategory;

  /// No description provided for @nameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameIsRequired;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @selectIcon.
  ///
  /// In en, this message translates to:
  /// **'Select Icon'**
  String get selectIcon;

  /// No description provided for @selectColor.
  ///
  /// In en, this message translates to:
  /// **'Select Color'**
  String get selectColor;

  /// No description provided for @addCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategoryTitle;

  /// No description provided for @editCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategoryTitle;

  /// No description provided for @addSubcategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Subcategory'**
  String get addSubcategoryTitle;

  /// No description provided for @editSubcategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Subcategory'**
  String get editSubcategoryTitle;

  /// No description provided for @noSpendingYet.
  ///
  /// In en, this message translates to:
  /// **'No spending yet'**
  String get noSpendingYet;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @noSubcategoriesYet.
  ///
  /// In en, this message translates to:
  /// **'No subcategories yet'**
  String get noSubcategoriesYet;

  /// No description provided for @restoreDefaults.
  ///
  /// In en, this message translates to:
  /// **'Restore defaults'**
  String get restoreDefaults;

  /// No description provided for @subcategoriesLabel.
  ///
  /// In en, this message translates to:
  /// **'SUBCATEGORIES'**
  String get subcategoriesLabel;

  /// No description provided for @deleteSubcategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Subcategory'**
  String get deleteSubcategoryTitle;

  /// No description provided for @deleteSubcategoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String deleteSubcategoryConfirm(String name);

  /// No description provided for @editIncome.
  ///
  /// In en, this message translates to:
  /// **'Edit Income'**
  String get editIncome;

  /// No description provided for @addIncomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Income'**
  String get addIncomeTitle;

  /// No description provided for @editExpense.
  ///
  /// In en, this message translates to:
  /// **'Edit Expense'**
  String get editExpense;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @remainingAmount.
  ///
  /// In en, this message translates to:
  /// **'Remaining: {amount}'**
  String remainingAmount(String amount);

  /// No description provided for @addToWhichBudget.
  ///
  /// In en, this message translates to:
  /// **'Add to which budget?'**
  String get addToWhichBudget;

  /// No description provided for @addNoteOptional.
  ///
  /// In en, this message translates to:
  /// **'Add a note (optional)'**
  String get addNoteOptional;

  /// No description provided for @coverTheDifference.
  ///
  /// In en, this message translates to:
  /// **'Cover the difference'**
  String get coverTheDifference;

  /// No description provided for @overflowNeedMore.
  ///
  /// In en, this message translates to:
  /// **'You need {amount} more. Choose which categories it comes from — you\'ll feel it there later.'**
  String overflowNeedMore(String amount);

  /// No description provided for @allCovered.
  ///
  /// In en, this message translates to:
  /// **'All covered'**
  String get allCovered;

  /// No description provided for @fromCategoryAmount.
  ///
  /// In en, this message translates to:
  /// **'From {category}: {amount}'**
  String fromCategoryAmount(String category, String amount);

  /// No description provided for @availableAmount.
  ///
  /// In en, this message translates to:
  /// **'Available: {amount}'**
  String availableAmount(String amount);

  /// No description provided for @fromNewIncome.
  ///
  /// In en, this message translates to:
  /// **'From new income'**
  String get fromNewIncome;

  /// No description provided for @confirmSpend.
  ///
  /// In en, this message translates to:
  /// **'Confirm spend'**
  String get confirmSpend;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @spentLabel.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spentLabel;

  /// No description provided for @incomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get incomeLabel;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @transactionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted'**
  String get transactionDeleted;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @editAction.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editAction;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteLabel;

  /// No description provided for @coveredFrom.
  ///
  /// In en, this message translates to:
  /// **'Covered from'**
  String get coveredFrom;

  /// No description provided for @newIncome.
  ///
  /// In en, this message translates to:
  /// **'New income'**
  String get newIncome;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions'**
  String get noTransactions;

  /// No description provided for @tryDifferentPeriod.
  ///
  /// In en, this message translates to:
  /// **'Try a different period'**
  String get tryDifferentPeriod;

  /// No description provided for @startNewMonthTitle.
  ///
  /// In en, this message translates to:
  /// **'Start a new month?'**
  String get startNewMonthTitle;

  /// No description provided for @startNewMonthMsg.
  ///
  /// In en, this message translates to:
  /// **'Leftover in every category moves to Saving, spending resets, and your active fixed expenses are posted.'**
  String get startNewMonthMsg;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @savedToSaving.
  ///
  /// In en, this message translates to:
  /// **'Saved {amount} to Saving'**
  String savedToSaving(String amount);

  /// No description provided for @recurringPostedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} fixed posted'**
  String recurringPostedCount(String count);

  /// No description provided for @recurringFlaggedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} need attention'**
  String recurringFlaggedCount(String count);

  /// No description provided for @newMonthStarted.
  ///
  /// In en, this message translates to:
  /// **'New month started · {parts}'**
  String newMonthStarted(String parts);

  /// No description provided for @fixedExpensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Fixed Expenses'**
  String get fixedExpensesTitle;

  /// No description provided for @monthlyFixedTotal.
  ///
  /// In en, this message translates to:
  /// **'Monthly fixed total'**
  String get monthlyFixedTotal;

  /// No description provided for @postedAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Posted automatically on the first day of each month'**
  String get postedAutomatically;

  /// No description provided for @startNewMonthAction.
  ///
  /// In en, this message translates to:
  /// **'Start New Month'**
  String get startNewMonthAction;

  /// No description provided for @noFixedExpensesYet.
  ///
  /// In en, this message translates to:
  /// **'No fixed expenses yet'**
  String get noFixedExpensesYet;

  /// No description provided for @addBillsHint.
  ///
  /// In en, this message translates to:
  /// **'Add bills like rent so they post each month'**
  String get addBillsHint;

  /// No description provided for @newFixedExpense.
  ///
  /// In en, this message translates to:
  /// **'New fixed expense'**
  String get newFixedExpense;

  /// No description provided for @editExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit expense'**
  String get editExpenseTitle;

  /// No description provided for @subcategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Subcategory'**
  String get subcategoryLabel;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @noteOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptionalLabel;

  /// No description provided for @exceedsBudgetBy.
  ///
  /// In en, this message translates to:
  /// **'Exceeds budget by {amount}'**
  String exceedsBudgetBy(String amount);

  /// No description provided for @remainingOfBudget.
  ///
  /// In en, this message translates to:
  /// **'{remaining} remaining of {budget} budget'**
  String remainingOfBudget(String remaining, String budget);

  /// No description provided for @balanceReconciled.
  ///
  /// In en, this message translates to:
  /// **'Balance reconciled'**
  String get balanceReconciled;

  /// No description provided for @startFreshTitle.
  ///
  /// In en, this message translates to:
  /// **'Start fresh?'**
  String get startFreshTitle;

  /// No description provided for @startFreshMsg.
  ///
  /// In en, this message translates to:
  /// **'Spending resets and {amount} is re-spread across your envelopes by their current ratios.'**
  String startFreshMsg(String amount);

  /// No description provided for @startFreshAction.
  ///
  /// In en, this message translates to:
  /// **'Start fresh'**
  String get startFreshAction;

  /// No description provided for @reconcileBalanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Reconcile balance'**
  String get reconcileBalanceTitle;

  /// No description provided for @envelopesHold.
  ///
  /// In en, this message translates to:
  /// **'Your envelopes hold'**
  String get envelopesHold;

  /// No description provided for @howMuchDoYouHaveNow.
  ///
  /// In en, this message translates to:
  /// **'How much do you actually have now?'**
  String get howMuchDoYouHaveNow;

  /// No description provided for @whereDidItGoSpent.
  ///
  /// In en, this message translates to:
  /// **'Where did the {amount} go? Enter what you spent from each.'**
  String whereDidItGoSpent(String amount);

  /// No description provided for @whereDidItGoExtra.
  ///
  /// In en, this message translates to:
  /// **'Where did the extra {amount} go? Add it as income to the envelopes that got it.'**
  String whereDidItGoExtra(String amount);

  /// No description provided for @startFreshInstead.
  ///
  /// In en, this message translates to:
  /// **'Lost track? Start fresh instead'**
  String get startFreshInstead;

  /// No description provided for @allAssigned.
  ///
  /// In en, this message translates to:
  /// **'All assigned'**
  String get allAssigned;

  /// No description provided for @leftToAssign.
  ///
  /// In en, this message translates to:
  /// **'Left to assign: {amount}'**
  String leftToAssign(String amount);

  /// No description provided for @confirmAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmAction;

  /// No description provided for @nowAmount.
  ///
  /// In en, this message translates to:
  /// **'Now: {amount}'**
  String nowAmount(String amount);

  /// No description provided for @everythingMatches.
  ///
  /// In en, this message translates to:
  /// **'Everything matches'**
  String get everythingMatches;

  /// No description provided for @unloggedSpending.
  ///
  /// In en, this message translates to:
  /// **'Unlogged spending: {amount}'**
  String unloggedSpending(String amount);

  /// No description provided for @extraMoney.
  ///
  /// In en, this message translates to:
  /// **'Extra money: {amount}'**
  String extraMoney(String amount);

  /// No description provided for @deferredNextMonthSpent.
  ///
  /// In en, this message translates to:
  /// **'Next month · spent {amount}'**
  String deferredNextMonthSpent(String amount);

  /// No description provided for @editCategoryDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategoryDialogTitle;

  /// No description provided for @overAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} over'**
  String overAmount(String amount);

  /// No description provided for @leftAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} left'**
  String leftAmount(String amount);

  /// No description provided for @partiallyAppliedTitle.
  ///
  /// In en, this message translates to:
  /// **'Partially applied'**
  String get partiallyAppliedTitle;

  /// No description provided for @partiallyAppliedMsg.
  ///
  /// In en, this message translates to:
  /// **'{names}: already spent more than the new budget — the new budget will apply from next month.'**
  String partiallyAppliedMsg(String names);

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;
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
