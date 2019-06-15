import 'package:async/async.dart';
import 'package:flutter/material.dart';

class Intro extends StatelessWidget {
  Duration duration = new Duration(seconds: 2);

  Widget build(context) {
    RestartableTimer timer = new RestartableTimer(duration, () {
      //replacement means it deletes the previous screen
      Navigator.pushReplacementNamed(context, '/');
    });

    return Scaffold(
      body: Container(
        child: Center(
          child: Text(
            'Bad Seal Studios',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Lobster', fontSize: 20.0, letterSpacing: 1.5),
          ),
        ),
      ),
    );
  }
}
