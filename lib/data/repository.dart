import 'package:weather_app/data/api_service.dart';
import 'package:weather_app/data/model.dart';

class WeatherRepository {
  WeatherRepository(apiClient) : apiClient = apiClient ?? ApiClient();

  final ApiClient apiClient;

  Future<WeatherModel> getWeather(String city) async {
    final location = await apiClient.locationSearch(city);
    final weather = await apiClient.getWeather(
      latitude: location.latitude,
      longitude: location.longitude,
    );
    return WeatherModel(
      temperature: weather.temperature,
      location: location.name,
      condition: weather.weatherCode.toInt().toCondition,
      lastUpdated: DateTime.now(),
    );
  }
}

extension on int {
  String get toCondition {
    switch (this) {
      case 0:
        return "clear";
      case 1:
      case 2:
      case 3:
      case 45:
      case 48:
        return "cloudy";
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
      case 95:
      case 96:
      case 99:
        return "rainy";
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return "snowy";
      default:
        return "unknown";
    }
  }
}
