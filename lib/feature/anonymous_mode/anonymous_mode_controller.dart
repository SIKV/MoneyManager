import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/local_preferences.dart';

/// Shown in place of an amount when the anonymous mode is enabled.
const String anonymousAmount = '•••';

final anonymousModeControllerProvider = NotifierProvider<AnonymousModeController, bool>(() =>
    AnonymousModeController()
);

/// Hides every amount across the app. Toggled by pulling down on the
/// transactions page. See [PullToActivate].
class AnonymousModeController extends Notifier<bool> {

  @override
  bool build() {
    return ref.read(localPreferencesProvider).isAnonymousMode();
  }

  void toggle() {
    setEnabled(!state);
  }

  void setEnabled(bool enabled) {
    ref.read(localPreferencesProvider)
        .setAnonymousMode(enabled);

    state = enabled;
  }
}
