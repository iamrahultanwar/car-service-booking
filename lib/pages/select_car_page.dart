import '../models/car_model.dart';
import '../pages/splash_screen_page.dart';
import '../services/http_service.dart';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class SelectCarPage extends StatefulWidget {
  static String routeName = "/select-car-page";

  @override
  _SelectCarPageState createState() => _SelectCarPageState();
}

class _SelectCarPageState extends State<SelectCarPage> {
  Future<List<CarModel>> cars;
  List<CarModel> _suggestionsCar = [
    {
      "car_image":
          "https://cdn.euroncap.com/media/41886/hyundai-santa-fe-359-235.201811191201488264.jpg?mode=crop&width=359&height=235",
      "_id": "5e8b6d8d429bcc03eb0b3191",
      "car_make": "Hyundai",
      "car_model": "SantaFE",
      "car_type": "Petrol",
      "car_category": "SUV"
    },
    {
      "car_image":
          "https://cdn.euroncap.com/media/41886/hyundai-santa-fe-359-235.201811191201488264.jpg?mode=crop&width=359&height=235",
      "_id": "5e8b6d8d429bcc03eb0b3192",
      "car_make": "Hyundai",
      "car_model": "SantaFE",
      "car_type": "Diesel",
      "car_category": "SUV"
    },
    {
      "car_image":
          "https://imgd.aeplcdn.com/664x374/cw/ec/32940/Hyundai-Santro-Right-Front-Three-Quarter-138738.jpg?wm=0&q=85",
      "_id": "5e8b6d8d429bcc03eb0b3193",
      "car_make": "Hyundai",
      "car_model": "Santro",
      "car_type": "Petrol",
      "car_category": "Hatchback"
    },
    {
      "car_image":
          "https://stimg.cardekho.com/images/car-images/large/Nissan/Nissan-Evalia/pearl_white.jpg",
      "_id": "5e8b6d8d429bcc03eb0b3239",
      "car_make": "Nissan",
      "car_model": "Evalia",
      "car_type": "Diesel",
      "car_category": "MUV"
    },
    {
      "car_image":
          "https://www-asia.nissan-cdn.net/content/dam/Nissan/in/vehicles/micra/updated02082018/15TDIinrhd_MIC-Hw001_S_ay6.png",
      "_id": "5e8b6d8d429bcc03eb0b323a",
      "car_make": "Nissan",
      "car_model": "Micra",
      "car_type": "Petrol",
      "car_category": "Hatchback"
    },
    {
      "car_image":
          "https://www-asia.nissan-cdn.net/content/dam/Nissan/in/vehicles/micra/updated02082018/15TDIinrhd_MIC-Hw001_S_ay6.png",
      "_id": "5e8b6d8d429bcc03eb0b323b",
      "car_make": "Nissan",
      "car_model": "Micra",
      "car_type": "Diesel",
      "car_category": "Hatchback"
    },
    {
      "car_image":
          "https://auto.ndtvimg.com/car-images/large/nissan/micra-active/nissan-micra-active.jpg?v=7",
      "_id": "5e8b6d8d429bcc03eb0b323c",
      "car_make": "Nissan",
      "car_model": "Micra Active",
      "car_type": "Petrol",
      "car_category": "Hatchback"
    },
    {
      "car_image":
          "https://images-na.ssl-images-amazon.com/images/I/61wxOCWjxQL._SX466_.jpg",
      "_id": "5e8b6d8d429bcc03eb0b323d",
      "car_make": "Nissan",
      "car_model": "Sunny",
      "car_type": "Petrol",
      "car_category": "Sedan"
    },
    {
      "car_image":
          "https://images-na.ssl-images-amazon.com/images/I/61wxOCWjxQL._SX466_.jpg",
      "_id": "5e8b6d8d429bcc03eb0b323e",
      "car_make": "Nissan",
      "car_model": "Sunny",
      "car_type": "Diesel",
      "car_category": "Sedan"
    },
    {
      "car_image":
          "https://media.zigcdn.com/media/car_model/2018/May/nissan-teana-right_600x300.jpg",
      "_id": "5e8b6d8d429bcc03eb0b323f",
      "car_make": "Nissan",
      "car_model": "Teana",
      "car_type": "Petrol",
      "car_category": "Mid Luxury"
    }
  ].map((car) {
    return CarModel.fromJson(car);
  }).toList();

  bool _isLoading = false;
  final SearchBarController<CarModel> _searchBarController =
      SearchBarController();

  void _updateUserCar(String carId) async {
    setState(() {
      _isLoading = true;
    });
    Map data = {"car": carId};

    bool _res = await updateUserDetails(data);

    if (_res) {
      Navigator.of(context).pushReplacementNamed(SplashScreenPage.routeName);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void getCars() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Select Your Car",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SearchBar<CarModel>(
                textStyle:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
                headerPadding: EdgeInsets.symmetric(horizontal: 10),
                onSearch: fetchCars,
                searchBarController: _searchBarController,
                suggestions: _suggestionsCar,
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
                onItemFound: (CarModel car, int index) {
                  return Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
                    color: Colors.white,
                    width: double.infinity,
                    child: InkWell(
                      onTap: () {
                        _updateUserCar(car.id);
                      },
                      child: ListTile(
                        dense: true,
                        leading: Container(
                            width: 70.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: car.logo,
                                fit: BoxFit.cover,
                              ),
                            )),
                        title: Container(
                          width: 10.0,
                          child: Text(
                            car.model,
                            style: TextStyle(
                                fontSize: 17.0,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              car.make,
                              style: TextStyle(fontSize: 17.0),
                            ),
                          ],
                        ),
                        trailing: Text(
                          car.type,
                          style: TextStyle(
                              color: (car.type == 'Petrol'
                                  ? Colors.green
                                  : Colors.deepOrange),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.4,
                              fontSize: 17.0),
                        ),
                        isThreeLine: false,
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Text("Detail"),
          ],
        ),
      ),
    );
  }
}
