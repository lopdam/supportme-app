import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supportme_app/Models/category_model.dart';
import 'package:supportme_app/Models/city_model.dart';
import 'package:supportme_app/Services/category_service.dart';
import 'package:supportme_app/Services/city_service.dart';
import 'package:supportme_app/Services/location_service.dart';
import 'package:supportme_app/Util/Util.dart';
import 'package:supportme_app/Variables/AppColors.dart';
import 'package:supportme_app/screens/huecas/types_hueca_list.dart';

class Huecas extends StatefulWidget {
  @override
  _Huecas createState() => _Huecas();
}

class _Huecas extends State<Huecas> {
  double _km = 120;
  double _maxKm = 120;
  int _divisionKm = 30;

  BuildContext _context;

  List<CityModel> _cities; //

  CityModel _selectedCity; //

  List<CategoryModel> _categories;

  CategoryModel _selectedCategory;
  Widget _dropCities;

  Widget _dropCategories;
  Widget _mainContainer;
  Widget _listHuecasWidget;
  bool _hiddenSelectokm;

  int _flexBar;

  TextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    _hiddenSelectokm = false;
    _flexBar = 3;
    _listHuecasWidget = NormalHuecaList();

    _cities = List();

    _categories = List();

    CategoryService.get_categories()
        .then((categories) => {_loadCategories(categories)});

    CityService.get_cities().then((cities) => {_loadCities(cities)});
  }

  @override
  Widget build(BuildContext context) {
    _editingController = TextEditingController(text: "");

    _context = context;
    _dropCategories = DropdownButton(
      elevation: 3,
      hint: Text('Category'),
      // Not necessary for Option 1
      value: _selectedCategory,
      onChanged: (value) {
        _selectedCategory = value;
        _selectedCity = null;
        _km = _maxKm;
        _listHuecasWidget = CategoryHuecaList(_selectedCategory.id);

        setState(() {});
      },
      items: _categories.map((category) {
        return DropdownMenuItem(
          child: new Text(category.name),
          value: category,
        );
      }).toList(),
    );

    _dropCities = DropdownButton(
      elevation: 3,
      hint: Text('City'),
      value: _selectedCity,
      onChanged: (value) {
        _selectedCity = value;
        _selectedCategory = null;
        _km = _maxKm;
        _listHuecasWidget = CityHuecaList(_selectedCity.id);

        setState(() {});
      },
      items: _cities.map((city) {
        return DropdownMenuItem(
          child: new Text(city.name),
          value: city,
        );
      }).toList(),
    );

    _mainContainer = mainContainer();

    return _mainContainer;
  }

  Widget mainContainer() {
    return Column(
      children: [
        Expanded(
          flex: _flexBar,
          child: Card(
            elevation: 4,
            child: Container(
              width: Util.sizeScreen(context: _context).height * 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: _searchInput(),
                    ),
                    Visibility(
                      visible: !_hiddenSelectokm,
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: _dropCities),
                          Expanded(flex: 1, child: _dropCategories),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !_hiddenSelectokm,
                      child: Expanded(
                        child: Row(
                          children: [
                            Text(
                              "To Km:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Slider(
                                value: _km,
                                onChangeEnd: (value) {
                                  LocationService.getrequestPermission().then(
                                      (permission) =>
                                          {_loadWithLocation(value)});
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _km = value;
                                  });
                                },
                                divisions: _divisionKm,
                                label: '$_km km',
                                min: 0,
                                max: _maxKm,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 12,
          child: _listHuecasWidget,
        )
      ],
    );
  }

  Widget _searchInput() {
    return TextField(
      controller: _editingController,
      onTap: () => {_hiddenKm()},
      onEditingComplete: _onSearch,
      cursorColor: AppColors.kPrimaryColor,
      decoration: InputDecoration(
          hintText: "Search Hueca",
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          suffixIcon: Icon(
            Icons.search,
            color: AppColors.kPrimaryColor,
          )),
    );
  }

  _loadCategories(List<CategoryModel> categories) {
    _categories = categories;
    setState(() {});
  }

  _loadCities(List<CityModel> cities) {
    _cities = cities;
    setState(() {});
  }

  void _hiddenKm() {
    _hiddenSelectokm = true;
    //_flexBar = 3;
    setState(() {});
  }

  void _onSearch() {
    _selectedCity = null;
    _selectedCategory = null;
    _km = _maxKm;
    _hiddenSelectokm = false;
    //_flexBar = 2;
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).unfocus();

    if (_editingController.text != "") {
      _listHuecasWidget = SearchHuecaList(_editingController.text);
    }

    setState(() {});
  }

  void _loadWithLocation(double km) {
    _selectedCategory = null;
    _selectedCity = null;
    LocationService.getcheckPermission().then((value) => {
          if (value != LocationPermission.denied)
            {
              LocationService.getPosition()
                  .then((position) => {_getListLocation(position, km)})
            }
          else
            {_permissionDenied()}
        });
  }

  void _permissionDenied() {
    Util.shortToastCenter(msg: "Location Permission Denied", context: _context);
    _listHuecasWidget = NormalHuecaList();
    _km = _maxKm;
    setState(() {});
  }

  void _getListLocation(Position position, double km) {
    if (km < (_maxKm - 6)) {
      _listHuecasWidget =
          LocationHuecaList(position.latitude, position.longitude, km);
    } else {
      _listHuecasWidget = NormalHuecaList();
    }
    setState(() {});
  }
}
