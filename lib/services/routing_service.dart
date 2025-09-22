import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RoutingService {
  static const String _osrmBaseUrl = 'http://router.project-osrm.org/route/v1/driving/';

  Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    final String url = '$_osrmBaseUrl${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final List<dynamic> coordinates = data['routes'][0]['geometry']['coordinates'];
          return coordinates.map<LatLng>((coord) => LatLng(coord[1], coord[0])).toList();
        }
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
    return [];
  }
}