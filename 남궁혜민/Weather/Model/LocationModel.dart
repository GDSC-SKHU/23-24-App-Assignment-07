import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

// jsonDecode를 사용하기 위해 import 추가
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:state_management/Weather/Model/Data/Weather.dart';

class LocationModel {
  final BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';

  // API키 발급
  String API_KEY = '8f56a6e1df81c819811b13ada11ef9d3';

  //접근 권한을 설정하는 것
  Future<bool> departminePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  // 현재위치를 가져오는 함수
  Future<String> getMyCurrentLocation1() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // 현재 위치를 가져옵니다.
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    if (position == null) {
      throw ('위치를 가져오는데 실패했습니다. ');
    }

    // 위치, 경도를 기반으로 위치 정보를 가져와서 placemarks에 저장
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    String? city = placemarks.first.locality;
    if (city == null) {
      throw Exception();
    }
    return city;
  }

  // 도시의 날씨 정보를 가져오는 함수
  Future<WeatherData> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$API_KEY&units=metric'));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return WeatherData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('위치를 통해 날씨를 가져오는 과정에서 오류 발생');
    }
  }
}
