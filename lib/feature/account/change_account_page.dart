import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/account/controller/change_account_controller.dart';
import 'package:moneymanager/navigation/routes.dart';
import 'package:moneymanager/theme/icons.dart';

import '../../domain/account.dart';
import '../../localizations.dart';
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
        height: 124,
        child: Center(
          child: Text(Strings.generalErrorMessage.localized(context)),
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
    final selectedValueIcon = Icon(
      AppIcons.check,
      size: 32,
      color: Theme.of(context).colorScheme.primary,
    );

    return ListView.builder(
      shrinkWrap: true,
      itemCount: accounts.length + 1,
      itemBuilder: (context, index) {
        if (index >= accounts.length) {
          return ListTile(
            onTap: () => _addAccount(context),
            title: Text(Strings.changeAccountPage_addAccountTitle.localized(context)),
            subtitle: Text(Strings.changeAccountPage_addAccountSubtitle.localized(context)),
          );
        } else {
          final account = accounts[index];

          return ListTile(
            onTap: () => _selectAccount(context, ref, account),
            title: Text('${account.currency.emoji ?? ''}  ${account.currency.code}'),
            subtitle: Text(account.currency.name),
            trailing: account == currentAccount ? selectedValueIcon : null,
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
