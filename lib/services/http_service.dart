import 'dart:convert';

import '../models/car_model.dart';
import '../models/service_model.dart';
import '../models/user_model.dart';
import '../services/shared_preferences.dart';

import 'package:http/http.dart' as http;

//13.233.12.2
String baseUrl = "https://autoflipz.com";

//Fetch service available
Future<List<ServiceModel>> fetchServices() async {
  final response = await http.get('$baseUrl/api/admin/service');

  if (response.statusCode == 200) {
    List serviceList = json.decode(response.body);
    List<ServiceModel> returnList = serviceList.map<ServiceModel>((service) {
      return ServiceModel.fromJson(service);
    }).toList();
    return returnList;
  } else {
    throw Exception('Failed to load album');
  }
}

//Find cars on user input
Future<List<CarModel>> fetchCars(String input) async {
  final response = await http.get('$baseUrl/api/car/$input');

  if (response.statusCode == 200) {
    List carList = json.decode(response.body);
    List<CarModel> returnList = carList.map<CarModel>((car) {
      return CarModel.fromJson(car);
    }).toList();
    return returnList;
  } else {
    throw Exception('Failed to load album');
  }
}

Future<SubServiceModel> getGoldPass() async {
  final response = await http.get('$baseUrl/api/golduser/');
  if (response.statusCode == 200) {
    // List<dynamic> goldUser = json.decode(response.body);

    SubServiceModel gold = SubServiceModel.fromJson(json.decode(response.body));

    return gold;
  } else {
    throw Exception('Failed to load data');
  }
}

//Fetch SubServices On Users Car
Future<List<ServiceTab>> fetchSubService() async {
  CarModel _userCar = await getUserCar();

  final response = await http.get(
      '$baseUrl/api/sub_service?car_category=${_userCar.category}&car_type=${_userCar.type}');

  if (response.statusCode == 200) {
    try {
      Map serviceList = json.decode(response.body);

      List<ServiceTab> tempList = [];
      serviceList.forEach((k, v) {
        // if (k == 'Body Wrapping' || k == 'Special') {
        //   print(true);
        // } else {
        List<SubServiceModel> _tempSubServiceList =
            serviceList[k].map<SubServiceModel>((x) {
          if (x['questions'] == '' || x['questions'] == null) {
            print('empty questions!');
            x['questions'] = [];
          }
          if (x['components'] == '' || x['components'] == null) {
            print('empty components!');
            x['components'] = [];
          }
          return SubServiceModel.fromJson(x);
        }).toList();

        tempList.add(ServiceTab(
            name: k.toString(), subServiceList: _tempSubServiceList));
        // }
      });

      return tempList;
    } catch (error) {
      print(error);
      throw Exception(error);
    }
  } else {
    throw Exception('Failed to load services');
  }
}

//Search User Car SubServices
Future<List<SubServiceModel>> findService(String input) async {
  CarModel _userCar = await getUserCar();

  final response = await http.get(
      '$baseUrl/api/sub_service/$input?car_category=${_userCar.category}&car_type=${_userCar.type}');

  if (response.statusCode == 200) {
    List serviceList = json.decode(response.body);
    List<SubServiceModel> returnList =
        serviceList.map<SubServiceModel>((service) {
      return SubServiceModel.fromJson(service);
    }).toList();
    return returnList;
  } else {
    throw Exception('Failed to load album');
  }
}

//get login otp
Future<bool> getLoginOTP(String mobile) async {
  final response = await http.get('$baseUrl/api/user/login/otp/$mobile');

  if (response.statusCode == 200) {
    Map res = jsonDecode(response.body);
    // print(response.body);
    if (res["status"] == true) return true;
    return false;
  } else {
    throw Exception('Failed to load album');
  }
}

