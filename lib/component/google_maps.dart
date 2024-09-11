import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => GoogleMapViewState();
}

class GoogleMapViewState extends State<GoogleMapView> {
  late double latit;
  late double longt;
  bool _locationServiceEnabled = false;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // static const CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

  @override
  void initState() {
    super.initState();
    _getLocationPermissionAndPosition();
  }

  Future<void> _getLocationPermissionAndPosition() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        latit = position.latitude;
        longt = position.longitude;
        _locationServiceEnabled = true;
      });
    } catch (e) {
      setState(() {
        _locationServiceEnabled = false;
      });
      if (kDebugMode) {
        print('Error getting location: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: _locationServiceEnabled
                ? GoogleMap(
                    markers: {
                      const Marker(
                        infoWindow: InfoWindow(title: "Mie Gacoan"),
                        markerId: MarkerId('Gacoan'),
                        position:
                            LatLng(-7.763562743392816, 110.39335519592109),
                      )
                    },
                    mapType: MapType.normal,
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(-7.763562743392816, 110.39335519592109),
                      zoom: 16,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  )
                : const Center(
                    child: Text(
                      'Waiting for location...',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     _getLocationPermissionAndPosition();
          //   },
          //   child: const Text("Refresh Location"),
          // ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: const Text('To the lake!'),
      //   icon: const Icon(Icons.directions_boat),
      // ),
    );
  }
}
