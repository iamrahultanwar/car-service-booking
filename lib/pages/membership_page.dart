import 'package:autoflipz_user_app/models/service_model.dart';
import 'package:autoflipz_user_app/models/user_model.dart';
import 'package:autoflipz_user_app/pages/cart_page.dart';
import 'package:autoflipz_user_app/services/http_service.dart';
import 'package:autoflipz_user_app/services/shared_preferences.dart';
import 'package:autoflipz_user_app/util/colors_util.dart';
import 'package:autoflipz_user_app/util/vibrate_util.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'home_page.dart';

class MembershipPage extends StatefulWidget {
  @override
  _MembershipPageState createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  SubServiceModel goldPass;
  CartModel _cartModel;
  bool isAdded = false;
  int cartItemLength = 0;

  void _intCartModel() async {
    CartModel _cart = await getUserCart();
    _cart = await userCartDetails(_cart.id);
    _cartModel = _cart;
    if (this.mounted) {
      setState(() {
        cartItemLength = _cartModel.subServices.length;
      });
    }
  }

  void _addItemToCart(SubServiceModel subService) async {
    _cartModel.subServices = [subService];
    _cartModel = await userCartAddItem(_cartModel);
    setState(() {
      isAdded = true;
      cartItemLength = _cartModel.subServices.length;
    });
    VibrateUtil().vibrate();

    Toast.show("Added", context,
        backgroundColor: ColorUtil.navyBlue,
        textColor: Colors.white,
        gravity: Toast.TOP,
        duration: Toast.LENGTH_LONG);
  }

  void _getGoldPass() async {
    goldPass = await getGoldPass();
  }

  @override
  void initState() {
    super.initState();
    _getGoldPass();
    _intCartModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: Text('Be Gold User'),
        ),
        body: ListView(
          children: <Widget>[
            Image.asset(
              'assets/images/membership.jpeg',
            ),
            Container(
              margin: EdgeInsets.all(5.0),
              width: double.infinity,
              alignment: Alignment.topCenter,
              child: Card(
                color: Colors.black87,
                elevation: 3.0,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'How It Works?',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Only one service can be redeemed at a single time of diagnosis.',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                    Text(
                      'How To Redeem',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          const Text(
                            "You will receive an email of your voucher code & other details from magicpass@autoflipz.com within 24 hrs of payment.",
                            style: TextStyle(color: Colors.white),
                          ),
                          const Text(
                            'Whenever you want to make your car service booking, call our Autoflipz Assisted HelpDesk on 9899551235. Share your voucher code , Service required, & the date of your booking.',
                            style: TextStyle(color: Colors.white),
                          ),
                          const Text(
                            'Our helpdesk executive will confirm your booking without making any additonal payments.',
                            style: TextStyle(color: Colors.white),
                          ),
                          RaisedButton(
                            onPressed: isAdded
                                ? () {
                                    Navigator.of(context).popUntil(
                                        ModalRoute.withName(
                                            HomePage.routeName));
                                    Navigator.of(context).pushReplacementNamed(
                                        CartPage.routeName);
                                  }
                                : () {
                                    _addItemToCart(goldPass);
                                  },
                            color: Colors.red,
                            child: Text(
                              isAdded ? 'Go To Cart' : 'RS 999' /*'Join Now!'*/,
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