//verify login otp
Future<bool> verifyLoginOTP(String mobile, String otp) async {
  final response = await http.get('$baseUrl/api/user/verify-otp/$mobile/$otp');

  if (response.statusCode == 200) {
    Map res = jsonDecode(response.body);

    if (res["status"] == true) return true;
    return false;
  } else {
    throw Exception('Failed to load album');
  }
}

//Login User
Future<UserModel> loginUser(String mobile) async {
  final response = await http.get('$baseUrl/api/user/login/$mobile');

  if (response.statusCode == 200) {
    Map userData = json.decode(response.body);
    await saveUserLocally(UserModel.fromJson(userData));

    return UserModel.fromJson(userData);
  } else {
    throw Exception('Failed to load album');
  }
}

//get user details by id
Future<UserModel> userDetails(String id) async {
  final response = await http.get('$baseUrl/api/user/$id');
  if (response.statusCode == 200) {
    Map userData = json.decode(response.body);
    await saveUserLocally(UserModel.fromJson(userData));

    return UserModel.fromJson(userData);
  } else {
    throw Exception('Failed to load album');
  }
}

//get region list
Future<List<UserRegion>> fetchRegion() async {
  final response = await http.get('$baseUrl/api/region');
  if (response.statusCode == 200) {
    List region = json.decode(response.body);
    List<UserRegion> returnList = region.map<UserRegion>((region) {
      return UserRegion.fromJson(region);
    }).toList();
    return returnList;
  } else {
    throw Exception('Failed to load album');
  }
}

//update user details
Future<bool> updateUserDetails(Map data) async {
  String _userId = await getUserToken();
  final response = await http.put("$baseUrl/api/user/update/$_userId",
      body: jsonEncode(data), headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    Map userData = json.decode(response.body);
    await saveUserLocally(UserModel.fromJson(userData));
    return true;
  } else {
    throw Exception('Failed to load album');
  }
}

//get user cart
Future<CartModel> userCartDetails(String id) async {
  final response = await http.get('$baseUrl/api/user/cart/get/$id');

  if (response.statusCode == 200) {
    Map cartData = json.decode(response.body);
    return CartModel.fromJson(cartData);
  } else {
    throw Exception('Failed to load album');
  }
}

//add item to cart
Future<CartModel> userCartAddItem(CartModel cart) async {
  var tempServices = [];
  cart.subServices.forEach((f) {
    tempServices.add(f.id);
  });
  var data = {"sub_services": tempServices};
  final response = await http.put("$baseUrl/api/user/cart/add/${cart.id}",
      body: jsonEncode(data), headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    Map cartData = json.decode(response.body);
    return CartModel.fromJson(cartData);
  } else {
    throw Exception('Failed to load album');
  }
}

//remove item from cart
Future<CartModel> userCartRemoveItem(CartModel cart) async {
  var tempServices = [];
  cart.subServices.forEach((f) {
    tempServices.add(f.id);
  });
  var data = {"sub_services": tempServices};
  final response = await http.put("$baseUrl/api/user/cart/remove/${cart.id}",
      body: jsonEncode(data), headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    Map cartData = json.decode(response.body);
    return CartModel.fromJson(cartData);
  } else {
    throw Exception('Failed to load album');
  }
}

//make booking
Future<BookingModel> userBookService(Map data) async {
  final response = await http.post("$baseUrl/api/booking/make",
      body: jsonEncode(data), headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    return BookingModel.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

//get User bookings
Future<List<BookingModel>> fetchUserBookings() async {
  String _userId = await getUserToken();
  final response = await http.get('$baseUrl/api/booking/$_userId');
  if (response.statusCode == 200) {
    List bookingData = json.decode(response.body);
    List<BookingModel> returnList = bookingData.map<BookingModel>((region) {
      return BookingModel.fromJson(region);
    }).toList();
    return returnList;
  } else {
    throw Exception('Failed to load album');
  }
}

//check validity of coupon code
Future<dynamic> checkCouponCode(String couponCode) async {
  final response =
      await http.get("$baseUrl/api/booking/coupon/apply?code=$couponCode");
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}
