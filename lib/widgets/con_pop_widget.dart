import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CanPopWidget extends StatefulWidget {
  final Widget pageWidget;

  CanPopWidget({this.pageWidget});

  @override
  _CanPopWidgetState createState() => _CanPopWidgetState();
}

class _CanPopWidgetState extends State<CanPopWidget> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Want to exit app ? ☹️'),
            content: new Text('There still more to explore'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  SystemNavigator.pop(animated: true);
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: _onWillPop, child: widget.pageWidget);
  }
}
