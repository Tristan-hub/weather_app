import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'package:weather_app/screens/detail_screen.dart';

class SearchScreen extends StatelessWidget {
  final TextEditingController cityController = TextEditingController();

  final List<String> cities = [
    'Paris, France',
    'Berlin, Germany',
    'New York, USA',
    'Tokyo, Japan',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter une ville')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.purple),
                hintText: 'Saisissez le nom d\'une ville',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final city = cityController.text.split(',')[0];
                if (city.isNotEmpty) {
                  BlocProvider.of<WeatherBloc>(context).add(FetchWeather(city));
                }
              },
              child: Text('Rechercher'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(cities[index]),
                    onTap: () {
                      final city = cities[index].split(',')[0];
                      BlocProvider.of<WeatherBloc>(context).add(FetchWeather(city));
                    },
                  );
                },
              ),
            ),
            BlocListener<WeatherBloc, WeatherState>(
              listener: (context, state) {
                if (state is WeatherLoaded) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(weather: state.weather),
                    ),
                  );
                }
              },
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoading) {
                    return CircularProgressIndicator();
                  } else if (state is WeatherError) {
                    return Text('Erreur lors de la récupération de la météo');
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
