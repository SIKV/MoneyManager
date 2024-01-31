import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:moneymanager/feature/transaction/controller/transaction_maker_controller.dart';

import '../../../utils.dart';

class DateTimeSelector extends ConsumerWidget {
  const DateTimeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionMakerControllerProvider);
    final controller = ref.watch(transactionMakerControllerProvider.notifier);

    final DateTime firstDate = DateTime.utc(1995);
    final DateTime initialDateTime = state.value?.transaction.createDateTime ?? DateTime.now();
    final DateTime lastDate = DateTime.now();

    return SingleChildScrollView(
      child: Column(
        children: [
          CalendarDatePicker(
            firstDate: firstDate,
            initialDate: initialDateTime,
            lastDate: lastDate,
            onDateChanged: (date) {
              controller.setCreationDate(date);
            },
          ),
          const Divider(),
          TimePickerSpinner(
            time: initialDateTime,
            normalTextStyle: Theme.of(context).textTheme.titleMedium,
            highlightedTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
            is24HourMode: is24HourMode(),
            onTimeChange: (time) {
              controller.setCreationTime(time);
            },
          ),
        ],
      ),
    );
  }
}
