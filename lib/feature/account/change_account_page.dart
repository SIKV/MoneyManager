import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/account/controller/change_account_controller.dart';
import 'package:moneymanager/navigation/routes.dart';
import 'package:moneymanager/theme/dimens.dart';

import '../../domain/account.dart';
import '../../theme/spacings.dart';
import '../../ui/widget/close_circle_button.dart';

class ChangeAccountPage extends ConsumerWidget {
  const ChangeAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(changeAccountControllerProvider);

    return state.when(
      loading: () => Container(),
      error: (_, __) => SizedBox(
        height: Dimens.changeAccountPageHeight,
        child: Center(
          child: Text(AppLocalizations.of(context)!.generalErrorMessage),
        ),
      ),
      data: (state) =>
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
              _AccountsList(
                accounts: state.accounts,
                currentAccount: state.currentAccount,
              ),
            ],
          ),
    );
  }
}

class _AccountsList extends ConsumerWidget {
  final List<Account> accounts;
  final Account? currentAccount;

  const _AccountsList({
    Key? key,
    required this.accounts,
    required this.currentAccount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIcon = Icon(Icons.radio_button_checked,
      color: Theme.of(context).colorScheme.primary,
    );

    const unselectedIcon = Icon(Icons.circle_outlined);

    const selectedTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
    );

    return ListView.builder(
      shrinkWrap: true,
      itemCount: accounts.length + 1,
      itemBuilder: (context, index) {
        if (index >= accounts.length) {
          return ListTile(
            onTap: () => _addAccount(context),
            leading: const Icon(Icons.add),
            title: Text(AppLocalizations.of(context)!.changeAccountPage_addAccountTitle),
            subtitle: Text(AppLocalizations.of(context)!.changeAccountPage_addAccountSubtitle(0)), // TODO: Get from config.
          );
        } else {
          final account = accounts[index];

          return ListTile(
            onTap: () => _selectAccount(context, ref, account),
            contentPadding: const EdgeInsets.only(
              left: Spacings.four,
              right: Spacings.three,
            ),
            leading: account == currentAccount ? selectedIcon : unselectedIcon,
            title: Text(account.currency.code,
              style: account == currentAccount ? selectedTextStyle : null,
            ),
            subtitle: Text(account.currency.name),
            trailing: IconButton(
              onPressed: () {
                // TODO: Implement.
              },
              icon: const Icon(Icons.more_vert),
            ),
          );
        }
      },
    );
  }

  void _addAccount(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushNamed(context, AppRoutes.addAccount);
  }

  void _selectAccount(BuildContext context, WidgetRef ref, Account account) {
    ref.read(changeAccountControllerProvider.notifier)
        .selectAccount(account);

    Navigator.pop(context);
  }
}
