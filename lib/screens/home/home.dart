import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:supportme_app/Models/account_save.dart';
import 'package:supportme_app/Variables/AppColors.dart';
import 'package:supportme_app/screens/huecas/huecas.dart';
import 'package:supportme_app/screens/likes/likes.dart';
import 'package:supportme_app/screens/login/Login/login_screen.dart';
import 'package:supportme_app/screens/profile/profile.dart';
import 'package:supportme_app/screens/registro_hueca/reg_hueca_paso1.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  int _currentPage;
  PageController _pageController;
  BuildContext _context;

  @override
  void initState() {
    super.initState();
    _currentPage = 1;
    _pageController = PageController(initialPage: _currentPage, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: _appBar(),
      body: PageView(
        controller: _pageController,
        children: [Likes(), Huecas(), Profile()],
        onPageChanged: (int index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
      bottomNavigationBar: _bottomNav(),
      floatingActionButton: _floatingBtn(),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text(widget.title),
    );
  }

  Widget _bottomNav() {
    return BottomNavyBar(
      selectedIndex: _currentPage,
      iconSize: 24.0,
      items: [
        BottomNavyBarItem(
          icon: Icon(Icons.favorite),
          title: Text("Likes"),
          activeColor: AppColors.mainColor,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.home),
          title: Text("Huecas"),
          activeColor: AppColors.mainColor,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.account_circle),
          title: Text("Perfil"),
          activeColor: AppColors.mainColor,
        ),
      ],
      onItemSelected: (int index) {
        setState(() {
          _currentPage = index;
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 600), curve: Curves.ease);
        });
      },
    );
  }

  Widget _floatingBtn() {
    return Visibility(
      child: FloatingActionButton.extended(
        elevation: 4,
        onPressed: () {
          if (AccountSave.isLogin()) {
            Navigator.push(_context,
                MaterialPageRoute(builder: (context) => Registro_Hueca()));
          } else {
            Navigator.push(_context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          }
        },
        icon: Icon(Icons.local_dining),
        label: Text('Add'),
      ),
      visible: _currentPage == 1,
    );
  }
}
