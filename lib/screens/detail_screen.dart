import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                  style: TextStyle(fontSize: 40, color: Colors.purple),
                ),
                Spacer(),
                SvgPicture.asset(
                  'assets/icons/sunlight.svg',
                  color: Colors.purple,
                  width: 50,
                  height: 50,
                ),
              ],
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(text: 'Aujourd\'hui, le temps est '),
                  TextSpan(text: weather.description, style: TextStyle(color: Colors.purple)),
                  TextSpan(text: '. Il y aura une minimale de '),
                  TextSpan(text: '${weather.dailyForecasts[0].minTemp}°C', style: TextStyle(color: Colors.purple)),
                  TextSpan(text: ' et un maximum de '),
                  TextSpan(text: '${weather.dailyForecasts[0].maxTemp}°C', style: TextStyle(color: Colors.purple)),
                  TextSpan(text: '.'),
                ],
              ),
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
          DateFormat('EEEE', 'fr_FR').format(DateTime.now()), // Affiche le jour actuel en français
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
                    Text(time, style: TextStyle(fontSize: 16)), // Affiche l'heure en couleur par défaut
                    SizedBox(height: 5),
                    SvgPicture.asset(
                      'assets/icons/sunlight.svg',
                      color: Color.fromARGB(255, 99, 99, 99),
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(height: 5),
                    Text('${temp}°', style: TextStyle(fontSize: 16, color: Colors.purple)), // Affiche la température en violet
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
              SvgPicture.asset(
                'assets/icons/sunlight.svg',
                color: Color.fromARGB(255, 99, 99, 99),
                width: 30,
                height: 30,
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
            _buildInfoColumn('Chances de pluie', '${weather.chanceOfRain}%', 'assets/icons/rain-drops-3.svg', Colors.purple),
            _buildInfoColumn('Taux d\'humidité', '${weather.humidity}%', 'assets/icons/rain.svg', Colors.purple),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildInfoColumn('Vent', 'NE ${weather.windSpeed} km/h', 'assets/icons/windy-1.svg', Colors.purple),
            _buildInfoColumn('Température ressentie', '${weather.feelsLike}°C', 'assets/icons/direction-1.svg', Colors.purple),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoColumn(String title, String value, String iconPath, Color color) {
    return Column(
      children: [
        SvgPicture.asset(iconPath, width: 30, height: 30),
        SizedBox(height: 10),
        Text(title, style: TextStyle(fontSize: 16)),
        SizedBox(height: 5),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
