import 'dart:convert';

import '../models/car_model.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future<bool> isFirstTime() async {
  final SharedPreferences prefs = await _prefs;
  bool _isFirstTime = prefs.getBool("isFirstTime");
  if (_isFirstTime == null) {
    await prefs.setBool("isFirstTime", false);
    return true;
  } else if (_isFirstTime == false) {
    return false;
  }

  return false;
}

Future<bool> saveUserToken(String token) async {
  final SharedPreferences prefs = await _prefs;
  await prefs.setString('token', token);
  return true;
}

Future<String> getUserToken() async {
  final SharedPreferences prefs = await _prefs;
  return prefs.getString('token');
}

Future<bool> saveUserLocally(UserModel data) async {
  final SharedPreferences prefs = await _prefs;
  var saveData = {
    "_id": data.id.toString(),
    "mobile": data.mobile.toString(),
    "email": data.email.toString(),
    "name": data.name.toString(),
    "region": {
      "name": data.userRegion.name.toString(),
      "_id": data.userRegion.id.toString()
    },
    "area": {
      "address": data.userArea.address,
      "pin_code": data.userArea.pinCode
    },
    "car": {
      "car_image": data.userCar.logo.toString(),
      "_id": data.userCar.id.toString(),
      "car_make": data.userCar.make.toString(),
      "car_model": data.userCar.model.toString(),
      "car_type": data.userCar.type.toString(),
      "car_category": data.userCar.category.toString()
    },
    "cart": {"_id": data.userCart.id.toString(), "sub_services": []}
  };
  await prefs.setString("user", jsonEncode(saveData));
  return true;
}

Future<UserModel> getUserLocally() async {
  final SharedPreferences prefs = await _prefs;
  var _temp = jsonDecode(prefs.getString('user'));
  return UserModel.fromJson(_temp);
}

Future<CarModel> getUserCar() async {
  final SharedPreferences prefs = await _prefs;
  UserModel user = UserModel.fromJson(jsonDecode(prefs.getString('user')));

  return user.userCar;
}

Future<CartModel> getUserCart() async {
  final SharedPreferences prefs = await _prefs;
  UserModel user = UserModel.fromJson(jsonDecode(prefs.getString('user')));
  return user.userCart;
}

Future<bool> logOutUser() async {
  final SharedPreferences prefs = await _prefs;
  return prefs.clear();
}
