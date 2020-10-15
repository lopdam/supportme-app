import 'package:flutter/material.dart';
import 'package:supportme_app/Services/active_service.dart';
import 'package:supportme_app/Services/login_service.dart';
import 'package:supportme_app/Variables/AppColors.dart';
import 'package:supportme_app/screens/home/home.dart';

class SupportMe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginService.getAccount()
        .then((value) => {ActiveService.verifiqueActiveToken()});

    return MaterialApp(
      title: 'SupportMe',
      theme: ThemeData(
        primarySwatch: AppColors.mainColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(title: 'SupportMe'),
    );
  }
}
