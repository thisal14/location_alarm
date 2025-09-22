import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class GeocodingService {
  static const String _nominatimUrl = 'https://nominatim.openstreetmap.org/search';

  Future<List<NominatimResult>> search(String query) async {
    if (query.isEmpty) return [];

    final uri = Uri.parse('$_nominatimUrl?q=$query&format=json&limit=10');
    final response = await http.get(uri, headers: {'User-Agent': 'LocationAlarmApp/1.0'});

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => NominatimResult.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load location suggestions');
    }
  }
}

class NominatimResult {
  final String displayName;
  final LatLng latLng;

  NominatimResult({
    required this.displayName,
    required this.latLng,
  });

  factory NominatimResult.fromJson(Map<String, dynamic> json) {
    return NominatimResult(
      displayName: json['display_name'],
      latLng: LatLng(double.parse(json['lat']), double.parse(json['lon'])),
    );
  }
}