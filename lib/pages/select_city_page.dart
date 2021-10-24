import 'package:cached_network_image/cached_network_image.dart';

import '../models/user_model.dart';

import '../pages/splash_screen_page.dart';
import '../services/http_service.dart';
import '../util/colors_util.dart';
import 'package:flutter/material.dart';

class SelectCityPage extends StatefulWidget {
  static String routeName = "/select-city-page";

  @override
  _SelectCityPageState createState() => _SelectCityPageState();
}

class _SelectCityPageState extends State<SelectCityPage> {
  bool _isLoading = false;

  void _updateUserRegion(String regionId) async {
    setState(() {
      _isLoading = true;
    });
    Map data = {"region": regionId};

    bool _res = await updateUserDetails(data);

    if (_res) {
      Navigator.of(context).pushReplacementNamed(SplashScreenPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorUtil.blueGrey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Select your area",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        body: FutureBuilder<List<UserRegion>>(
          future: fetchRegion(), // a previously-obtained Future<String> or null
          builder:
              (BuildContext context, AsyncSnapshot<List<UserRegion>> snapshot) {
            List<Widget> children;

            if (snapshot.hasData) {
              return GridView.count(
                crossAxisCount: 4,
                children: snapshot.data.map((region) {
                  return InkWell(
                    onTap: () {
                      _updateUserRegion(region.id);
                    },
                    child: Card(
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          region.logo == ""
                              ? FlutterLogo()
                              : CachedNetworkImage(
                                  imageUrl: region.logo,
                                  width: 30.0,
                                  height: 30.0),
                          SizedBox(
                            height: 10.0,
                          ),
                          SafeArea(
                            child: Text(
                              region.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                  color: ColorUtil.navyBlue),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            } else if (snapshot.hasError) {
              children = <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ];
            } else {
              children = <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                )
              ];
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            );
          },
        ));
  }
}

//Container(
//width: double.infinity,
//height: double.infinity,
//child: GridView.count(
//crossAxisCount: 4,
//children: new List<Widget>.generate(16, (index) {
//return new GridTile(
//child: GestureDetector(
//onTap: () {
//Navigator.of(context)
//    .pushReplacementNamed(SelectCarPage.routeName);
//},
//child: new Card(
//elevation: 4,
//color: Colors.white,
//child: Column(
//mainAxisAlignment: MainAxisAlignment.center,
//children: <Widget>[
//FlutterLogo(),
//SizedBox(
//height: 10.0,
//),
//Text(
//'City ${index + 1}',
//style: TextStyle(
//fontWeight: FontWeight.bold,
//fontSize: 15.0,
//color: ColorUtil.navyBlue),
//),
//],
//)),
//),
//);
//}),
//)),
