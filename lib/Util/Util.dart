import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class Util {
  static Size sizeScreen({BuildContext context}) {
    MediaQueryData queryData = MediaQuery.of(context);
    return queryData.size;
  }

  static Orientation orientationScreen({BuildContext context}) {
    MediaQueryData queryData = MediaQuery.of(context);
    return queryData.orientation;
  }

  static void longToast({BuildContext context, String msg}) {
    Toast.show(msg, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  static void shortToast({BuildContext context, String msg}) {
    Toast.show(msg, context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }

  static void shortToastCenter({BuildContext context, String msg}) {
    Toast.show(msg, context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
  }

  static void longToastCenter({BuildContext context, String msg}) {
    Toast.show(msg, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }

  static void shortToastTop({BuildContext context, String msg}) {
    Toast.show(msg, context, duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
  }

  static void longToastTop({BuildContext context, String msg}) {
    Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
  }
}
