import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:supportme_app/Models/account_save.dart';
import 'package:supportme_app/Models/comment_model.dart';
import 'package:supportme_app/Services/config_conection.dart';

class CommentService {
  static Future<List<CommentModel>> getComments({int hueca}) async {
    final http.Response response = await http.get(
      path.join(Config.api, "comments", hueca.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var results = jsonDecode(utf8.decode(response.bodyBytes));

    List<CommentModel> listComment = List();

    if (response.statusCode == HttpStatus.ok) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      for (Map<String, dynamic> comment in results) {
        listComment.add(CommentModel.fromJson(comment));
      }

      return listComment;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return listComment;
    }
  }

  static Future<bool> post_comment({int hueca, String content}) async {
    if (!AccountSave.isLogin()) {
      return false;
    }

    final http.Response response = await http.post(
      path.join(Config.api, "comment"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Token ${AccountSave.token}"
      },
      body: jsonEncode(<String, dynamic>{
        "content": content,
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

  static Future<bool> delete_comment({int comment}) async {
    if (!AccountSave.isLogin()) {
      return false;
    }

    final http.Response response = await http.delete(
      path.join(Config.api, "comment", comment.toString()),
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
}
