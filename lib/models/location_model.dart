import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class LocationData {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  LatLng get latLng => LatLng(latitude, longitude);

  factory LocationData.fromPosition(Position position) {
    return LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: position.timestamp ?? DateTime.now(),
    );
  }
}

class Destination {
  final LatLng position;
  final String? name;
  final DateTime createdAt;

  Destination({
    required this.position,
    this.name,
    required this.createdAt,
  });
}