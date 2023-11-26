import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_management/Login/View/Loginscreen.dart';
import 'package:state_management/Weather/ViewModel/storageController.dart';

// 저장된 것들을 보여주는 화면
class StorageScreen extends StatelessWidget {
  // getX를 이용해서 클래스 StorageController를 관리할 인스턴스 생성
  final StorageController storageController = Get.put(StorageController());

  StorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('저장: '),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              icon: const Icon(Icons.login_outlined))
        ],
      ),
      body: GetBuilder<StorageController>(
        builder: (controller) {
          return ListView.builder(
            // 콜백함수로 목록 항목 만들고 listTitke 위치 값 표시
            itemCount: controller.weatherList.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(controller.weatherList[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
