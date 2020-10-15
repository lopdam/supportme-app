import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:supportme_app/Models/account_save.dart';
import 'package:supportme_app/Models/hueca_model.dart';
import 'package:supportme_app/Services/config_conection.dart';

class HuecaService {
  static Future<List<HuecaModel>> get_huecas() async {
    final http.Response response = await http.get(
      path.join(Config.api, "huecas"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var results = jsonDecode(utf8.decode(response.bodyBytes));

    List<HuecaModel> listHuecas = List();

    if (response.statusCode == HttpStatus.ok) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      for (Map<String, dynamic> hueca in results) {
        listHuecas.add(HuecaModel.fromJson(hueca));
      }

      return listHuecas;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return listHuecas;
    }
  }

  static Future<List<HuecaModel>> get_huecas_user() async {
    List<HuecaModel> listHuecas = List();
    if (!AccountSave.isLogin()) {
      return listHuecas;
    }
    List<HuecaModel> listHuecasUser = List();
    listHuecas = await get_huecas();
    if (listHuecas.length > 0) {
      listHuecas.forEach((element) {
        if (element.user == AccountSave.id) listHuecasUser.add(element);
      });
    }
    return listHuecasUser;
  }

  static Future<List<HuecaModel>> get_likesHuecas() async {
    final http.Response response = await http.get(
      path.join(Config.api, "likes", "user", (AccountSave.id).toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Token ${AccountSave.token}",
      },
    );

    var results = jsonDecode(utf8.decode(response.bodyBytes));

    List<HuecaModel> listHuecas = List();

    if (response.statusCode == HttpStatus.ok) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      for (Map<String, dynamic> hueca in results) {
        listHuecas.add(HuecaModel.fromJson(hueca));
      }

      return listHuecas;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return listHuecas;
    }
  }

  static Future<HuecaModel> get_hueca({int hueca}) async {
    final http.Response response = await http.get(
      path.join(Config.api, "hueca", hueca.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var results = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == HttpStatus.ok) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      return HuecaModel.fromJson(results);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return null;
    }
  }

  static Future<bool> update_hueca(
      {int hueca,
      String name,
      String description,
      String address,
      String phone,
      double latitude,
      double longitude,
      int city_id,
      int category_id}) async {
    if (!AccountSave.isLogin()) {
      return false;
    }
    final http.Response response = await http.put(
      path.join(Config.api, "hueca", hueca.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Token ${AccountSave.token}"
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'description': description,
        'address': address,
        'phone': phone,
        'latitude': latitude,
        'longitude': longitude,
        'city': city_id,
        'category': category_id,
        "user": AccountSave.id,
      }),
    );

    //var results = jsonDecode(response.body);

    if (response.statusCode == HttpStatus.ok) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return false;
    }
  }

  static Future<bool> delete_hueca({int hueca}) async {
    if (!AccountSave.isLogin()) {
      return false;
    }
    final http.Response response = await http.delete(
      path.join(Config.api, "hueca", hueca.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Token ${AccountSave.token}"
      },
    );

    //var results = jsonDecode(response.body);

    if (response.statusCode == HttpStatus.ok) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return false;
    }
  }

  static Future<List<HuecaModel>> get_cityHuecas({int city}) async {
    final http.Response response = await http.get(
      path.join(Config.api, "huecas", "cities", city.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var results = jsonDecode(utf8.decode(response.bodyBytes));

    List<HuecaModel> listHuecas = List();

    if (response.statusCode == HttpStatus.ok) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      for (Map<String, dynamic> hueca in results) {
        listHuecas.add(HuecaModel.fromJson(hueca));
      }

      return listHuecas;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return listHuecas;
    }
  }

  static Future<List<HuecaModel>> get_categoryHuecas({int category}) async {
    final http.Response response = await http.get(
      path.join(Config.api, "huecas", "categories", category.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var results = jsonDecode(utf8.decode(response.bodyBytes));

    List<HuecaModel> listHuecas = List();

    if (response.statusCode == HttpStatus.ok) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      for (Map<String, dynamic> hueca in results) {
        listHuecas.add(HuecaModel.fromJson(hueca));
      }

      return listHuecas;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return listHuecas;
    }
  }

  static Future<List<HuecaModel>> get_locationHuecas(
      {double latitude, double longitude, double km}) async {
    final http.Response response = await http.get(
      path.join(Config.api, "location", latitude.toString(),
          longitude.toString(), km.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var results = jsonDecode(utf8.decode(response.bodyBytes));

    List<HuecaModel> listHuecas = List();

    if (response.statusCode == HttpStatus.ok) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      for (Map<String, dynamic> hueca in results) {
        listHuecas.add(HuecaModel.fromJson(hueca));
      }

      return listHuecas;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return listHuecas;
    }
  }

  static Future<List<HuecaModel>> get_searchHueca({String search}) async {
    final http.Response response = await http.get(
      path.join(Config.api, "huecas", "search", search),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var results = jsonDecode(utf8.decode(response.bodyBytes));

    List<HuecaModel> listHuecas = List();

    if (response.statusCode == HttpStatus.ok) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      for (Map<String, dynamic> hueca in results) {
        listHuecas.add(HuecaModel.fromJson(hueca));
      }

      return listHuecas;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return listHuecas;
    }
  }

  static Future<int> post_Hueca(
      {String name,
      String description,
      String address,
      String phone,
      double latitude,
      double longitude,
      int city_id,
      int category_id}) async {
    if (!AccountSave.isLogin()) {
      return -2;
    }

    final http.Response response = await http.post(
      path.join(Config.api, "hueca"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Token ${AccountSave.token}"
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'description': description,
        'address': address,
        'phone': phone,
        'latitude': latitude,
        'longitude': longitude,
        'city': city_id,
        'category': category_id,
        "user": AccountSave.id,
      }),
    );
    var results = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == HttpStatus.created) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      HuecaModel huecaTemp;
      huecaTemp = HuecaModel.fromJson(results);
      return huecaTemp.id;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return -1;
    }
  }
}
