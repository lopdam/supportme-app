import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:supportme_app/Models/account_save.dart';
import 'package:supportme_app/Models/user_model.dart';
import 'package:supportme_app/Services/signup_service.dart';
import 'package:supportme_app/Util/Util.dart';
import 'package:supportme_app/Variables/AppColors.dart';
import 'package:supportme_app/screens/common/circle_Indicator.dart';
import 'package:supportme_app/screens/common/loginBtn.dart';
import 'package:supportme_app/screens/common/logoutBtn.dart';
import 'package:supportme_app/screens/login/components/text_field_container.dart';
import 'package:supportme_app/screens/mishuecas/mishuecas.dart';

class Profile extends StatefulWidget {
  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  Widget _screen;
  BuildContext _context;

  String _username;
  String _password;
  String _email;
  String _last_name;
  String _first_name;
  List<Widget> _btns;
  State _state;
  bool _editable;

  bool _loadUser;

  TextEditingController _controllerUsername;

  TextEditingController _controllerEmail;
  TextEditingController _controllerLast_name;
  TextEditingController _controllerFirst_name;

  _NexPassword _newPassword;

  @override
  void initState() {
    super.initState();
    _state = this;
    _screen = LoginBtn();
    _username = "";
    _password = "";
    _email = "";
    _last_name = "";
    _first_name = "";
    _btns = _btns1();
    _editable = false;
    _loadUser = false;

    chargeUserInfo();
  }

  chargeUserInfo() {
    SignUpService.on_userInfo().then((user) => {
          if (user != null) {userInfo(user)}
        });
  }

  void userInfo(User user) {
    _username = user.username;
    _email = user.email;
    _last_name = user.last_name;
    _first_name = user.first_name;
    _loadUser = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _newPassword = _NexPassword();
    _controllerUsername = TextEditingController(text: _username);
    // _controllerPassword = TextEditingController();
    _controllerEmail = TextEditingController(text: _email);
    _controllerLast_name = TextEditingController(text: _last_name);
    _controllerFirst_name = TextEditingController(text: _first_name);

    verificarLogin();

    _context = context;
    return _screen;
  }

