import 'package:firebase_analytics/firebase_analytics.dart';

import '../config.dart';

class Analytics {

  static final _instance = isFirebaseEnabled() ? FirebaseAnalytics.instance : null;

  static void logScreenView({
    required String currentScreen,
    required String previousScreen
  }) {
    _instance?.logScreenView(
      screenClass: null,
      screenName: currentScreen,
      parameters: {
        "previous_screen" : previousScreen
      },
    );
  }
}
