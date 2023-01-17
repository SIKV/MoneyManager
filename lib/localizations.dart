import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class Strings {
  static const String transactionsPageTitle = 'transactionsPageTitle';
  static const String morePageTitle = 'morePageTitle';
  static const String categoriesPageTitle = 'categoriesPageTitle';
  static const String statisticsPageTitle = 'statisticsPageTitle';
  static const String searchPageTitle = 'searchPageTitle';

  static const String add = 'add';
  static const String save = 'save';
  static const String cancel = 'cancel';
  static const String delete = 'delete';
  static const String income = 'income';
  static const String expense = 'expense';
  static const String generalErrorMessage = 'generalErrorMessage';

  // Transactions page
  static const String dayIncome = 'dayIncome';
  static const String dayExpenses = 'dayExpenses';
  static const String weekIncome = 'weekIncome';
  static const String weekExpenses = 'weekExpenses';
  static const String monthIncome = 'monthIncome';
  static const String monthExpenses = 'monthExpenses';
  static const String yearIncome = 'yearIncome';
  static const String yearExpenses = 'yearExpenses';

  // Categories page
  static const String addCategory = 'addCategory';
  static const String categoryTitle = 'categoryTitle';
  static const String addSubcategory = 'addSubcategory';
  static const String newSubcategory = 'newSubcategory';
}

extension GetLocalizedString on String {
  String localized(BuildContext context) {
    return AppLocalizations.of(context).string(this);
  }
}

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of(context, AppLocalizations);
  }

  static List<String> languages() => _localized.keys.toList();

  String string(String id) {
    var localizedStrings = _localized[locale.languageCode];
    if (localizedStrings == null) {
      throw Exception('Locale \'${locale.languageCode}\' not found.');
    }
    var string = localizedStrings[id];
    if (string == null) {
      throw Exception('String \'$id\' not found.');
    } else {
      return string;
    }
  }

  static const _localized = <String, Map<String, String>>{
    'en': {
      Strings.transactionsPageTitle: 'Transactions',
      Strings.morePageTitle: 'More',
      Strings.categoriesPageTitle: 'Categories',
      Strings.statisticsPageTitle: 'Statistics',
      Strings.searchPageTitle: 'Search',

      Strings.add: 'Add',
      Strings.save: 'Save',
      Strings.cancel: 'Cancel',
      Strings.delete: 'Delete',
      Strings.income: 'Income',
      Strings.expense: 'Expense',
      Strings.generalErrorMessage: 'Something went wrong',

      // Transactions page
      Strings.dayIncome: 'This day income',
      Strings.dayExpenses: 'This day expenses',
      Strings.weekIncome: 'This week income',
      Strings.weekExpenses: 'This week expenses',
      Strings.monthIncome: 'This month income',
      Strings.monthExpenses: 'This month expenses',
      Strings.yearIncome: 'This year income',
      Strings.yearExpenses: 'This year expenses',

      // Categories page
      Strings.addCategory: 'Add category',
      Strings.categoryTitle: 'Category title',
      Strings.addSubcategory: 'Add subcategory',
      Strings.newSubcategory: 'New subcategory',
    },
    'uk': {
      // TODO: Add translations.
    }
  };
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {

  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.languages().contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
