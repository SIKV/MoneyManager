import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:function_tree/function_tree.dart';
import 'package:moneymanager/feature/calculator/domain/calculator_page_result.dart';
import 'package:moneymanager/feature/calculator/domain/calculator_page_args.dart';

import 'calculator_state.dart';
import 'domain/amount_key.dart';

const _divideSign = '÷';
const _multiplySign = '×';
const _minusSign = '-';
const _plusSign = '+';

const _maxInputLength = 25;

final calculatorControllerProvider = NotifierProvider
    .autoDispose<CalculatorController, CalculatorState>(() {
  return CalculatorController();
});

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
      _updateExpression(key.char, false);
    } else {
      switch (key) {
        case AmountKey.decimal:
          _updateExpression('.', true);
          break;
        case AmountKey.divide:
          _updateExpression(_divideSign, true);
          break;
        case AmountKey.multiply:
          _updateExpression(_multiplySign, true);
          break;
        case AmountKey.minus:
          _updateExpression(_minusSign, true);
          break;
        case AmountKey.plus:
          _updateExpression(_plusSign, true);
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

  void _updateExpression(String s, bool checkDuplicate) {
    if (_rawExpression == '0') {
      _rawExpression = s;
    } else if (_rawExpression.length < _maxInputLength) {
      // If the [_rawExpression] already ends with [s], do not append it again.
      if (checkDuplicate && _rawExpression.endsWith(s)) {
        /** TODO:
         * Currently, this method doesn't check other incorrect inputs.
         * For example, typing '÷+÷' or something like this.
         * Also the _rawExpression cannot be started with an operation.
         * */
      } else {
        _rawExpression += s;
      }
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
    _rawExpression = _rawExpression.replaceAll(_divideSign, '/');
    _rawExpression = _rawExpression.replaceAll(_multiplySign, '*');

    try {
      final num result = _rawExpression.interpret();

      if (result.isInfinite) {
        _rawExpression = '0';
      } else {
        _rawExpression = _removeTrailingZeros(result.toString());
      }
    } catch (e) {
      // Catch all exceptions during calculating the expression.
      // Do not need to log any errors in this case.
    }

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
