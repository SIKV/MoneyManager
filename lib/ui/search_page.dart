import 'package:flutter/material.dart';

import '../localizations.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(Strings.searchPageTitle.localized(context)),
    );
  }
}
