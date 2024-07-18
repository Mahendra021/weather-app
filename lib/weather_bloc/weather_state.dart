part of 'weather_bloc.dart';

enum WeatherStatus { initial, loading, success, failure }

enum TemperatureUnits { fahrenheit, celsius }

abstract class WeatherState {
  const WeatherState();
}

// Initial TodoBloc state
class WeatherInitialState extends WeatherState {}

// TodoBloc state when the todo item list is loaded
class WeatherLoadedState extends WeatherState {
  final WeatherModel weather;
  final WeatherStatus status;
  final TemperatureUnits temperatureUnits;

  WeatherLoadedState({
    this.status = WeatherStatus.initial,
    this.temperatureUnits = TemperatureUnits.celsius,
    WeatherModel? weather,
  }) : weather = weather ?? WeatherModel.empty;

  WeatherLoadedState copyWith({
    WeatherStatus? status,
    TemperatureUnits? temperatureUnits,
    WeatherModel? weather,
  }) {
    return WeatherLoadedState(
      status: status ?? this.status,
      temperatureUnits: temperatureUnits ?? this.temperatureUnits,
      weather: weather ?? this.weather,
    );
  }
}

// TodoBloc state when a todo item errors when loading
class WeatherErrorState extends WeatherState {
  final String message;
  final WeatherStatus status;
  const WeatherErrorState(this.status, this.message);
}

class WeatherHistoryState extends WeatherState {
  final List<WeatherModel> weathers;
  const WeatherHistoryState(this.weathers);
}

class WeatherHistoryErrorState extends WeatherState {
  final String message;
  const WeatherHistoryErrorState(this.message);
}