  Widget _profileAccount() {
    return (_loadUser)
        ? SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 12.0,
                ),
                Visibility(
                  visible: !_editable,
                  child: Icon(
                    Icons.account_circle,
                    size: Util.sizeScreen(context: _context).width * 0.32,
                  ),
                ),
                TextFieldContainer(
                  child: TextField(
                    keyboardType: TextInputType.name,
                    controller: _controllerUsername,
                    enabled: _editable,
                    cursorColor: AppColors.kPrimaryColor,
                    decoration: InputDecoration(
                      icon: Text("Username:"),
                      hintText: "User Name",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextFieldContainer(
                  child: TextField(
                    keyboardType: TextInputType.name,
                    controller: _controllerFirst_name,
                    enabled: _editable,
                    cursorColor: AppColors.kPrimaryColor,
                    decoration: InputDecoration(
                      icon: Text("Name:"),
                      hintText: "First Name",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextFieldContainer(
                  child: TextField(
                    keyboardType: TextInputType.name,
                    controller: _controllerLast_name,
                    enabled: _editable,
                    cursorColor: AppColors.kPrimaryColor,
                    decoration: InputDecoration(
                      icon: Text("Last Name:"),
                      hintText: "Last Name",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextFieldContainer(
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _controllerEmail,
                    enabled: _editable,
                    cursorColor: AppColors.kPrimaryColor,
                    decoration: InputDecoration(
                      icon: Text("Email:"),
                      hintText: "Email",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Visibility(
                  child: _newPassword,
                  visible: _editable,
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _btns,
                ),
                SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: !_editable,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _huecasButton(),
                  ),
                ),
              ],
            ),
          )
        : CircleIndicator();
  }

  void verificarLogin() {
    setState(() {
      if (AccountSave.isLogin()) {
        // _screen = Container(
        //     child: Center(
        //   child: LogoutBtn(this),
        // ));
        _screen = _profileAccount();
      } else {
        _screen = LoginBtn();
      }
    });
  }

  void _changeBtn2() {
    _btns = _btns2();
    _editable = true;
    setState(() {});
  }

  List<Widget> _btns1() {
    return [
      LogoutBtn(_state),
      SizedBox(
        width: 8,
      ),
      RaisedButton(
        splashColor: Colors.grey,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        onPressed: _changeBtn2,
        child: Container(
            height: 56,
            width: 48,
            child: Center(
                child: Text(
              "EDIT",
              style: TextStyle(fontSize: 16.0),
            ))),
        color: AppColors.mainColor,
        textColor: Colors.white,
      )
    ];
  }

  List<Widget> _huecasButton() {
    return [
      SizedBox(
        width: 8,
      ),
      RaisedButton(
        splashColor: Colors.grey,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        onPressed: _toMisHuecas,
        child: Container(
            height: 56,
            width: 120,
            child: Center(
                child: Text(
              "MIS HUECAS",
              style: TextStyle(fontSize: 16.0),
            ))),
        color: AppColors.mainColor,
        textColor: Colors.white,
      )
    ];
  }

  void _toMisHuecas() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Mis_Huecas(),
        ));
  }

  void _changeBtn1() {
    _btns = _btns1();
    _editable = false;
    chargeUserInfo();
    setState(() {});
  }

  List<Widget> _btns2() {
    return [
      RaisedButton(
        splashColor: Colors.grey,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        onPressed: _formUser,
        child: Container(
            height: 56,
            width: Util.sizeScreen(context: context).width * 0.4,
            child: Center(
                child: Text(
              "SAVE",
              style: TextStyle(fontSize: 16.0),
            ))),
        color: AppColors.mainColor,
        textColor: Colors.white,
      ),
      SizedBox(
        width: 8,
      ),
      RaisedButton(
        splashColor: Colors.grey,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        onPressed: _changeBtn1,
        child: Container(
            height: 56,
            width: 64,
            child: Center(
                child: Text(
              "CANCEL",
              style: TextStyle(fontSize: 16.0),
            ))),
        color: AppColors.mainColor,
        textColor: Colors.white,
      )
    ];
  }

  void _formUser() {
    _username = _controllerUsername.text;
    _first_name = _controllerFirst_name.text;
    _last_name = _controllerLast_name.text;
    _email = _controllerEmail.text;
    _password = _newPassword.getPassword();

    if (_username == "" || _email == "") {
      Util.longToastCenter(msg: "Empty Fields", context: _context);
    } else if (_username.length < 6) {
      Util.longToastCenter(
          msg: "Invalid Username Minimum 6 Characters", context: _context);
    } else if (!EmailValidator.validate(_email)) {
      Util.longToastCenter(msg: "Invalid Email", context: _context);
    } else if (_password.length != 0 && _password.length < 8) {
      Util.longToastCenter(
          msg: "Invalid Password Minimum 8 Characters", context: _context);
      return;
    } else if (_password.length != 0 && !SignUpService.isPassword(_password)) {
      Util.longToastCenter(
          msg: "Password Minimum one Uppercase, Lowercase and Numbers.",
          context: _context);
      return;
    } else {
      SignUpService.on_editProfile(
              username: _username,
              password: _password,
              email: _email,
              last_name: _last_name,
              first_name: _first_name,
              context: _context)
          .then((value) => {
                if (value)
                  {
                    _state.setState(() {
                      _btns = _btns1();
                      _editable = false;
                    })
                  }
              });
    }
  }
}

class _NexPassword extends StatefulWidget {
  _NexPasswordState _nexPasswordState = _NexPasswordState();

  @override
  _NexPasswordState createState() {
    return _nexPasswordState;
  }

  String getPassword() {
    return _nexPasswordState.getPassword();
  }
}

class _NexPasswordState extends State<_NexPassword> {
  bool _hiddenPassword;
  TextEditingController _controllerPassword;
  Widget _body;

  @override
  void initState() {
    super.initState();
    _hiddenPassword = true;
    _controllerPassword = TextEditingController();
  }

  String getPassword() {
    return _controllerPassword.text;
  }

  void changeHidde() {
    _hiddenPassword = !_hiddenPassword;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _body = TextFieldContainer(
      child: TextField(
        controller: _controllerPassword,
        obscureText: _hiddenPassword,
        cursorColor: AppColors.kPrimaryColor,
        decoration: InputDecoration(
          hintText: "New Password",
          icon: Icon(
            Icons.lock,
            color: AppColors.kPrimaryColor,
          ),
          suffixIcon: GestureDetector(
            onTap: changeHidde,
            child: Icon(
              Icons.visibility,
              color: AppColors.kPrimaryColor,
            ),
          ),
          border: InputBorder.none,
        ),
      ),
    );
    return _body;
  }
}
