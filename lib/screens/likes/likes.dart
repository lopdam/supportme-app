import 'package:flutter/material.dart';
import 'package:supportme_app/Models/account_save.dart';
import 'package:supportme_app/screens/common/loginBtn.dart';
import 'package:supportme_app/screens/huecas/types_hueca_list.dart';

class Likes extends StatefulWidget {
  @override
  _Likes createState() => _Likes();
}

class _Likes extends State<Likes> {
  Widget _screen;
  BuildContext _context;

  @override
  void initState() {
    _screen = LoginBtn();
    verificarLogin();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return _screen;
  }

  void verificarLogin() {
    setState(() {
      if (AccountSave.isLogin()) {
        _screen = LikesHuecaList();
      } else {
        _screen = LoginBtn();
      }
    });
  }
}
