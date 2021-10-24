import 'package:autoflipz_user_app/models/car_model.dart';
import 'package:autoflipz_user_app/services/shared_preferences.dart';
import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  String car = 'car';

  void getCar() async {
    CarModel _userCar = await getUserCar();
    setState(() {
      car = _userCar.model;
    });
  }

  @override
  void initState() {
    super.initState();
    getCar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(10.0),
        child: ListView(
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            ListTile(
              title: Text(
                'How many AutoFlipz workshops are there PAN India?',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  'We have more than 100+ industry standard workshops offering a variety of car services. You can also opt for our doorstep pick-up service absolutely free of cost.',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'What makes AutoFlipz different from other car service providers?',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  'AutoFlipz is a network of multi-brand car service workshops spread across multiple locations in India. We are not working as an aggregator so we offer the best car services at affordable prices. Not only you can choose a wide assortment of car services, but you also save upto 40% on car service compared to what is charged at authorised workshops.',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'How can I book my ' + car + ' service with AutoFlipz?',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  'You can book directly from our website or using the exclusive AutoFlipz Android app. Want a more human experience? call or watsapp us on 9899551235.',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Do you offer pickup and live updates facility for my ' +
                    car +
                    ' ?',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  'We provide free doorstep pickup and drop-in anywhere. Also you\'ll get live updates. Sit back and Relax!',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Do you offer a warranty on my ' + car + ' service?',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  'Yes, you get an unconditional 1000kms/1month warranty on car repairs and services redeemable anywhere. No questions asked!',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Does AutoFlipz provide any offer or discounts on car service & repairs?',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  'AutoFlipz introduces many great offers & discounts for its customers. Always keep an eye on our offers section on website & app to stay updated about our trending offers.',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
