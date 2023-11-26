import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:state_management/Login/Model/data.dart';

class LoginToken with ChangeNotifier {
  bool isLoggedIn = false;
  final Dio _dio;

  String? accessToken;
  String? refreshToken;

  // Dio 클래스의 인스턴스로 초기화
  LoginToken() : _dio = Dio();
  // 사용자의 로그인 상태를 변경하고, ChangeNotifier를 통해 상태 변경을 알림
  void login() {
    isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }

  // async를 사용하여 id와 pw가 맞는지 서버에게 보내서 일치 여부 확인
  Future<Response<dynamic>> logincheck(String id, String pw) async {
    final token = base64Encode(utf8.encode('$id:$pw'));
    try {
      final response = await _dio.post(
        'http://$ip/auth/login',
        options: Options(
          headers: {
            'Authorization': 'Basic $token',
          },
        ),
      );

      final data = response.data;
      accessToken = data['accessToken'];
      refreshToken = data['refreshToken'];

      return response;
    } catch (e) {
      throw Exception('로그인 요청을 실패했습니다. 에러: $e');
    }
  }

  Future<Response<dynamic>> authRequest(String token) async {
    //  int itstatusCode;
    final options = Options(headers: {'Authorization': 'Bearer $accessToken'});

    try {
      final response = await _dio.get(
        'http://$ip/$token',
        options: options,
      );
      return response;
    } catch (e) {
      throw Exception('인증된 요청을 실패했습니다. 에러: $e');
    }
  }

  Future<void> refreshAccessToken() async {
    final response = await _dio.post(
      'http://$ip/auth/refresh',
      data: {'refreshToken': refreshToken},
    );

    final data = response.data;
    accessToken = data['accessToken'];
  }
}
