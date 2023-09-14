import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/provider/current_account_provider.dart';
import '../../account/change_account_page.dart';

class AccountSelector extends ConsumerWidget {
  const AccountSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAccount = ref.watch(currentAccountProvider);

    return currentAccount.whenOrNull(
      data: (currentAccount) =>
          InkWell(
            onTap: () {
              _showChangeAccount(context);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(currentAccount.currency.code),
                const Icon(Icons.keyboard_arrow_down_rounded)
              ],
            ),
          )
    ) ?? Container();
  }

  void _showChangeAccount(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const ChangeAccountPage();
      },
    );
  }
}
