import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import 'package:supportme_app/Models/account_save.dart';
import 'package:supportme_app/Models/menu_model.dart';
import 'package:supportme_app/Services/config_conection.dart';

class MenuService {
  static Future<List<MenuModel>> get_menus({int hueca}) async {
    final http.Response response = await http.get(
      path.join(Config.api, "menus", hueca.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var results = jsonDecode(utf8.decode(response.bodyBytes));

    List<MenuModel> listMenus = List();

    if (response.statusCode == HttpStatus.ok) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      for (Map<String, dynamic> menu in results) {
        listMenus.add(MenuModel.fromJson(menu));
      }

      return listMenus;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return listMenus;
    }
  }

  static Future<bool> post_menu(
      {String name,
      double price,
      String description,
      File image,
      int hueca}) async {
    String url = path.join(Config.api, "menu");
    FormData formData = new FormData.fromMap({
      'name': name,
      'price': price,
      'description': description,
      "image": await MultipartFile.fromFile(image.path,
          filename: basename(image.path)),
      "hueca": hueca,
    });

    var dio = Dio(BaseOptions(
      baseUrl: url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Token ${AccountSave.token}"
      },
    ));

    Response response = await dio.post(
      "",
      data: formData,
    );

    if (response.statusCode == HttpStatus.created) {
      return true;
    } else {
      return false;
    }
  }
}
