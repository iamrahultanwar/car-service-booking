import '../models/car_model.dart';
import '../models/user_model.dart';
import '../pages/select_car_page.dart';
import '../services/http_service.dart';
import '../services/shared_preferences.dart';
import '../util/colors_util.dart';
import '../widgets/bottom_navigation_widget.dart';
import '../widgets/floating_icon_widget.dart';
import '../widgets/user_bookings_list.dart';
import 'package:flutter/material.dart';

import 'splash_screen_page.dart';

class AccountPage extends StatefulWidget {
  static String routeName = "/account-page";

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  UserModel _user = new UserModel(userCar: new CarModel());
  TextEditingController _userEmail = new TextEditingController();
  TextEditingController _userName = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _getUserDetails() async {
    _user = await getUserLocally();
    setState(() {
      _user = _user;
      _userEmail.text = _user.email;
      _userName.text = _user.name;
    });
    if (_user.email == null || _user.email == "null" || _user.email.isEmpty) {
      _updateInfoAlert();
    }
  }

  void _logOutUser() async {
    bool _isLoggedOut = await logOutUser();
    bool _isFirstTime = await isFirstTime();
    if (_isLoggedOut && _isFirstTime)
      Navigator.of(context).pushReplacementNamed(SplashScreenPage.routeName);
  }

  void _updateUserDetails() async {
    Map data = {"email": _userEmail.text, "name": _userName.text};

    bool _res = await updateUserDetails(data);

    if (_res) {
      bool can = Navigator.of(context).canPop();

      if (can) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed(AccountPage.routeName);
      }
    }
  }

  void _updateInfoAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
                key: _formKey,
                child: Container(
                  width: 200.0,
                  height: 300.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      TextFormField(
                        controller: _userName,
                        validator: (val) {
                          if (val.length == 0) {
                            return "Please Enter Something";
                          }
                          return null;
                        },
                        decoration: new InputDecoration(
                          labelStyle: TextStyle(letterSpacing: 1.2),
                          hintStyle: TextStyle(letterSpacing: 0.8),
                          labelText: "Name",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                          ),
                          //fillColor: Colors.green
                        ),
                      ),
                      TextFormField(
                        controller: _userEmail,
                        validator: (val) {
                          if (val.length == 0) {
                            return "Please Enter Something";
                          }
                          return null;
                        },
                        decoration: new InputDecoration(
                          labelStyle: TextStyle(letterSpacing: 1.2),
                          hintStyle: TextStyle(letterSpacing: 0.8),
                          labelText: "Email",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                          ),
                          //fillColor: Colors.green
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FlatButton(
                              child: Text(
                                "Close",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FlatButton(
                              child: Text(
                                "Save",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  _updateUserDetails();
                                }
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtil.blueGrey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Account",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _logOutUser();
            },
            icon: Icon(
              Icons.offline_bolt,
              size: 30.0,
            ),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8.0),
                height: 120.0,
                width: double.infinity,
                child: Card(
                  elevation: 3.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _user.name == null
                                  ? "Update your name"
                                  : _user.name,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _user.mobile == null
                                  ? "Update your mobile"
                                  : _user.mobile,
                              style: TextStyle(
                                  fontSize: 17.0, color: Colors.black38),
                            ),
                            Text(
                              _user.email == null
                                  ? "Update your email"
                                  : _user.email,
                              style: TextStyle(
                                  fontSize: 17.0, color: Colors.black38),
                            )
                          ],
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              _updateInfoAlert();
                            },
                            child: Container(
                              width: 60.0,
                              height: 25.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(
                                    width: 1.2, color: Colors.redAccent),
                                color: Colors.red.withOpacity(0.8),
                              ),
                              child: Center(
                                  child: Text(
                                "Edit",
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.white),
                              )),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(
                    Icons.directions_car,
                    size: 40.0,
                  ),
                  title: Text("My Car"),
                  subtitle:
                      Text("${_user.userCar.make} ${_user.userCar.model}"),
                  trailing: IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(SelectCarPage.routeName);
                      },
                      icon: Icon(Icons.arrow_forward_ios)),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(
                    Icons.add_shopping_cart,
                    size: 40.0,
                  ),
                  title: Text("My Bookings"),
                  subtitle: Text("Your booking details here"),
                  trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserBookingsList()),
                        );
                      },
                      icon: Icon(Icons.arrow_forward_ios)),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//      floatingActionButton: FloatingIconWidget(),
      bottomNavigationBar: BottomNavigationWidget(),
    );
  }
}
