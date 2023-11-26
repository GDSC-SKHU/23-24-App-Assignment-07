import 'package:flutter/material.dart';
import 'package:state_management/Login/Model/customTextField.dart';
import 'package:state_management/Login/ViewModel/Token.dart';
import 'package:state_management/Weather/View/MainScreen.dart';
import 'package:provider/provider.dart';
//import 'dart:ui';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';

  String? idErrorText = '';
  String? pwErrorText = '';

  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  LoginToken loginToken = LoginToken();

  //로그인을 성공헀을 때 실행할 함수 onloginsuccess를 통해 weatherScreen으로 이동
  void _onLoginSuccess(BuildContext context) {
    print('성공');
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()));
  }

  //로그인을 실패했을 때 보여지는 다이얼로그 창
  void _onLoginFailure(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그인 실패'),
          content: const Text('아이디 또는 비밀번호가 올바르지 않습니다.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  // formKey가 타당한지 확인하는 함수
  void validateForm() {
    if (_formKey.currentState!.validate()) {
      print("일단 여기는 실행됨 ");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("로그인 중입니다.")));
      _loginResponse();
    } else {
      print("vaildateForm 함수가 실패 ");
    }
  }

//loginToken에서 응답을 확인하는 함수
  void _loginResponse() async {
    final id = idController.text; //아이디와 패스워드 값 확인
    final pw = pwController.text;

    try {
      // 생성자를 통해 보내주기
      var response = await loginToken.logincheck(id, pw);
      print(
          '상태코드 : ${response.statusCode}'); // response가 일치하다고 응답을 주면 onLoginSucess() 함수 호출
      if (response.statusCode == 201 || response.statusCode == 200) {
        _onLoginSuccess(context);
      } else {
        _onLoginFailure(context);
      }
    } catch (e) {
      print('로그인 요청 에러: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginToken = Provider.of<LoginToken>(context);
    return Scaffold(
      //resizeToAvoidBottomInset 화면 그대로 두고 키보드만 올라오고 싶을 때 사용
      resizeToAvoidBottomInset: false,

      //화면 자체를 스크롤할 수 있도록
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                'assets/images/weatherLogin.png',
                width: 200,
              ),
              const Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        'Sign In',
                        style: TextStyle(
                            fontSize: 40.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(children: [
                  Column(
                    children: [
                      CustomTextField(
                        hintText: 'ID(이메일을 입력하세요) : ',
                        controller: idController,
                        onChanged: (value) {
                          setState(() {
                            idErrorText = null;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'ID를 다시 입력해주세요.';
                          } else if (!value.contains('@')) {
                            return '@를 포함해주세요.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      CustomTextField(
                        controller: pwController,
                        hintText: '비밀번호:',
                        //errorText: pwErrorText,
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            pwErrorText = null;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 다시 입력해주세요';
                          } else if (value.length <= 6) {
                            return '비밀번호는 7자리 이상입니다';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30.0)
                    ],
                  ),
                  ElevatedButton(
                    // 버튼을 눌렀을 때 provider를 이용해 logout
                    onPressed: () {
                      if (loginToken.isLoggedIn) {
                        loginToken.logout();
                      } else {
                        validateForm();
                      }
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 150, vertical: 15),
                    ),
                    child: const Text('로그인',
                        style: TextStyle(fontSize: 20, color: Colors.indigo)),
                  ),
                  const SizedBox(height: 30.0),
                  ElevatedButton(
                    // 버튼을 눌렀을 때 provider를 이용해 logout
                    onPressed: () {
                      if (loginToken.isLoggedIn) {
                        loginToken.logout();
                      } else {
                        validateForm();
                      }
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 150, vertical: 15),
                    ),
                    child: const Text('로그아웃',
                        style: TextStyle(fontSize: 20, color: Colors.indigo)),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
