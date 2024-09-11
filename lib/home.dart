import 'dart:async';

import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';

import 'db/presence.dart';
import 'model/presence_model.dart';

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
    _fetchPresenceEntries();
    _startClock();
  }

  Presence? data;
  final PresenceRepo _presenceRepo = PresenceRepo.instance;

  Future<void> _fetchPresenceEntries() async {
    try {
      data = await _presenceRepo.read("john_doe");
    } catch (e) {
      // Handle any errors that occur during data fetching
      print("Error fetching presence entries: $e");
    }
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
        "john_doe",
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
            data != null
                ? Column(
                    children: [
                      const Text("Presence Time"),
                      Text("${data!.userName}"),
                      DigitalClock(
                          format: 'Hms',
                          textScaleFactor: 2.0,
                          showSeconds: true,
                          isLive: false,
                          digitalClockTextColor: Colors.green[700]!,
                          decoration: const BoxDecoration(
                              // color: Colors.yellow,
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          datetime: data!.presenceTime),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                : SizedBox(
                    width: 10,
                  )

            // const Text("Go Home"),
            // DigitalClock(
            //     format: 'Hms',
            //     textScaleFactor: 2.0,
            //     showSeconds: true,
            //     isLive: false,
            //     digitalClockTextColor: Colors.green[700]!,
            //     decoration: const BoxDecoration(
            //         // color: Colors.yellow,
            //         shape: BoxShape.rectangle,
            //         borderRadius: BorderRadius.all(Radius.circular(15))),
            //     datetime: goHome),
          ],
        ),
      ),
    );
  }
}
