import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather.dart';

class WeatherRepository {
  // Hardcoding coordinates for demonstration purposes
  final Map<String, Map<String, double>> cityCoordinates = {
    'Paris': {'latitude': 48.8566, 'longitude': 2.3522},
    'Berlin': {'latitude': 52.52, 'longitude': 13.4050},
    'New York': {'latitude': 40.7128, 'longitude': -74.0060},
    'Tokyo': {'latitude': 35.6762, 'longitude': 139.6503},
    // You can add more cities here
  };

  Future<Weather> fetchWeather(String city) async {
    if (!cityCoordinates.containsKey(city)) {
      throw Exception('City not found');
    }

    final latitude = cityCoordinates[city]!['latitude'];
    final longitude = cityCoordinates[city]!['longitude'];

    final response = await http.get(Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&hourly=temperature_2m&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_mean&current_weather=true'));

    if (response.statusCode == 200) {
      final weatherData = json.decode(response.body);
      return Weather.fromJson(weatherData, city);
    } else {
      print('Failed to load weather: ${response.statusCode} - ${response.reasonPhrase}');
      throw Exception('Failed to load weather');
    }
  }
}
