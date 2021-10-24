import 'package:cached_network_image/cached_network_image.dart';

import '../models/user_model.dart';
import '../pages/cart_page.dart';
import '../pages/home_page.dart';
import '../util/colors_util.dart';
import '../util/common_widgets_util.dart';
import '../widgets/booking_track_timeline_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingPage extends StatefulWidget {
  static String routeName = "/booking-page";

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  var formatter = new DateFormat.yMMMMEEEEd();

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Start Exploring Again'),
            content: new Text('Booking more services ?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(CartPage.routeName));
                  Navigator.of(context)
                      .pushReplacementNamed(HomePage.routeName);
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Widget _bookingDetailsScaffold(BookingModel _booking) {
    double _screenRatio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      backgroundColor: ColorUtil.blueGrey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Booking",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 50.0,
                ),
                Text(
                  "Booking Confirmed",
                  style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookingTrackTimeLineWidget()),
                    );
                  },
                  child: Text("Track Order"),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: double.infinity,
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        ListTile(
                          leading: CachedNetworkImage(
                              imageUrl: _booking.userCar.logo,
                              fit: BoxFit.cover),
                          title: Text(
                              "${_booking.userCar.make} ${_booking.userCar.model}"),
                        ),
                        ListTile(
                          title: Text("Booking Id"),
                          subtitle: Text(_booking.id),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.content_copy,
                              size: 20.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Car Appointment Date",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorUtil.navyBlue,
                                  fontSize: _screenRatio * 4)),
                        ),
                        ListTile(
                          subtitle: CommonWidgets()
                              .arrivalWidget(_booking.arrivalMode),
                          title: Text(
                            _booking.bookingDate,
                            style: TextStyle(fontSize: _screenRatio * 4),
                          ),
                          trailing: CommonWidgets()
                              .timeSlotWidget(_booking.bookingTime),
                        ),
                        ListTile(
                          title: Text("Address"),
                          subtitle: Text(_booking.bookingAddress),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Payment",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorUtil.navyBlue,
                                  fontSize: 20.0)),
                        ),
                        ListTile(
                          dense: true,
                          title: Text(
                            'Rs ${_booking.totalAmount.toString()}',
                            style: TextStyle(
                                fontSize: _screenRatio * 4,
                                fontWeight: FontWeight.bold),
                          ),
                          leading: _booking.paymentMode == "cash"
                              ? Image.asset(
                                  "assets/images/money.png",
                                  width: _screenRatio * 7,
                                  height: _screenRatio * 7,
                                )
                              : Image.asset(
                                  "assets/images/payment.png",
                                  width: _screenRatio * 7,
                                  height: _screenRatio * 7,
                                ),
                          trailing: Text(formatter
                              .format(DateTime.parse(_booking.created))),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Services Booked",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorUtil.navyBlue,
                        fontSize: 20.0),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Card(
                    child: Column(
                      children: _booking.subServices.map((service) {
                        return ListTile(
                          trailing: Text(
                            'Rs ${service.price}',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          title: Text(
                            service.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            service.brief,
                            style: TextStyle(
                                fontSize: 12.0, color: Colors.blueGrey),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context).settings.arguments;
    BookingModel _booking = arguments['booking'];
    bool showPop = arguments["show"];
    return showPop
        ? WillPopScope(
            onWillPop: _onWillPop,
            child: _bookingDetailsScaffold(_booking),
          )
        : _bookingDetailsScaffold(_booking);
  }
}
