import '../models/car_model.dart';
import '../models/service_model.dart';

class UserModel {
  String id;
  String name;
  String mobile;
  String email;
  UserRegion userRegion;
  UserArea userArea;
  CarModel userCar;
  CartModel userCart;

  UserModel(
      {this.id = "",
      this.name = "",
      this.mobile = "",
      this.email = "",
      this.userRegion,
      this.userArea,
      this.userCar,
      this.userCart});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['_id'],
        name: json['name'],
        mobile: json['mobile'],
        email: json['email'],
        userRegion: UserRegion.fromJson(json['region']),
        userArea: UserArea.fromJson(json['area']),
        userCar: CarModel.fromJson(json['car']),
        userCart: CartModel.fromJson(json['cart']));
  }
}

class UserRegion {
  String id;
  String name;
  String logo;

  UserRegion({this.id = "", this.name = "", this.logo = ""});

  factory UserRegion.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return UserRegion();
    }
    return UserRegion(
        id: json['_id'] ?? "",
        name: json['name'] ?? "",
        logo: json['logo'] ?? "");
  }
}

class UserArea {
  String address;
  String pinCode;

  UserArea({this.address = "", this.pinCode = ""});

  factory UserArea.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return UserArea();
    }
    return UserArea(address: json['address'], pinCode: json['pin_code']);
  }
}

class CartModel {
  String id;
  List<SubServiceModel> subServices;

  CartModel({this.id, this.subServices});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
        id: json["_id"],
        subServices: json['sub_services'].map<SubServiceModel>((service) {
          return SubServiceModel.fromJson(service);
        }).toList());
  }
}

class BookingModel {
  String id;
  String userId;
  CarModel userCar;
  String bookingDate;
  String bookingTime;
  String bookingRegion;
  String bookingAddress;
  String arrivalMode;
  String paymentMode;
  String totalAmount;
  List<SubServiceModel> subServices;
  String created;

  BookingModel(
      {this.id,
      this.userId,
      this.userCar,
      this.bookingDate,
      this.bookingTime,
      this.bookingRegion,
      this.bookingAddress,
      this.arrivalMode,
      this.paymentMode,
      this.totalAmount,
      this.subServices,
      this.created});

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
        id: json['_id'],
        userId: json['user_id'],
        userCar: CarModel.fromJson(json['car_id']),
        bookingDate: json['booking_date'],
        bookingTime: json['booking_time'],
        bookingRegion: json['booking_region'],
        bookingAddress: json['booking_address'],
        arrivalMode: json['arrival_mode'],
        paymentMode: json['payment_mode'],
        totalAmount: json['total_amount'],
        subServices: json['sub_services'].map<SubServiceModel>((service) {
          return SubServiceModel.fromJson(service);
        }).toList(),
        created: json['created']);
  }
}
