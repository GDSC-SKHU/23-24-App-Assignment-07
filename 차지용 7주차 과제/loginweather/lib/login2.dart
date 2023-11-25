import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'weather.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'DB/data.dart';
class LoginSecond extends StatefulWidget {
  @override
  _LoginSecondState createState() => _LoginSecondState();
}

class _LoginSecondState extends State<LoginSecond> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final dio = Dio();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: 
              Icon(Icons.lock_outline_rounded, size: 90, ),
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              ),
              Container(
                alignment: Alignment.center,
                child: const Text('Welcome back, you`ve been missed!'),
              ),
              Form(
                key: _formKey,
                child: Column(children: [
                TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: 'Email'),
                validator: (value){
                  if(value == null || value.isEmpty || !value.contains('@')){
                    return("Please enter your email");
                  }
                  return null;
                },
            ),
            Padding(padding: const EdgeInsets.symmetric(vertical: 10.0),),
              TextFormField(
                controller: _passwordController, // 사용자가 입력한 비밀번호 값을 가져오기 위해 컨트롤러를 할당합니다.
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Password'),
                validator: (value){
                  if(value==null || value.length<=6){
                    return("Password must be at least 6 characters");
                  }
                  return null;
                },
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              alignment: Alignment.centerRight,
              child: Text('Forgot Password?'),
            ),
            ElevatedButton(
              onPressed: () async{
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data'),),
                  );
                }
                try{
                  String user_id = _emailController.text;
                  String user_pw = _passwordController.text;
                  //ID, 비밀번호를 포함한 문자열 생성
                  final rawString = '$user_id:$user_pw';

                  Codec<String, String> stringTobase64 = utf8.fuse(base64);
                  String token  = stringTobase64.encode(rawString);

                  //dio을 사용하여 서버에서 POST 요청
                  final response = await dio.post(
                    '$iosip',
                    options: Options(
                      headers: {'authorization': 'Basic $token',},
                    ),
                  );
                  //서버에서 refreshToken, accessToken 가져오기
                  final refreshToken = response.data['refreshToken'];
                  final accessToken = response.data['accessToken'];
                  await storage.write(
                    key: REFRESH_TOKEN_KEY,
                    value: refreshToken,
                  );
                  await storage.write(
                    key: ACCESS_TOKEN_KEY,
                    value: accessToken,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => Weather())
                  );
                } catch(e){
                  print(e);
                }
              },
              child: const Text('Sign In'),
            ),
              ],),),
              
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              alignment: Alignment.center,
              child: const Text('Or continue with'),
              ),
              Container(
                
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                  Image.asset("assets/google.jpeg", width: 70, height: 70,),
                  Image.asset("assets/apple.jpeg", width: 60, height: 60,),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
               child: const Row(
                 mainAxisAlignment:MainAxisAlignment.center,
                 children: [
                  Text('Not a member?'),
                  Text(' Register now', style: TextStyle(
                    color: Colors.blue,
                  ),),
               
                 ],
              ),
              )
          ],
        ),
      ),
    );
  }
}
