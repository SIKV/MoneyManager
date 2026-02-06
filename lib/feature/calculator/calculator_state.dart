import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/feature/calculator/domain/caclculator_page_result.dart';

part 'calculator_state.freezed.dart';

@freezed
class CalculatorState with _$CalculatorState {
  const factory CalculatorState({
    required String expression,
    required CalculatorPageResult? shouldReturnResult,
  }) = _CalculatorState;
}
