




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huawei_location/location/fused_location_provider_client.dart';
import 'package:huawei_location/location/hwlocation.dart';
import 'package:huawei_location/location/location.dart';
import 'package:huawei_location/location/location_availability.dart';
import 'package:huawei_location/location/location_callback.dart';
import 'package:huawei_location/location/location_request.dart';
import 'package:huawei_location/location/location_result.dart';
import 'package:huawei_location/location/location_settings_request.dart';
import 'package:huawei_location/location/location_settings_states.dart';
import 'package:huawei_location/permission/permission_handler.dart';
import 'package:locationkitdemo/activity_corversion.dart';
import 'package:locationkitdemo/activity_identification_service.dart';
import 'package:locationkitdemo/locationCallback.dart';


class FusedLocation extends StatefulWidget {
  static const String routeName = "FusedLocationScreen";
  @override
  _FusedLocationState createState() => _FusedLocationState();
}

class _FusedLocationState extends State<FusedLocation> {

  PermissionHandler permissionHandler;
  FusedLocationProviderClient locationService;
  List<LocationRequest> locationRequestList;
  LocationSettingsRequest locationSettingsRequest;
  LocationRequest locationRequest;
  Location mockLocation;


  String infoText = "Unknown";

  int requestCode;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    locationService = FusedLocationProviderClient();
    permissionHandler = PermissionHandler();
    locationRequest = LocationRequest();
    locationRequest.interval = 5000;
    locationRequestList = <LocationRequest>[locationRequest];
    locationSettingsRequest =
        LocationSettingsRequest(requests: locationRequestList);
    mockLocation = Location(latitude: 38.6155, longitude: 27.4245);

  }

  void requestLocationUpdates() async {
    try {
      requestCode = await locationService.requestLocationUpdates(
          locationRequest);

      setState(() {
        infoText =
            "Location updates requested successfully " + requestCode.toString();
      });
    } catch (e) {
      setState(() {
        infoText = e.toString();
      });
    }
  }

  void removeLocationUpdates() async {
    try{
      await locationService.removeLocationUpdates(requestCode);
      requestCode = null;
      setState(() {
        infoText = "Location updates are removed successfully";


      });
    } catch(e){
      infoText = e.toString();
    }

  }

  void getLastLocation() async {
    setState(() {
      infoText = "";
    });
    try {
      Location location = await locationService.getLastLocation();
      setState(() {
        infoText = location.toString();
      });
    } catch (e) {
      setState(() {
        infoText = e.toString();
      });
    }
  }
  void getLastLocationWithAddress() async {

    try {
      HWLocation location =
      await locationService.getLastLocationWithAddress(locationRequest);
      setState(() {
        infoText = location.toString();
      });
    } catch (e) {
      setState(() {
        infoText = e.toString();
      });
    }
  }
  void hasPermission() async {
    try {
      bool status = await permissionHandler.hasLocationPermission();
      setState(() {
        infoText = "Has permission: $status";
      });
    } catch (e) {
      setState(() {
        infoText = e.toString();
      });
    }
  }

  void requestPermission() async {
    try {
      bool status = await permissionHandler.requestLocationPermission();
      setState(() {
        infoText = "Is permission granted $status";
      });
    } catch (e) {
      setState(() {
        infoText = e.toString();
      });
    }
  }

  void requestBackgroundLocationPermission() async {
    try {
      bool status = await permissionHandler.requestBackgroundLocationPermission();
      setState(() {
        infoText = "Is permission granted $status";
      });
    } catch (e) {
      setState(() {
        infoText = e.toString();
      });
    }
  }
  void checkLocationSettings() async {
    try {
      LocationSettingsStates states = await locationService.checkLocationSettings(locationSettingsRequest);
      setState(() {
        infoText = states.toString();
      });
    } catch (e) {
      setState(() {
        infoText = e.toString();
      });
    }
  }
  void getLocationAvailability() async {

    try {
      LocationAvailability availability =
      await locationService.getLocationAvailability();
      setState(() {
        infoText = availability.toString();
      });
    } catch (e) {
      setState(() {
        infoText = e.toString();
      });
    }
  }
  void setMockLocation() async {

    try {
      await locationService.setMockLocation(mockLocation);
      setState(() {
        infoText =
        "Mock location has set lat:${mockLocation.latitude} lng:${mockLocation.longitude}";
      });
    } catch (e) {
      setState(() {
        infoText = e.toString();
      });
    }
  }
  void setMockModeTrue() async {

    try {
      await locationService.setMockMode(true);
      setState(() {
        infoText = "Mock mode set to 'true'";
      });
    } on PlatformException catch (e) {
      setState(() {
        infoText = e.toString();
      });
    }
  }

  void setMockModeFalse() async {

    try {
      await locationService.setMockMode(false);
      setState(() {
        infoText = "Mock mode set to 'false'";
      });
    } catch (e) {
      setState(() {
        infoText = e.toString();
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
            ),
            RaisedButton(
              child:Text("RequestBackPermissions"),
              onPressed: requestBackgroundLocationPermission,
            ),
            RaisedButton(
              child:Text("checkLocationSettings"),
              onPressed: checkLocationSettings,
            ), */
            RaisedButton(
              child:Text("getLastLocation"),
              onPressed: getLastLocation,
            ),
            RaisedButton(
              child:Text("getLastLocationWithAddress"),
              onPressed: getLastLocationWithAddress,
            ),
            RaisedButton(
              child:Text("getLocationAvailability"),
              onPressed: getLocationAvailability,
            ),
            RaisedButton(
              child:Text("setMockLocation"),
              onPressed: setMockLocation,
            ),
            RaisedButton(
              child:Text("setMockModeTrue"),
              onPressed: setMockModeTrue,
            ),
            RaisedButton(
              child:Text("setMockModeFalse"),
              onPressed: setMockModeFalse,
            ),
            RaisedButton(
              child:Text("requestLocationUpdates"),
              onPressed: requestLocationUpdates,
            ),
            RaisedButton(
              child:Text("removeLocationUpdates"),
              onPressed: removeLocationUpdates,
            ),
            RaisedButton(
              child:Text("LocationCallBack"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LocationCallBack()),
                  );
                }
            )
          ],
        ),
      ),
    );
  }


}