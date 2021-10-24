import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../models/user_model.dart';
import '../pages/splash_screen_page.dart';
import '../services/http_service.dart';
import '../services/shared_preferences.dart';

class OTPVerifyWidget extends StatefulWidget {
  static final String routeName = "/verify-otp";

  @override
  _OTPVerifyWidgetState createState() => _OTPVerifyWidgetState();
}

class _OTPVerifyWidgetState extends State<OTPVerifyWidget> {
  bool _isLoading = false;
  String _mobile;
  TextEditingController _otp = new TextEditingController();

  void _loginUser() async {
    setState(() {
      _isLoading = true;
    });

    bool _isOTPVerified = await verifyLoginOTP(_mobile, _otp.text);

    if (_isOTPVerified) {
      UserModel _user = await loginUser(_mobile);
      bool _saveUserToken = await saveUserToken(_user.id);
      setState(() {
        _isLoading = false;
      });
      if (_saveUserToken) {
        Navigator.of(context).pushReplacementNamed(SplashScreenPage.routeName);
      }
    } else {
      Toast.show("Wrong OTP", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _mobile = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Verify OTP",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _otp,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                letterSpacing: 5.0,
              ),
              maxLength: 5,
              decoration: new InputDecoration(
                labelStyle: TextStyle(letterSpacing: 1.2),
                hintStyle: TextStyle(letterSpacing: 0.8),
                labelText: "Enter OTP here",
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
                            if (_otp.text.length == 5) {
                              _loginUser();
                            } else {
                              Toast.show("OTP Must be 5 digits", context);
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
                        child: Text('Verify OTP',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
