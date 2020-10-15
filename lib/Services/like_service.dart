import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:supportme_app/Models/account_save.dart';
import 'package:supportme_app/Services/config_conection.dart';

class LikeService {
  static Future<bool> get_like({int hueca}) async {
    if (!AccountSave.isLogin()) {
      return false;
    }

    final http.Response response = await http.get(
      path.join(
          Config.api, "like", hueca.toString(), (AccountSave.id).toString()),
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

  static Future<bool> delete_like({int hueca}) async {
    if (!AccountSave.isLogin()) {
      return false;
    }

    final http.Response response = await http.delete(
      path.join(
          Config.api, "like", hueca.toString(), (AccountSave.id).toString()),
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

  static Future<bool> post_like({int hueca}) async {
    if (!AccountSave.isLogin()) {
      return false;
    }

    final http.Response response = await http.post(
      path.join(Config.api, "like"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Token ${AccountSave.token}"
      },
      body: jsonEncode(<String, int>{
        "hueca": hueca,
        "user": AccountSave.id,
      }),
    );
    //var results = jsonDecode(response.body);

    if (response.statusCode == HttpStatus.created) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return false;
    }
  }
}
