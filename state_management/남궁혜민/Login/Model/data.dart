import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const ACESSS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

const storage = FlutterSecureStorage();
// 삼행연산자를 이용해서 기종에 따라 ip 값 변환
const emulatorIP = '10.0.2.2:3000';
const simulatorIP = '127.0.0.1:3000';

final ip = Platform.isIOS ? simulatorIP : emulatorIP;
