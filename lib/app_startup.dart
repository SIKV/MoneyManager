import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/app.dart';
import 'package:moneymanager/data/providers.dart';
import 'package:moneymanager/local_preferences.dart';
import 'package:moneymanager/theme/spacings.dart';
import 'package:moneymanager/theme/theme.dart';
import 'package:moneymanager/theme/theme_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'feature/backup/backup_page.dart';
import 'feature/categories/categories_page.dart';
import 'feature/change_theme/change_theme_page.dart';
import 'feature/search/search_page.dart';
import 'feature/statistics/statistics_page.dart';
import 'feature/transaction/calculator/calculator_page.dart';
import 'feature/transaction/transaction_page.dart';
import 'feature/wallet/add_wallet_page.dart';
import 'feature/wallet_settings/wallet_settings_page.dart';
import 'navigation/calculator_page_args.dart';
import 'navigation/routes.dart';
import 'navigation/transaction_page_args.dart';

part 'app_startup.g.dart';

@Riverpod(keepAlive: true)
Future<void> appStartup(AppStartupRef ref) async {
  final localPreferences = ref.watch(localPreferencesProvider);
  await localPreferences.load();

  if (localPreferences.isFirstLaunch()) {
    final categoriesRepository = await ref.watch(categoriesRepositoryProvider);
    await categoriesRepository.initWithDefaultsIfEmpty();

    localPreferences.setFirstLaunch();
  }
}

class AppStartup extends ConsumerWidget {
  const AppStartup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartupState = ref.watch(appStartupProvider);
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);

    Widget home = appStartupState.when(
      loading: () => const _AppStartupLoading(),
      error: (_, __) => const _AppStartupError(),
      data: (_) => const App(),
    );

    return MaterialApp(
      theme: appTheme.themeData(),
      home: home,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.categories:
            return MaterialPageRoute(builder: (_) => const CategoriesPage());
          case AppRoutes.search:
            return MaterialPageRoute(builder: (_) => const SearchPage());
          case AppRoutes.statistics:
            return MaterialPageRoute(builder: (_) => const StatisticsPage());
          case AppRoutes.addTransaction:
          case AppRoutes.viewTransaction:
            return MaterialPageRoute(builder: (_) => TransactionPage(
              args: settings.arguments as TransactionPageArgs,
            ));
          case AppRoutes.addWallet:
            return MaterialPageRoute(builder: (_) => const AddWalletPage());
          case AppRoutes.walletSettings:
            return MaterialPageRoute(builder: (_) => const WalletSettingsPage());
          case AppRoutes.changeTheme:
            return MaterialPageRoute(builder: (_) => const ChangeThemePage());
          case AppRoutes.calculator:
            return MaterialPageRoute(builder: (_) => CalculatorPage(
              args: settings.arguments as CalculatorPageArgs,
            ));
          case AppRoutes.backup:
            return MaterialPageRoute(builder: (_) => const BackupPage());
        }
        assert(false, '${settings.name} route is not implemented.');
        return null;
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

class _AppStartupLoading extends StatelessWidget {

  const _AppStartupLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

class _AppStartupError extends StatelessWidget {

  const _AppStartupError();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Spacings.six),
          child: Text(
            AppLocalizations.of(context)!.appStartupErrorMessage,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
