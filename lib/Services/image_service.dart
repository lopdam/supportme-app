import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:supportme_app/Models/image_model.dart';
import 'package:supportme_app/Services/config_conection.dart';
import 'package:supportme_app/Models/account_save.dart';
import 'package:dio/dio.dart';

class ImageService {
  static Future<List<ImageModel>> get_images({int hueca}) async {
    final http.Response response = await http.get(
      path.join(Config.api, "images", hueca.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var results = jsonDecode(response.body);

    List<ImageModel> listHuecas = List();
    if (response.statusCode == HttpStatus.ok) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      for (Map<String, dynamic> image in results) {
        listHuecas.add(ImageModel.fromJson(image));
      }

      return listHuecas;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return listHuecas;
    }
  }

  static Future<bool> post_Image({File image, int hueca}) async {
    String url = path.join(Config.api, "image");
    FormData formData = new FormData.fromMap({
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
