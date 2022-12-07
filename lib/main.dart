import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/localizations.dart';

import 'ui/home_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  Route? onGenerateRoute(RouteSettings settings) {
    Route? page;

    switch (settings.name) {
      case '/':
        page = PageRouteBuilder(
            pageBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return const HomePage();
            }
        );
    }

    return page;
  }

  Route onUnknownRoute(RouteSettings settings) {
    return PageRouteBuilder(
        pageBuilder: (BuildContext context,
            Animation<double> animation, Animation<double> secondaryAnimation) {
          return Container();
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      onGenerateRoute: onGenerateRoute,
      onUnknownRoute: onUnknownRoute,
      textStyle: const TextStyle(),
      color: Colors.lightBlue,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('uk', ''),
      ],
    );
  }
}
