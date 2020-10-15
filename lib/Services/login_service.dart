import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:supportme_app/Models/account_save.dart';
import 'package:supportme_app/Services/config_conection.dart';
import 'package:supportme_app/Util/Util.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supportme_app/screens/likes/likes.dart';

class LoginService {

  static Future<bool> on_login(
      {String username, String password, BuildContext context}) async {
    //Util.shortToast(msg: path.join(Config.api,"login/"),context: context);
    final http.Response response = await http.post(
     path.join(Config.api,"login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, String>{"username": username, "password": password}),
    );
    var results = jsonDecode(response.body);

    if (response.statusCode == HttpStatus.ok) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      Util.longToast(msg: "Welcome "+results["username"],context: context);
      saveUser(token: results["token"],id: results["user_id"]);

      Navigator.of(context).pop();

      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      Util.longToast(msg: "User or Password Incorrect", context: context);
      return false;

    }

  }


  static void saveUser({int id,String token}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setInt("user_id", id);
   getAccount();

  }

  static Future<void> getAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int id = prefs.getInt('user_id');
    String token = prefs.getString('token');
    //await prefs.setString('token', token);
    //await prefs.setInt("id", id);

    //print("id: "+id.toString());
    //print("token: "+token);
    AccountSave(id: id,token: token);
  }

  static Future<bool> logoutUSer(BuildContext context) async {
    final http.Response response = await http.delete(
      path.join(Config.api,"logout",AccountSave.id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Token ${AccountSave.token}"
      },
    );


    if (response.statusCode == HttpStatus.ok) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('user_id');
      prefs.remove('token');
      AccountSave(id: null,token: null);
      Util.longToast(msg: "Logout Succesfully", context: context);
      return true;

    }
    else if(response.statusCode == HttpStatus.notFound){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('user_id');
      prefs.remove('token');
      AccountSave(id: null,token: null);
      Util.longToast(msg: "Your Account Have Problem", context: context);

    }
    else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      Util.longToast(msg: "Logout Problem", context: context);

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.remove('user_id');
      // prefs.remove('token');

      return false;

    }

  }

}
