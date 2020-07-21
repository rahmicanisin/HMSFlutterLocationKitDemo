import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locationkitdemo/activity_identification_service.dart';
import 'package:locationkitdemo/fused_location.dart';
import 'package:locationkitdemo/geofence_service.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

void routeToFusedLocation() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => FusedLocation()),
  );
}

void routeToGeofenseService() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => GeofenceServiceScreen()),
  );
}
void routeToActivityIdentificationService() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ActivityIdentification()),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fused Location Service'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            RaisedButton(
              child:Text("Fused Location"),
              onPressed: routeToFusedLocation,
            ),
            RaisedButton(
              child:Text("Activity Identification"),
              onPressed: routeToActivityIdentificationService,
            ),
            RaisedButton(
              child:Text("Geofence Service"),
              onPressed: routeToGeofenseService,
            )
          ],
        ),
      ),
    );
  }

}