import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:supportme_app/Services/signup_service.dart';
import 'package:supportme_app/Util/Util.dart';
import 'package:supportme_app/Variables/AppColors.dart';
import 'package:supportme_app/screens/login/Signup/components/background.dart';
import 'package:supportme_app/screens/login/components/already_have_an_account_acheck.dart';
import 'package:supportme_app/screens/login/components/rounded_button.dart';
import 'package:supportme_app/screens/login/components/rounded_input_field.dart';
import 'package:supportme_app/screens/login/components/rounded_password_field.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _username;
  String _password;
  String _email;
  String _last_name;
  String _first_name;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _username = "";
    _password = "";
    _email = "";
    _last_name = "";
    _first_name = "";
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
              "WELCOME TO SUPPORTME",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.kPrimaryColor),
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "User Name",
              onChanged: (value) {
                _username = value.toString();
                setState(() {});
              },
            ),
            RoundedInputField(
              icon: Icons.email,
              hintText: "Email",
              onChanged: (value) {
                _email = value.toString();
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
              text: "SIGNUP",
              press: () {
                if (_username == "" || _password == "" || _email == "") {
                  Util.longToastCenter(msg: "Empty Fields", context: context);
                } else if (_username.length < 6) {
                  Util.longToastCenter(
                      msg: "Invalid Username Minimum 6 Characters",
                      context: context);
                } else if (!EmailValidator.validate(_email)) {
                  Util.longToastCenter(msg: "Invalid Email", context: context);
                } else if (_password.length < 8) {
                  Util.longToastCenter(
                      msg: "Invalid Password Minimum 8 Characters",
                      context: context);
                } else if (!SignUpService.isPassword(_password)) {
                  Util.longToastCenter(
                      msg:
                          "Password Minimum one Uppercase, Lowercase and Numbers.",
                      context: context);
                } else {
                  SignUpService.on_signup(
                      username: _username,
                      password: _password,
                      email: _email,
                      context: context);
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
