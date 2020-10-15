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
import 'package:supportme_app/screens/registro_hueca/agregarPlato.dart';

class Profile_Hueca extends StatefulWidget {
  String _name;
  String _description;
  String _address;
  String _phone;

  double _latitud;
  double _longitud;

  int _city_id;
  int _category_id;

  int _hueca;

  Profile_Hueca(
      {String name,
      String description,
      String address,
      String phone,
      double latitud,
      double longitud,
      int city_id,
      int category_id,
      int hueca}) {
    _name = name;
    _description = description;
    _address = address;
    _phone = phone;
    _latitud = latitud;
    _longitud = longitud;
    _city_id = city_id;
    _category_id = category_id;
    _hueca = hueca;
  }

  @override
  _Profile_Hueca createState() {
    return _Profile_Hueca(
        name: _name,
        description: _description,
        address: _address,
        phone: _phone,
        latitud: _latitud,
        longitud: _longitud,
        city_id: _city_id,
        category_id: _category_id,
        hueca: _hueca);
  }
}

class _Profile_Hueca extends State<Profile_Hueca> {
  Widget _screen;
  BuildContext _context;

  Completer<GoogleMapController> _controller = Completer();

  static LatLng _initialPosition;
  final Set<Marker> _markers = {};
  static LatLng _lastMapPosition = _initialPosition;
  /*
  File _image;
  final picker = ImagePicker();
  */
  String _name;
  String _categoria;
  String _ciudad;
  String _description;
  String _address;
  String _phone;

  double _latitud;
  double _longitud;

  double _latitud2;
  double _longitud2;

  int _hueca;

  int _city_id;
  int _category_id;

  List<CityModel> _cities; //

  CityModel _selectedCity; //
  CityModel _selectedCityTemp;
  List<CategoryModel> _categories;

  CategoryModel _selectedCategory;
  CategoryModel _selectedCategoryTemp;
  Widget _dropCities;

  Widget _dropCategories;

  Widget _map;

  CameraPosition _camera;

  String _created_on;
  String _updated_on;
  int user;
  User _loadUser;
  bool _verificador;
  bool page1;
  bool page2;
  bool _editable;

  TextEditingController _controllerName;
  TextEditingController _controllerDescription;
  TextEditingController _controllerAddress;
  TextEditingController _controllerPhone;
  TextEditingController _controllerCity;
  TextEditingController _controllerCategory;

  String _name2;
  String _categoria2;
  String _ciudad2;
  String _description2;
  String _address2;
  String _phone2;

  List<Widget> _btns;
  State _state;

  _Profile_Hueca(
      {String name,
      String description,
      String address,
      String phone,
      double latitud,
      double longitud,
      int city_id,
      int category_id,
      int hueca}) {
    _name = name;
    _description = description;
    _address = address;
    _phone = phone;
    _latitud = _latitud2 = latitud;
    _longitud = _longitud2 = longitud;
    _city_id = city_id;
    _category_id = category_id;
    _hueca = hueca;
  }

  @override
  void initState() {
    super.initState();
    _verificador = false;
    _editable = false;
    _state = this;
    _categoria = "";
    _ciudad = "";

    _cities = List();

    _categories = List();

    _controllerName = TextEditingController(text: _name);
    _controllerDescription = TextEditingController(text: _description);
    _controllerAddress = TextEditingController(text: _address);
    _controllerPhone = TextEditingController(text: _phone);
    _controllerCity = TextEditingController(text: _ciudad);
    _controllerCategory = TextEditingController(text: _categoria);

    CategoryService.get_categories()
        .then((categories) => {_categories = categories});

    CityService.get_cities().then((cities) => {_cities = cities});

    _getUserLocation();

    chargeUserInfo();
    _btns = _btns1();
  }

  @override
  Widget build(BuildContext context) {
    _loadCategories(_categories);
    _loadCities(_cities);

    _load_Camera();
    _load_Map();

    _context = context;
    _screen = mainContainer();
    return _screen;
  }
  /*
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }*/

  void _save_changes() {
    _categoria = _selectedCategory.name;
    _name = _controllerName.text;
    _description = _controllerDescription.text;
    _address = _controllerAddress.text;
    _phone = _controllerPhone.text;
    _ciudad = _selectedCity.name;
  }

