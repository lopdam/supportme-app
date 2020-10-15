import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:supportme_app/Models/account_save.dart';
import 'package:supportme_app/Models/user_model.dart';
import 'package:supportme_app/Services/config_conection.dart';
import 'package:supportme_app/Util/Util.dart';

class SignUpService {
  static Future<bool> on_signup(
      {String username,
      String password,
      String email,
      String last_name = "",
      String first_name = "",
      BuildContext context}) async {
    //Util.shortToast(msg: path.join(Config.api,"login/"),context: context);
    final http.Response response = await http.post(
      path.join(Config.api, "signup"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username": username,
        "password": password,
        "email": email,
        "first_name": first_name,
        "last_name": last_name
      }),
    );
    var results = jsonDecode(response.body);

    if (response.statusCode == HttpStatus.created) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      Util.longToastCenter(msg: "SignUp Successfully", context: context);
      Navigator.of(context).pop();

      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.

      Util.longToastCenter(msg: results["error"], context: context);
      throw Exception('Failed Sigup');
    }
  }

  static Future<bool> on_editProfile(
      {String username,
      String password,
      String email,
      String last_name,
      String first_name,
      BuildContext context}) async {
    //Util.shortToast(msg: path.join(Config.api,"login/"),context: context);
    final http.Response response = await http.put(
      path.join(Config.api, "update", (AccountSave.id).toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Token ${AccountSave.token}"
      },
      body: jsonEncode(<String, String>{
        "username": username,
        "password": password,
        "email": email,
        "first_name": first_name,
        "last_name": last_name
      }),
    );

    var results = jsonDecode(response.body);

    if (response.statusCode == HttpStatus.ok) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      Util.longToastCenter(msg: "Edit Successfully", context: context);
      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.

      //Util.longToastCenter(msg: results["error"], context: context);
      Util.longToastCenter(msg: results["error"], context: context);
      throw Exception('Failed Update');
    }
  }

  static bool isPassword(String password) {
    if (password == null || password.isEmpty) {
      return false;
    }

    bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
    //bool hasSpecialCharacters =password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return hasDigits & hasUppercase & hasLowercase;
  }

  static Future<User> on_userInfo() async {
    //Util.shortToast(msg: path.join(Config.api,"login/"),context: context);
    final http.Response response = await http.get(
      path.join(Config.api, "user", (AccountSave.id).toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Token ${AccountSave.token}"
      },
    );

    if (response.statusCode == HttpStatus.ok) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      var results = jsonDecode(response.body);
      return User(
          username: results["username"],
          first_name: results["first_name"],
          email: results["email"],
          last_name: results["last_name"]);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return null;
      //throw Exception('Failed Sigup');
    }
  }
}
