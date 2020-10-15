import 'package:flutter/material.dart';
import 'package:supportme_app/Util/Util.dart';
import 'package:supportme_app/Variables/AppColors.dart';
import 'package:supportme_app/screens/login/Login/login_screen.dart';

class LoginBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        elevation: 4,
        splashColor: Colors.grey,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        onPressed: () => _onLoginPressd(context),
        child: Container(
            height: 56,
            width: Util.sizeScreen(context: context).width * 0.5,
            child: Center(
                child: Text(
              "Login",
              style: TextStyle(fontSize: 16.0),
            ))),
        color: AppColors.mainColor,
        textColor: Colors.white,
      ),
    );
  }

  void _onLoginPressd(context) {
    //Util.shortToast(context: context, msg: "Functionality not Implemented");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LoginScreen();
        },
      ),
    );
  }
}
