import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';
import '../services/geocoding_service.dart';
import '../services/routing_service.dart';
import '../services/alarm_service.dart';
import '../models/location_model.dart';
import '../models/alarm_settings.dart';
import '../widgets/control_panel.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final GeocodingService _geocodingService = GeocodingService();
  final RoutingService _routingService = RoutingService();
  final AlarmService _alarmService = AlarmService();

  LocationData? _currentLocation;
  Destination? _destination;
  List<NominatimResult> _searchResults = [];
  Timer? _debounce;
  double? _distanceToDestination;
  List<LatLng> _routePoints = [];
  bool _isJourneyActive = false;
  AlarmSettings _alarmSettings = AlarmSettings();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    LocationService().startLocationTracking();
    LocationService().locationStream.listen((location) {
      setState(() {
        _currentLocation = location;
        _updateDistanceAndRoute();
        if (_destination == null) {
          _mapController.move(location.latLng, _mapController.zoom);
        }
        _checkAlarmTrigger();
      });
    });
  }

  Future<void> _getCurrentLocation() async {
    final location = await LocationService().getCurrentLocation();
    if (location != null) {
      setState(() {
        _currentLocation = location;
        _mapController.move(location.latLng, 15.0);
        _updateDistanceAndRoute();
      });
    }
  }

  void _setDestination(LatLng latLng) {
    setState(() {
      _destination = Destination(position: latLng, createdAt: DateTime.now());
      _mapController.move(latLng, 15.0);
      _searchResults = []; // Clear search results after setting destination
      _searchController.clear();
      _updateDistanceAndRoute();
    });
  }

  void _updateDistanceAndRoute() async {
    if (_currentLocation != null && _destination != null) {
      _distanceToDestination = LocationService().calculateDistance(
        _currentLocation!,
        _destination!.position,
      );
      _routePoints = await _routingService.getRoute(
        _currentLocation!.latLng,
        _destination!.position,
      );
    } else {
      _distanceToDestination = null;
      _routePoints = [];
    }
    setState(() {}); // Trigger rebuild to update UI
  }

  void _checkAlarmTrigger() {
    if (_isJourneyActive && _distanceToDestination != null && _destination != null) {
      if (_distanceToDestination! <= _alarmSettings.alertDistance) {
        _alarmService.triggerAlarm(_alarmSettings);
        // Optionally, stop the journey or show a notification here
        // For now, let's just stop the journey after triggering
        _stopJourney();
      }
    }
  }

  void _startJourney() {
    if (_destination == null) {
      // Show a message to the user to set a destination first
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set a destination first!')),
      );
      return;
    }
    setState(() {
      _isJourneyActive = true;
    });
    _checkAlarmTrigger(); // Check immediately in case already at destination
  }

  void _stopJourney() {
    setState(() {
      _isJourneyActive = false;
    });
    _alarmService.stopAlarm();
  }

  void _onAlarmSettingsChanged(AlarmSettings newSettings) {
    setState(() {
      _alarmSettings = newSettings;
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isNotEmpty) {
        try {
          final results = await _geocodingService.search(query);
          setState(() {
            _searchResults = results;
          });
        } catch (e) {
          print('Error searching: $e');
          setState(() {
            _searchResults = [];
          });
        }
      } else {
        setState(() {
          _searchResults = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Alarm'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation?.latLng ?? LatLng(0, 0),
              initialZoom: 15.0,
              onLongPress: (tapPosition, latLng) => _setDestination(latLng),
            ),
            children: [
              TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _routePoints,
                    strokeWidth: 4.0,
                    color: Colors.blue,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  if (_currentLocation != null)
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _currentLocation!.latLng,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.blueAccent,
                        size: 40.0,
                      ),
                    ),
                  if (_destination != null)
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _destination!.position,
                      child: const Icon(
                        Icons.flag,
                        color: Colors.redAccent,
                        size: 40.0,
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search location...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
                if (_searchResults.isNotEmpty)
                  Container(
                    constraints: BoxConstraints(maxHeight: 200),
                    color: Colors.white.withOpacity(0.9),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final result = _searchResults[index];
                        return ListTile(
                          title: Text(result.displayName),
                          onTap: () {
                            _setDestination(result.latLng);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          if (_distanceToDestination != null)
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.black54,
                child: Text(
                  'Distance to destination: ${(_distanceToDestination! / 1000).toStringAsFixed(2)} km',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          Positioned(
            bottom: _distanceToDestination != null ? 70 : 10,
            left: 10,
            right: 10,
            child: ControlPanel(
              settings: _alarmSettings,
              isTrackingActive: _isJourneyActive,
              onStartTracking: _startJourney,
              onStopTracking: _stopJourney,
              onSettingsChanged: _onAlarmSettingsChanged,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    LocationService().stopLocationTracking();
    LocationService().dispose();
    _alarmService.dispose();
    super.dispose();
  }
}