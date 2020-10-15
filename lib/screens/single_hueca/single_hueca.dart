import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:supportme_app/Models/hueca_model.dart';
import 'package:supportme_app/Models/image_model.dart';
import 'package:supportme_app/Services/config_conection.dart';
import 'package:supportme_app/Services/hueca_sevice.dart';
import 'package:supportme_app/Services/image_service.dart';
import 'package:supportme_app/Util/Util.dart';
import 'package:supportme_app/Variables/AppColors.dart';
import 'package:supportme_app/screens/common/circle_Indicator.dart';
import 'package:supportme_app/screens/single_hueca//likeBtn.dart';
import 'package:supportme_app/screens/single_hueca/comment_list.dart';
import 'package:supportme_app/screens/single_hueca/infoHuecaBtn.dart';
import 'package:supportme_app/screens/single_hueca/menu_list.dart';
import 'package:supportme_app/screens/single_hueca/ratingbar_indicator.dart';

class SingleHueca extends StatefulWidget {
  String _name;
  int _hueca;

  SingleHueca({String name, int hueca}) {
    _name = name;
    _hueca = hueca;
  }

  @override
  _SingleHueca createState() {
    return _SingleHueca(name: _name, hueca: _hueca);
  }
}

class _SingleHueca extends State<SingleHueca> {
  String _name;
  int _hueca;
  BuildContext _context;
  List<Widget> _listImages;
  bool _on_loadHueca;
  Widget _mainContainer;
  HuecaModel _huecaInfo;

  PageController _pageController;
  int _currentPage;

  Color _colorfont1;
  Color _colorfont2;
  Color _colorBackgorund1;
  Color _colorBackgorund2;

  _SingleHueca({String name, int hueca}) {
    _name = name;
    _hueca = hueca;
  }

  @override
  void initState() {
    super.initState();

    _on_loadHueca = false;
    _listImages = List();

    _colorfont1 = Colors.white;
    _colorBackgorund1 = AppColors.mainColor;
    _colorfont2 = AppColors.mainColor;
    _colorBackgorund2 = Colors.white;
    _currentPage = 0;

    _pageController = PageController(initialPage: _currentPage, keepPage: true);

    HuecaService.get_hueca(hueca: _hueca).then((hueca) => {_loadHueca(hueca)});
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    _mainContainer = Scaffold(
      floatingActionButton: _locationWidget(),
      body: (_on_loadHueca) ? _body() : CircleIndicator(),
    );
    return _mainContainer;
  }

  Widget _body() {
    return Column(
      children: [
        Expanded(
          flex: 9,
          child: Stack(
            children: [
              ListView(
                scrollDirection: Axis.horizontal,
                children: _listImages,
              ),
              _arrowBack(),
              _nameHueca(),
              Positioned(left: -4, bottom: 48, child: InfoBtn(_huecaInfo)),
              Positioned(
                  left: 12, bottom: 0, child: RatingBarIndicator(_hueca)),
              Positioned(right: 0, bottom: 4, child: LikeBtn(_hueca))
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: _pageControlContainer(),
        ),
        Expanded(
          flex: 11,
          child: _pageContainer(),
        ),
      ],
    );
  }

  Widget _pageContainer() {
    return PageView(
      controller: _pageController,
      children: [MenusListHueca(_hueca), CommentListHueca(_hueca)],
      onPageChanged: (int index) {
        setState(() {
          _currentPage = index;
          _changeColorTaps(index);
        });
      },
    );
  }

  Widget _pageControlContainer() {
    return Container(
      width: Util.sizeScreen(context: _context).width,
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () => _changePage(0),
                child: Card(
                    color: _colorBackgorund1,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Center(
                        child: Text(
                          "Menus",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: _colorfont1),
                        ),
                      ),
                    )),
              )),
          Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () => _changePage(1),
                child: Card(
                    elevation: 4,
                    color: _colorBackgorund2,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Center(
                          child: Text(
                        "Commentarios",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: _colorfont2),
                      )),
                    )),
              )),
        ],
      ),
    );
  }

  void _changePage(int index) {
    setState(() {
      _currentPage = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
      _changeColorTaps(index);
    });
  }

  void _changeColorTaps(int index) {
    if (index == 0) {
      _colorfont1 = Colors.white;
      _colorBackgorund1 = AppColors.mainColor;
      _colorfont2 = AppColors.mainColor;
      _colorBackgorund2 = Colors.white;
    } else {
      _colorfont2 = Colors.white;
      _colorBackgorund2 = AppColors.mainColor;
      _colorfont1 = AppColors.mainColor;
      _colorBackgorund1 = Colors.white;
    }
  }

  Widget _locationWidget() {
    return Visibility(
      visible: _currentPage == 0,
      child: FloatingActionButton(
          child: Icon(
            Icons.location_on,
            size: 28,
            color: Colors.white,
          ),
          onPressed: () {
            MapsLauncher.launchCoordinates(
                _huecaInfo.latitude, _huecaInfo.longitude);
          }),
    );
  }

  Widget _arrowBack() {
    return Positioned(
      top: 28,
      left: 4,
      child: GestureDetector(
        onTap: () {
          Navigator.of(_context).pop();
        },
        child: Card(
          elevation: 4,
          color: AppColors.mainColor,
          child: Padding(
            padding: EdgeInsets.all(6.0),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  Widget _nameHueca() {
    return Positioned(
        left: 48,
        top: 28,
        child: Card(
          elevation: 2,
          child: Container(
            padding: EdgeInsets.only(left: 2, right: 1),
            width: Util.sizeScreen(context: _context).width * 0.80,
            child: Text(
              _name,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              maxLines: 2,
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainColor),
            ),
          ),
        ));
  }

  Widget _createImageHueca(String url) {
    return Container(
      width: Util.sizeScreen(context: _context).width,
      child: ClipRRect(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(48.0),
              bottomLeft: Radius.circular(48.0)),
          child: Card(elevation: 4, child: Image.network(Config.api + url))),
    );
  }

  void _loadHueca(HuecaModel hueca) {
    _huecaInfo = hueca;
    ImageService.get_images(hueca: hueca.id)
        .then((images) => {_loadImages(images)});
  }

  void _loadImages(List<ImageModel> images) {
    List<Widget> _tmplistImages = List();

    for (ImageModel image in images) {
      _tmplistImages.add(_createImageHueca(image.image));
      //Util.shortToastCenter(msg: image.image, context: _context);
    }
    _listImages = _tmplistImages;
    _on_loadHueca = true;

    setState(() {});
  }
}
