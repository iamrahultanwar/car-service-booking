import '../models/service_model.dart';
import '../services/http_service.dart';
import '../widgets/service_tab_list.dart';
import 'package:flutter/material.dart';

class ServicePage extends StatefulWidget {
  static String routeName = "/service-page";

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  Map<String, int> _serviceTab = {
    "Car Service": 0,
    "Car AC ": 1,
    "Wheel Services": 2,
    "Coating": 3,
    "Regular Repairs": 4,
    "Car Care": 5,
    "Denting/Painting": 6,
    "Body Wrapping": 7,
    "Special": 8
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // { name:"Special",index: 0 }
    Map<String, dynamic> _service = ModalRoute.of(context).settings.arguments;
    // print('**' + _serviceTab[_service["name"].trim()].toString() + '**');
    int serviceIndex = 0;
    int subServiceIndex = 0;
    if (_serviceTab[_service["name"]] != null) {
      serviceIndex = _serviceTab[_service["name"]];
    }

    return FutureBuilder<List<ServiceTab>>(
      future: fetchSubService(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ServiceTabWidget(
              subServiceList: snapshot.data,
              serviceIndex: serviceIndex,
              subSubservice: subServiceIndex);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        // By default, show a loading spinner.
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
