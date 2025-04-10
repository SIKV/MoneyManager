import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/feature/backup/backup_page.dart';
import 'package:moneymanager/feature/categories/categories_page.dart';
import 'package:moneymanager/feature/change_theme/change_theme_page.dart';
import 'package:moneymanager/feature/search/search_page.dart';
import 'package:moneymanager/feature/statistics/statistics_page.dart';
import 'package:moneymanager/feature/transaction/transaction_page.dart';
import 'package:moneymanager/navigation/calculator_page_args.dart';
import 'package:moneymanager/navigation/routes.dart';
import 'package:moneymanager/navigation/transaction_page_args.dart';
import 'package:moneymanager/theme/theme.dart';
import 'package:moneymanager/theme/theme_manager.dart';

import 'common/provider/current_wallet_provider.dart';
import 'domain/wallet.dart';
import 'feature/home/home_page.dart';
import 'feature/transaction/calculator/calculator_page.dart';
import 'feature/wallet/add_wallet_page.dart';
import 'feature/wallet_settings/wallet_settings_page.dart';

part 'app.freezed.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);
    final state = ref.watch(appControllerProvider);

    Widget home = state.when(
      loading: () => Container(),
      error: (_, __) => Container(),
      data: (state) {
        if (state.shouldAddWallet) {
          return const AddWalletPage();
        } else {
          return const HomePage();
        }
      },
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

@freezed
class AppState with _$AppState {
  const factory AppState({
    required bool shouldAddWallet,
  }) = _AppState;
}

final appControllerProvider = AsyncNotifierProvider<AppController, AppState>(() {
  return AppController();
});

class AppController extends AsyncNotifier<AppState> {
  @override
  FutureOr<AppState> build() async {
    final Wallet? currentWallet = await ref.watch(currentWalletOrNullProvider.future);
    return AppState(
      shouldAddWallet: currentWallet == null,
    );
  }
}
