import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/transaction/calculator/calculator_controller.dart';
import 'package:moneymanager/theme/spacings.dart';

import '../../../navigation/calculator_page_args.dart';
import '../domain/amount_key.dart';
import '../ui/common/fake_key.dart';
import '../ui/common/key_container.dart';
import '../ui/common/text_key.dart';

class CalculatorPage extends ConsumerStatefulWidget {
  final CalculatorPageArgs args;

  const CalculatorPage({
    super.key,
    required this.args,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends ConsumerState<CalculatorPage> {

  @override
  void initState() {
    super.initState();

    ref.read(calculatorControllerProvider.notifier)
        .initWithArgs(widget.args);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(calculatorControllerProvider);

    _listenShouldReturnResult();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(Spacings.two),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: Spacings.six),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(state.expression,
                    style: const TextStyle(
                      fontSize: 48, // TODO: Should be auto resizable.
                    ),
                  ),
                ),
              ),
            ),
            /**
             * [AC] [DIV] [MUL] [Remove]
             */
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextKey(
                    isAction: true,
                    amountKey: AmountKey.clear,
                    onTap: _onKeyTap,
                  ),
                  KeyContainer(
                    isAction: true,
                    onTap: () {
                      _onKeyTap(null, AmountKey.divide);
                    },
                    child: const Center(
                      child: Icon(CupertinoIcons.divide),
                    ),
                  ),
                  KeyContainer(
                    isAction: true,
                    onTap: () {
                      _onKeyTap(null, AmountKey.multiply);
                    },
                    child: const Center(
                      child: Icon(CupertinoIcons.multiply),
                    ),
                  ),
                  KeyContainer(
                    isAction: true,
                    onTap: () {
                      _onKeyTap(null, AmountKey.backspace);
                    },
                    child: const Center(
                      child: Icon(CupertinoIcons.delete_left),
                    ),
                  ),
                ],
              ),
            ),
            /**
             * [7] [8] [9] [-]
             */
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
                      _onKeyTap(null, AmountKey.minus);
                    },
                    child: const Center(
                      child: Icon(CupertinoIcons.minus),
                    ),
                  ),
                ],
              ),
            ),
            /**
             * [4] [5] [6] [+]
             */
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextKey(amountKey: AmountKey.four, onTap: _onKeyTap),
                  TextKey(amountKey: AmountKey.five, onTap: _onKeyTap),
                  TextKey(amountKey: AmountKey.six, onTap: _onKeyTap),

                  KeyContainer(
                    isAction: true,
                    onTap: () {
                      _onKeyTap(null, AmountKey.plus);
                    },
                    child: const Center(
                      child: Icon(CupertinoIcons.plus),
                    ),
                  ),
                ],
              ),
            ),
            /**
             * [1] [2] [3] [=]
             */
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
                      _onKeyTap(null, AmountKey.equal);
                    },
                    child: const Center(
                      child: Icon(CupertinoIcons.equal),
                    ),
                  ),
                ],
              ),
            ),
            /**
             * [0] [.] [Done]
             */
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
                      _onKeyTap(null, AmountKey.done);
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
      )
    );
  }

  void _onKeyTap(WidgetRef? ref, AmountKey key) {
    this.ref.read(calculatorControllerProvider.notifier)
        .processKey(key);
  }

  void _listenShouldReturnResult() {
    ref.listen(calculatorControllerProvider.select((state) => state.shouldReturnResult), (previous, next) {
      if (next != null) {
        Navigator.pop(context, next);
      }
    });
  }
}
