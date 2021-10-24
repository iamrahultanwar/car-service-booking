import 'package:autoflipz_user_app/pages/faq_page.dart';

import '../models/car_model.dart';
import '../models/service_model.dart';
import '../models/user_model.dart';
import '../pages/account_page.dart';

import '../pages/membership_page.dart';
import '../pages/select_car_page.dart';
import '../pages/select_city_page.dart';
import '../services/http_service.dart';
import '../services/shared_preferences.dart';
import '../util/badge_util.dart';
import '../widgets/bottom_navigation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'service_details_page.dart';
import 'service_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;

class HomePage extends StatefulWidget {
  static String routeName = "/home-page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel user = new UserModel(userCar: new CarModel());
  List<ServiceModel> _services;
  bool _isLoading = true;

  wp.WordPress wordPress = wp.WordPress(
    baseUrl: 'http://blogs.autoflipz.com/',
    authenticator: wp.WordPressAuthenticator.JWT,
    adminName: '',
    adminKey: '',
  );

  List<wp.Post> _posts = [];

  void _getWordPressPost() async {
    Future<List<wp.Post>> posts = wordPress.fetchPosts(
      postParams: wp.ParamsPostList(
        context: wp.WordPressContext.view,
        pageNum: 1,
        perPage: 20,
        order: wp.Order.desc,
        orderBy: wp.PostOrderBy.date,
      ),
      fetchAttachments: true,
      fetchFeaturedMedia: true,
    );

    _posts = await posts;
    setState(() {
      _posts = _posts;
    });
  }

  void getUserDetails() async {
    user = await getUserLocally();
    setState(() {
      user = user;
    });
  }

  void _getServiceList() async {
    setState(() {
      _isLoading = true;
    });
    _services = await fetchServices();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
    _getServiceList();
    _getWordPressPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Image.asset(
                  "assets/images/af-logo.png",
                  height: 10.0,
                  width: 10.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              ListTile(
                title: Text('Get a quote'),
                onTap: () {
                  launch("tel://9899551235");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('My account'),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, AccountPage.routeName);
                },
              ),
              // ListTile(
              //   title: Text('Wallet'),
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => UserPaymentPage(),
              //       ),
              //     );
              //   },
              // ),
              ListTile(
                title: Text('FAQ'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FAQPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Contact us'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(SelectCityPage.routeName);
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(width: 0.8, color: Colors.red),
                  color: Colors.white),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                    Text(
                      user.userRegion == null ? "" : user.userRegion.name,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      softWrap: true,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MembershipPage()),
                    );
                  },
                  child: Badge(
                    size: 30.0,
                    text: "Go plus",
                  ),
                ),
              ),
            )
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: ListTile(
                      leading: CachedNetworkImage(
                          imageUrl: user.userCar.logo,
                          width: 80.0,
                          height: 80.0),
                      title: Text(
                        '${user.userCar.make} ${user.userCar.model}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                      subtitle: Text(
                        user.userCar.type,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      trailing: Container(
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(SelectCarPage.routeName);
                          },
                          child: Text(
                            "Change",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    height: 200,
                    width: double.infinity,
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "https://storageautoflipz.s3.ap-south-1.amazonaws.com/pictures/27.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "https://storageautoflipz.s3.ap-south-1.amazonaws.com/pictures/17.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "https://storageautoflipz.s3.ap-south-1.amazonaws.com/pictures/26.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "https://storageautoflipz.s3.ap-south-1.amazonaws.com/pictures/16.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "https://storageautoflipz.s3.ap-south-1.amazonaws.com/pictures/7.png",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20.0),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "What are you looking for ?",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        Text(
                          "Select services and checkout easily",
                          style: TextStyle(color: Colors.grey, fontSize: 12.0),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    // Create a grid with 2 columns. If you change the scrollDirection to
                    // horizontal, this produces 2 rows.
                    crossAxisCount: 3,
                    // Generate 100 widgets that display their index in the List.
                    children: _services.map((service) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(ServicePage.routeName,
                              arguments: {'name': service.name});
                        },
                        child: Container(
                          height: 200.0,
                          width: 200.0,
                          color: Colors.white,
                          margin: EdgeInsets.all(1.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              CachedNetworkImage(
                                imageUrl: service.logoUrl,
                                width: 80.0,
                                height: 80.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    service.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Blogs",
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: map<Widget>(_posts, (index, post) {
                        return GestureDetector(
                          // ignore: sdk_version_set_literal
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => new WebviewScaffold(
                                  ignoreSSLErrors: true,
                                  url: post.link.toString(),
                                  appBar: new AppBar(
                                    title: new Text("Autoflipz Blogs"),
                                  ),
                                ),
                              ),
                            ),
                          },
                          child: Container(
                            margin: EdgeInsets.all(3.0),
                            // width: 300,
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: CachedNetworkImage(
                                      imageUrl: post.featuredMedia.sourceUrl,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      fit: BoxFit.fill),
                                ),
                                Positioned(
                                  child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.red.withOpacity(0.5),
                                      border: Border.all(
                                          color: Colors.red, width: 2.0),
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      post.title.rendered,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  /*Container(
                    height: 200.0,
                    width: double.infinity,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _posts.length,
                        itemBuilder: (context, index) {
                          wp.Post post = _posts[index];
                     }),
                  )*/
                ],
              ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: FloatingIconWidget(),
        bottomNavigationBar: BottomNavigationWidget());
  }
}
