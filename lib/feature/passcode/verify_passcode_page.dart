import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final state = ref.watch(verifyPasscodeControllerProvider(mode));

    _listenResult(context, ref);

    return PasscodeInputWidget(
      title: AppLocalizations.of(context)!.verifyPasscodePage_title,
      passcodeLength: state.passcodeLength,
      numberOfEntered: state.currentInputLength,
      onTap: (_, key) => {
        ref.read(verifyPasscodeControllerProvider(mode).notifier)
            .processKeyEntered(key)
      },
    );
  }

  void _listenResult(BuildContext context, WidgetRef ref) {
    ref.listen(verifyPasscodeControllerProvider(mode).select((s) => s.result), (prev, curr) {
      switch (curr) {
        case VerifyPasscodeResult.success: {
          Navigator.pop(context, curr);
        }
        case VerifyPasscodeResult.error: {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.verifyPasscodePage_error),
              )
          );
        }
        case null: // Do nothing.
          break;
      }

      ref.read(verifyPasscodeControllerProvider(mode).notifier)
          .resetResult();
    });
  }
}