  Widget mainContainer() {
    return Scaffold(
        appBar: AppBar(
          title: Text("Perfil de Hueca"),
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
          Text('Perfil de Hueca'),
          Visibility(
            visible: page1,
            child: TextFieldContainer(
              child: TextField(
                keyboardType: TextInputType.name,
                controller: _controllerName,
                enabled: _editable,
                cursorColor: AppColors.kPrimaryColor,
                decoration: InputDecoration(
                  icon: Text("Nombre:"),
                  hintText: _name,
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
                controller: _controllerDescription,
                enabled: _editable,
                cursorColor: AppColors.kPrimaryColor,
                decoration: InputDecoration(
                  icon: Text("Descripcion:"),
                  hintText: _description,
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
                controller: _controllerAddress,
                enabled: _editable,
                cursorColor: AppColors.kPrimaryColor,
                decoration: InputDecoration(
                  icon: Text("Direccion:"),
                  hintText: _address,
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
                controller: _controllerPhone,
                enabled: _editable,
                cursorColor: AppColors.kPrimaryColor,
                decoration: InputDecoration(
                  icon: Text("Telefono:"),
                  hintText: _phone,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Visibility(
            visible: page1,
            child: _editable
                ? _dropCities
                : TextFieldContainer(
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      controller: _controllerCity,
                      enabled: false,
                      cursorColor: AppColors.kPrimaryColor,
                      decoration: InputDecoration(
                        icon: Text("Ciudad:"),
                        hintText: _ciudad,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
          ),
          Visibility(
            visible: page1,
            child: _editable
                ? _dropCategories
                : TextFieldContainer(
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      controller: _controllerCategory,
                      enabled: false,
                      cursorColor: AppColors.kPrimaryColor,
                      decoration: InputDecoration(
                        icon: Text("Categoria:"),
                        hintText: _categoria,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
          ),
          /*
          Visibility(
            visible: page1 && _editable,
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
          */
          Visibility(
              visible: page1 && _editable,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*
                  FloatingActionButton(
                    onPressed: getImage,
                    tooltip: 'Pick Image',
                    child: Icon(Icons.add_a_photo),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  */
                  FloatingActionButton(
                    onPressed: _to_Map,
                    tooltip: 'Escoje una nueva ubicacion para la hueca',
                    child: Icon(Icons.add_location),
                  ),
                ],
              )),
          Visibility(
            visible: page2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('\nUbique su hueca en el mapa \n'),
              ],
            ),
          ),
          Visibility(
            visible: page2,
            child: _map,
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _btns,
          ),
          SizedBox(
            height: 20,
          ),
          Visibility(
            visible: !_editable,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _platoButton(),
            ),
          ),
        ],
      ),
    );
  }

  _loadCategories(List<CategoryModel> categories) {
    _categories = categories;
    categories.forEach((element) {
      if (element.id == _category_id) {
        _selectedCategory = element;
        _categoria = _selectedCategory.name;
      }
    });
    _dropCategories = DropdownButton(
      elevation: 3,
      hint: Text('Category'),
      value: _selectedCategoryTemp,
      onChanged: (value) {
        _selectedCategoryTemp = value;
        _categoria = _selectedCategory.name;
        //_save_changes();
        setState(() {});
      },
      items: _categories.map((category) {
        return DropdownMenuItem(
          child: new Text(category.name),
          value: category,
        );
      }).toList(),
    );
    setState(() {});
  }

  _loadCities(List<CityModel> cities) {
    _cities = cities;
    cities.forEach((element) {
      if (element.id == _city_id) {
        _selectedCity = element;
        _ciudad = _selectedCity.name;
      }
    });
    _dropCities = DropdownButton(
      elevation: 3,
      hint: Text('City'),
      value: _selectedCityTemp,
      onChanged: (value) {
        _selectedCityTemp = value;
        _ciudad = _selectedCity.name;
        //_save_changes();
        setState(() {});
      },
      items: _cities.map((city) {
        return DropdownMenuItem(
          child: new Text(city.name),
          value: city,
        );
      }).toList(),
    );
    setState(() {});
  }

  _load_Map() {
    _map = Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height / 1.5,
          width: MediaQuery.of(context).size.width - 20,
          child: GoogleMap(
            mapType: MapType.normal,
            markers: _markers,
            initialCameraPosition: _camera,
            onMapCreated: (GoogleMapController controller) {},
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            onCameraMove: _onCameraMove,
            myLocationEnabled: true,
            compassEnabled: true,
            myLocationButtonEnabled: true,
            onTap: (LatLng latLng) {
              _initialPosition = latLng;
              if (_markers.length >= 1) {
                _markers.clear();
              }
              _save_changes();
              _addMarker(latLng);
            },
          ),
        ),
      ],
    );
  }

  _load_Camera() {
    _camera = CameraPosition(
      target: _initialPosition ?? LatLng(0, 0),
      zoom: 14.4746,
    );
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
    _save_changes();
  }

  void _getUserLocation() {
    print(_latitud);
    _initialPosition = LatLng(_latitud, _longitud);
    _addMarker(_initialPosition);
    setState(() {});
  }

  void _addMarker(LatLng latLng) {
    _latitud = latLng.latitude;
    _longitud = latLng.longitude;
    print("Latitud: " +
        _latitud.toString() +
        " | " +
        "Longitud: " +
        _longitud.toString());
    _markers.add(Marker(
        markerId: MarkerId(_initialPosition.toString()),
        position: latLng,
        draggable: true,
        infoWindow: InfoWindow(
            title: "Este es la ubicación de su hueca",
            snippet: "Localizando hueca",
            onTap: () {
              _save_changes();
            }),
        onTap: () {
          _save_changes();
        },
        onDragEnd: (value) {
          _initialPosition = LatLng(value.latitude, value.longitude);
          _latitud = value.latitude;
          _longitud = value.longitude;
          print("Latitud: " +
              _latitud.toString() +
              " | " +
              "Longitud: " +
              _longitud.toString());
        },
        icon: BitmapDescriptor.defaultMarker));
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
        onPressed: _to_secondPhase,
        child: Container(
            height: 56,
            width: 90,
            child: Center(
                child: Text(
              "Editar",
              style: TextStyle(fontSize: 16.0),
            ))),
        color: AppColors.mainColor,
        textColor: Colors.white,
      ),
      SizedBox(
        width: 12,
      ),
      RaisedButton(
        splashColor: Colors.grey,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        onPressed: _deleteHueca,
        child: Container(
            height: 56,
            width: 90,
            child: Center(
                child: Text(
              "Eliminar",
              style: TextStyle(fontSize: 16.0),
            ))),
        color: AppColors.mainColor,
        textColor: Colors.white,
      )
    ];
  }

  void _to_secondPhase() {
    _btns = _btns2();
    _save_changes();
    page1 = true;
    page2 = false;
    _editable = true;
    _name2 = _name;
    _categoria2 = _categoria;
    _ciudad2 = _ciudad;
    _description2 = _description;
    _address2 = _address;
    _phone2 = _phone;
    setState(() {});
  }

  void _to_Map() {
    _btns = _btns3();
    _save_changes();
    page1 = false;
    page2 = true;
    _editable = true;
    setState(() {});
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
        onPressed: _to_firstPhase,
        child: Container(
            height: 56,
            width: 90,
            child: Center(
                child: Text(
              "Cancel",
              style: TextStyle(fontSize: 16.0),
            ))),
        color: AppColors.mainColor,
        textColor: Colors.white,
      ),
      SizedBox(
        width: 8,
      ),
      RaisedButton(
        splashColor: Colors.grey,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        onPressed: _formHueca,
        child: Container(
            height: 56,
            width: 90,
            child: Center(
                child: Text(
              "Guardar",
              style: TextStyle(fontSize: 16.0),
            ))),
        color: AppColors.mainColor,
        textColor: Colors.white,
      )
    ];
  }

  void _to_firstPhase() {
    _btns = _btns1();
    page1 = true;
    page2 = false;
    _editable = false;
    _controllerName.text = _name2;
    _controllerCategory.text = _categoria2;
    _controllerCity.text = _ciudad2;
    _controllerDescription.text = _description2;
    _controllerAddress.text = _address2;
    _controllerPhone.text = _phone2;
    _save_changes();
    setState(() {});
  }

  List<Widget> _btns3() {
    return [
      //LogoutBtn(_state),
      SizedBox(
        width: 8,
      ),
      RaisedButton(
        splashColor: Colors.grey,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        onPressed: _to_secondPhase,
        child: Container(
            height: 56,
            width: 90,
            child: Center(
                child: Text(
              "Cancel",
              style: TextStyle(fontSize: 16.0),
            ))),
        color: AppColors.mainColor,
        textColor: Colors.white,
      ),
      SizedBox(
        width: 8,
      ),
      RaisedButton(
        splashColor: Colors.grey,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        onPressed: _saveLocation,
        child: Container(
            height: 56,
            width: 90,
            child: Center(
                child: Text(
              "Guardar",
              style: TextStyle(fontSize: 16.0),
            ))),
        color: AppColors.mainColor,
        textColor: Colors.white,
      )
    ];
  }

  void _saveLocation() {
    _latitud2 = _latitud;
    _longitud2 = _longitud;
    _to_secondPhase();
  }

  void _formHueca() async {
    if (_controllerName.text != "") _name = _controllerName.text;
    if (_controllerDescription.text != "")
      _description = _controllerDescription.text;
    if (_controllerAddress.text != "") _address = _controllerAddress.text;
    if (_controllerPhone.text != "") _phone = _controllerPhone.text;
    if (_selectedCategoryTemp != null)
      _selectedCategory = _selectedCategoryTemp;
    if (_selectedCityTemp != null) _selectedCity = _selectedCityTemp;
    if (await HuecaService.update_hueca(
        hueca: _hueca,
        name: _name,
        description: _description,
        address: _address,
        phone: _phone,
        latitude: _latitud2,
        longitude: _longitud2,
        city_id: _selectedCity.id,
        category_id: _selectedCategory.id)) {
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Util.longToastCenter(
          msg: "Hueca no pudo ser actualizada", context: _context);
    }

    setState(() {});
  }

  void _deleteHueca() async {
    if (await HuecaService.delete_hueca(hueca: _hueca)) {
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Util.longToastCenter(
          msg: "Hueca no pudo ser eliminada", context: _context);
    }
  }

  void _addPlato() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Agregar_Plato(hueca: _hueca),
        ));
  }

  List<Widget> _platoButton() {
    return [
      SizedBox(
        width: 8,
      ),
      RaisedButton(
        splashColor: Colors.grey,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        onPressed: _addPlato,
        child: Container(
            height: 56,
            width: 140,
            child: Center(
                child: Text(
              "Añadir Plato",
              style: TextStyle(fontSize: 16.0),
            ))),
        color: AppColors.mainColor,
        textColor: Colors.white,
      )
    ];
  }
}
