import 'package:flutter/material.dart';
import 'package:flutter_cfmid_1/user/view/weatherveiw/weatherscreen.dart';
import 'package:flutter_cfmid_1/weatherdata/my_location.dart';
import 'package:flutter_cfmid_1/weatherdata/network.dart';

const apikey = '47e29f45e68b4ec80e1b7e393878aace';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  double? latitude_loading;
  double? longitude_loading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  void getLocation() async {
    MyLocation myLocation = MyLocation();
    await myLocation.getMyCurrentLocation();
    latitude_loading = myLocation.latitudenow;
    longitude_loading = myLocation.longitudenow;
    print(latitude_loading);
    print(longitude_loading);

    Network network = Network(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude_loading&lon=$longitude_loading&appid=$apikey&units=metric'); //&units=metric 이부분은 섭씨변환부분(없어도된다)
    var weatherData = await network.getJsonData();
    print(weatherData);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WeatherScreen(
        parseWeatherData: weatherData,
      ); //weather스크린으로 데이터전달
    }));
  }

  // void fetchData() async {

  //     var myjson = parsingData(jsonData)['weather'][0]['description'];
  //     print(myjson);

  //     var wind = parsingData(jsonData)['wind']['speed'];
  //     print(wind);

  //     var id = parsingData(jsonData)['id'];
  //     print(id);
  //   } else {
  //     print(response.statusCode);
  //   }

  //   print(response.body); //14강 12:30
  // }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: null,
          child: Text(
            'Get my location',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
