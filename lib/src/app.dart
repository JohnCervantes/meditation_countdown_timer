import 'package:flutter/material.dart';
import 'package:timer/src/screens/countdown_screen.dart';
import 'package:timer/src/screens/intro_screen.dart';

class App extends StatelessWidget {
  bool seen = false;
  Widget build(context) {
    return MaterialApp(
      title: 'Meditation Countdown Timer',
      onGenerateRoute: routes,
    );
  }

  Route routes(RouteSettings settings) {
//switch case sample
// switch(settings.name){
//   case '/': something()
// }
    if (settings.name == '/') {
      if (seen == false) {
        return MaterialPageRoute(builder: (context) {
          seen = true;
          return Intro();
        });
      } else {
        return MaterialPageRoute(builder: (context) {
          return Countdown();
        });
      }
    }
  }
}
