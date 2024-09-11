import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class PlaceCircleBody extends StatefulWidget {
  const PlaceCircleBody({super.key});

  @override
  State<StatefulWidget> createState() => PlaceCircleBodyState();
}

class PlaceCircleBodyState extends State<PlaceCircleBody> {
  GoogleMapController? _controller;

  final Map<CircleId, Circle> circles = <CircleId, Circle>{
    const CircleId('Office Area'): Circle(
      circleId: const CircleId('Office Area'),
      consumeTapEvents: true,
      strokeColor: Colors.green,
      fillColor: Colors.green.withOpacity(0.5),
      strokeWidth: 3,
      center: const LatLng(-7.756449440996939, 110.40840409528828),
      //-7.756{4}49440996939  110.40885309528828
      radius: 50,
    ),
    const CircleId('Near Office'): Circle(
      circleId: const CircleId('Near Office'),
      consumeTapEvents: true,
      strokeColor: Colors.orange,
      fillColor: Colors.orange.withOpacity(0.2),
      strokeWidth: 3,
      center: const LatLng(-7.756449440996939, 110.40840409528828),
      //-7.756{4}49440996939  110.40885309528828
      radius: 100,
    )
  };

  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  double _currentZoom = 18.0;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.875,
          child: GoogleMap(
            zoomControlsEnabled: false,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: const LatLng(-7.756449440996939, 110.40840409528828),
              zoom: _currentZoom,
            ),
            circles: Set<Circle>.of(circles.values),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              _goToCurrentLocation();
            },
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Column(
            children: [
              FloatingActionButton(
                onPressed: _zoomIn,
                mini: true,
                child: const Icon(Icons.zoom_in),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                onPressed: _zoomOut,
                mini: true,
                child: const Icon(Icons.zoom_out),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _zoomIn() {
    if (_controller != null) {
      _currentZoom++;
      _controller!.animateCamera(CameraUpdate.zoomIn());
    }
  }

  void _zoomOut() {
    if (_controller != null) {
      _currentZoom--;
      _controller!.animateCamera(CameraUpdate.zoomOut());
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showError(
          'Location services are disabled. Please enable them in settings.');
      return;
    }

    // Check location permissions.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        _showError(
            'Location permissions are permanently denied. You cannot use this feature.');
        return;
      }

      if (permission == LocationPermission.denied) {
        _showError(
            'Location permissions are denied. Please grant permission to access location.');
        return;
      }
    }

    // Get current location.
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentPosition = position;
        _markers[const MarkerId('user_marker')] = Marker(
          markerId: const MarkerId('user_marker'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(title: 'Your Location'),
          // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        );
      });

      _goToCurrentLocation();
    } catch (e) {
      _showError('Failed to get current location: $e');
    }
  }

  void _goToCurrentLocation() {
    if (_currentPosition != null && _controller != null) {
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: _currentZoom,
          ),
        ),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
