import 'dart:async';

import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime _dateTime = DateTime.now();
  DateTime timePresent = DateTime.now();
  DateTime goHome = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startClock();
  }

  void _startClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _dateTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "Mario Pandapotan Simarmata",
        style: TextStyle(fontSize: 18),
      )),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Now"),
            DigitalClock(
                format: 'Hms',
                textScaleFactor: 2.0,
                showSeconds: true,
                isLive: true,
                digitalClockTextColor: Colors.black,
                decoration: const BoxDecoration(
                    // color: Colors.yellow,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                datetime: _dateTime),
            const SizedBox(
              height: 20,
            ),
            const Text("Presence"),
            DigitalClock(
                format: 'Hms',
                textScaleFactor: 2.0,
                showSeconds: true,
                isLive: false,
                digitalClockTextColor: Colors.green[700]!,
                decoration: const BoxDecoration(
                    // color: Colors.yellow,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                datetime: timePresent),
            const SizedBox(
              height: 20,
            ),
            const Text("Go Home"),
            DigitalClock(
                format: 'Hms',
                textScaleFactor: 2.0,
                showSeconds: true,
                isLive: false,
                digitalClockTextColor: Colors.green[700]!,
                decoration: const BoxDecoration(
                    // color: Colors.yellow,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                datetime: goHome),
          ],
        ),
      ),
    );
  }
}
