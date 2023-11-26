import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_auth/common/component/custom_text_form_field.dart';
import 'package:flutter_auth/common/const/colors.dart';
import 'package:flutter_auth/common/const/data.dart';
import 'package:flutter_auth/common/layout/default_layout.dart';
import 'package:flutter_auth/common/view/root_tab.dart';
import 'package:gap/gap.dart';
import 'package:dio/dio.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

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

    return DefaultLayout(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Title(),
                const Gap(16),
                const _SubTitle(),
                const Gap(16),
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
                        onChanged: (String value) {
                          username = value;
                        },
                      ),
                      const Gap(16),
                      CustomTextFormField(
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length <= 6) {
                            return '7자 이상의 비밀번호를 입력해주세요';
                          }
                          return null;
                        },
                        hintText: '비밀번호를 입력해주세요',
                        obscureText: true,
                        onChanged: (String value) {
                          password = value;
                        },
                      ),
                      const Gap(16),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('로그인 중입니다. 잠시만 기다려주세요'),
                              ),
                            );
                          }

                          final rawString = '$username:$password';

                          Codec<String, String> stringToBase64 =
                              utf8.fuse(base64);

                          String token = stringToBase64.encode(rawString);

                          try {
                            final response = await dio.post(
                              'http://$ip/auth/login',
                              options: Options(
                                headers: {
                                  'authorization': 'Basic $token',
                                },
                              ),
                            );
                            print(response.data);
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
                              MaterialPageRoute(
                                builder: (_) => const RootTab(),
                              ),
                            );
                          } catch (e) {
                            return;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PRIMARY_COLOR,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          '로그인',
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    final refreshToken = await storage.read(
                      key: REFRESH_TOKEN_KEY,
                    );
                    final response = await dio.post(
                      'http://$ip/auth/token',
                      options: Options(
                        headers: {
                          'authorization': 'Bearer $refreshToken',
                        },
                      ),
                    );
                    print(response.data);
                  },
                  child: const Text(
                    "회원가입",
                  ),
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
      '환영합니다!',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요! \n좋은 하루 입니다!:)',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}