import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart'; // Changed from google_maps_flutter
import '../models/location_model.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  StreamSubscription<Position>? _positionStream;
  final StreamController<LocationData> _locationController = 
      StreamController<LocationData>.broadcast();

  Stream<LocationData> get locationStream => _locationController.stream;

  Future<LocationData?> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return LocationData.fromPosition(position);
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  void startLocationTracking() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _locationController.add(LocationData.fromPosition(position));
    });
  }

  void stopLocationTracking() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  double calculateDistance(LocationData from, LatLng to) {
    return Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
  }

  void dispose() {
    _positionStream?.cancel();
    _locationController.close();
  }
}