import 'package:flutter/material.dart';
import 'package:supportme_app/Util/Util.dart';

class CircleIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Container(
        width: Util.sizeScreen(context: context).width * 0.5,
        height: Util.sizeScreen(context: context).width * 0.5,
        child: CircularProgressIndicator(
          strokeWidth: 8,
        ),
      ),
    );
  }
}
