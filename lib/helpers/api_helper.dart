import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHelper {
  ApiHelper._();

  static ApiHelper apiHelper = ApiHelper._();

  Future<Map?> whetherApi({required String searchTerm}) async {
    String whetherApi =
        'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$searchTerm?unitGroup=metric&key=ZQQJDBL92UZ49BEVW2YWTHJ3D&contentType=json';
    http.Response response = await http.get(Uri.parse(whetherApi));
    if (response.statusCode == 200) {
      Map whetherData = jsonDecode(response.body);

      return whetherData;
    }
    return null;
  }
}
