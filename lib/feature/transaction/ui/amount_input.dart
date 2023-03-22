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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _KeyItem(text: '1', onTap: _onKeyTap),
                _KeyItem(text: '2', onTap: _onKeyTap),
                _KeyItem(text: '3', onTap: _onKeyTap),
              ],
            ),
          ),
          const SizedBox(height: Spacings.two),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _KeyItem(text: '4', onTap: _onKeyTap),
                _KeyItem(text: '5', onTap: _onKeyTap),
                _KeyItem(text: '6', onTap: _onKeyTap),
              ],
            ),
          ),
          const SizedBox(height: Spacings.two),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _KeyItem(text: '7', onTap: _onKeyTap),
                _KeyItem(text: '8', onTap: _onKeyTap),
                _KeyItem(text: '9', onTap: _onKeyTap),
              ],
            ),
          ),
          const SizedBox(height: Spacings.two),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
      child: Center(
        child: Text(text,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.normal,
          ),
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
    return RawMaterialButton(
      onPressed: onTap,
      fillColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
      elevation: 0,
      shape: const CircleBorder(),
      child: child,
    );
  }
}
