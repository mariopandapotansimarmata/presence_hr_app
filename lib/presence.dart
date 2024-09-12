import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:presence_hr_app/db/presence.dart';
import 'package:presence_hr_app/model/presence_model.dart';
import 'component/google_maps.dart';

class PresencePage extends StatefulWidget {
  const PresencePage({super.key});

  @override
  State<PresencePage> createState() => _PresencePageState();
}

class _PresencePageState extends State<PresencePage> {
  final double officeLat = -7.756449440996939;
  final double officeLong = 110.40840409528828;
  final double radius = 50.0; // Radius in meters

  Presence? data;
  final PresenceRepo _presenceRepo = PresenceRepo.instance;

  Future<void> _fetchPresenceEntries() async {
    try {
      final fetchedData = await _presenceRepo.read("john_doe");
      setState(() {
        data = fetchedData;
      });
    } catch (e) {
      print("Error fetching presence entries: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPresenceEntries();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              PlaceCircleBody(),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  try {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);

                    double distanceInMeters = Geolocator.distanceBetween(
                      officeLat,
                      officeLong,
                      position.latitude,
                      position.longitude,
                    );

                    if (distanceInMeters <= radius) {
                      if (data == null) {
                        // Create new presence
                        final newPresence = Presence(
                          presenceId: Random().nextInt(
                              500), // Consider a more robust ID generation method
                          userName: "john_doe",
                          presenceTime: DateTime.now(),
                          goHomeTime: null,
                          latitude: position.latitude,
                          longitude: position.longitude,
                        );
                        await _presenceRepo.create(newPresence);
                        print("Presence berhasil");
                      } else {
                        // Update existing presence
                        final updatedPresence = Presence(
                          presenceId: data!.presenceId,
                          userName: data!.userName,
                          presenceTime: data!.presenceTime,
                          goHomeTime: DateTime.now(),
                          latitude: data!.latitude,
                          longitude: data!.longitude,
                        );
                        await _presenceRepo.update(updatedPresence);
                        print(updatedPresence.goHomeTime);
                        print("Go Home berhasil");
                      }
                    } else {
                      print("Di luar radius absensi");
                    }
                  } catch (e) {
                    print("Error during presence update: $e");
                  }
                },
                child: Text(data == null ? "Presence" : "Go Home"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
