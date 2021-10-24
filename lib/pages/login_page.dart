import '../services/http_service.dart';

import '../util/colors_util.dart';
import '../widgets/otp_verify_widget.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  static String routeName = "/login-page";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  TextEditingController _mobile = new TextEditingController();

  void _getLoginOTP(context) async {
    setState(() {
      _isLoading = true;
    });
    bool otp = await getLoginOTP(_mobile.text);
    if (otp)
      Navigator.of(context)
          .pushNamed(OTPVerifyWidget.routeName, arguments: _mobile.text);
    else
      Toast.show("Error in sending OTP,please try again", context);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtil.blueGrey,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.only(top: 160.0),
        child: Column(
          children: <Widget>[
            Text(
              "Log In",
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "Enter your mobile number for verification",
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
            ),
            SizedBox(
              height: 40.0,
            ),
            TextField(
              controller: _mobile,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                letterSpacing: 5.0,
              ),
              decoration: new InputDecoration(
                labelStyle: TextStyle(fontSize: 12.0, letterSpacing: 0.6),
                hintStyle: TextStyle(letterSpacing: 0.8),
                prefix: Text("+91 "),
                labelText: "Enter 10 digits Mobile Number",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(),
                ),
                //fillColor: Colors.green
              ),
              keyboardType: TextInputType.numberWithOptions(),
            ),
            SizedBox(
              height: 60.0,
            ),
            _isLoading
                ? CircularProgressIndicator()
                : FlatButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_mobile.text.length == 10) {
                              _getLoginOTP(context);
                            } else {
                              Toast.show(
                                  "Mobile Number Must be 10 digits", context);
                            }
                          },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      width: 200.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(width: 0.8, color: Colors.white),
                        gradient: LinearGradient(
                          colors: <Color>[
                            Colors.red,
                            Colors.redAccent,
                            Colors.deepOrange,
                          ],
                        ),
                      ),
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: Text('Get OTP',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: ColorUtil.blueGrey,
        width: double.infinity,
        height: 100.0,
        child: Center(
          child: Text(
            "Autoflipz @2020",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                letterSpacing: 3.0),
          ),
        ),
      ),
    );
  }
}
