import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supportme_app/Models/user_model.dart';
import 'package:supportme_app/Services/menu_service.dart';
import 'package:supportme_app/Services/signup_service.dart';
import 'package:supportme_app/Util/Util.dart';
import 'package:supportme_app/Variables/AppColors.dart';
import 'package:supportme_app/screens/common/circle_Indicator.dart';
import 'package:supportme_app/screens/login/components/text_field_container.dart';

class Agregar_Plato extends StatefulWidget {
  int _hueca;

  Agregar_Plato({int hueca}) {
    _hueca = hueca;
  }

  @override
  _Agregar_Plato createState() {
    return _Agregar_Plato(hueca: _hueca);
  }
}

class _Agregar_Plato extends State<Agregar_Plato> {
  int _hueca;
  Widget _screen;
  BuildContext _context;

  String _menu_name;
  String _menu_description;
  double _menu_price;

  File _image;
  final picker = ImagePicker();

  int user;
  User _loadUser;
  bool _verificador;
  bool page1;
  bool page2;
  bool _editable;

  String value_price;

  TextEditingController _controllerMenuName;
  TextEditingController _controllerMenuDescription;

  TextEditingController _controllerPrice;

  List<Widget> _btns;
  State _state;

  _Agregar_Plato({int hueca}) {
    _hueca = hueca;
  }

  @override
  void initState() {
    super.initState();
    _verificador = false;
    _editable = true;
    _state = this;

    chargeUserInfo();
    _btns = _btns1();
  }

  chargeUserInfo() {
    SignUpService.on_userInfo().then((user) => {
          if (user != null) {userInfo(user)}
        });
  }

  void userInfo(User user) {
    _loadUser = user;
    _verificador = true;
    page1 = true;
    page2 = false;

    setState(() {});
  }

  Future getImage() async {
    _save_changes();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
      _save_changes();
    });
  }

  void _save_changes() {
    _menu_name = _controllerMenuName.text;
    _menu_description = _controllerMenuDescription.text;
    value_price = _controllerPrice.text;
  }

  @override
  Widget build(BuildContext context) {
    _controllerMenuName = TextEditingController(text: _menu_name);
    _controllerMenuDescription = TextEditingController(text: _menu_description);
    _controllerPrice = TextEditingController(text: value_price);
    _context = context;
    _screen = mainContainer();
    return _screen;
  }

  Widget mainContainer() {
    return Scaffold(
        appBar: AppBar(
          title: page1
              ? Text("Agregar Plato para su hueca")
              : Text("Terminar el registro de la hueca"),
        ),
        body: (_verificador) ? _primer_paso() : CircleIndicator());
  }

  Widget _primer_paso() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 12.0,
          ),
          Visibility(
            visible: page1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('\nIngrese un plato de comida\nde su local\n'),
              ],
            ),
          ),
          Visibility(
            visible: page1,
            child: TextFieldContainer(
              child: TextField(
                keyboardType: TextInputType.name,
                controller: _controllerMenuName,
                enabled: true,
                cursorColor: AppColors.kPrimaryColor,
                decoration: InputDecoration(
                  icon: Text("Plato:"),
                  hintText: "plato",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Visibility(
            visible: page1,
            child: TextFieldContainer(
              child: TextField(
                keyboardType: TextInputType.name,
                controller: _controllerMenuDescription,
                enabled: true,
                cursorColor: AppColors.kPrimaryColor,
                decoration: InputDecoration(
                  icon: Text("Descripcion:"),
                  hintText: "descripcion",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Visibility(
            visible: page1,
            child: TextFieldContainer(
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _controllerPrice,
                enabled: true,
                cursorColor: AppColors.kPrimaryColor,
                decoration: InputDecoration(
                  icon: Text("Precio:"),
                  hintText: "precio",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Visibility(
            visible: page1,
            child: TextFieldContainer(
              child: TextField(
                keyboardType: TextInputType.phone,
                enabled: false,
                cursorColor: AppColors.kPrimaryColor,
                decoration: InputDecoration(
                  icon: Text("Imagen:"),
                  hintText: _image == null
                      ? "no hay imagen seleccionada"
                      : _image.path,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Visibility(
            visible: page1,
            child: FloatingActionButton(
              onPressed: getImage,
              tooltip: 'Pick Image',
              child: Icon(Icons.add_a_photo),
            ),
          ),
          Visibility(
            visible: page2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('\nDesea registrar otro plato\nde comida de su local\n'),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _btns,
          )
        ],
      ),
    );
  }

  List<Widget> _btns1() {
    return [
      //LogoutBtn(_state),
      SizedBox(
        width: 8,
      ),
      RaisedButton(
        splashColor: Colors.grey,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        onPressed: _form_plato,
        child: Container(
            height: 56,
            width: 90,
            child: Center(
                child: Text(
              "Agregar",
              style: TextStyle(fontSize: 16.0),
            ))),
        color: AppColors.mainColor,
        textColor: Colors.white,
      )
    ];
  }

  List<Widget> _btns2() {
    return [
      //LogoutBtn(_state),
      SizedBox(
        width: 8,
      ),
      RaisedButton(
        splashColor: Colors.grey,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        onPressed: _finish,
        child: Container(
            height: 56,
            width: 45,
            child: Center(
                child: Text(
              "No",
              style: TextStyle(fontSize: 16.0),
            ))),
        color: AppColors.mainColor,
        textColor: Colors.white,
      ),
      RaisedButton(
        splashColor: Colors.grey,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        onPressed: _to_firstPhase,
        child: Container(
            height: 56,
            width: 45,
            child: Center(
                child: Text(
              "Sí",
              style: TextStyle(fontSize: 16.0),
            ))),
        color: AppColors.mainColor,
        textColor: Colors.white,
      )
    ];
  }

  void _to_firstPhase() {
    _menu_name = "";
    _menu_description = "";
    value_price = "";
    _btns = _btns1();
    page1 = true;
    page2 = false;
    setState(() {});
  }

  void _form_plato() async {
    bool control = false;
    _menu_name = _controllerMenuName.text;
    _menu_description = _controllerMenuDescription.text;
    value_price = _controllerPrice.text;
    if (_menu_name == "" || _menu_description == "" || value_price == "") {
      Util.longToastCenter(
          msg: "Campos sin llenar en sección anterior", context: _context);
    } else if (!isNumeric(value_price)) {
      Util.longToastCenter(
          msg: "El costo del plato debe ser un valor numerico",
          context: _context);
    } else if (_image == null) {
      Util.longToastCenter(
          msg: "No ha subido una imagen para la hueca", context: _context);
    } else {
      _menu_price = double.parse(value_price);
      control = await MenuService.post_menu(
          name: _menu_name,
          description: _menu_description,
          price: _menu_price,
          image: _image,
          hueca: _hueca);
      if (control) {
        print("Plato Subido exitosamente");
        _next();
      } else
        print("Plato no subido exitosamente");
    }

    setState(() {});
  }

  void _next() {
    page1 = false;
    page2 = true;
    _btns = _btns2();
    setState(() {});
  }

  void _finish() {
    Navigator.pop(context);
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }
}
