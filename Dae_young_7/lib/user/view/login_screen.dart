import 'dart:convert';

import 'dart:io'
    show Platform; //Platform.isIOS ? simulatorIP : emulatorIp; 아부부구연위해서
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cfmid_1/common/component/custom_text_form_field.dart';
import 'package:flutter_cfmid_1/common/const/colors.dart';
import 'package:flutter_cfmid_1/common/const/data.dart';

import 'package:flutter_cfmid_1/common/layout/defalt_layout.dart';
import 'package:flutter_cfmid_1/common/view/root_tab.dart';
import 'package:flutter_cfmid_1/user/view/weatherveiw/loading.dart';
import 'package:flutter_cfmid_1/user/view/weatherveiw/weatherscreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    const Storage = FlutterSecureStorage();

    //로컬호스트
    const emulatorIp = '10.0.2.2:3000';
    const simulatorIP = '127.0.0.1:3000';

    final ip = Platform.isIOS ? simulatorIP : emulatorIp;

    return DefaultLayout(
      //키보드 올라오고 위젯들 같이올라오는 기능부분 화면을 스크롤가능, 최대크기 넘어선다
      child: SingleChildScrollView(
        //드래그하면 키보드살아짐
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Title(),
                const SizedBox(
                  height: 16,
                ),
                const _SubTitle(),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextFormField(
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !value.contains('@')) {
                            return '이메일을 입력해주세요';
                          }
                          return null;
                        },
                        hintText: '이메일을 입력해주세요',
                        //onchanged 텍스트필드에 값들어갈떄마다 작동 / 변화감지 /값 입력할떄만다 맨위 선언한 username에저장
                        onChanged: (String value) {
                          username = value;
                        },
                      ),
                      const Gap(16),
                      CustomTextFormField(
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 6) {
                            return '7자 이상의 비밀번호를 입력해주세요';
                          }
                          return null;
                        },
                        hintText: '비밀번호를 입력해주세요',
                        onChanged: (String value) {
                          password = value;
                        },
                        obscureText: true,
                      ),
                      const Gap(16),
                      ElevatedButton(
                        onPressed: () async {
                          //아이디 비밀전호
                          final rawString = '$username:$password';

                          //플러터에서 64로 인코딩하는방법
                          //String넣고 String받겠다는 뜻  utf8많이쓰는 인코딩 코덱

                          Codec<String, String> stringToBase64 =
                              utf8.fuse(base64);
                          String token = stringToBase64.encode(rawString);

                          try {
                            final resp = await dio.post('http://$ip/auth/login',
                                options: Options(headers: {
                                  'authorization': 'Basic $token'
                                }));
                            final refreshToken = resp.data[
                                'refreshToken']; //access ,refresh 토큰들어가 있는 맵형태 /데이터 타입나중에 이해할것
                            final accessToken = resp.data['accessToken'];

                            Storage.write(
                                key: REFRESH_TOKEN_KEY, value: refreshToken);

                            Storage.write(
                                key: ACCESS_TOKEN_KEY, value: accessToken);

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) =>
                                    const Loading())); //날씨loading페이지로
                          } catch (e) {
                            return;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: PRIMARY_COLOR),
                        child: const Text(
                          '로그인',
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    const refreshtoken =
                        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3RAY29kZWZhY3RvcnkuYWkiLCJzdWIiOiJmNTViMzJkMi00ZDY4LTRjMWUtYTNjYS1kYTlkN2QwZDkyZTUiLCJ0eXBlIjoicmVmcmVzaCIsImlhdCI6MTcwMDExNjc5MiwiZXhwIjoxNzAwMjAzMTkyfQ.zq_z88mbMA7Exd9lKBzPzPcGPQxUHkDPCIDrACRI5m0';
                    final resp = await dio.post('http://$ip/auth/token',
                        options: Options(headers: {
                          'authorization': 'Bearer $refreshtoken'
                        }));
                    print(resp.data);
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.black),
                  child: const Text('회원가입'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '환영합니다',
      style: TextStyle(
          fontSize: 34, fontWeight: FontWeight.w500, color: Colors.black),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요!',
      style: TextStyle(fontSize: 16),
    );
  }
}

class _idcheck extends StatelessWidget {
  const _idcheck({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}