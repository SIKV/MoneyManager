import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/passcode/ui/passcode_input_widget.dart';

import '../../l10n/app_localizations.dart';
import 'controller/verify_passcode_controller.dart';
import 'domain/verify_passcode_result.dart';

class VerifyPasscodePage extends ConsumerWidget {
  const VerifyPasscodePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(verifyPasscodeControllerProvider);

    _listenResult(context, ref);

    return PasscodeInputWidget(
      title: AppLocalizations.of(context)!.verifyPasscodePage_title,
      passcodeLength: state.passcodeLength,
      numberOfEntered: state.currentInputLength,
      onTap: (_, key) => {
        ref.read(verifyPasscodeControllerProvider.notifier)
            .processKeyEntered(key)
      },
    );
  }

  void _listenResult(BuildContext context, WidgetRef ref) {
    ref.listen(verifyPasscodeControllerProvider.select((s) => s.result), (prev, curr) {
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

      ref.read(verifyPasscodeControllerProvider.notifier)
          .resetResult();
    });
  }
}
