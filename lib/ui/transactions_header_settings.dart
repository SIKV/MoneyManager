import 'package:flutter/cupertino.dart';

import '../theme/spacings.dart';
import '../theme/theme.dart';
import 'close_circle_button.dart';

class TransactionsHeaderSettings extends StatelessWidget {
  const TransactionsHeaderSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Spacings.four),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: CloseCircleButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const Text("Primary",
            style: TextStyles.titleNormal,
          ),
          const Text("Description",
            style: TextStyles.subtitleNormal,
          ),
          const SizedBox(
            height: Spacings.four,
          ),
          _buildSegmentedControl({
            0 : "Income",
            1 : "Outcome",
          }, 1),
          const SizedBox(
            height: Spacings.three,
          ),
          _buildSegmentedControl({
            0 : "Day",
            1 : "Week",
            2 : "Month",
            3 : "Year",
            4 : "All",
          }, 3),
          const SizedBox(
            height: Spacings.six,
          ),
          const Text("Secondary",
            style: TextStyles.titleNormal,
          ),
          const Text("Description",
            style: TextStyles.subtitleNormal,
          ),
          const SizedBox(
            height: Spacings.four,
          ),
          _buildSegmentedControl({
            0 : "Income",
            1 : "Outcome",
            2 : "None"
          }, 2),
          const SizedBox(
            height: Spacings.three,
          ),
          _buildSegmentedControl({
            0 : "Day",
            1 : "Week",
            2 : "Month",
            3 : "Year",
            4 : "All",
          }, null),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl(Map<int, String> options, int? groupValue) {
    return CupertinoSegmentedControl(
      children: options.map((key, value) =>
          MapEntry(key, _segmentedControlOption(value))
      ),
      groupValue: groupValue,
      onValueChanged: (_) { },
    );
  }

  Widget _segmentedControlOption(String option) {
    return Padding(
      padding: const EdgeInsets.all(Spacings.two),
      child: Text(option),
    );
  }
}
