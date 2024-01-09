import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/transaction/controller/transaction_maker_controller.dart';
import 'package:moneymanager/feature/transaction/domain/amount_key.dart';
import 'package:moneymanager/theme/spacings.dart';

import 'common/fake_key.dart';
import 'common/key_container.dart';
import 'common/text_key.dart';

class AmountInput extends ConsumerWidget {
  const AmountInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(
        top: Spacings.three,
        left: Spacings.three,
        right: Spacings.three,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextKey(amountKey: AmountKey.seven, onTap: _onKeyTap),
                TextKey(amountKey: AmountKey.eight, onTap: _onKeyTap),
                TextKey(amountKey: AmountKey.nine, onTap: _onKeyTap),

                KeyContainer(
                  isAction: true,
                  onTap: () {
                    _onKeyTap(ref, AmountKey.backspace);
                  },
                  child: const Center(
                    child: Icon(CupertinoIcons.delete_left),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacings.two),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextKey(amountKey: AmountKey.four, onTap: _onKeyTap),
                TextKey(amountKey: AmountKey.five, onTap: _onKeyTap),
                TextKey(amountKey: AmountKey.six, onTap: _onKeyTap),

                TextKey(
                  isAction: true,
                  amountKey: AmountKey.clear,
                  onTap: _onKeyTap,
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacings.two),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextKey(amountKey: AmountKey.one, onTap: _onKeyTap),
                TextKey(amountKey: AmountKey.two, onTap: _onKeyTap),
                TextKey(amountKey: AmountKey.three, onTap: _onKeyTap),

                KeyContainer(
                  isAction: true,
                  onTap: () {
                    _onKeyTap(ref, AmountKey.calculator);
                  },
                  child: const Center(
                    child: Icon(CupertinoIcons.plus_slash_minus),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacings.two),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const FakeKey(),

                TextKey(amountKey: AmountKey.zero, onTap: _onKeyTap),
                TextKey(amountKey: AmountKey.decimal, onTap: _onKeyTap),

                KeyContainer(
                  isAction: true,
                  onTap: () {
                    _onKeyTap(ref, AmountKey.done);
                  },
                  child: const Center(
                    child: Icon(Icons.done),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onKeyTap(WidgetRef ref, AmountKey key) {
    ref.read(transactionMakerControllerProvider.notifier)
        .processAmountKey(key);
  }
}
