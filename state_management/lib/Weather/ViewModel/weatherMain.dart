import 'package:state_management/Weather/Model/Data/picture.dart';
import 'package:state_management/Weather/Model/Data/weather.dart';
import 'package:state_management/Weather/Model/locationModel.dart';

class WeatherMain {
  // search할 떄 나올 것 정리

  /*void getWeatherData() async {
    HttpHelper helper = HttpHelpers();
    result = await helper.getCurrentLocation1();
  }*/
  String city = '';
  LocationModel currentLocation = LocationModel();
  WeatherData? weatherData;
  final WeatherPicture picture = WeatherPicture();

// 현재 위치를 기반으로 위도와 경도를 받아와서 도시를 출력-? 이게 아마 필요없을 수 도 있을 거 같음
  void fetchCity() async {
    city = await currentLocation.getMyCurrentLocation1();
  }
}
