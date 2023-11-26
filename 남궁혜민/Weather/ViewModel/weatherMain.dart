import 'package:state_management/Weather/Model/Data/picture.dart';
import 'package:state_management/Weather/Model/Data/weather.dart';
import 'package:state_management/Weather/Model/locationModel.dart';

class WeatherMain {
  String city = '';
  LocationModel currentLocation = LocationModel();
  WeatherData? weatherData;
  final WeatherPicture picture = WeatherPicture();

  void fetchCity() async {
    city = await currentLocation.getMyCurrentLocation1();
  }
}
