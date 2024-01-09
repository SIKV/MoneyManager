import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:function_tree/function_tree.dart';
import 'package:moneymanager/navigation/calculator_page_args.dart';
import 'package:moneymanager/navigation/result/caclculator_page_result.dart';

import '../domain/amount_key.dart';
import 'calculator_state.dart';

final calculatorControllerProvider = NotifierProvider
    .autoDispose<CalculatorController, CalculatorState>(() {
  return CalculatorController();
});

// TODO: Not finished yet.
class CalculatorController extends AutoDisposeNotifier<CalculatorState> {
  double _initialValue = 0;
  String _rawExpression = '0';

  @override
  CalculatorState build() {
    return CalculatorState(
      expression: _rawExpression,
      shouldReturnResult: null,
    );
  }

  void initWithArgs(CalculatorPageArgs args) {
    _initialValue = args.value;
    _rawExpression = _removeTrailingZeros(_initialValue.toString());

    ref.invalidateSelf();
  }

  void processKey(AmountKey key) {
    if (key.isDigit) {
      _updateExpression(key.char);
    } else {
      switch (key) {
        case AmountKey.decimal:
          _updateExpression('.');
          break;
        case AmountKey.divide:
          _updateExpression(' ÷ ');
          break;
        case AmountKey.multiply:
          _updateExpression(' × ');
          break;
        case AmountKey.minus:
          _updateExpression(' - ');
          break;
        case AmountKey.plus:
          _updateExpression(' + ');
          break;
        case AmountKey.equal:
          _calculateExpression();
          break;
        case AmountKey.backspace:
          _removeLast();
          break;
        case AmountKey.clear:
          _removeAll();
          break;
        case AmountKey.done:
          _returnResult();
          break;
        default:
          // Do nothing.
      }
    }
  }

  void _updateExpression(String s) {
    if (_rawExpression == '0') {
      _rawExpression = s;
    } else {
      _rawExpression += s;
    }

    state = state.copyWith(
      expression: _rawExpression,
    );
  }

  void _removeAll() {
    _rawExpression = '0';

    state = state.copyWith(
      expression: _rawExpression,
    );
  }

  void _removeLast() {
    if (_rawExpression.isNotEmpty) {
      _rawExpression = _rawExpression.substring(0, _rawExpression.length - 1);
    }
    if (_rawExpression.isEmpty) {
      _rawExpression = '0';
    }

    state = state.copyWith(
      expression: _rawExpression,
    );
  }

  void _calculateExpression({bool updateState = true}) {
    _rawExpression = _rawExpression.replaceAll('÷', '/');
    _rawExpression = _rawExpression.replaceAll('×', '*');

    _rawExpression = _removeTrailingZeros(_rawExpression.interpret().toString());

    if (updateState) {
      state = state.copyWith(
        expression: _rawExpression,
      );
    }
  }

  void _returnResult() {
    _calculateExpression(updateState: false);
    final result = double.tryParse(_rawExpression);

    state = state.copyWith(
      shouldReturnResult: CalculatorPageResult(value: result ?? 0),
    );
  }

  String _removeTrailingZeros(String s) {
    return s.replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');
  }
}
