import 'package:get/get.dart';

// 저장과 관련된 클래스
class StorageController extends GetxController {
  final List<String> weatherList = <String>[].obs.toList();

  void addWeather(String weather) {
    weatherList.add(weather);
  }

// 날씨를 지우는 함수
  void removeWeather(String weather) {
    weatherList.remove(weather);
  }

//데이터 저장하는 메소드
  void saveData(String data) {
    addWeather(data);
  }
}
