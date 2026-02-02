import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/passcode/domain/set_passcode_mode.dart';
import 'package:moneymanager/feature/passcode/domain/set_passcode_result.dart';
import 'package:moneymanager/feature/passcode/ui/passcode_input_widget.dart';

import '../../l10n/app_localizations.dart';
import 'controller/set_passcode_controller.dart';

class SetPasscodePage extends ConsumerWidget {
  const SetPasscodePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(setPasscodeControllerProvider);

    _listenSetResult(context, ref);

    var title = switch (state.mode) {
      SetPasscodeMode.set => AppLocalizations.of(context)!.setPasscodePage_setTitle,
      SetPasscodeMode.reEnter => AppLocalizations.of(context)!.setPasscodePage_reEnterTitle,
    };

    return PasscodeInputWidget(
      title: title,
      passcodeLength: state.passcodeLength,
      numberOfEntered: state.currentInputLength,
      error: state.result == SetPasscodeResult.validationError
          ? AppLocalizations.of(context)!.setPasscodePage_validationError
          : null,
      onTap: (_, key) => {
        ref.read(setPasscodeControllerProvider.notifier)
            .processKeyEntered(key)
      },
    );
  }

  void _listenSetResult(BuildContext context, WidgetRef ref) {
    ref.listen(setPasscodeControllerProvider.select((s) => s.result), (prev, curr) {
      switch (curr) {
        case SetPasscodeResult.set:
          Navigator.pop(context, curr);
          break;
        case SetPasscodeResult.validationError: // Handled in build().
          break;
        case null: // Do nothing.
          break;
      }
    });
  }
}
