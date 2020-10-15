import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:supportme_app/Models/city_model.dart';
import 'package:supportme_app/Services/config_conection.dart';

class CityService {
  static Future<List<CityModel>> get_cities() async {
    final http.Response response = await http.get(
      path.join(Config.api, "cities"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var results = jsonDecode(utf8.decode(response.bodyBytes));

    List<CityModel> listCities = List();

    if (response.statusCode == HttpStatus.ok) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      for (Map<String, dynamic> city in results) {
        listCities.add(CityModel.fromJson(city));
      }

      return listCities;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return listCities;
    }
  }
}
