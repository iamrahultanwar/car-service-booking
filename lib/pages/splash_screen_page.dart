import 'dart:async';

import 'package:autoflipz_user_app/pages/account_page.dart';

import '../models/user_model.dart';
import '../pages/home_page.dart';

import '../pages/login_page.dart';
import '../pages/select_car_page.dart';
import '../pages/select_city_page.dart';
import '../services/http_service.dart';
import '../services/shared_preferences.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget {
  static String routeName = "/splash-screen";

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  void getInitialRoute() async {
    bool _isFirstTime = await isFirstTime();
    if (_isFirstTime) {
      setRoutes(LoginPage.routeName);
    } else {
      String _isUserLoggedIn = await getUserToken();

      if (_isUserLoggedIn == null) {
        setRoutes(LoginPage.routeName);
      } else {
        UserModel _user = await userDetails(_isUserLoggedIn);
        if (_user.userCar.id == null) {
          setRoutes(SelectCarPage.routeName);
        } else if (_user.userRegion.name == "") {
          setRoutes(SelectCityPage.routeName);
        } else if (_user.email == null || _user.email.isEmpty) {
          setRoutes(AccountPage.routeName);
        } else {
          setRoutes(HomePage.routeName);
        }
      }
    }
  }

  void setRoutes(String route) {
    new Timer(new Duration(milliseconds: 500), () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed(route);
      } else {
        Navigator.of(context).pushReplacementNamed(route);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 500), () {
      getInitialRoute();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset("assets/images/car_loading.gif"),
      ),
    );
  }
}
