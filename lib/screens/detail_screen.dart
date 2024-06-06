import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  final Weather weather;

  DetailScreen({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(weather.cityName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrentWeatherCard(),
            SizedBox(height: 20),
            _buildHourlyForecast(),
            SizedBox(height: 20),
            _buildDailyForecast(),
            SizedBox(height: 20),
            _buildAdditionalInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentWeatherCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              weather.description,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '${weather.temperature}°',
                  style: TextStyle(fontSize: 40),
                ),
                Spacer(),
                Icon(
                  Icons.wb_sunny,
                  color: Colors.orange,
                  size: 50,
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Aujourd\'hui, le temps est ${weather.description}. '
              'Il y aura une minimale de ${weather.dailyForecasts[0].minTemp}°C et un maximum de ${weather.dailyForecasts[0].maxTemp}°C.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHourlyForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('EEEE', 'fr_FR').format(DateTime.now()),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(weather.hourlyTemperatures.length, (index) {
              final time = DateFormat('HH:mm').format(DateTime.parse(weather.hourlyTimes[index]));
              final temp = weather.hourlyTemperatures[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Text(time, style: TextStyle(fontSize: 16)), 
                    SizedBox(height: 5),
                    Icon(
                      Icons.wb_sunny,
                      color: Colors.orange,
                      size: 30,
                    ),
                    SizedBox(height: 5),
                    Text('${temp}°', style: TextStyle(fontSize: 16)), 
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: weather.dailyForecasts.map((forecast) {
        return _buildDailyForecastRow(forecast.day, forecast);
      }).toList(),
    );
  }

  Widget _buildDailyForecastRow(String day, DailyForecast forecast) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day, style: TextStyle(fontSize: 18)),
          Row(
            children: [
              Icon(
                Icons.wb_sunny,
                color: Colors.orange,
              ),
              SizedBox(width: 10),
              Text('${forecast.minTemp}° ${forecast.maxTemp}°'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plus d\'infos',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildInfoColumn('Chances de pluie', '${weather.chanceOfRain}%', Icons.grain),
            _buildInfoColumn('Taux d\'humidité', '${weather.humidity}%', Icons.water),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildInfoColumn('Vent', 'NE ${weather.windSpeed} km/h', Icons.air),
            _buildInfoColumn('Température ressentie', '${weather.feelsLike}°C', Icons.thermostat),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoColumn(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.black),
        SizedBox(height: 10),
        Text(title, style: TextStyle(fontSize: 16)),
        SizedBox(height: 5),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
