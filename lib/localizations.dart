import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

// TODO Change strings format to pageName_stringName.
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

  // Transaction page
  static const String date = 'date';
  static const String category = 'category';
  static const String amount = 'amount';
  static const String note = 'note';
  static const String selectTimeHint = 'selectTimeHint';

  static const String transaction_enterNoteHint = 'transaction_enterNoteHint';
  static const String transaction_actionDelete = 'transaction_actionDelete';
  static const String transaction_actionSave = 'transaction_actionSave';
  static const String transaction_actionAdd = 'transaction_actionAdd';

  // Transactions page
  static const String dayIncome = 'dayIncome';
  static const String dayExpenses = 'dayExpenses';
  static const String weekIncome = 'weekIncome';
  static const String weekExpenses = 'weekExpenses';
  static const String monthIncome = 'monthIncome';
  static const String monthExpenses = 'monthExpenses';
  static const String yearIncome = 'yearIncome';
  static const String yearExpenses = 'yearExpenses';
  static const String transactions_noItems = 'transactions_noItems';

  // Categories page
  static const String addCategory = 'addCategory';
  static const String categoryTitle = 'categoryTitle';
  static const String addSubcategory = 'addSubcategory';
  static const String newSubcategory = 'newSubcategory';

  // Add Account page
  static const String addAccountTitle = 'addAccountTitle';
  static const String addAccountSubtitle = 'addAccountSubtitle';
  static const String addAccountActionButton = 'addAccountActionButton';
  static const String selectCurrencyPlaceholder = 'selectCurrencyPlaceholder';

  // Change Account page
  static const String changeAccountPage_addAccountTitle = 'changeAccountPage_addAccountTitle';
  static const String changeAccountPage_addAccountSubtitle = 'changeAccountPage_addAccountSubtitle';

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

      // Transaction page
      Strings.date: 'Date',
      Strings.category: 'Category',
      Strings.amount: 'Amount',
      Strings.note: 'Note',
      Strings.selectTimeHint: 'Scroll down to select time ▼',
      Strings.transaction_enterNoteHint: 'Enter a note...',
      Strings.transaction_actionDelete: 'Delete',
      Strings.transaction_actionSave: 'Save',
      Strings.transaction_actionAdd: 'Add',

      // Transactions page
      Strings.dayIncome: 'This day income',
      Strings.dayExpenses: 'This day expenses',
      Strings.weekIncome: 'This week income',
      Strings.weekExpenses: 'This week expenses',
      Strings.monthIncome: 'This month income',
      Strings.monthExpenses: 'This month expenses',
      Strings.yearIncome: 'This year income',
      Strings.yearExpenses: 'This year expenses',
      Strings.transactions_noItems: 'No transactions yet',

      // Categories page
      Strings.addCategory: 'Add category',
      Strings.categoryTitle: 'Category title',
      Strings.addSubcategory: 'Add subcategory',
      Strings.newSubcategory: 'New subcategory',

      // Add Account page
      Strings.addAccountTitle: 'Add Account',
      Strings.addAccountSubtitle: 'Choose a currency for your account ',
      Strings.addAccountActionButton: 'Add Account',
      Strings.selectCurrencyPlaceholder: 'Select currency',

      // Change Account page
      Strings.changeAccountPage_addAccountTitle: 'Add account',
      Strings.changeAccountPage_addAccountSubtitle: 'Tap here to create a new account',
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
