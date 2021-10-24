import '../models/service_model.dart';
import '../models/user_model.dart';
import '../pages/cart_page.dart';
import '../pages/home_page.dart';
import '../services/http_service.dart';
import '../services/shared_preferences.dart';
import '../util/colors_util.dart';
import '../util/vibrate_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'package:toast/toast.dart';

List<String> imgList = [
  "https://www.wearemarmalade.co.uk/driver-hub/app/uploads/2017/04/car-service.jpg",
];

final Widget placeholder = Container(color: Colors.grey);

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

class ServiceDetailsPage extends StatefulWidget {
  static String routeName = "/service-details-page";

  @override
  _ServiceDetailsPageState createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  CartModel _cartModel;
  bool isAdded = false;
  int cartItemLength = 0;

  void _intCartModel() async {
    CartModel _cart = await getUserCart();
    _cart = await userCartDetails(_cart.id);
    _cartModel = _cart;
    setState(() {
      cartItemLength = _cartModel.subServices.length;
    });
  }

  void _addItemToCart(SubServiceModel subService) async {
    _cartModel.subServices = [subService];
    _cartModel = await userCartAddItem(_cartModel);
    setState(() {
      isAdded = true;
      cartItemLength = _cartModel.subServices.length;
    });
    VibrateUtil().vibrate();

    Toast.show("Service Added", context,
        backgroundColor: ColorUtil.navyBlue,
        textColor: Colors.white,
        gravity: Toast.TOP,
        duration: Toast.LENGTH_LONG);
  }

  @override
  void initState() {
    super.initState();
    _intCartModel();
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height * 0.7);
    FlutterStatusbarcolor.setStatusBarColor(Colors.redAccent);

    SubServiceModel serviceData = ModalRoute.of(context).settings.arguments;
    if (serviceData.images.length > 0) {
      imgList = serviceData.images;
      imgList = imgList.where((element) => element != '').toList();
    }

    Widget _what() {
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(0.0),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: serviceData.what.split(",").map((e) {
              return Column(
                children: <Widget>[
                  Text(
                    "$e",
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          serviceData.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CarouselWithIndicator(),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.6,
              child: DefaultTabController(
                length: 3,
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0.0,
                    automaticallyImplyLeading: false,
                    title: TabBar(
                      labelColor: Colors.red,
                      unselectedLabelColor: Colors.blueGrey,
                      indicatorPadding: EdgeInsets.all(0.0),
                      labelPadding: EdgeInsets.all(13.0),
                      tabs: [
                        Text(
                          "Description",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Component",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "FAQ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 50),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // shrinkWrap: true,
                            // physics: NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              Text(
                                serviceData.description,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                "When is it required",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                serviceData.when,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                "What is included",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              _what(),
                            ],
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 50),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // shrinkWrap: true,
                            // physics: NeverScrollableScrollPhysics(),
                            children: serviceData.components.length > 0
                                ? serviceData.components.map((component) {
                                    return Card(
                                      elevation: 1.0,
                                      child: ListTile(
                                        dense: true,
                                        title: Text(
                                          component.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0),
                                        ),
                                        subtitle: Text(component.details,
                                            style: TextStyle(fontSize: 16.0)),
                                        trailing: Image.asset(
                                          "assets/images/check-mark.gif",
                                          width: 50.0,
                                          height: 50.0,
                                        ),
                                      ),
                                    );
                                  }).toList()
                                : <Widget>[
                                    Container(
                                      margin: const EdgeInsets.all(10.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'No Information Available!',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      ),
                                    ),
                                  ],
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 50),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // shrinkWrap: true,
                            // physics: NeverScrollableScrollPhysics(),
                            children: serviceData.questions.length > 0
                                ? serviceData.questions.map((question) {
                                    return Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10.0),
                                      child: ExpandablePanel(
                                        header: Text(
                                          question.question,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0),
                                        ),
                                        expanded: Text(
                                          question.answer,
                                          softWrap: true,
                                        ),
                                      ),
                                    );
                                  }).toList()
                                : <Widget>[
                                    Container(
                                      margin: const EdgeInsets.all(10.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'No Information Available!',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      ),
                                    ),
                                  ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Colors.red,
                Colors.redAccent,
                Colors.deepOrange,
              ],
            ),
            border: Border.all(color: Colors.red, width: 2.0),
            borderRadius: BorderRadius.circular(10.0)),
        margin: EdgeInsets.all(10.0),
        // width: double.infinity,
        // height: 70.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'Rs ${serviceData.price}',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            FlatButton(
              onPressed: isAdded
                  ? () {
                      Navigator.of(context)
                          .popUntil(ModalRoute.withName(HomePage.routeName));
                      Navigator.of(context)
                          .pushReplacementNamed(CartPage.routeName);
                    }
                  : () {
                      _addItemToCart(serviceData);
                    },
              child: Text(
                isAdded ? "GO TO CART" : "ADD TO CART",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CarouselWithIndicator extends StatefulWidget {
  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CarouselSlider(
        items: map<Widget>(
          imgList,
          (index, i) {
            return Container(
              width: double.infinity,
              height: 700.0,
              child: CachedNetworkImage(
                imageUrl: i,
                fit: BoxFit.fill,
              ),
            );

            // return null;
          },
        ).toList(),
        options: CarouselOptions(
          viewportFraction: 1.0,
          aspectRatio: 2,
          autoPlay: true,
          enlargeCenterPage: false,
          onPageChanged: (index, CarouselPageChangedReason next) {
            setState(() {
              _current = index;
            });
          },
        ),
      ),
      Positioned(
        bottom: 5.0,
        left: 5.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: map<Widget>(
            imgList,
            (index, url) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Colors.red.withOpacity(0.8)
                        : Colors.white.withOpacity(0.5)),
              );
            },
          ),
        ),
      ),
    ]);
  }
}
