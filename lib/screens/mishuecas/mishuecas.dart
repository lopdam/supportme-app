import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supportme_app/Models/category_model.dart';
import 'package:supportme_app/Models/city_model.dart';
import 'package:supportme_app/Models/user_model.dart';
import 'package:supportme_app/Services/category_service.dart';
import 'package:supportme_app/Services/city_service.dart';
import 'package:supportme_app/Services/hueca_sevice.dart';
import 'package:supportme_app/Services/image_service.dart';
import 'package:supportme_app/Services/signup_service.dart';
import 'package:supportme_app/Util/Util.dart';
import 'package:supportme_app/Variables/AppColors.dart';
import 'package:supportme_app/screens/common/circle_Indicator.dart';
import 'package:supportme_app/screens/login/components/text_field_container.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supportme_app/screens/mishuecas/menu_list.dart';
import 'package:supportme_app/screens/registro_hueca/agregarPlato.dart';

class Mis_Huecas extends StatefulWidget {
  @override
  _Mis_Huecas createState() => _Mis_Huecas();
}

class _Mis_Huecas extends State<Mis_Huecas> {
  Widget _screen;
  BuildContext _context;

  Widget _listHuecasWidget;

  int user;
  User _loadUser;
  bool _verificador;

  @override
  void initState() {
    super.initState();
    _verificador = false;
    _listHuecasWidget = UserHuecaList();
    chargeUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    _screen = mainContainer();
    return _screen;
  }

  Widget mainContainer() {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mis Huecas"),
        ),
        body: (_verificador) ? _principal() : CircleIndicator());
  }

  Widget _principal() {
    return Column(children: [
      Expanded(
        flex: 12,
        child: _listHuecasWidget,
      )
    ]);
  }

  chargeUserInfo() {
    SignUpService.on_userInfo().then((user) => {
          if (user != null) {userInfo(user)}
        });
  }

  void userInfo(User user) {
    _loadUser = user;
    _verificador = true;
    setState(() {});
  }
}
