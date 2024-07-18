import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/api_service.dart';
import 'package:weather_app/data/repository.dart';
import 'package:weather_app/weather_bloc/weather_bloc.dart';
import 'package:weather_app/widgets/weather_error.dart';
import 'package:weather_app/widgets/weather_loading.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final WeatherBloc weatherBloc = WeatherBloc(WeatherRepository(ApiClient()));

  @override
  void initState() {
    weatherBloc.add(GetWeatherHistoryEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History")),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        bloc: weatherBloc,
        builder: (context, state) {
          if (state is WeatherHistoryState) {
            return ListView.builder(
              itemCount: state.weathers.length,
              itemBuilder: (context, index) => ListTile(
                leading: SizedBox(
                  width: 100,
                  child: Text(
                    state.weathers[index].location,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                title: Text(
                  state.weathers[index].condition,
                ),
                subtitle:
                    Text("${state.weathers[index].temperature.toStringAsPrecision(2)}°${'C'}"),
                trailing: Text(
                  TimeOfDay.fromDateTime(state.weathers[index].lastUpdated).format(context),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            );
          } else if (state is WeatherHistoryErrorState) {
            return const Center(child: WeatherError());
          } else {
            return const Center(child: WeatherLoading());
          }
        },
      ),
    );
  }
}
