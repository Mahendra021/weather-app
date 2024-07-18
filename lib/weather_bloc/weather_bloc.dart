import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weather_app/data/model.dart';
import 'package:weather_app/data/repository.dart';

part 'weather_state.dart';

abstract class WeatherEvent {}

final class GetLocationWeatherEvent extends WeatherEvent {
  final String location;
  GetLocationWeatherEvent(this.location);
}

final class GetWeatherHistoryEvent extends WeatherEvent {
  GetWeatherHistoryEvent();
}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  WeatherBloc(this.weatherRepository) : super(WeatherInitialState()) {
    on<GetLocationWeatherEvent>((event, emit) async {
      try {
        emit(WeatherLoadedState(status: WeatherStatus.loading, weather: WeatherModel.empty));
        final weather = await weatherRepository.getWeather(event.location);
        firebaseFirestore.collection("Weather").add(weather.toJson());
        emit(
          WeatherLoadedState(
            status: WeatherStatus.success,
            weather: weather,
          ),
        );
      } on Exception {
        emit(const WeatherErrorState(WeatherStatus.success, "Something want wrong"));
      }
    });
    on<GetWeatherHistoryEvent>((event, emit) async {
      try {
        final weathers = await firebaseFirestore.collection("Weather").get();
        List<WeatherModel> weatherList =
            List<WeatherModel>.from(weathers.docs.map((x) => WeatherModel.fromJson(x.data())));
        weatherList.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
        emit(
          WeatherHistoryState(weatherList),
        );
      } on Exception {
        emit(const WeatherHistoryErrorState("Something want wrong"));
      }
    });
  }
}
