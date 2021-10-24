import '../models/user_model.dart';
import '../pages/booking_page.dart';
import '../services/http_service.dart';
import '../util/colors_util.dart';
import '../util/common_widgets_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

class UserBookingsList extends StatefulWidget {
  @override
  _UserBookingsListState createState() => _UserBookingsListState();
}

class _UserBookingsListState extends State<UserBookingsList> {
  var formatter = new DateFormat.yMMMMEEEEd();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Your Bookings",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<BookingModel>>(
        future: fetchUserBookings(),
        // a previously-obtained Future<String> or null
        builder:
            (BuildContext context, AsyncSnapshot<List<BookingModel>> snapshot) {
          List<Widget> children;

          if (snapshot.hasData) {
            List<BookingModel> _bookings = snapshot.data;

            if (_bookings.length == 0)
              return Center(
                child: Image.asset(
                  "assets/images/no-order.png",
                ),
              );

            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _bookings.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                          leading: Container(
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Stack(
                                children: <Widget>[
                                  Center(
                                    child: Image.asset(
                                      "assets/images/car_loading.gif",
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  Center(
                                    child: FadeInImage.memoryNetwork(
                                      placeholder: kTransparentImage,
                                      image: _bookings[index].userCar.logo,
                                    ),
                                  ),
                                ],
                              )),
                          isThreeLine: false,
                          title: Text(
                            "${_bookings[index].userCar.make} ${_bookings[index].userCar.model}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          subtitle: Text(
                            "Order Placed, ${formatter.format(DateTime.parse(_bookings[index].created))}",
                            style: TextStyle(fontSize: 10.0),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(BookingPage.routeName, arguments: {
                                "booking": _bookings[index],
                                "show": false
                              });
                            },
                            icon: Icon(
                              Icons.arrow_forward,
                              size: 35.0,
                            ),
                          )),
                      ListTile(
                          dense: true,
                          leading: Text(
                            "Rs ${_bookings[index].totalAmount}",
                            style: TextStyle(
                                fontSize: 15.0, color: ColorUtil.navyBlue),
                          ),
                          title: Text(
                            _bookings[index].bookingDate,
                          ),
                          trailing: Container(
                            width: 100.0,
                            child: CommonWidgets()
                                .timeSlotWidget(_bookings[index].bookingTime),
                          ),
                          subtitle: CommonWidgets()
                              .arrivalWidget(_bookings[index].arrivalMode)),
                    ],
                  ),
                );
              },
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
      ),
    );
  }
}
