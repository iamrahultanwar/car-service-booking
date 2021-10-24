import '../pages/account_page.dart';
import '../pages/cart_page.dart';
import '../pages/home_page.dart';
import '../pages/search_page.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BottomNavigationWidget extends StatelessWidget {
  List<Map<String, dynamic>> _navList = [
    {"nav": "Home", "icon": Icons.home, "route": HomePage.routeName},
    {"nav": "Search", "icon": Icons.search, "route": SearchPage.routeName},
    {"nav": "Cart", "icon": Icons.shopping_cart, "route": CartPage.routeName},
    {
      "nav": "Account",
      "icon": Icons.account_circle,
      "route": AccountPage.routeName
    }
  ];

  @override
  Widget build(BuildContext context) {
    var currentRoute = ModalRoute.of(context).settings.name;

    List<Widget> _navigation = _navList.map((nav) {
      bool _isCurrent = currentRoute == nav["route"];
      double _iconSize = _isCurrent ? 30.0 : 27.0;
      double _fontSize = _isCurrent ? 12.0 : 10.0;
      Color _iconColor = _isCurrent ? Colors.red : Colors.blueGrey;
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
            iconSize: _iconSize,
            icon: Icon(nav["icon"]),
            color: _iconColor,
            onPressed: () {
              if (currentRoute != nav["route"]) {
                Navigator.of(context).pushReplacementNamed(nav["route"]);
              }
            },
          ),
          Text(
            nav["nav"],
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: _fontSize,
                color: _iconColor),
          ),
        ],
      );
    }).toList();

    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Container(
        height: 65,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _navigation,
          ),
        ),
      ),
    );
  }
}
