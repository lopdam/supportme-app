import 'package:flutter/material.dart';
import 'package:supportme_app/Models/account_save.dart';
import 'package:supportme_app/Services/like_service.dart';
import 'package:supportme_app/Variables/AppColors.dart';
import 'package:supportme_app/screens/login/Login/login_screen.dart';

class LikeBtn extends StatefulWidget {
  int _hueca;

  LikeBtn(this._hueca);

  @override
  _LikeBtn createState() {
    return _LikeBtn(_hueca);
  }
}

class _LikeBtn extends State<LikeBtn> {
  Icon _likeIcon;
  bool _like;
  bool _on_loadLike;
  Widget _body;
  int _hueca;

  _LikeBtn(this._hueca);
  double _sizeIconNot;
  double _sizeIconLike;

  Icon _iconLike;
  Icon _iconNotLike;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sizeIconNot = 28;
    _sizeIconLike = 32;

    _iconLike = Icon(
      Icons.favorite,
      color: AppColors.ColorLike,
      size: _sizeIconLike,
    );

    _iconNotLike = Icon(
      Icons.favorite_border,
      color: AppColors.mainColor,
      size: _sizeIconNot,
    );

    _like = false;
    _on_loadLike = false;
    _likeIcon = _iconNotLike;

    LikeService.get_like(hueca: _hueca).then((like) => {_onLoadLike(like)});
  }

  @override
  Widget build(BuildContext context) {
    _body = Visibility(
      visible: _on_loadLike,
      child: RawMaterialButton(
        elevation: 4,
        fillColor: Colors.white,
        padding: EdgeInsets.all(15.0),
        shape: CircleBorder(),
        onPressed: _on_like,
        child: _likeIcon,
      ),
    );
    return _body;
  }

  void _on_like() {
    if (!AccountSave.isLogin()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ),
      );
    } else {
      if (_like) {
        _likeIcon = _iconNotLike;

        LikeService.delete_like(hueca: _hueca);
        _like = false;
      } else {
        _likeIcon = _iconLike;

        LikeService.post_like(hueca: _hueca);
        _like = true;
      }

      setState(() {});
    }
  }

  void _onLoadLike(bool like) {
    _like = like;
    _on_loadLike = true;
    if (_like) {
      _likeIcon = _iconLike;
    }
    setState(() {});
  }
}
