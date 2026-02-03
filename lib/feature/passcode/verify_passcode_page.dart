import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/passcode/domain/verify_passcode_controller_args.dart';
import 'package:moneymanager/feature/passcode/domain/verify_passcode_mode.dart';
import 'package:moneymanager/feature/passcode/ui/passcode_input_widget.dart';

import '../../l10n/app_localizations.dart';
import 'controller/verify_passcode_controller.dart';
import 'domain/verify_passcode_result.dart';

class VerifyPasscodePage extends ConsumerWidget {
  final VerifyPasscodeMode mode;

  const VerifyPasscodePage({super.key, required this.mode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(verifyPasscodeControllerProvider(_getControllerArgs(context)));

    _listenSuccessResult(context, ref);

    return PasscodeInputWidget(
      title: AppLocalizations.of(context)!.verifyPasscodePage_title,
      passcodeLength: state.passcodeLength,
      numberOfEntered: state.currentInputLength,
      error: state.result == VerifyPasscodeResult.error
          ? AppLocalizations.of(context)!.verifyPasscodePage_error
          : null,
      onTap: (_, key) => {
        ref.read(verifyPasscodeControllerProvider(_getControllerArgs(context)).notifier)
            .processKeyEntered(key)
      },
    );
  }

  void _listenSuccessResult(BuildContext context, WidgetRef ref) {
    ref.listen(verifyPasscodeControllerProvider(_getControllerArgs(context)).select((s) => s.result), (prev, curr) {
      switch (curr) {
        case VerifyPasscodeResult.success:
          Navigator.pop(context, curr);
          break;
        case VerifyPasscodeResult.error: // Handled in build().
          break;
        case null: // Do nothing.
          break;
      }
    });
  }

  VerifyPasscodeControllerArgs _getControllerArgs(BuildContext context) {
    return VerifyPasscodeControllerArgs(
      mode: mode,
      localizedReason: AppLocalizations.of(context)!.verifyPasscodePage_reason,
    );
  }
}
