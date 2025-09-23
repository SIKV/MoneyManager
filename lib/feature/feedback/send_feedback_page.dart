import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SendFeedbackPage extends StatelessWidget {
  const SendFeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SentryFeedbackWidget();
  }
}
