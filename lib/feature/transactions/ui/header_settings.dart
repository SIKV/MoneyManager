import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/transactions/controller/header_controller.dart';
import 'package:moneymanager/feature/transactions/extensions.dart';
import 'package:moneymanager/localizations.dart';
import 'package:moneymanager/theme/icons.dart';

import '../../../theme/spacings.dart';
import '../../../ui/widget/close_circle_button.dart';
import '../domain/header_value.dart';

class HeaderSettings extends ConsumerWidget {
  const HeaderSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(headerControllerProvider);

    return state.when(
      loading: () => Container(),
      error: (_, __) => SizedBox(
        height: 124,
        child: Center(
          child: Text(Strings.generalErrorMessage.localized(context)),
        ),
      ),
      data: (config) =>
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(Spacings.four),
                  child: CloseCircleButton(),
                ),
              ),
              _ValuesList(
                values: config.values,
                selectedValue: config.selectedValue,
                onSelectValue: (value) {
                  ref.read(headerControllerProvider.notifier)
                      .selectValue(value);

                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }
}

class _ValuesList extends StatelessWidget {
  final List<HeaderValue> values;
  final HeaderValue selectedValue;
  final Function onSelectValue;

  const _ValuesList({
    Key? key,
    required this.values,
    required this.selectedValue,
    required this.onSelectValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const valueTextStyle = TextStyle(
      fontWeight: FontWeight.normal,
    );

    final selectedValueTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    final selectedValueIcon = Icon(
      AppIcons.transactionsHeaderSettingsSelectedValue,
      size: 32,
      color: Theme.of(context).colorScheme.primary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: values.map((value) =>
          ListTile(
            onTap: () => onSelectValue(value),
            title: Text(value.getTitle(context),
              style: (value == selectedValue) ? selectedValueTextStyle : valueTextStyle,
            ),
            trailing: value == selectedValue ? selectedValueIcon : null,
          ),
      ).toList(),
    );
  }
}
