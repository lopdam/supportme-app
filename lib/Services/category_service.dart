import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:supportme_app/Models/category_model.dart';
import 'package:supportme_app/Services/config_conection.dart';

class CategoryService {
  static Future<List<CategoryModel>> get_categories() async {
    final http.Response response = await http.get(
      path.join(Config.api, "categories"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var results = jsonDecode(utf8.decode(response.bodyBytes));

    List<CategoryModel> listCategories = List();

    if (response.statusCode == HttpStatus.ok) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      for (Map<String, dynamic> category in results) {
        listCategories.add(CategoryModel.fromJson(category));
      }

      return listCategories;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return listCategories;
    }
  }
}
