import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:moneymanager/feature/transaction/controller/transaction_maker_controller.dart';
import 'package:moneymanager/localizations.dart';

import '../../../theme/spacings.dart';
import '../../../utils.dart';

class DateTimeSelector extends ConsumerStatefulWidget {
  const DateTimeSelector({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DateTimeSelectorState();
}

class _DateTimeSelectorState extends ConsumerState<ConsumerStatefulWidget> {
  late ScrollController _scrollController;

  bool _showSelectTimeHint = true;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.offset > 5.0) {
        _updateShowSelectTimeHint(false);
      } else {
        _updateShowSelectTimeHint(true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  void _updateShowSelectTimeHint(bool value) {
    if (value != _showSelectTimeHint) {
      setState(() {
        _showSelectTimeHint = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionMakerControllerProvider);
    final controller = ref.watch(transactionMakerControllerProvider.notifier);

    final DateTime firstDate = DateTime.utc(1995);
    final DateTime initialDateTime = state.value?.transaction.createDateTime ?? DateTime.now();
    final DateTime lastDate = DateTime.now();

    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
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
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 350),
          opacity: _showSelectTimeHint ? 1.0 : 0.0,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(
                right: Spacings.four,
              ),
              child: Text(Strings.selectTimeHint.localized(context),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
