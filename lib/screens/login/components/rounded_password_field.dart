import 'package:flutter/material.dart';
import 'package:supportme_app/Variables/AppColors.dart';
import 'package:supportme_app/screens/login/components/text_field_container.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {

  bool _hiddenPassword;
  @override
  void initState() {
    super.initState();
    _hiddenPassword=true;
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(

        obscureText: _hiddenPassword,
        onChanged: widget.onChanged,
        cursorColor: AppColors.kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: AppColors.kPrimaryColor,
          ),
          suffixIcon: GestureDetector(
            onTap: (){
              setState(() {
                _hiddenPassword=!_hiddenPassword;
              });
            },
            child: Icon(
            Icons.visibility,
            color: AppColors.kPrimaryColor,
          ),),
          border: InputBorder.none,
        ),
      ),
    );
  }

}
