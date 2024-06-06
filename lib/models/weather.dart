class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final double windSpeed;
  final int humidity;
  final double feelsLike;
  final List<double> hourlyTemperatures;
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
    required this.dailyForecasts,
    required this.chanceOfRain,
  });

  factory Weather.fromJson(Map<String, dynamic> json, String city) {
    List<double> hourlyTemps = (json['hourly']['temperature_2m'] as List).map((e) => (e ?? 0.0) as double).toList();
    List<DailyForecast> dailyForecasts = [];
    for (int i = 0; i < json['daily']['temperature_2m_max'].length; i++) {
      dailyForecasts.add(DailyForecast(
        day: "Jour $i", // Vous pouvez adapter cette partie pour les vrais jours
        minTemp: (json['daily']['temperature_2m_min'][i] ?? 0.0) as double,
        maxTemp: (json['daily']['temperature_2m_max'][i] ?? 0.0) as double,
      ));
    }

    return Weather(
      cityName: city,
      temperature: (json['hourly']['temperature_2m'][0] ?? 0.0) as double,
      description: 'Ensoleillé', // Modifier selon les données réelles
      windSpeed: (json['current_weather']['windspeed'] ?? 0.0) as double,
      humidity: (json['current_weather']['humidity'] ?? 0) as int,
      feelsLike: (json['hourly']['temperature_2m'][0] ?? 0.0) as double, // Remplacer par les données réelles si disponibles
      hourlyTemperatures: hourlyTemps,
      dailyForecasts: dailyForecasts,
      chanceOfRain: (json['daily']['precipitation_probability_mean'][0] ?? 0) as int,
    );
  }
}

class DailyForecast {
  final String day;
  final double minTemp;
  final double maxTemp;

  DailyForecast({
    required this.day,
    required this.minTemp,
    required this.maxTemp,
  });
}
