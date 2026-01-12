import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/passcode/controller/passcode_settings_controller.dart';
import 'package:moneymanager/feature/passcode/domain/passcode_settings_state.dart';
import 'package:moneymanager/ui/widget/something_went_wrong.dart';

import '../../l10n/app_localizations.dart';

class PasscodeSettingsPage extends ConsumerWidget {

  const PasscodeSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(passcodeSettingsControllerProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Text(
                AppLocalizations.of(context)!.passcodeSettingsPage_title),
          ),
          SliverFillRemaining(
            child: state.when(
              loading: () => Container(),
              data: (data) =>
                  _Content(
                    onPasscodeEnabledChanged: (enabled) => {
                      ref.read(passcodeSettingsControllerProvider.notifier)
                          .setPasscodeEnabled(enabled)
                    },
                    onUseBiometricsChanged: (enabled) => {
                      ref.read(passcodeSettingsControllerProvider.notifier)
                          .setBiometricsEnabled(enabled)
                    },
                    state: data,
                  ),
              error: (_, __) => const SomethingWentWrong(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final Function(bool) onPasscodeEnabledChanged;
  final Function(bool) onUseBiometricsChanged;
  final PasscodeSettingsState state;

  const _Content({
    required this.onPasscodeEnabledChanged,
    required this.onUseBiometricsChanged,
    required this.state,
});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            onPasscodeEnabledChanged(!state.isPasscodeEnabled);
          },
          title: Text(state.isPasscodeEnabled
              ? AppLocalizations.of(context)!.passcodeSettingsPage_disablePasscodeTitle
              : AppLocalizations.of(context)!.passcodeSettingsPage_enablePasscodeTitle
          ), //
          trailing: Switch(
              value: state.isPasscodeEnabled,
              onChanged: onPasscodeEnabledChanged,
          ),
        ),
        if (state.isPasscodeEnabled)
          ListTile(
            onTap: () {
              onUseBiometricsChanged(!state.isBiometricsEnabled);
            },
            title: Text(AppLocalizations.of(context)!.passcodeSettingsPage_biometricsTitle),
            trailing: Switch(
              value: state.isBiometricsEnabled,
              onChanged: onUseBiometricsChanged,
            ),
          ),
      ],
    );
  }
}
