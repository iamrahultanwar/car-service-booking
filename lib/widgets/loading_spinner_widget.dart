import 'package:flutter/material.dart';

class LoadingSpinnerWidget extends StatefulWidget {
  final bool loading;
  final Widget child;

  LoadingSpinnerWidget({this.loading, this.child});

  @override
  _LoadingSpinnerWidgetState createState() => _LoadingSpinnerWidgetState();
}

class _LoadingSpinnerWidgetState extends State<LoadingSpinnerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: widget.loading
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white70,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : widget.child);
  }
}
