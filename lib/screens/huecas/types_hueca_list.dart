import 'package:flutter/material.dart';
import 'package:supportme_app/screens/huecas/body_listhuecas.dart';

//enum TypeHuecaLoad { LIKES, NORMAL, LOCATION, CATEGORY, , SEARCH, CITY }

class LikesHuecaList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListViewHuecas.Likes();
  }
}

class NormalHuecaList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListViewHuecas.Normal();
  }
}

class CategoryHuecaList extends StatelessWidget {
  int _category;
  CategoryHuecaList(this._category);

  @override
  Widget build(BuildContext context) {
    return ListViewHuecas.Category(_category);
  }
}

class SearchHuecaList extends StatelessWidget {
  String _search;
  SearchHuecaList(this._search);

  @override
  Widget build(BuildContext context) {
    return ListViewHuecas.Search(_search);
  }
}

class CityHuecaList extends StatelessWidget {
  int _city;
  CityHuecaList(this._city);
  @override
  Widget build(BuildContext context) {
    return ListViewHuecas.City(_city);
  }
}

class LocationHuecaList extends StatelessWidget {
  double _latitude;
  double _longitude;
  double _km;

  LocationHuecaList(this._latitude, this._longitude, this._km);

  @override
  Widget build(BuildContext context) {
    return ListViewHuecas.Location(_latitude, _longitude, _km);
  }
}
