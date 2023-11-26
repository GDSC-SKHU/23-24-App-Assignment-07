import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/Login/View/Loginscreen.dart';
import 'package:state_management/Login/ViewModel/Token.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); //constructor

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => LoginToken(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            scaffoldBackgroundColor: const Color.fromARGB(255, 227, 242, 255),
            appBarTheme: const AppBarTheme(
              shadowColor: Color.fromARGB(255, 227, 242, 255),
            ),
          ),
          home: const LoginScreen(),
        ));
  }
}
