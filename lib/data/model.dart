class LocationResponse {
  int id;
  String name;
  double latitude;
  double longitude;

  LocationResponse({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory LocationResponse.fromJson(Map<String, dynamic> json) => LocationResponse(
        id: json["id"],
        name: json["name"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
      };
}

class WeatherResponse {
  double temperature;
  double weatherCode;

  WeatherResponse({
    required this.temperature,
    required this.weatherCode,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) => WeatherResponse(
        temperature: json["temperature"]?.toDouble(),
        weatherCode: json["weathercode"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "temperature": temperature,
        "weathercode": weatherCode,
      };
}

class WeatherModel {
  String location;
  double temperature;
  String condition;
  DateTime lastUpdated;

  WeatherModel({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.lastUpdated,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
        location: json["location"],
        temperature: json["temperature"]?.toDouble(),
        condition: json["condition"],
        lastUpdated: DateTime.parse(json["lastUpdated"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location,
        "temperature": temperature,
        "condition": condition,
        "lastUpdated": lastUpdated.toIso8601String(),
      };

  static final empty = WeatherModel(
    condition: "",
    temperature: 0.0,
    location: "",
    lastUpdated: DateTime(0),
  );
}
