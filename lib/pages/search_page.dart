import '../models/car_model.dart';
import '../models/service_model.dart';
import '../models/user_model.dart';
import '../pages/service_details_page.dart';
import '../services/http_service.dart';
import '../services/shared_preferences.dart';
import '../util/colors_util.dart';
import '../util/vibrate_util.dart';
import '../widgets/bottom_navigation_widget.dart';
import '../widgets/floating_icon_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class SearchPage extends StatefulWidget {
  static String routeName = "/search-page";

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Future<List<SubServiceModel>> cars;
  final SearchBarController<SubServiceModel> _searchBarController =
      SearchBarController();
  CartModel _cartModel;
  CarModel _userCar = new CarModel();

  List<SubServiceModel> _suggestions = [];
  void _intCartModel() async {
    CartModel _cart = await getUserCart();
    _cart = await userCartDetails(_cart.id);
    _suggestions = await findService("car");
    _cartModel = _cart;
    setState(() {
      _userCar = _userCar;
      _suggestions = _suggestions.sublist(0,10);
    });
  }

  void _addItemToCart(SubServiceModel subService) async {
    _cartModel.subServices.add(subService);
    _cartModel = await userCartAddItem(_cartModel);
    VibrateUtil().vibrate();

    Toast.show("Service Added", context,
        backgroundColor: ColorUtil.navyBlue,
        textColor: Colors.white,
        gravity: Toast.TOP,
        duration: Toast.LENGTH_LONG);
  }

  @override
  void initState() {
    _intCartModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Search",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SearchBar<SubServiceModel>(
          textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          listPadding: EdgeInsets.symmetric(horizontal: 4),
          onSearch: findService,
          searchBarController: _searchBarController,
          minimumChars: 3,
          suggestions: _suggestions,
          cancellationWidget: Icon(
            Icons.clear,
            size: 20.0,
            color: Colors.red,
          ),
          emptyWidget: Center(
            child: Image.asset(
              "assets/images/no_result.gif",
            ),
          ),
          onCancelled: () {},
          onItemFound: (SubServiceModel service, int index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(ServiceDetailsPage.routeName,
                    arguments: service);
              },
              child: Card(
                child: ListTile(
                  isThreeLine: true,
                  dense: true,
                  leading: Container(
                      padding: EdgeInsets.all(5.0),
                      child: service.logoUrl == null
                          ? Container(
                              padding: EdgeInsets.all(5.0),
                              child: Image.asset("assets/images/005-car-1.png"))
                          : CachedNetworkImage(
                              imageUrl: service.logoUrl,
                              width: 50.0,
                              height: 50.0,
                            )),
                  title: Text(
                    service.name,
                    style:
                        TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Rs ${service.price}',
                            style: TextStyle(fontSize: 12.0, color: Colors.red),
                          ),
                          Text(
                            '${service.offerPrice}',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        service.brief,
                        style: TextStyle(
                          fontSize: 13.0,
                        ),
                      )
                    ],
                  ),
                  trailing: InkWell(
                    onTap: () {
                      _addItemToCart(service);
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
                ),
              ),
            );
          },
        ),
      ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//      floatingActionButton: FloatingIconWidget(),
      bottomNavigationBar: BottomNavigationWidget(),
    );
  }
}
