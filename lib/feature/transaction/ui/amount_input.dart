import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/transaction/controller/transaction_maker_controller.dart';
import 'package:moneymanager/theme/spacings.dart';

import '../../../theme/theme_manager.dart';

class AmountInput extends ConsumerWidget {
  const AmountInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(
        top: Spacings.three,
        left: Spacings.three,
        right: Spacings.three,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Row(
              children: [
                _KeyItem(text: '1', onTap: _onKeyTap),
                _KeyItem(text: '2', onTap: _onKeyTap),
                _KeyItem(text: '3', onTap: _onKeyTap),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _KeyItem(text: '4', onTap: _onKeyTap),
                _KeyItem(text: '5', onTap: _onKeyTap),
                _KeyItem(text: '6', onTap: _onKeyTap),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _KeyItem(text: '7', onTap: _onKeyTap),
                _KeyItem(text: '8', onTap: _onKeyTap),
                _KeyItem(text: '9', onTap: _onKeyTap),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _KeyItem(text: '0', onTap: _onKeyTap),
                _KeyItem(text: '.', onTap: _onKeyTap),

                _KeyContainer(
                  onTap: () {
                    // TODO: Implement
                  },
                  child: const Center(
                    child: Icon(Icons.backspace),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onKeyTap(WidgetRef ref, String key) {
    ref.read(transactionMakerControllerProvider.notifier)
        .processAmountKey(key);
  }
}

class _KeyItem extends ConsumerWidget {
  final String text;
  final Function(WidgetRef, String) onTap;

  const _KeyItem({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _KeyContainer(
      onTap: () => onTap(ref, text),
      child: Text(text,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _KeyContainer extends ConsumerWidget {
  final VoidCallback onTap;
  final Widget child;

  const _KeyContainer({
    Key? key,
    required this.onTap,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(appThemeManagerProvider);

    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(Spacings.one),
        child: Container(
          decoration: BoxDecoration(
            color: appTheme.colors.slightlyGray,
            borderRadius: BorderRadius.circular(Spacings.two),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(Spacings.two),
            child: Center(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
