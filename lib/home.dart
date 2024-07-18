import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/api_service.dart';
import 'package:weather_app/data/repository.dart';
import 'package:weather_app/history.dart';
import 'package:weather_app/weather_bloc/weather_bloc.dart';
import 'package:weather_app/widgets/weather_empty.dart';
import 'package:weather_app/widgets/weather_error.dart';
import 'package:weather_app/widgets/weather_loading.dart';
import 'package:weather_app/widgets/weather_populated.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();
  final WeatherBloc weatherBloc = WeatherBloc(WeatherRepository(ApiClient()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      hintText: 'Ahmedabad',
                    ),
                  ),
                ),
              ),
              IconButton(
                key: const Key('searchPage_search_iconButton'),
                icon: const Icon(Icons.search, semanticLabel: 'Submit'),
                onPressed: () => {weatherBloc.add(GetLocationWeatherEvent(textController.text))},
              ),
            ],
          ),
          Expanded(
            child: BlocConsumer<WeatherBloc, WeatherState>(
              bloc: weatherBloc,
              listener: (context, state) {
                if (state is WeatherLoadedState) {
                  // context.read<ThemeCubit>().updateTheme(state.weather);
                }
              },
              builder: (context, state) {
                if (state is WeatherLoadedState) {
                  switch (state.status) {
                    case WeatherStatus.initial:
                      return const WeatherEmpty();
                    case WeatherStatus.loading:
                      return const WeatherLoading();
                    case WeatherStatus.success:
                      return WeatherPopulated(
                        weather: state.weather,
                        onRefresh: () async {
                          return;
                        },
                      );
                    case WeatherStatus.failure:
                      return const WeatherError();
                  }
                } else if (state is WeatherLoadedState) {
                  return const WeatherError();
                } else {
                  return const WeatherEmpty();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.history),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HistoryPage(),
          ),
        ),
      ),
    );
  }
}
