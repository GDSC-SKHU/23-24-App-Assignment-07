//앱처음진입하면 데이터 읽고 어떤 페이지로 보낼지 판단하는 페이지

import 'package:flutter/material.dart';
import 'package:flutter_cfmid_1/common/const/colors.dart';
import 'package:flutter_cfmid_1/common/const/data.dart';
import 'package:flutter_cfmid_1/common/layout/defalt_layout.dart';
import 'package:flutter_cfmid_1/common/view/root_tab.dart';
import 'package:flutter_cfmid_1/user/view/login_screen.dart';
import 'package:flutter_cfmid_1/user/view/weatherveiw/loading.dart';
import 'package:flutter_cfmid_1/user/view/weatherveiw/weatherscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //deleteToken();
    checkToken();
    //initState await불가
  }

  //void deleteToken() async {
  // await storage.deleteAll();
  //} 이부분 껴있으면 토큰 사라져서 로그인페이지로

  void checkToken() async {
    try {
      final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
      final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

      if (refreshToken == null || accessToken == null) {
        // 로그인 한 적 없으면 로그인 페이지로 이동
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      } else {
        // 로그인 토큰이 있는 경우, 루트 페이지로 이동
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const Loading()),
          (route) => false,
        );
      }
    } catch (e) {
      print('Error: $e');
      return; // 혹은 다른 반환값 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        backgroundColor: PRIMARY_COLOR,
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 16,
                ),
                CircularProgressIndicator(
                  color: Colors.white,
                )
              ],
            )));
  }
}
