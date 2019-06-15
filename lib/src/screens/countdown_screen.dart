import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiver/async.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:screen/screen.dart';

class Countdown extends StatefulWidget {
  @override
  CountdownState createState() => new CountdownState();
}

class CountdownState extends State<Countdown> {
  bool playing = false;
  final stepInSeconds = 1;
  double value = 0.0;
  double sliderValue = 0.0;
  Duration latestNumber;
  double temp;
  StreamSubscription<CountdownTimer> sub;

  onChanged(double value) {
    setState(() {
      this.value = value;
      this.sliderValue = value;
    });
  }

  setupCountdownTimer(int timeOutinSeconds) {
    CountdownTimer countDownTimer = new CountdownTimer(
        new Duration(seconds: timeOutinSeconds),
        new Duration(seconds: stepInSeconds));

    sub = countDownTimer.listen(null);

    sub.onData((duration) {
      timeOutinSeconds -= stepInSeconds;
      this.onTimerTick(timeOutinSeconds.toDouble());
    });

    sub.onDone(() {
      setState(() {
        AudioCache player = new AudioCache();
        player.play('alarm.wav');
        playing = false;
      });
      sub.cancel();
    });
  }

  void onTimerTick(double currentNumber) {
    setState(() {
      this.value = (currentNumber / 60) / 60;
      this.sliderValue = currentNumber / temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    Screen.keepOn(true);
    latestNumber = new Duration(seconds: ((this.value * 60) * 60).round());
    return Scaffold(
        body: Center(
      child: Container(
        color: Colors.blueAccent[50],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
               margin: EdgeInsets.all(40.0),
              child: Text(
                "${(latestNumber.inHours)}" +
                    ":" +
                    "${(latestNumber.inMinutes) % 60}".padLeft(2, '0') +
                    ":" +
                    "${latestNumber.inSeconds % 60}".padLeft(2, '0'),
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 40.0,
                    fontFamily: 'Major Mono'),
              ),
            ),
            Container(
              child: Slider(
                value: this.sliderValue,
                onChanged: onChanged,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () {
                    if (this.value > 0.0) {
                      if (playing == false) {
                        setState(() {
                          playing = true;
                          temp = latestNumber.inSeconds.toDouble();
                          setupCountdownTimer(latestNumber.inSeconds);
                        });
                      } else if (playing == true) {
                        setState(() {
                          playing = false;
                          sub.pause();
                        });
                      }
                    }
                  },
                  child: playing ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                ),
                Container(width: 30.0),
                FloatingActionButton(
                    backgroundColor: Colors.redAccent,
                    child: Icon(Icons.refresh),
                    onPressed: () {
                      if (playing) {
                        sub.cancel();
                      }
                      setState(() {
                        this.value = 0.0;
                        this.sliderValue = 0.0;
                        playing = false;
                      });
                    }),
              ],
            ),
            Container(
              child: playing == false
                  ? FadeInImage(
                      placeholder: AssetImage('assets/transparent.png'),
                      image: AssetImage('assets/seal0.png'))
                  : FadeInImage(
                      placeholder: AssetImage('assets/seal0.png'),
                      image: AssetImage('assets/seal.gif')),
            )
          ],
        ),
      ),
    ));
  }
}
