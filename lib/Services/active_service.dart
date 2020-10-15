import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supportme_app/Models/account_save.dart';
import 'package:supportme_app/Services/config_conection.dart';

class ActiveService {
  static verifiqueActiveToken() {
    if (AccountSave.isLogin()) {
      isActiveToken().then((active) => {
            if (!active) {setOnNotActive()}
          });
    }
  }

  static void setOnNotActive() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user_id');
    prefs.remove('token');
    AccountSave.id = null;
    AccountSave.token = null;
  }

  static Future<bool> isActiveToken() async {
    final http.Response response = await http.get(
      path.join(Config.api, "active", AccountSave.id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Token ${AccountSave.token}"
      },
    );

    var results = jsonDecode(response.body);

    if (response.statusCode == HttpStatus.ok) {
      return results["active"];
    } else {
      return false;
    }
  }
}
