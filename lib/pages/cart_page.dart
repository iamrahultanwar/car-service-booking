import '../models/service_model.dart';
import '../models/user_model.dart';
import '../pages/check_out_page.dart';
import '../pages/search_page.dart';
import '../services/http_service.dart';
import '../services/shared_preferences.dart';
import '../util/vibrate_util.dart';
import '../widgets/bottom_navigation_widget.dart';
import '../widgets/floating_icon_widget.dart';
import '../widgets/loading_spinner_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class CartPage extends StatefulWidget {
  static String routeName = "/cart-page";

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<SubServiceModel> _services = [];
  bool _isLoading = true;
  CartModel cart;
  int totalPrice = 0;

  void _getUserCart() async {
    _isLoading = true;
    cart = await getUserCart();
    cart = await userCartDetails(cart.id);
    _services = cart.subServices;

    setState(() {
      _services = _services;
      _isLoading = false;
    });

    _updateTotalPrice();
  }

  void _removeItem(SubServiceModel subService) async {
    setState(() {
      _isLoading = true;
    });
    cart.subServices = [subService];
    cart = await userCartRemoveItem(cart);
    VibrateUtil().vibrate();

    Toast.show("Service Removed", context,
        backgroundColor: Colors.redAccent.withOpacity(0.7),
        textColor: Colors.white,
        gravity: Toast.BOTTOM,
        duration: Toast.LENGTH_LONG);
    setState(() {
      _services = cart.subServices;
      _isLoading = false;
    });

    _updateTotalPrice();
  }

  void _updateTotalPrice() {
    totalPrice = 0;
    _services.forEach((service) {
      totalPrice += int.parse(service.price);
    });
    setState(() {
      totalPrice = totalPrice;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Cart",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
      ),
      body: LoadingSpinnerWidget(
        loading: _isLoading,
        child: Container(
          padding: EdgeInsets.only(top: 3.0),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.7,
          child: _services.length == 0
              ? Center(
                  child: Image.asset(
                    "assets/images/empty-cart.png",
                  ),
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: _services.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0.5, horizontal: 2.0),
                      child: Card(
                        child: ListTile(
                          isThreeLine: false,
                          dense: true,
                          leading: Container(
                              padding: EdgeInsets.all(5.0),
                              child: _services[index].logoUrl == null
                                  ? Container(
                                      padding: EdgeInsets.all(5.0),
                                      child: Image.asset(
                                          "assets/images/005-car-1.png"))
                                  : CachedNetworkImage(
                                      imageUrl: _services[index].logoUrl,
                                      width: 50.0,
                                      height: 50.0,
                                    )),
                          title: Text(
                            _services[index].name.toString(),
                            style: TextStyle(fontSize: 12.0),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Rs ${_services[index].price}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              Text(
                                _services[index].brief.toString(),
                                style: TextStyle(
                                  fontSize: 10.0,
                                ),
                              )
                            ],
                          ),
                          trailing: InkWell(
                            onTap: () {
                              _removeItem(_services[index]);
                            },
                            child: Container(
                              width: 70.0,
                              height: 25.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                border:
                                    Border.all(width: 1.5, color: Colors.red),
                                color: Colors.white.withOpacity(0.5),
                              ),
                              margin: EdgeInsets.all(4.0),
                              child: Center(
                                child: Text(
                                  "Remove",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                      color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
        ),
      ),
      bottomNavigationBar: BottomNavigationWidget(),

      bottomSheet: _isLoading
          ? null
          : Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF0B1F2D)),
                padding: EdgeInsets.all(3.0),
                width: double.infinity,
                height: 90.0,
                child: _services.length == 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Cart Is Empty",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          RaisedButton(
                            elevation: 6.0,
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(SearchPage.routeName);
                            },
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Explore",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0B1F2D)),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Total",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                "₹ $totalPrice",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          RaisedButton(
                            elevation: 6.0,
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  CheckOutPage.routeName,
                                  arguments: _services);
                            },
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Proceed",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0B1F2D)),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 30.0,
                                  color: Color(0xFF0B1F2D),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
              ),
            ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//      floatingActionButton: FloatingIconWidget(),
    );
  }
}
