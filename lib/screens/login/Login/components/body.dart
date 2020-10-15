import 'package:flutter/material.dart';
import 'package:supportme_app/Services/login_service.dart';
import 'package:supportme_app/Util/Util.dart';
import 'package:supportme_app/Variables/AppColors.dart';
import 'package:supportme_app/screens/login/Login/components/background.dart';
import 'package:supportme_app/screens/login/Signup/signup_screen.dart';
import 'package:supportme_app/screens/login/components/already_have_an_account_acheck.dart';
import 'package:supportme_app/screens/login/components/rounded_button.dart';
import 'package:supportme_app/screens/login/components/rounded_input_field.dart';
import 'package:supportme_app/screens/login/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _username;
  String _password ;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _username = "";
    _password = "";
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SUPPORTME",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.kPrimaryColor),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "User Name",
              onChanged: (value) {
                _username = value.toString();
                setState(() {});
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                _password = value.toString();
                setState(() {});
              },
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {

                if (_username == "" || _password == "") {
                  Util.longToast(msg: "Empty Fields", context: context);
                } else {
                  LoginService.on_login(
                      username: _username, password: _password, context: context);
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
