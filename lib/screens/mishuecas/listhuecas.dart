import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supportme_app/Models/city_model.dart';
import 'package:supportme_app/Models/hueca_model.dart';
import 'package:supportme_app/Models/image_model.dart';
import 'package:supportme_app/Services/city_service.dart';
import 'package:supportme_app/Services/config_conection.dart';
import 'package:supportme_app/Services/hueca_sevice.dart';
import 'package:supportme_app/Services/image_service.dart';
import 'package:supportme_app/Util/Util.dart';
import 'package:supportme_app/screens/common/circle_Indicator.dart';
import 'package:supportme_app/screens/mishuecas/hueca_form.dart';
import 'package:supportme_app/screens/single_hueca//single_hueca.dart';

class ListViewHuecas2 extends StatefulWidget {
  @override
  _ListViewHuecas2 createState() {
    return _ListViewHuecas2();
  }
}

class _ListViewHuecas2 extends State<ListViewHuecas2> {
  BuildContext _context;
  bool _imgExist;

  List<Widget> _listWidget;
  Widget _listView;
  bool _loadHuecas;
  int _numItemsLoad;

  List<CityModel> _cities;

  @override
  void initState() {
    super.initState();
    _loadHuecas = false;
    _numItemsLoad = 0;
    _imgExist = false;
    _cities = List();
    CityService.get_cities().then((cities) => {_loadCities(cities)});
    HuecaService.get_huecas_user().then((huecas) => {_addHuecas(huecas)});
  }

  @override
  Widget build(BuildContext context) {
    _listWidget = List();
    _context = context;
    return (_loadHuecas) ? _listView : CircleIndicator();
  }

  _addHuecas(List<HuecaModel> huecas) {
    if (huecas.length != 0) {
      for (HuecaModel hueca in huecas) {
        ImageService.get_images(hueca: hueca.id).then((images) => {
              _addImage(
                images: images,
                hueca: hueca,
                n: huecas.length,
              )
            });
      }
    } else {
      _listView = Center(
        child: Text("No existen Huecas"),
      );
      _loadHuecas = true;
      setState(() {});
    }
  }

  _addImage({List<ImageModel> images, HuecaModel hueca, int n}) {
    if (images.length != 0) {
      _listWidget.add(_listTile(image: images[0].image, hueca: hueca));
      _imgExist = true;
    }

    _numItemsLoad++;
    if (n == _numItemsLoad) {
      if (_imgExist) {
        _listView = ListView(
          children: _listWidget,
        );
      } else {
        _listView = Center(
          child: Text("No existen Huecas"),
        );
      }

      _loadHuecas = true;
      setState(() {});
    }
  }

  Widget _listTile({String image, HuecaModel hueca}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            _context,
            MaterialPageRoute(
                builder: (_context) => Profile_Hueca(
                      name: hueca.name,
                      description: hueca.description,
                      address: hueca.address,
                      phone: hueca.phone,
                      latitud: hueca.latitude,
                      longitud: hueca.longitude,
                      city_id: hueca.city,
                      category_id: hueca.category,
                      hueca: hueca.id,
                    )));
      },
      child: Card(
        elevation: 3.5,
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Row(
            children: [
              ConstrainedBox(
                constraints: new BoxConstraints(
                  minHeight: 100.0,
                  maxHeight: 180.0,
                  minWidth: Util.sizeScreen(context: _context).width * 0.35,
                  maxWidth: Util.sizeScreen(context: _context).width * 0.45,
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    child: Image.network(Config.api + image)),
              ),
              Container(
                width: Util.sizeScreen(context: _context).width * 0.45,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hueca.name,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        maxLines: 3,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        getCity(hueca.city),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                      ),
                      Text(
                        hueca.address,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _loadCities(List<CityModel> cities) {
    _cities = cities;
  }

  String getCity(int city) {
    for (CityModel i in _cities) {
      if (i.id == city) {
        return i.name;
      }
    }
    return "Ecuador";
  }
}
