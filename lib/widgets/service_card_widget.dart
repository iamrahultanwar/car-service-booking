import '../models/service_model.dart';
import '../pages/service_page.dart';
import 'package:flutter/material.dart';

class ServiceCardWidget extends StatelessWidget {
  final ServiceModel service;
  final int serviceIndex;
  ServiceCardWidget({this.service, this.serviceIndex});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ServicePage.routeName, arguments: serviceIndex);
        },
        child: Container(
          height: 140,
          width: 120,
          child: Card(
            margin: EdgeInsets.all(0),
            elevation: 6.0,
            child: Stack(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        service.name,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                Positioned(
                  top: 50,
                  left: 35,
                  child: Image.asset(
                    service.logoUrl,
                    width: 50,
                    height: 50,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 15,
                  child: Text(
                    service.offer,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.indigo),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
