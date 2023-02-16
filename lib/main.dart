import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/account/add_account_page.dart';
import 'package:moneymanager/feature/categories/categories_page.dart';
import 'package:moneymanager/feature/transaction/transaction_page.dart';
import 'package:moneymanager/localizations.dart';
import 'package:moneymanager/navigation/routes.dart';
import 'package:moneymanager/navigation/transaction_page_args.dart';
import 'package:moneymanager/preferences.dart';
import 'package:moneymanager/theme/theme.dart';
import 'package:moneymanager/theme/theme_manager.dart';

import 'ui/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = Preferences();
  await preferences.load();

  runApp(
    ProviderScope(
      overrides: [
        preferencesProvider.overrideWith((ref) => preferences),
      ],
      child: const App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);

    return MaterialApp(
      theme: appTheme.themeData(),
      home: const HomePage(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.categories:
            return MaterialPageRoute(builder: (_) => const CategoriesPage());
          case AppRoutes.transaction:
            return MaterialPageRoute(builder: (_) => TransactionPage(
              args: settings.arguments as TransactionPageArgs,
            ));
          case AppRoutes.addAccount:
            return MaterialPageRoute(builder: (_) => const AddAccountPage());
        }
        assert(false, '${settings.name} route is not implemented.');
        return null;
      },
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('uk', ''),
      ],
    );
  }
}
