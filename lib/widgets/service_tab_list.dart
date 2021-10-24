import '../models/car_model.dart';
import '../models/service_model.dart';
import '../models/user_model.dart';
import '../pages/cart_page.dart';
import '../pages/home_page.dart';
import '../services/http_service.dart';
import '../services/shared_preferences.dart';
import '../util/colors_util.dart';
import '../util/vibrate_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../pages/service_details_page.dart';
import 'package:toast/toast.dart';

class ServiceTabWidget extends StatefulWidget {
  final List<ServiceTab> subServiceList;
  final int serviceIndex;
  final int index;
  final int subSubservice;
  final SubServiceModel selectSubService;

  ServiceTabWidget(
      {this.subServiceList,
      this.serviceIndex,
      this.index,
      this.subSubservice = 0,
      this.selectSubService});

  @override
  _ServiceTabWidgetState createState() => _ServiceTabWidgetState();
}

class _ServiceTabWidgetState extends State<ServiceTabWidget> {
  CartModel _cartModel;
  int cartItemLength = 0;
  CarModel _userCar = new CarModel();

  void _intCartModel() async {
    _userCar = await getUserCar();
    setState(() {
      _userCar = _userCar;
    });
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
      cartItemLength = _cartModel.subServices.length;
    });
    VibrateUtil().vibrate();
    Toast.show("Service Added", context,
        backgroundColor: ColorUtil.navyBlue,
        textColor: Colors.white,
        gravity: Toast.BOTTOM,
        duration: Toast.LENGTH_LONG);
  }

  @override
  void initState() {
    _intCartModel();
    // if (widget.serviceIndex > 0) {
    //   Navigator.of(context).pushNamed(ServiceDetailsPage.routeName,
    //       arguments: widget.selectSubService);
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ServiceTab> _serviceTabList = widget.subServiceList;
    List<Tab> _tabData = _serviceTabList.map((service) {
      return Tab(
        child: Text(
          service.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
        ),
      );
    }).toList();

    List<Widget> _serviceContainer = _serviceTabList.map((service) {
      return Container(
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
        child: ListView.separated(
          physics: BouncingScrollPhysics(),
          itemCount: service.subServiceList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              contentPadding: EdgeInsets.all(10.0),
              onTap: () {
                Navigator.of(context).pushNamed(ServiceDetailsPage.routeName,
                    arguments: service.subServiceList[index]);
              },
              isThreeLine: false,
              dense: false,
              leading: service.subServiceList[index].logoUrl == null
                  ? Container(
                      padding: EdgeInsets.all(5.0),
                      child: Image.asset("assets/images/005-car-1.png"))
                  : CachedNetworkImage(
                      imageUrl: service.subServiceList[index].logoUrl,
                      width: 50.0,
                      height: 50.0,
                    ),
              title: Text(
                service.subServiceList[index].name.toString(),
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${service.subServiceList[index].offerPrice}',
                        style: TextStyle(fontSize: 12.0, color: Colors.red),
                      ),
                      Text(
                        'Rs ${service.subServiceList[index].price}',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  Text(
                    service.subServiceList[index].brief.toString(),
                    style: TextStyle(fontSize: 12.0),
                  )
                ],
              ),
              trailing: GestureDetector(
                onTap: () {
                  _addItemToCart(service.subServiceList[index]);
                },
                child: Container(
                  width: 60.0,
                  height: 25.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(width: 1.5, color: Colors.red),
                    color: Colors.white.withOpacity(0.5),
                  ),
                  margin: EdgeInsets.all(2.0),
                  child: Center(
                    child: Text(
                      "Add",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.red),
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(),
        ),
      );
    }).toList();
    return DefaultTabController(
      length: _serviceTabList.length,
      initialIndex: widget.serviceIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            " ${_userCar.make} ${_userCar.model} ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: PreferredSize(
              child: TabBar(
                  isScrollable: true,
                  unselectedLabelColor: Colors.white.withOpacity(0.6),
                  indicatorColor: Colors.white,
                  tabs: _tabData),
              preferredSize: Size.fromHeight(30.0)),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(width: 0.8, color: Colors.orangeAccent),
                  color: Colors.amber.withOpacity(0.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "${_userCar.category} ${_userCar.type}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: _serviceContainer,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "   $cartItemLength    Services",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(HomePage.routeName));
                  Navigator.of(context)
                      .pushReplacementNamed(CartPage.routeName);
                },
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: ColorUtil.navyBlue,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "Go To Cart",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
