import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/data/providers.dart';
import 'package:moneymanager/feature/feedback/send_feedback_page.dart';
import 'package:moneymanager/feature/passcode/domain/verify_passcode_mode.dart';
import 'package:moneymanager/feature/passcode/passcode_settings_page.dart';
import 'package:moneymanager/feature/transactions/ui/header_filters.dart';
import 'package:moneymanager/feature/wallet/change_wallet_page.dart';
import 'package:moneymanager/local_preferences.dart';
import 'package:moneymanager/theme/spacings.dart';
import 'package:moneymanager/theme/theme.dart';
import 'package:moneymanager/theme/theme_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../analytics/AnalyticsNavigatorObserver.dart';
import '../../l10n/app_localizations.dart';
import '../calculator/domain/calculator_page_args.dart';
import '../../navigation/routes.dart';
import '../../navigation/transaction_page_args.dart';
import '../backup/backup_page.dart';
import '../categories/categories_page.dart';
import '../change_theme/change_theme_page.dart';
import '../passcode/set_passcode_page.dart';
import '../passcode/verify_passcode_page.dart';
import '../search/search_page.dart';
import '../statistics/statistics_page.dart';
import '../calculator/calculator_page.dart';
import '../transaction/transaction_page.dart';
import '../wallet/add_wallet_page.dart';
import '../wallet_settings/wallet_settings_page.dart';
import 'app.dart';

part 'app_startup.g.dart';

@Riverpod(keepAlive: true)
Future<void> appStartup(AppStartupRef ref) async {
  final localPreferences = ref.watch(localPreferencesProvider);

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
      navigatorObservers: [
        AnalyticsNavigatorObserver(),
      ],
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.categories:
            return MaterialPageRoute(
              builder: (_) => const CategoriesPage(),
              settings: settings,
            );
          case AppRoutes.search:
            return MaterialPageRoute(
              builder: (_) => const SearchPage(),
              settings: settings,
            );
          case AppRoutes.statistics:
            return MaterialPageRoute(
              builder: (_) => const StatisticsPage(),
              settings: settings,
            );
          case AppRoutes.addTransaction:
          case AppRoutes.viewTransaction:
            return MaterialPageRoute(
              builder: (_) => TransactionPage(
                args: settings.arguments as TransactionPageArgs,
              ),
              settings: settings,
            );
          case AppRoutes.addWallet:
            return MaterialPageRoute(
              builder: (_) => const AddWalletPage(),
              settings: settings,
            );
          case AppRoutes.walletSettings:
            return MaterialPageRoute(
              builder: (_) => const WalletSettingsPage(),
              settings: settings,
            );
          case AppRoutes.changeTheme:
            return MaterialPageRoute(
              builder: (_) => const ChangeThemePage(),
              settings: settings,
            );
          case AppRoutes.calculator:
            return MaterialPageRoute(
              builder: (_) => CalculatorPage(
                args: settings.arguments as CalculatorPageArgs,
              ),
              settings: settings,
            );
          case AppRoutes.backup:
            return MaterialPageRoute(
              builder: (_) => const BackupPage(),
              settings: settings,
            );
          case AppRoutes.passcodeSettings:
            return MaterialPageRoute(
              builder: (_) => const PasscodeSettingsPage(),
              settings: settings,
            );
          case AppRoutes.setPasscode:
            return MaterialPageRoute(
              builder: (_) => const SetPasscodePage(),
              settings: settings,
            );
          case AppRoutes.verifyPasscode:
            return MaterialPageRoute(
              builder: (_) => const VerifyPasscodePage(mode: VerifyPasscodeMode.inApp),
              settings: settings,
            );
          case AppRoutes.sendFeedback:
            return MaterialPageRoute(
              builder: (_) => const SendFeedbackPage(),
              settings: settings,
            );
          case AppRoutes.changeWalletModal:
            return ModalBottomSheetRoute(
              builder: (_) => const ChangeWalletPage(),
              isScrollControlled: true,
              settings: settings,
            );
          case AppRoutes.transactionsFiltersModal:
            return ModalBottomSheetRoute(
              builder: (_) => const HeaderFilters(),
              isScrollControlled: true,
              settings: settings,
            );
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
