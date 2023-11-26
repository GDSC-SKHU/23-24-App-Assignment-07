import 'package:flutter/material.dart';

// 날씨마다 다르게 이미지 올리기
class WeatherPicture {
  Widget? getWeatherIcon(int condition) {
    if (condition < 300) {
      return Image.asset(
        'assets/images/weather_rain.png',
        width: 100,
        height: 100,
      );
    } else if (condition < 600) {
      return Image.asset(
        'assets/images/weather_snow.png',
        width: 100,
        height: 100,
      );
    } else if (condition == 800) {
      return Image.asset(
        'assets/images/weather_sunny.png',
        width: 100,
        height: 100,
      );
    } else if (condition <= 804) {
      return Image.asset(
        'assets/images/weather_cloud.png',
        width: 100,
        height: 100,
      );
    }
    return null;
  }
}
