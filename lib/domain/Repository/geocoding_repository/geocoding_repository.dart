import 'dart:convert';
import 'package:flutter_application_evdeai/domain/API/googleMapApi.dart';
import 'package:http/http.dart' as http;

class GeocodingService {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/geocode/json';
  static const String _apiKey = GoogleMapApi;

  static Future<Map<String, double>?> getLocationFromAddress(
      String address) async {
    try {
      final encodedAddress = Uri.encodeComponent(address);
      final url = '$_baseUrl?address=$encodedAddress&key=$_apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK') {
          final results = data['results'];
          if (results != null && results.isNotEmpty) {
            final location = results[0]['geometry']['location'];
            if (location != null) {
              return {
                'latitude': location['lat'],
                'longitude': location['lng'],
              };
            } else {
              print("Error: No location found in response");
            }
          } else {
            print("Error: No results found in response");
          }
        } else {
          print(
              "Error: ${data['status']} - ${data['error_message'] ?? 'No error message provided'}");
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }
}
