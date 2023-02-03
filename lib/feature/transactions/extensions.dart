import 'package:flutter/widgets.dart';

import '../../localizations.dart';
import 'domain/header_value.dart';

extension GetTitle on HeaderValue {

  String getTitle(BuildContext context) {
    switch (this) {
      case HeaderValue.dayIncome:
        return Strings.dayIncome.localized(context);
      case HeaderValue.dayExpenses:
        return Strings.dayExpenses.localized(context);
      case HeaderValue.weekIncome:
        return Strings.weekIncome.localized(context);
      case HeaderValue.weekExpenses:
        return Strings.weekExpenses.localized(context);
      case HeaderValue.monthIncome:
        return Strings.monthIncome.localized(context);
      case HeaderValue.monthExpenses:
        return Strings.monthExpenses.localized(context);
      case HeaderValue.yearIncome:
        return Strings.yearIncome.localized(context);
      case HeaderValue.yearExpenses:
        return Strings.yearExpenses.localized(context);
    }
  }
}
