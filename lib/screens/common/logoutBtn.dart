import 'package:flutter/material.dart';
import 'package:supportme_app/Services/login_service.dart';
import 'package:supportme_app/Util/Util.dart';
import 'package:supportme_app/Variables/AppColors.dart';
import 'package:supportme_app/screens/login/Login/login_screen.dart';

class LogoutBtn extends StatelessWidget {
  State _parent;

  LogoutBtn(this._parent);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        splashColor: Colors.grey,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        onPressed: () => _onLogoutPressed(context),
        child: Container(
            height: 56,
            width: Util.sizeScreen(context: context).width * 0.5,
            child: Center(
                child: Text(
              "Logout",
              style: TextStyle(fontSize: 16.0),
            ))),
        color: AppColors.mainColor,
        textColor: Colors.white,
      ),
    );
  }

  void _onLogoutPressed(context) async {
    //Util.shortToast(context: context, msg: "Functionality not Implemented");
    LoginService.logoutUSer(context).then((value) => {
        _parent.setState(() {

        })


    });
  }
}
