import 'package:flutter/material.dart';
import 'package:flutter_cfmid_1/user/view/weatherveiw/weatherscreen.dart';

import 'package:get/get.dart';

class SecondPage extends StatelessWidget {
  final MyController myController = Get.find<MyController>();

  SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather List'),
      ),
      body: Obx(
        //리스트뷰생성 ,itemCount생성할 항목의수 지정
        () => ListView.builder( 
          itemCount: myController.timeList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                  '${myController.cityName} - ${myController.temp}°C - ${myController.timeList[index]}'),
            );
          },
        ),
      ),
    );
  }
}
