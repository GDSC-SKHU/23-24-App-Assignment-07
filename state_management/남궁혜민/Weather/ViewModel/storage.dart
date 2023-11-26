import 'package:flutter/widgets.dart';
import 'package:state_management/Weather/Model/Data/TimeInfo.dart';
import 'package:state_management/Weather/View/MainScreen.dart';
import 'package:state_management/Weather/Model/LocationModel.dart';

class Storage extends ChangeNotifier {
  // 현재시간 저장
  String? time;
  final TimeInfo _ti = TimeInfo();
  void saveData(time) {
    this.time = time;
    notifyListeners();
  }

  MainScreen ms = const MainScreen();

// locationModel로 받아온 정보들 배열에 저장
  List<LocationModel> saveLocation = [];
}
