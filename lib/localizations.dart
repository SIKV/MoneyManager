import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class Strings {
  static const String transactionsPageTitle = 'transactionsPageTitle';
  static const String morePageTitle = 'morePageTitle';
  static const String categoriesPageTitle = 'categoriesPageTitle';
  static const String statisticsPageTitle = 'statisticsPageTitle';
  static const String searchPageTitle = 'searchPageTitle';

  // Categories page
  static const String addCategory = 'addCategory';
  static const String categoryTitle = 'categoryTitle';
  static const String addSubcategory = 'addSubcategory';
  static const String saveCategory = 'saveCategory';
  static const String deleteCategory = 'deleteCategory';
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

      Strings.addCategory: 'Add category',
      Strings.categoryTitle: 'Category title',
      Strings.addSubcategory: 'Add subcategory',
      Strings.saveCategory: 'Save',
      Strings.deleteCategory: 'Delete',
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
