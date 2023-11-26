class WeatherData {
  final String cityName;
  final double temp;
  final int condition;
  final String conditionText;

  WeatherData({
    required this.cityName,
    required this.temp,
    required this.condition,
    required this.conditionText,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['name'],
      temp: json['main']['temp'],
      condition: json['weather'][0]['id'],
      conditionText: json['weather'][0]['main'],
    );
  }
}
