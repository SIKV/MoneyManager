import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/config.dart';
import 'package:moneymanager/local_preferences.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app_startup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  final localPreferences = container.read(localPreferencesProvider);

  await localPreferences.load();

  if (isSentryEnabled()) {
    await SentryFlutter.init((options) {
      options.dsn = getSentryDSN();
      options.sendDefaultPii = true;

      /*
      It appears that Sentry only allows SentryFeedbackOptions to be set within the SentryFlutter.init { } block.
      Because of this, AppLocalizations can’t be used there.

      At the moment, the app supports only English, so this isn’t a major issue.
      However, a better long-term approach would be to create a custom feedback widget instead of using SentryFeedbackWidget.
      This would allow the use of AppLocalizations and provide full control over the UI.
       */
      options.feedback.title = 'Send Feedback';
      options.feedback.messagePlaceholder = 'Send feedback or report a bug';
      options.feedback.showBranding = false;
      options.feedback.showCaptureScreenshot = false;
      options.feedback.submitButtonLabel = 'Submit';

    }, appRunner: () =>
        runApp(
          SentryWidget(
            child: UncontrolledProviderScope(
              container: container,
              child: const AppStartup(),
            ),
          ),
        ),
    );
  } else {
    runApp(
      UncontrolledProviderScope(
        container: container,
        child: const AppStartup(),
      ),
    );
  }
}
