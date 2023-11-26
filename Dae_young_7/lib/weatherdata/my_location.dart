import 'package:geolocator/geolocator.dart';

class MyLocation {
  double? latitudenow;
  double? longitudenow;

  Future<void> getMyCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          //position 위도 경도 정보담긴다
          desiredAccuracy: LocationAccuracy.high);
      latitudenow = position.latitude;
      longitudenow = position.longitude;
      print(latitudenow);
      print(longitudenow);
    } catch (e) {
      print('인터넷 문제');
    }
  }
}
