import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserLocation {
  final String cityName;
  final double latitude;
  final double longitude;

  UserLocation({required this.cityName, required this.latitude, required this.longitude});
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final String apiKey = '423e3538b9221108f42027e6edf96df4';
  double? latitude;
  double? longitude;
  String? weatherCondition;
  double? temperature;
  bool _isRequestingLocation = false;
  List<String> informationList = [];
  UserLocation? userLocation;

  @override
  void initState() {
    super.initState();
    getLocationAndWeather();
  }

  Future<void> getLocationAndWeather() async {
    if (!mounted) {
      return;
    }

    if (userLocation != null) {
      setState(() {
        latitude = userLocation!.latitude;
        longitude = userLocation!.longitude;
      });
    } else {
      await getLocation();
    }
    await getWeather();
  }

  Future<void> getLocation() async {
    try {
      if (_isRequestingLocation) {
        return;
      }

      _isRequestingLocation = true;
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        _showLocationPermissionDeniedDialog();
      } else {
        await fetchLocation();
      }
    } catch (e) {
      print('위치 정보를 가져오는 중 오류 발생: $e');
    } finally {
      _isRequestingLocation = false;
    }
  }

  Future<Position> fetchLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      if (!mounted) {
        return position;
      }

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
      return position;
    } catch (e) {
      print('위치 정보를 가져오는 중 오류 발생: $e');
      _showLocationFetchErrorDialog();
      rethrow;
    }
  }

  Future<void> getWeather() async {
    if (latitude == null || longitude == null) {
      return;
    }

    final String apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';

    try {
      http.Response response = await http.get(Uri.parse(apiUrl));

      if (!mounted) {
        return;
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> weatherData = json.decode(response.body);
        setState(() {
          temperature = weatherData['main']['temp'];
          weatherCondition = weatherData['weather'][0]['main'];
        });
      } else {
        print('날씨 데이터 로드 실패. 상태 코드: ${response.statusCode}');
      }
    } catch (e) {
      print('날씨 정보를 가져오는 중 오류 발생: $e');
    }
  }

  void _showLocationPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('위치 권한 거부'),
          content: Text('위치 정보를 가져오기 위해서는 위치 권한이 필요합니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showLocationFetchErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('위치 정보 가져오기 실패'),
          content: Text('위치 정보를 가져오지 못했습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void updateInformationList() {
    DateTime now = DateTime.now();
    String period = now.hour < 12 ? '오전' : '오후';
    int hour = now.hour % 12;
    hour = hour == 0 ? 12 : hour;
    String currentTime = '$period $hour시 ${now.minute}분 ${now.second}초';
    String location =
        "위치: ${userLocation?.cityName ?? '알 수 없음'}, ${userLocation?.latitude ?? latitude ?? '알 수 없음'}, ${userLocation?.longitude ?? longitude ?? '알 수 없음'}";
    String weather =
        "날씨: ${weatherCondition ?? '알 수 없음'}, ${temperature != null ? '$temperature°C' : '알 수 없음'}";

    String informationLine = "$currentTime\n$location\n$weather";
    
    // 새로운 정보 추가
    informationList.add(informationLine);
  }

  IconData _getWeatherIcon() {
    switch (weatherCondition) {
      case 'Clear':
        return Icons.wb_sunny;
      case 'Clouds':
        return Icons.cloud;
      case 'Rain':
        return Icons.beach_access;
      case 'Snow':
        return Icons.ac_unit;
      case 'Thunderstorm':
        return Icons.flash_on;
      case 'Drizzle':
        return Icons.grain;
      case 'Fog':
        return Icons.filter_drama;
      default:
        return Icons.wb_cloudy;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('날씨 앱'),
      ),
      body: FutureBuilder<void>(
        future: getLocationAndWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('오류: ${snapshot.error}'));
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  _getWeatherIcon(),
                  size: 100,
                  color: Colors.blue,
                ),
                SizedBox(height: 20),
                Text(
                  '온도: ${temperature != null ? '$temperature°C' : '위치 정보를 동의해주세요!'}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  '날씨: ${weatherCondition ?? '위치 정보를 동의해주세요!'}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    updateInformationList();
                    setState(() {});
                  },
                  child: Text('정보 저장'),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: informationList.length,
                    itemBuilder: (context, index) {
                      double fontSize = 12.0;

                      return Container(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                informationList[index],
                                style: TextStyle(
                                  fontSize: fontSize,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  informationList.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
