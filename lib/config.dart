bool isFirebaseEnabled() {
  return const bool.fromEnvironment('FIREBASE_ENABLED', defaultValue: false);
}

bool isSentryEnabled() {
  return const bool.hasEnvironment('SENTRY_DSN');
}

String getSentryDSN() {
  return const String.fromEnvironment('SENTRY_DSN', defaultValue: '');
}

bool isFeedbackEnabled() {
  return isSentryEnabled();
}
