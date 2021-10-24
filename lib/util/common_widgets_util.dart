import '../util/colors_util.dart';
import 'package:flutter/material.dart';

class CommonWidgets {
  Widget arrivalWidget(String id) {
    if (id == "1") {
      return Text(
        "Home Pickup",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
            color: ColorUtil.navyBlue),
      );
    } else {
      return Text(
        "Drop at workshop",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
            color: ColorUtil.navyBlue),
      );
    }
  }

  Widget timeSlotWidget(String id) {
    String time = "";
    if (id == "1") {
      time = "10am - 1pm";
    } else if (id == '2') {
      time = "1pm - 4pm";
    } else if (id == '3') {
      time = "4pm - 7pm";
    } else {
      time = "7pm - 10pm";
    }

    return Text(time,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
            color: ColorUtil.navyBlue));
  }

  Widget badgeContainer(String data) {
    return Container(
      width: 60.0,
      height: 25.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(width: 1.2, color: Colors.redAccent),
        color: Colors.red.withOpacity(0.8),
      ),
      child: Center(
          child: Text(
        data,
        style: TextStyle(fontSize: 15.0, color: Colors.white),
      )),
    );
  }
}
