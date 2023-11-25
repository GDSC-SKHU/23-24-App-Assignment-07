import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class Weather extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();
}

class Controller extends GetxController {
  String locationState = ''; // 위치
  String tempData = ''; // 현재 날씨 상태를 저장하는 변수
  String timeState = ''; // 현재 시간의 상태를 저장하는 변수
  List<dynamic> buffer = []; // 현재 시간, 위치, 날씨 정보를 리스트에 저장할 변수

  String locationMessage = '';

  List<dynamic> buffer2 = []; // 특정 지역의 정보를 저장할 변수

  void saveState(Function(String, String, String) updateState) { //위치, 날씨 상태 현재시간 상태를 저장할 함수
    buffer.add(locationState);
    buffer.add(tempData);
    buffer.add(timeState);
    updateState(locationState, tempData, timeState);
    print(buffer);
  }
  void newyorkState(Function(String) updateState2){ //  뉴욕 지역정보를 저장하고 해당 지역의 정보를 받아올 함수
    // 뉴욕의 위도와 경도 값 설정
    double newYorkLatitude = 40.7128;
    double newYorkLongitude = -74.0060;
    locationMessage = "뉴욕의 위치 - 위도: $newYorkLatitude, 경도: $newYorkLongitude";

    buffer2.add(locationMessage);
    updateState2(locationMessage);
    print(buffer2);

  }

}

class _WeatherState extends State<Weather> {
  String weatherState = ''; // 현재 온도의 상태를 저장하는 변수
  String API_KEY = '5a271a50327b9a021ef3cc5f04d3ca02'; // 날씨 API키 저장
  IconData weatherIcon = Icons.cloud;

  final Controller _controller = Controller();

  // 위치 정보를 가져오는 비동기 함수
  Future<void> getPosition() async {
    print('Getting position...');
    // 위치 권한 요청
    LocationPermission permission = await Geolocator.requestPermission();
    // 위치 권한에 따라 처리
    if (permission == LocationPermission.denied) {
      // 위치 권한이 거부된 경우
      print('Location permission denied');
    } else if (permission == LocationPermission.deniedForever) {
      // 위치 권한이 영구적으로 거부된 경우
      print('Location permission denied forever');
    } else {
      // 위치 권한이 허용된 경우
      print('Location permission granted');
    }
    // 사용자의 현재 위치를 얻은 다음 해당 위치의 날씨 정보를 가져옴
    var currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    getWeather(lat: currentPosition.latitude.toString(), lon: currentPosition.longitude.toString());
  }

  Future<void> getWeather({required String lat, required String lon}) async {
    print('Getting weather...');
    var response = await http.get(
      Uri.parse('http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$API_KEY&units=metric'),
    );

    // HTTP 응답의 상태 코드가 200인지 확인
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      DateTime currentTime = DateTime.now();
      _controller.timeState = currentTime.toString();
      setState(() {
        _controller.locationState = '${data['name']}';
        weatherState = '${data['main']['temp']}°C ';
        _controller.tempData = '${data['weather'][0]['description']}';
        weatherIcon = getWeatherIcon(data['weather'][0]['id']);
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  IconData getWeatherIcon(int condition) {
    if (condition < 300) {
      return Icons.bolt; // 천둥
    } else if (condition < 400) {
      return Icons.umbrella; // 이슬비
    } else if (condition < 600) {
      return Icons.beach_access; // 비
    } else if (condition < 700) {
      return Icons.snowing; // 눈
    } else if (condition < 800) {
      return Icons.foggy; // 대기
    } else if (condition == 800) {
      return Icons.wb_sunny; // 해
    } else if (condition <= 804) {
      return Icons.cloud; // 구름
    } else {
      return Icons.error_outline;
    }
  }

  @override
  void initState() {
    super.initState();
    getPosition();
  }

  void updateState(String location, String temp, String time) {
    setState(() {
      _controller.locationState = location;
      _controller.tempData = temp;
      _controller.timeState = time;
    });
  }

    void updateState2(String newyork) {
    setState(() {
      _controller.locationMessage = newyork;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.cloud, size: 20, color: Colors.lightBlue,),
            const SizedBox(height: 10),
            Text(_controller.timeState, style: TextStyle(fontSize: 20),),
            const SizedBox(height: 10),
            Text(_controller.locationState, style: TextStyle(fontSize: 40),),
            const SizedBox(height: 30),
            Icon(weatherIcon, size: 70, color: Colors.yellow,),
            const SizedBox(height: 30),
            Text(weatherState, style: TextStyle(fontSize: 35),),
            const SizedBox(height: 10),
            Text( _controller.tempData, style: TextStyle(fontSize: 20),),
            Container(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _controller.saveState(updateState);

                  });
                },
                child: Text("상태 정보 저장", style: TextStyle(color:Colors.black),),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.greenAccent)),
              ),
            ),
            Container(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                     _controller.newyorkState(updateState2);
                   
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.greenAccent)),
                child: Text("특정 지역 정보", style: TextStyle(color:Colors.black),),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            getPosition();
          });
        },
      ),
    );
  }
}
