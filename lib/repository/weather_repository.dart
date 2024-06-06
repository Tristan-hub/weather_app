import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather.dart';

class WeatherRepository {
  final String geoCodingApiUrl = 'https://api.open-meteo.com/v1/forecast?latitude=';

  Future<Map<String, double>> fetchCoordinates(String city) async {
    // Here you should use a geocoding API to convert city names to coordinates
    // For the sake of example, we will hardcode coordinates for now.
    final coordinates = {
      'Paris': {'latitude': 48.8566, 'longitude': 2.3522},
      'Berlin': {'latitude': 52.52, 'longitude': 13.41},
      'New York': {'latitude': 40.7128, 'longitude': -74.0060},
      'Tokyo': {'latitude': 35.6762, 'longitude': 139.6503},
    };

    if (!coordinates.containsKey(city)) {
      throw Exception('City not found');
    }

    return coordinates[city]!;
  }

  Future<Weather> fetchWeather(String city) async {
    final coordinates = await fetchCoordinates(city);
    final latitude = coordinates['latitude'];
    final longitude = coordinates['longitude'];

    final response = await http.get(Uri.parse(
        '$geoCodingApiUrl$latitude&longitude=$longitude&hourly=temperature_2m&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_mean&current_weather=true'));

    if (response.statusCode == 200) {
      final weatherData = json.decode(response.body);
      return Weather.fromJson(weatherData, city);
    } else {
      print('Failed to load weather: ${response.statusCode} - ${response.reasonPhrase}');
      throw Exception('Failed to load weather');
    }
  }
}
