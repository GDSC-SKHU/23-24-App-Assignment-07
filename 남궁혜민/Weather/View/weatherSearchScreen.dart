import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_management/Weather/Model/Data/TimeInfo.dart';
import 'package:state_management/Weather/Model/Data/picture.dart';
import 'package:state_management/Weather/Model/Data/Weather.dart';
import 'package:state_management/Weather/Model/LocationModel.dart';
import 'package:state_management/Weather/View/storageScreen.dart';
import 'package:state_management/Weather/ViewModel/storageController.dart';

//검색을 했을 때 나오는 화면
class WeatherSearchScreen extends StatefulWidget {
  final String initialCity;
  const WeatherSearchScreen({Key? key, required this.initialCity})
      : super(key: key);

  @override
  _WeatherSearchScreenState createState() => _WeatherSearchScreenState();
}

class _WeatherSearchScreenState extends State<WeatherSearchScreen> {
  final LocationModel locationModel = LocationModel();
  final WeatherPicture picture = WeatherPicture();
  final TimeInfo time = TimeInfo();

  final storageController = Get.put(StorageController());

  WeatherData? weatherData;
  String cityName = '';

  Future<void> fetchCityName() async {
    cityName = await locationModel.getMyCurrentLocation1();
    weatherData = await locationModel.getWeather(cityName);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchCityName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (weatherData != null)
                Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            const Text(
                              '도시',
                              style: TextStyle(fontSize: 40),
                            ),
                            Text(
                              ' ${weatherData!.cityName}',
                              style: const TextStyle(fontSize: 25),
                            ),
                          ],
                        ),
                        if (weatherData != null)
                          picture.getWeatherIcon(weatherData!.condition)!,
                      ],
                    ),
                    const SizedBox(height: 50),
                    Text(
                      '${weatherData!.temp}°C',
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      '날씨',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      weatherData!.conditionText,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        storageController.saveData(time.currentTime());
                        Get.to(() => StorageScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 150,
                          vertical: 15,
                        ),
                        backgroundColor: Colors.indigo,
                      ),
                      child: const Text(
                        '저장',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              if (weatherData == null) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
