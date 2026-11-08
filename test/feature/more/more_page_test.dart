import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moneymanager/common/provider/current_wallet_provider.dart';
import 'package:moneymanager/domain/currency.dart';
import 'package:moneymanager/domain/wallet.dart';
import 'package:moneymanager/feature/more/more_page.dart';
import 'package:moneymanager/l10n/app_localizations.dart';
import 'package:moneymanager/local_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class _FakeUrlLauncher extends UrlLauncherPlatform {
  String? launchedUrl;
  PreferredLaunchMode? launchMode;

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launchedUrl = url;
    launchMode = options.mode;
    return true;
  }
}

void main() {
  testWidgets('Tapping Privacy Policy opens the policy in an external app', (tester) async {
    // GIVEN
    final urlLauncher = _FakeUrlLauncher();
    UrlLauncherPlatform.instance = urlLauncher;

    PackageInfo.setMockInitialValues(
      appName: 'Money Manager',
      packageName: 'sikv.moneymanager',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );

    SharedPreferences.setMockInitialValues({});
    final localPreferences = LocalPreferences();
    await localPreferences.load();

    const wallet = Wallet(
      id: 1,
      currency: Currency(code: 'USD', name: 'US Dollar', symbol: '\$', emoji: null),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localPreferencesProvider.overrideWithValue(localPreferences),
          currentWalletProvider.overrideWith((ref) => Stream.value(wallet)),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MorePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // WHEN
    await tester.tap(find.text('Privacy Policy'));
    await tester.pump();

    // THEN
    expect(urlLauncher.launchedUrl, 'https://github.com/SIKV/MoneyManager/blob/master/docs/privacy-policy.md');
    expect(urlLauncher.launchMode, PreferredLaunchMode.externalApplication);
  });
}
