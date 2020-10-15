import 'package:flutter/material.dart';
import 'package:supportme_app/Variables/AppColors.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: AppColors.kPrimaryLightColor,
          border: Border.all(
            width: 1.5,
            color: AppColors.kPrimaryColor,
          ),
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
