import 'package:flutter/material.dart';
import 'package:loginweather/weather.dart';
import 'package:loginweather/login2.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'DB/data.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  void deleteToken() async {
    await storage.deleteAll();
  }

  void checkToken() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    final dio = Dio();

    try {
      final response = await dio.post(
        '$iosip',
        options: Options(
          headers: {
            'authorization': 'Bearer $refreshToken',
          },
        ),
      );
      await storage.write(
        key: ACCESS_TOKEN_KEY,
        value: response.data['accessToken'],
      );
      // 모든 것이 정상이면 Weather 화면으로 이동
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) =>  Weather(),
        ),
        (route) => false,
      );
    } catch (e) {
      // 토큰에 문제가 있으면 Login 화면으로 이동
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => LoginSecond(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), //앱 진행상황을 나타낼 때 가장 많이 사용되는 위젯
      ),
    );
  }
}