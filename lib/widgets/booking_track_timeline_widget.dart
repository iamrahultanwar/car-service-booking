import '../util/colors_util.dart';
import 'package:flutter/material.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

class BookingTrackTimeLineWidget extends StatefulWidget {
  @override
  _BookingTrackTimeLineWidgetState createState() =>
      _BookingTrackTimeLineWidgetState();
}

class _BookingTrackTimeLineWidgetState
    extends State<BookingTrackTimeLineWidget> {
  List<TimelineModel> items = [
    TimelineModel(
        Container(
            width: 100.0,
            height: 100.0,
            child: Center(child: Text("placeholder"))),
        position: TimelineItemPosition.left,
        iconBackground: Colors.red,
        icon: Icon(
          Icons.call_made,
          color: Colors.white,
          size: 12.0,
        )),
    TimelineModel(
        Container(
            width: 100.0,
            height: 100.0,
            child: Center(child: Text("placeholder"))),
        position: TimelineItemPosition.right,
        iconBackground: ColorUtil.blueGrey,
        icon: Icon(
          Icons.call_made,
          color: ColorUtil.blueGrey,
          size: 12.0,
        )),
    TimelineModel(
        Container(
            width: 100.0,
            height: 100.0,
            child: Center(child: Text("placeholder"))),
        position: TimelineItemPosition.left,
        iconBackground: ColorUtil.blueGrey,
        icon: Icon(
          Icons.call_made,
          color: ColorUtil.blueGrey,
          size: 12.0,
        )),
    TimelineModel(
        Container(
            width: 100.0,
            height: 100.0,
            child: Center(child: Text("placeholder"))),
        position: TimelineItemPosition.right,
        iconBackground: ColorUtil.blueGrey,
        icon: Icon(
          Icons.call_made,
          color: ColorUtil.blueGrey,
          size: 12.0,
        )),
    TimelineModel(
        Container(
            width: 100.0,
            height: 100.0,
            child: Center(child: Text("placeholder"))),
        position: TimelineItemPosition.left,
        iconBackground: ColorUtil.blueGrey,
        icon: Icon(
          Icons.timeline,
          color: ColorUtil.blueGrey,
          size: 12.0,
        )),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Track Order"),
      ),
      body: Timeline(
        iconSize: 20.0,
        children: items,
        position: TimelinePosition.Center,
        lineColor: ColorUtil.blueGrey,
      ),
    );
  }
}
