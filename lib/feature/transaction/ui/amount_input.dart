import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/transaction/controller/transaction_maker_controller.dart';
import 'package:moneymanager/feature/transaction/domain/amount_key.dart';
import 'package:moneymanager/theme/spacings.dart';

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
                _TextKey(amountKey: AmountKey.seven, onTap: _onKeyTap),
                _TextKey(amountKey: AmountKey.eight, onTap: _onKeyTap),
                _TextKey(amountKey: AmountKey.nine, onTap: _onKeyTap),

                _KeyContainer(
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
                _TextKey(amountKey: AmountKey.four, onTap: _onKeyTap),
                _TextKey(amountKey: AmountKey.five, onTap: _onKeyTap),
                _TextKey(amountKey: AmountKey.six, onTap: _onKeyTap),

                _TextKey(
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
                _TextKey(amountKey: AmountKey.one, onTap: _onKeyTap),
                _TextKey(amountKey: AmountKey.two, onTap: _onKeyTap),
                _TextKey(amountKey: AmountKey.three, onTap: _onKeyTap),

                _KeyContainer(
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
                const _FakeKey(),

                _TextKey(amountKey: AmountKey.zero, onTap: _onKeyTap),
                _TextKey(amountKey: AmountKey.decimal, onTap: _onKeyTap),

                _KeyContainer(
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

class _TextKey extends ConsumerWidget {
  final bool isAction;
  final AmountKey amountKey;
  final Function(WidgetRef, AmountKey) onTap;

  const _TextKey({
    Key? key,
    this.isAction = false,
    required this.amountKey,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _KeyContainer(
      isAction: isAction,
      onTap: () => onTap(ref, amountKey),
      child: Center(
        child: Text(amountKey.char,
          style: TextStyle(
            fontSize: 28,
            fontWeight: isAction ? FontWeight.w300 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _KeyContainer extends ConsumerWidget {
  final bool isAction;
  final VoidCallback onTap;
  final Widget child;

  const _KeyContainer({
    Key? key,
    this.isAction = false,
    required this.onTap,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RawMaterialButton(
      onPressed: onTap,
      fillColor: isAction
          ? Theme.of(context).colorScheme.tertiaryContainer
          : Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
      elevation: 0,
      shape: const CircleBorder(),
      child: child,
    );
  }
}

class _FakeKey extends StatelessWidget {
  const _FakeKey({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0,
      child: _TextKey(amountKey: AmountKey.zero, onTap: (_, __) { }),
    );
  }
}
