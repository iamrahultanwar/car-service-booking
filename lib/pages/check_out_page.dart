import 'dart:math';

import '../models/service_model.dart';
import '../models/user_model.dart';
import '../pages/account_page.dart';
import '../pages/booking_page.dart';
import '../services/http_service.dart';
import '../services/shared_preferences.dart';
import '../util/colors_util.dart';
import '../util/vibrate_util.dart';
import '../widgets/loading_spinner_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CheckOutPage extends StatefulWidget {
  static String routeName = "/check-out-page";

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var formatter = new DateFormat.yMMMMEEEEd();
  DateTime _date = DateTime.now().add(Duration(days: 1));
  List<SubServiceModel> _services = [];
  int _totalPrice = 0;
  int _originalTotalPrice = 0;
  int _timeSlot = 1;
  int _arrival = 1;
  bool _isFirstTime = true;
  Razorpay _razorPay;
  bool _isLoading = false;
  bool _couponCodeApplied = false;
  String _couponCodeError;

  TextEditingController _address = new TextEditingController();
  TextEditingController _pinCode = new TextEditingController();
  TextEditingController _couponCode = new TextEditingController();

  UserModel _user = new UserModel(userRegion: new UserRegion());

  void _getUserDetails() async {
    _user = await getUserLocally();
    setState(() {
      _user = _user;

      _address.text = _user.userArea.address;
      _pinCode.text = _user.userArea.pinCode;
    });
  }

  void _userMakingBooking(String paymentMode, String totalAmount) async {
    setState(() {
      _isLoading = true;
    });
    UserModel _user = await getUserLocally();
    List service = _services.map((f) {
      return f.id;
    }).toList();
    Map uData = {"address": _address.text, "pin_code": _pinCode.text};

    Map data = {
      "cart_id": _user.userCart.id,
      "car_id": _user.userCar.id,
      "user_id": _user.id,
      "booking_date": formatter.format(_date),
      "booking_time": _timeSlot.toString(),
      "booking_region": _user.userRegion.name,
      "booking_address": _address.text,
      "pin_code": _pinCode.text,
      "arrival_mode": _arrival.toString(),
      "payment_mode": paymentMode,
      "total_amount": totalAmount,
      "sub_services": service,
    };
    try {
      await updateUserDetails(uData);
      BookingModel _booking = await userBookService(data);
      Navigator.of(context).pushReplacementNamed(BookingPage.routeName,
          arguments: {"booking": _booking, "show": true});
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  void _payOnline(double amount, String description) async {
    try {
      UserModel _user = await getUserLocally();

      var options = {
        'key': 'rzp_live_OWtaObZlKyILc3',
        'amount': amount.round() * 100,
        // 'order_id': Random().nextInt(999999),
        'name': 'AutoFlipz',
        'description': description,
        'prefill': {
          'contact': _user.mobile,
          'email': _user.email ?? 'support@autoflipz.com'
        },
        'external': {
          'wallets': ['paytm']
        }
      };

      print(options);
      _razorPay.open(options);
    } catch (e) {
      // _scaffoldKey.currentState.showSnackBar(new SnackBar(
      //   duration: Duration(milliseconds: 1800),
      //   content: new Text(e),
      // ));
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _userMakingBooking('online', (_totalPrice * 0.95).toStringAsFixed(2));
  }

  void _handlePaymentError(PaymentFailureResponse response) {}

  void _handleExternalWallet(ExternalWalletResponse response) {}

  @override
  void initState() {
    super.initState();
    _razorPay = Razorpay();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _getUserDetails();
  }

  @override
  void dispose() {
    super.dispose();
    _razorPay.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstTime) {
      _isFirstTime = false;
      _services = ModalRoute.of(context).settings.arguments;
      _services.forEach((service) {
        _totalPrice += int.parse(service.price);
      });
      _originalTotalPrice = _totalPrice;
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ColorUtil.blueGrey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Checkout",
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: _user.name == "null" && _user.email == "null"
          ? Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Card(
                    color: Colors.redAccent,
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .pushReplacementNamed(AccountPage.routeName);
                      },
                      title: Text(
                        "Please update your details in account section before placing order",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white70),
                      ),
                      subtitle: Text(
                        "Your details will be used to share updates with you",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white70),
                      ),
                      trailing:
                          Icon(Icons.arrow_forward, color: Colors.white70),
                    ),
                  ),
                  Image.asset("assets/images/car_loading.gif")
                ],
              ),
            )
          : LoadingSpinnerWidget(
              loading: _isLoading,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 3.0),
                    child: Text(
                      "Basic",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: ColorUtil.navyBlue),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                            color: Colors.white,
                            width: 1.5,
                            style: BorderStyle.solid)),
                    width: double.infinity,
                    child: ListTile(
                      title: Text(_user.name),
                      subtitle: Row(
                        children: <Widget>[
                          Text(_user.mobile),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(_user.email)
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 3.0),
                    child: Text(
                      "Date of service",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: ColorUtil.navyBlue),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    height: 120.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                            color: Colors.white,
                            width: 1.5,
                            style: BorderStyle.solid)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            formatter.format(_date),
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey),
                          ),
                          trailing: RaisedButton(
                            onPressed: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime:
                                      DateTime.now().add(Duration(days: 1)),
                                  maxTime: DateTime(2020, 12, 12),
                                  theme: DatePickerTheme(
                                      headerColor: Colors.red,
                                      backgroundColor: Colors.white,
                                      itemStyle: TextStyle(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30.0,
                                          fontFamily: "Archia"),
                                      doneStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Archia"),
                                      cancelStyle: TextStyle(
                                          color: ColorUtil.navyBlue,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Archia")),
                                  onConfirm: (date) {
                                setState(() {
                                  _date = date;
                                });
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                            color: Colors.redAccent,
                            child: Text(
                              "Choose",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 50.0,
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ChoiceChip(
                                  label: Text('10am - 1pm'),
                                  selectedColor: Colors.red,
                                  backgroundColor: Colors.grey,
                                  labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                      fontFamily: 'Archia'),
                                  selected: _timeSlot == 1,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _timeSlot = selected ? 1 : null;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ChoiceChip(
                                  label: Text('1pm - 4pm'),
                                  selectedColor: Colors.red,
                                  backgroundColor: Colors.grey,
                                  labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                      fontFamily: 'Archia'),
                                  selected: _timeSlot == 2,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _timeSlot = selected ? 2 : null;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ChoiceChip(
                                  label: Text('4pm - 7pm'),
                                  selectedColor: Colors.red,
                                  backgroundColor: Colors.grey,
                                  labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                      fontFamily: 'Archia'),
                                  selected: _timeSlot == 3,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _timeSlot = selected ? 3 : null;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ChoiceChip(
                                  label: Text('7pm - 10pm'),
                                  selectedColor: Colors.red,
                                  backgroundColor: Colors.grey,
                                  labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                      fontFamily: 'Archia'),
                                  selected: _timeSlot == 4,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _timeSlot = selected ? 4 : null;
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 3.0),
                    child: Text(
                      "Address",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: ColorUtil.navyBlue),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                              style: BorderStyle.solid)),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextFormField(
                            controller: TextEditingController()
                              ..text = _user.userRegion.name,
                            enabled: false,
                            decoration: new InputDecoration(
                              enabled: false,
                              labelStyle: TextStyle(letterSpacing: 1.2),
                              hintStyle: TextStyle(letterSpacing: 0.8),
                              labelText: "Your Region",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                              ),
                              //fillColor: Colors.green
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextField(
                            controller: _address,
                            maxLength: 100,
                            decoration: new InputDecoration(
                              labelStyle: TextStyle(letterSpacing: 1.2),
                              hintStyle: TextStyle(letterSpacing: 0.8),
                              labelText: "Your address",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                              ),
                              //fillColor: Colors.green
                            ),
                          ),
                          TextField(
                            controller: _pinCode,
                            maxLength: 6,
                            style: TextStyle(letterSpacing: 5.0),
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: new InputDecoration(
                              labelStyle: TextStyle(letterSpacing: 1.2),
                              hintStyle: TextStyle(letterSpacing: 0.8),
                              labelText: "Your pin code",
                              fillColor: Colors.white,

                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                              ),

                              //fillColor: Colors.green
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ChoiceChip(
                                  label: Text('Doorstep Pickup'),
                                  selectedColor: Colors.red,
                                  backgroundColor: Colors.grey,
                                  labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                      fontFamily: 'Archia'),
                                  selected: _arrival == 1,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _arrival = selected ? 1 : null;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ChoiceChip(
                                  label: Text('Self Drop'),
                                  selectedColor: Colors.red,
                                  backgroundColor: Colors.grey,
                                  labelStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                      fontFamily: 'Archia'),
                                  selected: _arrival == 2,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      _arrival = selected ? 2 : null;
                                    });
                                  },
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 3.0),
                    child: Text(
                      "Apply Coupon Code",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: ColorUtil.navyBlue),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                              style: BorderStyle.solid)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _couponCodeApplied
                              ? Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(12)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(_couponCode.text + " Applied",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      GestureDetector(
                                        onTap: () => setState(() {
                                          _totalPrice = _originalTotalPrice;
                                          _couponCodeApplied = false;
                                        }),
                                        child: Text("X",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  ),
                                )
                              : Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  child: TextField(
                                    controller: _couponCode,
                                    decoration: new InputDecoration(
                                      labelStyle: TextStyle(letterSpacing: 1.2),
                                      hintStyle: TextStyle(letterSpacing: 0.8),
                                      errorText: _couponCodeError,
                                      labelText: "Coupon Code",
                                      fillColor: Colors.white,
                                      border: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(25.0),
                                      ),
                                      //fillColor: Colors.green
                                    ),
                                  ),
                                ),
                          RaisedButton(
                            onPressed: () async {
                              if (!_couponCodeApplied) {
                                if (_couponCode.text.isNotEmpty) {
                                  var response =
                                      await checkCouponCode(_couponCode.text);
                                  if (response["status"]) {
                                    _couponCodeError = null;
                                    _couponCodeApplied = true;
                                    if (response["percentage"]) {
                                      _totalPrice = _totalPrice -
                                          int.parse((_totalPrice *
                                                  (double.parse(response["off"]
                                                          .toString()) /
                                                      100))
                                              .floor()
                                              .toString());
                                    } else {
                                      _totalPrice = _totalPrice -
                                          int.parse(double.parse(
                                                  response["off"].toString())
                                              .floor()
                                              .toString());
                                    }

                                    setState(() {});
                                  } else {
                                    setState(() {
                                      _couponCodeError = "Invalid Coupon Code";
                                    });
                                  }
                                } else {
                                  setState(() {
                                    _couponCodeError = "Invalid Coupon Code";
                                  });
                                }
                              }
                            },
                            color: Colors.redAccent,
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            child: Text(
                              "Apply\nCoupon",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 3.0),
                    child: Text(
                      "Summary",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: ColorUtil.navyBlue),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.all(10.0),
                      height: 250.0,
                      decoration: BoxDecoration(
                          color: ColorUtil.navyBlue,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                              style: BorderStyle.solid)),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Selected Services",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 80.0,
                            padding: EdgeInsets.only(left: 10.0),
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              children: _services.map((service) {
                                return Container(
                                  width: 300.0,
                                  child: Card(
                                    child: ListTile(
                                      dense: true,
                                      leading: Text(
                                        'Rs ${service.price}',
                                      ),
                                      title: Text(
                                        service.name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        service.brief,
                                        style:
                                            TextStyle(color: Colors.blueGrey),
                                      ),
//                                trailing: IconButton(
//                                  onPressed: () {},
//                                  icon: Icon(
//                                    Icons.remove_circle,
//                                    color: Colors.redAccent,
//                                    size: 20.0,
//                                  ),
//                                ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          // Container(
                          //   width: double.infinity,
                          //   height: 20.0,
                          //   color: Colors.red,
                          //   child: Marquee(
                          //     text: "Pay online and get 5% instant discount",
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.white),
                          //     blankSpace: 10.0,
                          //   ),
                          // ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  VibrateUtil().vibrate();
                                  _userMakingBooking(
                                      "cash", _totalPrice.toString());
                                },
                                child: Container(
                                  width: 140.0,
                                  height: 70.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.white),
                                  child: ListTile(
                                    trailing: Image.asset(
                                      "assets/images/money.png",
                                      width: 20.0,
                                      height: 20.0,
                                    ),
                                    title: Text(
                                      "Rs $_totalPrice",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Pay on delivery",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _payOnline((_totalPrice * 0.95),
                                      "Please complete your payment.");
                                },
                                child: Container(
                                    width: 140.0,
                                    height: 70.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: Colors.white),
                                    child: ListTile(
                                      trailing: Image.asset(
                                        "assets/images/payment.png",
                                        width: 20.0,
                                        height: 20.0,
                                      ),
                                      title: Text(
                                        "Rs ${(_totalPrice * 0.95).toStringAsFixed(0)}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Pay online",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0),
                                      ),
                                    )),
                              ),
                            ],
                          )
                        ],
                      )),
                ],
              ),
            ),
    );
  }
}
