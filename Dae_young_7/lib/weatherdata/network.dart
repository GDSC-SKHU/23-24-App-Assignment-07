import 'package:http/http.dart' as http;
import 'dart:convert'; //json parsing 위한것 jsonDecode메소드 사용가능

class Network {
  final String url;
  Network(this.url);

  Future<dynamic> getJsonData() async {
    http.Response response =
        await http.get(Uri.parse(url)); //respons http패키지에서온거
    if (response.statusCode == 200) {
      String jsonData = response.body;
      var parsingData = jsonDecode(jsonData);
      return parsingData;
    }
  }
}
