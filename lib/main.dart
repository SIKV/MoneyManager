import 'package:flutter/material.dart';
import 'ui/home_page.dart';

void main() {
  runApp(const App());
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
        DefaultWidgetsLocalizations.delegate,
        DefaultMaterialLocalizations.delegate
      ],
    );
  }
}
