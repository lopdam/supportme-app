import 'package:flutter/material.dart';
import 'package:supportme_app/Models/menu_model.dart';
import 'package:supportme_app/Services/config_conection.dart';
import 'package:supportme_app/Services/menu_service.dart';
import 'package:supportme_app/Util/Util.dart';
import 'package:supportme_app/screens/common/circle_Indicator.dart';

class MenusListHueca extends StatefulWidget {
  int _hueca;

  MenusListHueca(this._hueca);

  @override
  _MenusListHueca createState() {
    return _MenusListHueca(_hueca);
  }
}

class _MenusListHueca extends State<MenusListHueca> {
  BuildContext _context;
  int _hueca;
  bool _loadMenu;
  List<Widget> _listMenuWidget;

  _MenusListHueca(this._hueca);
  Widget _listView;

  @override
  void initState() {
    super.initState();
    _loadMenu = false;
    MenuService.get_menus(hueca: _hueca).then((menus) => {_addMenus(menus)});
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    _listMenuWidget = List();
    return (_loadMenu) ? _listView : CircleIndicator();
  }

  _addMenus(List<MenuModel> menus) {
    if (menus.length != 0) {
      for (MenuModel menu in menus) {
        _listMenuWidget.add(_listTile(menu: menu));
      }
      _listView = ListView(
        children: _listMenuWidget,
      );
    } else {
      _listView = Center(
        child: Text("No existen Menus"),
      );
    }
    _loadMenu = true;
    setState(() {});
  }

  Widget _listTile({MenuModel menu}) {
    return Card(
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
                  child: Image.network(Config.api + menu.image)),
            ),
            Container(
              width: Util.sizeScreen(context: _context).width * 0.45,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menu.name,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      maxLines: 3,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      menu.description,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      maxLines: 5,
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    Text(
                      "\$ " + (menu.price).toString(),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.deepOrangeAccent),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
