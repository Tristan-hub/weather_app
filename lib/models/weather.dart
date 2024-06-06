import 'package:intl/intl.dart';

class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final double windSpeed;
  final int humidity;
  final double feelsLike;
  final List<double> hourlyTemperatures;
  final List<String> hourlyTimes;
  final List<DailyForecast> dailyForecasts;
  final int chanceOfRain;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.windSpeed,
    required this.humidity,
    required this.feelsLike,
    required this.hourlyTemperatures,
    required this.hourlyTimes,
    required this.dailyForecasts,
    required this.chanceOfRain,
  });

  factory Weather.fromJson(Map<String, dynamic> json, String city) {
    List<double> hourlyTemps = (json['hourly']['temperature_2m'] as List).map((e) => (e ?? 0.0) as double).toList();
    List<String> hourlyTimes = (json['hourly']['time'] as List).map((e) => e.toString()).toList();
    List<DailyForecast> dailyForecasts = [];
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    for (int i = 0; i < json['daily']['temperature_2m_max'].length; i++) {
      String dateString = json['daily']['time'][i];
      DateTime date = dateFormat.parse(dateString);
      dailyForecasts.add(DailyForecast(
        date: date,
        minTemp: (json['daily']['temperature_2m_min'][i] ?? 0.0) as double,
        maxTemp: (json['daily']['temperature_2m_max'][i] ?? 0.0) as double,
      ));
    }

    return Weather(
      cityName: city,
      temperature: (json['current_weather']['temperature'] ?? 0.0) as double,
      description: (json['current_weather']['weathercode'] ?? 'Ensoleillé').toString(), // Modifier selon les données réelles
      windSpeed: (json['current_weather']['windspeed'] ?? 0.0) as double,
      humidity: (json['current_weather']['humidity'] ?? 0) as int,
      feelsLike: (json['current_weather']['temperature'] ?? 0.0) as double, // Remplacer par les données réelles si disponibles
      hourlyTemperatures: hourlyTemps,
      hourlyTimes: hourlyTimes,
      dailyForecasts: dailyForecasts,
      chanceOfRain: (json['daily']['precipitation_probability_mean'][0] ?? 0) as int,
    );
  }
}

class DailyForecast {
  final DateTime date;
  final double minTemp;
  final double maxTemp;

  DailyForecast({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
  });

  String get day => DateFormat('EEEE', 'fr_FR').format(date); // Renvoie le nom du jour en français (e.g., "lundi")
}
