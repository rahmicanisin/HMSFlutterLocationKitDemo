













import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huawei_location/location/fused_location_provider_client.dart';
import 'package:huawei_location/location/location_availability.dart';
import 'package:huawei_location/location/location_callback.dart';
import 'package:huawei_location/location/location_request.dart';
import 'package:huawei_location/location/location_result.dart';



class LocationCallBack extends StatefulWidget {
  @override
  _LocationCallBackState createState() => _LocationCallBackState();
}

class _LocationCallBackState extends State<LocationCallBack> {

  String infoText = "Unknown";
  int callbackId;
  FusedLocationProviderClient locationService;
  LocationRequest locationRequest;
  LocationCallback locationCallback;


  @override
  void initState() {
    super.initState();
    locationService = FusedLocationProviderClient();
    locationRequest = LocationRequest();
    locationRequest.interval = 5000;
    locationCallback = LocationCallback(onLocationAvailability: _onLocationAvailability,onLocationResult: _onLocationResult);
  }

  void _onLocationResult(LocationResult res) {
    setState(() {
      infoText = infoText + "\n\n" + res.toString();
    });
  }

  void _onLocationAvailability(LocationAvailability availability) {
    setState(() {
      infoText = infoText + "\n\n" + availability.toString();
    });
  }

  void requestLocationUpdatesCb() async {
    if (callbackId == null) {
      try {
        int _callbackId = await locationService.requestLocationUpdatesCb(
            locationRequest, locationCallback);
        callbackId = _callbackId;
        setState(() {
          infoText = "Location updates requested successfully";
        });
      } catch (e) {
        setState(() {
          infoText = e.toString();
        });
      }
    } else {
      setState(() {
        infoText =
        "Already requested location updates. Try removing location updates";
      });
    }
  }

  void removeLocationUpdatesCb() async {
    if (callbackId != null) {
      try {
        await locationService.removeLocationUpdatesCb(callbackId);
        callbackId = null;
        setState(() {
          infoText = "Location updates are removed successfully";

        });
      } catch (e) {
        setState(() {
          infoText = e.toString();
        });
      }
    } else {
      setState(() {
        infoText = "callbackId does not exist. Request location updates first";
      });
    }
  }

  void requestLocationUpdatesExCb() async {
    if (callbackId == null) {
      try {
        int _callbackId = await locationService.requestLocationUpdatesExCb(
            locationRequest, locationCallback);
        callbackId = _callbackId;
        setState(() {
          infoText = "Location updates are requested successfully";
        });
      } catch (e) {
        setState(() {
          infoText = e.toString();
        });
      }
    } else {
      setState(() {
        infoText =
        "Already requested location updates. Try removing location updates";
      });
    }
  }

  void removeLocationUpdatesExCb() async {
    setState(() {
      infoText = "";
    });
    if (callbackId != null) {
      try {
        await locationService.removeLocationUpdatesCb(callbackId);
        callbackId = null;
        setState(() {
          infoText = "Location updates are removed successfully";
        });
      } catch (e) {
        setState(() {
          infoText = e.toString();
        });
      }
    } else {
      setState(() {
        infoText = "callbackId does not exist. Request location updates first";
      });
    }
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
            Container(
              padding: EdgeInsets.only(
                top: 10,
              ),
              height: 90,
              child: Text(infoText),
            ),
            Divider(
              thickness: 0.1,
              color: Colors.black,
            ),
            /* RaisedButton(
              child:Text("IsPermissions"),
              onPressed: hasPermission,
            ),
            RaisedButton(
              child:Text("RequestPermissions"),
              onPressed: requestPermission,
            ), */
            RaisedButton(
              child:Text("requestLocationUpdatesCb"),
              onPressed: requestLocationUpdatesCb,
            ),
            RaisedButton(
              child:Text("removeLocationUpdatesCb"),
              onPressed: removeLocationUpdatesCb,
            ),
            RaisedButton(
              child:Text("requestLocationUpdatesExCb"),
              onPressed: requestLocationUpdatesExCb,
            ),
            RaisedButton(
              child:Text("removeLocationUpdatesExCb"),
              onPressed: removeLocationUpdatesExCb,
            )
          ],
        ),
      ),
    );
  }



}



