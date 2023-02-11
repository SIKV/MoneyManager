import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/localizations.dart';

import '../../../theme/spacings.dart';

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
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              CalendarDatePicker(
                firstDate: DateTime.utc(1995),
                initialDate: DateTime.now(),
                lastDate: DateTime.now(),
                onDateChanged: (_) {
                  // TODO: Implement.
                },
              ),
              const Divider(),
              CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                onTimerDurationChanged: (_) {
                  // TODO: Implement.
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
