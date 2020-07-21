




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huawei_location/geofence/geofence.dart';
import 'package:huawei_location/location/fused_location_provider_client.dart';
import 'package:huawei_location/location/location_callback.dart';
import 'package:huawei_location/location/location_request.dart';
import 'package:locationkitdemo/activity_identification_service.dart';
import 'package:locationkitdemo/fused_location.dart';
import 'package:locationkitdemo/geofence_service.dart';

class AddGeofence extends StatefulWidget {
  static const String routeName = "AddGeofence";
  @override
  _AddGeofenceState createState() => _AddGeofenceState();
}

class _AddGeofenceState extends State<AddGeofence> {
  String infoText = "Addgeofence";
  int fenceCount;
  int callbackId;

  TextEditingController _lat;
  TextEditingController _lng;
  TextEditingController _rad;
  TextEditingController _uid;
  TextEditingController _conversions;
  TextEditingController _validTime;
  TextEditingController _dwellTime;
  TextEditingController _notifInterval;

  List<Geofence> geofenceList;
  List<String> geofenceIdList;

  List<TextInputFormatter> numWithDecimalFormatter = <TextInputFormatter>[
    WhitelistingTextInputFormatter(
        RegExp(r"[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)")),
  ];

  List<TextInputFormatter> digitsOnlyFormatter = <TextInputFormatter>[
    WhitelistingTextInputFormatter.digitsOnly,
  ];

  FusedLocationProviderClient locationService;
  LocationCallback locCallback;

  @override
  void initState() {
    super.initState();
    initialValues();
    getGeofenceFromRoute();
  }

  void initialValues() {
    infoText = "";
    fenceCount = 0;
    _lat = TextEditingController();
    _lng = TextEditingController();
    _rad = TextEditingController(text: "60");
    _uid = TextEditingController();
    _conversions = TextEditingController(text: "5");
    _validTime = TextEditingController(text: "1000000");
    _dwellTime = TextEditingController(text: "10000");
    _notifInterval = TextEditingController(text: "100");
    locationService = FusedLocationProviderClient();
    locCallback = LocationCallback(onLocationResult: (locationRes) {
      _lat.text = locationRes.locations.last.latitude.toString();
      _lng.text = locationRes.locations.last.longitude.toString();
    });
  }

  void getGeofenceFromRoute() {
    Future.delayed(Duration.zero, () {
      Map<String, Object> args = ModalRoute.of(context).settings.arguments;
      geofenceList = args['geofenceList'];
      geofenceIdList = args['geofenceIdList'];
      setState(() {
        infoText = geofenceIdList.toString();
        fenceCount = geofenceIdList.length;
      });
    });
  }

  void addGeofence() {
    try {
      String uniqueId = _uid.text;

      if (uniqueId == '') {
        setState(() {
          infoText = "UniqueId cannot be empty.";
        });
      } else if (geofenceIdList.contains(uniqueId)) {
        setState(() {
          infoText = "Geofence with this UniqueId already exists.";
        });
      } else {
        int conversions = int.parse(_conversions.text);
        int validDuration = int.parse(_validTime.text);
        double latitude = double.parse(_lat.text);
        double longitude = double.parse(_lng.text);
        double radius = double.parse(_rad.text);
        int notificationInterval = int.parse(_notifInterval.text);
        int dwellDelayTime = int.parse(_dwellTime.text);

        Geofence geofence = Geofence(
          uniqueId: uniqueId,
          conversions: conversions,
          validDuration: validDuration,
          latitude: latitude,
          longitude: longitude,
          radius: radius,
          notificationInterval: notificationInterval,
          dwellDelayTime: dwellDelayTime,
        );

        geofenceList.add(geofence);
        geofenceIdList.add(geofence.uniqueId);

        setState(() {
          fenceCount++;
          infoText = geofenceIdList.toString() + " Geofence added successfully.";
        });
      }
    } catch (e) {
      setState(() {
        infoText = e.toString();
      });
    }
  }

  void removeLocationUpdatesCb(int callbackId) async {
    try {
      await locationService.removeLocationUpdatesCb(callbackId);
      print("Removed location updates with callback id $callbackId");
    } catch (e) {
      print(e.toString());
    }
  }

  void requestLocationUpdatesCb() async {
    LocationRequest locationRequest;
    locationService = FusedLocationProviderClient();
    locationRequest = LocationRequest();
    locationRequest.interval = 1000;

    try {
      callbackId = await locationService.requestLocationUpdatesCb(
          locationRequest, locCallback);
      print("Requested location updates with callback id $callbackId");
      print("Now removing location updates");
      removeLocationUpdatesCb(callbackId);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, {
          'geofenceList': geofenceList,
          'geofenceIdList': geofenceIdList,
        });
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Add Geofence Screen'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(infoText),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextField(
                        controller: _lat,
                        keyboardType: TextInputType.numberWithOptions(
                            signed: false, decimal: true),
                        inputFormatters: numWithDecimalFormatter,
                        decoration: InputDecoration(labelText: "Latitude",hintText: "[-90,90]"),
                      ),
                      TextField(
                        controller: _lng,
                        keyboardType: TextInputType.numberWithOptions(
                            signed: false, decimal: true),
                        inputFormatters: numWithDecimalFormatter,
                        decoration: InputDecoration(labelText: "Longitude",hintText: "[-180,180]"),
                      ),
                      TextField(
                        controller: _rad,
                        keyboardType: TextInputType.numberWithOptions(
                            signed: false, decimal: true),
                        inputFormatters: numWithDecimalFormatter,
                        decoration: InputDecoration(labelText: "Conversions",hintText: "in meters"),
                      ),
                      TextField(
                        controller: _uid,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: "UniqueId"),
                      ),
                      TextField(
                        controller: _conversions,
                        keyboardType: TextInputType.number,
                        inputFormatters: digitsOnlyFormatter,
                        decoration: InputDecoration(labelText: "Conversions"),
                      ),
                      TextField(
                        controller: _validTime,
                        keyboardType: TextInputType.number,
                        inputFormatters: digitsOnlyFormatter,
                        decoration: InputDecoration(labelText: "ValidTime"),
                      ),
                      TextField(
                        controller: _dwellTime,
                        keyboardType: TextInputType.number,
                        inputFormatters: digitsOnlyFormatter,
                        decoration: InputDecoration(labelText: "DwellDelayTime"),
                      ),
                      TextField(
                        controller: _notifInterval,
                        keyboardType: TextInputType.number,
                        inputFormatters: digitsOnlyFormatter,
                        decoration: InputDecoration(labelText: "NotificationInterval"),
                      ),
                      RaisedButton(
                        child:Text("Get Current Location"),
                        onPressed: requestLocationUpdatesCb,
                      ),
                      RaisedButton(
                        child:Text("Add Geofence"),
                        onPressed: addGeofence,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}