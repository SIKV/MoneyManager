import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/feature/account/add_account_page.dart';
import 'package:moneymanager/feature/account_settings/account_settings_page.dart';
import 'package:moneymanager/feature/categories/categories_page.dart';
import 'package:moneymanager/feature/change_theme/change_theme_page.dart';
import 'package:moneymanager/feature/search/search_page.dart';
import 'package:moneymanager/feature/statistics/statistics_page.dart';
import 'package:moneymanager/feature/transaction/transaction_page.dart';
import 'package:moneymanager/navigation/routes.dart';
import 'package:moneymanager/navigation/transaction_page_args.dart';
import 'package:moneymanager/theme/theme.dart';
import 'package:moneymanager/theme/theme_manager.dart';

import 'common/provider/current_account_provider.dart';
import 'domain/account.dart';
import 'feature/home/home_page.dart';

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
        if (state.shouldAddAccount) {
          return const AddAccountPage();
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
          case AppRoutes.addAccount:
            return MaterialPageRoute(builder: (_) => const AddAccountPage());
          case AppRoutes.accountSettings:
            return MaterialPageRoute(builder: (_) => const AccountSettingsPage());
          case AppRoutes.changeTheme:
            return MaterialPageRoute(builder: (_) => const ChangeThemePage());
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
    required bool shouldAddAccount,
  }) = _AppState;
}

final appControllerProvider = AsyncNotifierProvider<AppController, AppState>(() {
  return AppController();
});

class AppController extends AsyncNotifier<AppState> {
  @override
  FutureOr<AppState> build() async {
    final Account? currentAccount = await ref.watch(currentAccountOrNullProvider.future);
    return AppState(
      shouldAddAccount: currentAccount == null,
    );
  }
}
