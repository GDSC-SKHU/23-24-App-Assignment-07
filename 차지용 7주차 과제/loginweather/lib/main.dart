import 'package:flutter/material.dart';
import 'package:loginweather/weather.dart';
import 'package:loginweather/login2.dart';
import 'DB/data.dart';
import 'package:loginweather/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    
    );
  }
}
