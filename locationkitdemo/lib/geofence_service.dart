



import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huawei_location/geofence/geofence.dart';
import 'package:huawei_location/geofence/geofence_data.dart';
import 'package:huawei_location/geofence/geofence_request.dart';
import 'package:huawei_location/geofence/geofence_service.dart';
import 'package:huawei_location/location/fused_location_provider_client.dart';
import 'package:huawei_location/permission/permission_handler.dart';

import 'add_geofence.dart';

class GeofenceServiceScreen extends StatefulWidget {
  static const String routeName = "GeofenceScreen";

  @override
  _GeofenceServiceScreenState createState() => _GeofenceServiceScreenState();
}

class _GeofenceServiceScreenState extends State<GeofenceServiceScreen> {
  String infoText="null";
  String geofenceText;

  int requestCode;
  PermissionHandler permissionHandler;
  int fenceCount;

  List<Geofence> geofenceList;
  List<String> geofenceIdList;
  GeofenceService geofenceService;
  GeofenceRequest geofenceRequest;
  FusedLocationProviderClient locationService;
  StreamSubscription<GeofenceData> geofenceStreamSub;
  TextEditingController _uid;
  TextEditingController _trigger;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fenceCount = 0;
    geofenceList = <Geofence>[];
    geofenceIdList = <String>[];
    permissionHandler = PermissionHandler();
    geofenceService = GeofenceService();
    geofenceRequest = GeofenceRequest();
    locationService = FusedLocationProviderClient();
    _uid = TextEditingController();
    _trigger = TextEditingController(text: "5");
    geofenceStreamSub = geofenceService.onGeofenceData.listen((data) {
      setState(() {
        infoText = infoText + '\n\n' + data.toString();
      });
    });

    geofenceText = geofenceIdList.toString();
    fenceCount = geofenceList.length;
  }

  navigateToAddGeofence(BuildContext context) async {
    final dynamic result = await Navigator.pushNamed(
        context, AddGeofence.routeName,
        arguments: {
          'geofenceList': geofenceList,
          'geofenceIdList': geofenceIdList,
        }
    );
    setState(() {
      fenceCount = geofenceList.length;
      geofenceText = result['geofenceIdList'].toString();
    });
  }

  void createGeofenceList() async {
    if (requestCode != null) {
      setState(() {
        infoText =
        "Already created geofence list. Call deleteGeofenceList method first.";
      });
    } else if (geofenceList.isEmpty) {
      setState(() {
        infoText = "Add Geofence first.";
      });
    } else {
      geofenceRequest.geofenceList = geofenceList;
      geofenceRequest.initConversions = 5;
      try {
        requestCode = await geofenceService.createGeofenceList(geofenceRequest);
        setState(() {
          infoText = "Created geofence list successfully.";
        });
      } catch (e) {
        setState(() {
          infoText = e.toString();
        });
      }
    }
  }

  void deleteGeofenceList() async {
    if (requestCode == null) {
      setState(() {
        infoText = "Call createGeofenceList method first.";
      });
    } else {
      try {
        await geofenceService.deleteGeofenceList(requestCode);
        requestCode = null;
        setState(() {
          infoText = "Deleted geofence list successfully.";
        });
      } catch (e) {
        setState(() {
          infoText = e.toString();
        });
      }
    }
  }

  void deleteGeofenceListWithIds() async {
    if (requestCode == null) {
      setState(() {
        infoText = "Call createGeofenceList method first.";
      });
    } else {
      try {
        await geofenceService.deleteGeofenceListWithIds(geofenceIdList);
        requestCode = null;
        setState(() {
          infoText = "Deleted geofence list successfully.";
        });
      } catch (e) {
        setState(() {
          infoText = e.toString();
        });
      }
    }
  }

  void hasPermission() async {
    try {
      bool status = await permissionHandler.hasBackgroundLocationPermission();
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
      bool status =
      await permissionHandler.requestBackgroundLocationPermission();
      setState(() {
        infoText = "Is permission granted $status";
      });
    } catch (e) {
      setState(() {
        infoText = e.toString();
      });
    }
  }
  void removeGeofence() {
    if (geofenceList.isEmpty) {
      setState(() {
        infoText = "Geofence list is empty. Add geofence first.";
      });
    }
    String uniqueId = _uid.text;

    if (uniqueId == '') {
      setState(() {
        infoText = "Enter unique id of the geofence to remove it.";
      });
    } else if (!geofenceIdList.contains(uniqueId)) {
      setState(() {
        infoText = "Id '$uniqueId' does not exist on geofence list.";
      });
    } else {
      geofenceIdList.remove(uniqueId);
      geofenceList.removeWhere((e) => e.uniqueId == uniqueId);

      setState(() {
        fenceCount = geofenceList.length;
        geofenceText = geofenceIdList.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: const Text('Geofence Service'),
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
            Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text("Geofences: $fenceCount"),
                    SizedBox(height: 15),
                    Text(geofenceText),
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 0.1,
              color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                child:Text("hasPermission"),
                onPressed: hasPermission,
              ),
                RaisedButton(
                  child:Text("requestPermission"),
                  onPressed: requestPermission,
                ),
              ],
            ),
            RaisedButton(
              child:Text("Add Geofence"),
              onPressed: () {
                navigateToAddGeofence(context);
              },
            ),
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 9,
              child: TextField(
                scrollPadding: EdgeInsets.all(0),
                controller: _uid,
                decoration: InputDecoration( labelText: "Geofence UniqueId"),
                keyboardType: TextInputType.text,
              ),
            ),
            Flexible(
              flex: 6,
              child: Container(
                height: 45,
                child:RaisedButton(
                  child:Text("Remove Geofence"),
                  onPressed: removeGeofence,
                ),
              ),
            ),
          ],
        ),
      ),
      Divider(
        thickness: 0.1,
        color: Colors.black,
      ),
      RaisedButton(
        child:Text("createGeofenceList"),
        onPressed: createGeofenceList,
      ),
      RaisedButton(
        child:Text("deleteGeofenceList"),
        onPressed: deleteGeofenceList,
      ),
      RaisedButton(
        child:Text("deleteGeofenceListWithIds"),
        onPressed: deleteGeofenceListWithIds,
      ),
          ],
        ),
      ),
    );
  }

}