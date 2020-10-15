import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:supportme_app/Models/account_save.dart';
import 'package:supportme_app/Models/rating_model.dart';
import 'package:supportme_app/Services/config_conection.dart';

class RatingsService {
  static Future<int> get_rating({int hueca}) async {
    if (!AccountSave.isLogin()) {
      return 0;
    }

    final http.Response response = await http.get(
      path.join(
          Config.api, "rating", hueca.toString(), (AccountSave.id).toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Token ${AccountSave.token}"
      },
    );
    var results = jsonDecode(response.body);

    if (response.statusCode == HttpStatus.ok) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return results["score"];
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return 0;
    }
  }

  static Future<bool> update_rating({int hueca, int score}) async {
    if (!AccountSave.isLogin()) {
      return false;
    }

    final http.Response response = await http.put(
      path.join(
          Config.api, "rating", hueca.toString(), (AccountSave.id).toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Token ${AccountSave.token}"
      },
      body: jsonEncode(<String, int>{
        "score": score,
        "hueca": hueca,
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

  static Future<bool> post_rating({int hueca, int score}) async {
    if (!AccountSave.isLogin()) {
      return false;
    }

    final http.Response response = await http.post(
      path.join(Config.api, "rating"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Token ${AccountSave.token}"
      },
      body: jsonEncode(<String, int>{
        "score": score,
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

  static Future<double> get_ratings({int hueca}) async {
    final http.Response response = await http.get(
      path.join(Config.api, "ratings", hueca.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var results = jsonDecode(response.body);

    if (response.statusCode == HttpStatus.ok) {
      List<RatingModel> listRating = List();

      double sumScores = 0;

      for (Map<String, dynamic> rating in results) {
        RatingModel tmp = RatingModel.fromJson(rating);
        sumScores += tmp.score;
        listRating.add(tmp);
      }
      int n = listRating.length;
      return (n == 0) ? 0 : double.parse((sumScores / n).toStringAsFixed(1));
    } else {
      return 0;
    }
  }
}
