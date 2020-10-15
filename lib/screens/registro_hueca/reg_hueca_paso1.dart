import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:supportme_app/screens/registro_hueca/agregarPlato.dart';

class Registro_Hueca extends StatefulWidget {
  @override
  _Registro_Hueca createState() => _Registro_Hueca();
}

class _Registro_Hueca extends State<Registro_Hueca> {
  Widget _screen;
  BuildContext _context;

  Completer<GoogleMapController> _controller = Completer();

  static LatLng _initialPosition;
  final Set<Marker> _markers = {};
  static LatLng _lastMapPosition = _initialPosition;

  File _image;
  final picker = ImagePicker();

  String _name;
  String _categoria;
  String _ciudad;
  String _description;
  String _address;
  String _phone;

  double _latitud;
  double _longitud;

  List<CityModel> _cities; //

  CityModel _selectedCity; //

  List<CategoryModel> _categories;

  CategoryModel _selectedCategory;
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

  List<Widget> _btns;
  State _state;

  @override
  void initState() {
    super.initState();
    _verificador = false;
    _editable = true;
    _state = this;
    _name = "";
    _description = "";
    _address = "";
    _categoria = "";
    _ciudad = "";
    _phone = "";

    _cities = List();

    _categories = List();

    _controllerName = TextEditingController(text: _name);
    _controllerDescription = TextEditingController(text: _description);
    _controllerAddress = TextEditingController(text: _address);
    _controllerPhone = TextEditingController(text: _phone);

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

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

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
          title: Text("Agregar Hueca"),
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
          Text('Registrar Hueca'),
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
                  hintText: "nombre",
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
                keyboardType: TextInputType.name,
                controller: _controllerAddress,
                enabled: _editable,
                cursorColor: AppColors.kPrimaryColor,
                decoration: InputDecoration(
                  icon: Text("Direccion:"),
                  hintText: "direccion",
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
                  hintText: "telefono",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Visibility(
            visible: page1,
            child: _dropCities,
          ),
          Visibility(
            visible: page1,
            child: _dropCategories,
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
              onPressed: _getImage,
              tooltip: 'Pick Image',
              child: Icon(Icons.add_a_photo),
            ),
          ),
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
          )
        ],
      ),
    );
  }

  _loadCategories(List<CategoryModel> categories) {
    _categories = categories;
    _dropCategories = DropdownButton(
      elevation: 3,
      hint: Text('Category'),
      value: _selectedCategory,
      onChanged: (value) {
        _selectedCategory = value;
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
    _dropCities = DropdownButton(
      elevation: 3,
      hint: Text('City'),
      value: _selectedCity,
      onChanged: (value) {
        _selectedCity = value;
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

  void _getUserLocation() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _addMarker(_initialPosition);
      print('${placemark[0].name}');
    });
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
              "Siguiente",
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
    page1 = false;
    page2 = true;
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
              "Atrás",
              style: TextStyle(fontSize: 16.0),
            ))),
        color: AppColors.mainColor,
        textColor: Colors.white,
      ),
      RaisedButton(
        splashColor: Colors.grey,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        onPressed: _form_hueca,
        child: Container(
            height: 56,
            width: 90,
            child: Center(
                child: Text(
              "Registrar",
              style: TextStyle(fontSize: 16.0),
            ))),
        color: AppColors.mainColor,
        textColor: Colors.white,
      )
    ];
  }

  void _to_firstPhase() {
    _btns = _btns1();
    _save_changes();
    page1 = true;
    page2 = false;
    setState(() {});
  }

  void _form_hueca() {
    _name = _controllerName.text;
    _description = _controllerDescription.text;
    _address = _controllerAddress.text;
    _phone = _controllerPhone.text;
    if (_name == "" ||
        _description == "" ||
        _address == "" ||
        _phone == "" ||
        _categoria == "" ||
        _ciudad == "") {
      Util.longToastCenter(
          msg: "Campos sin llenar en sección anterior", context: _context);
    } else if (_phone.length < 7) {
      Util.longToastCenter(
          msg: "El número de telefono debe contener al menos 7 digitos",
          context: _context);
    } else if (_image == null) {
      Util.longToastCenter(
          msg: "No ha subido una imagen para la hueca", context: _context);
    } else {
      HuecaService.post_Hueca(
              name: _name,
              description: _description,
              address: _address,
              phone: _phone,
              latitude: _latitud,
              longitude: _longitud,
              city_id: _selectedCity.id,
              category_id: _selectedCategory.id)
          .then((value) => {
                if (value >= 0)
                  {
                    print("registro de hueca exitoso: " + value.toString()),
                    ImageService.post_Image(image: _image, hueca: value)
                        .then((value2) => {
                              if (value2)
                                print("Imagen Subido exitosamente")
                              else
                                print("Imagen no subido exitosamente")
                            }),
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Agregar_Plato(hueca: value),
                        ))
                  }
                else
                  {print("registro de hueca fallido")}
              });
    }

    setState(() {});
  }
}
