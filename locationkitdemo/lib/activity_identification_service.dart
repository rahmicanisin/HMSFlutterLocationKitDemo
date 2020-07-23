import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:huawei_location/activity/activity_identification_data.dart';
import 'package:huawei_location/activity/activity_identification_response.dart';
import 'package:huawei_location/activity/activity_identification_service.dart';
import 'package:huawei_location/permission/permission_handler.dart';
import 'package:locationkitdemo/activity_corversion.dart';

class ActivityIdentification extends StatefulWidget {
  @override
  _ActivityIdentificationState createState() => _ActivityIdentificationState();
}

class _ActivityIdentificationState extends State<ActivityIdentification> {

  String infoText = "Unknown";
  int callbackId;
  PermissionHandler permissionHandler;
  ActivityIdentificationService activityIdentificationService;
  StreamSubscription<ActivityIdentificationResponse> streamSubscription;
  int _vehicle;
  int _bike;
  int _foot;
  int _still;
  int _others;
  int _tilting;
  int _walking;
  int _running;
  int requestCode;

  @override
  void initState() {
    super.initState();
    permissionHandler = PermissionHandler();
    activityIdentificationService =
        ActivityIdentificationService();
    streamListen();
    _vehicle = 0;
    _bike = 0;
    _foot = 0;
    _still = 0;
    _others = 0;
    _tilting = 0;
    _walking = 0;
    _running = 0;
  }



  void requestActivityRecognitionPermission() async {
    try {
      bool status = await permissionHandler.requestActivityRecognitionPermission();
      // status is true if permissions are granted, false otherwise
      setState(() {
        infoText = status.toString();
      });

    } catch (e) {
      setState(() {
        infoText = e.toString();
      });
    }
  }
  void hasPermission() async {
    bool status = await permissionHandler.hasActivityRecognitionPermission();
    setState(() {
      infoText = "Has permission: $status";
    });
  }
  void  createActivityIdentificationUpdates() async {

    try {
      requestCode = await activityIdentificationService.createActivityIdentificationUpdates(5000);
      setState(() {
        infoText = "Created Activity Identification Updates successfully.";
      });

    } catch (e) {
      setState(() {
        infoText = e.toString();
      });
    }
  }

  void   onActivityIdentificationResponse(ActivityIdentificationResponse response)  {
    for (ActivityIdentificationData data
    in response.activityIdentificationDatas) {
      setChange(data.identificationActivity , data.possibility);

      //data.identificationActivity include activity type like vehicle,bike etc.
      //data.posibility The confidence for the user to execute the activity.
      //The confidence ranges from 0 to 100. A larger value indicates more reliable activity authenticity.
    }
  }
void streamListen() {
  streamSubscription =
      activityIdentificationService.onActivityIdentification.listen(onActivityIdentificationResponse);

}

  void deleteActivityIdentificationUpdates() async {
    if (requestCode != null) {
      try {
        await activityIdentificationService.deleteActivityIdentificationUpdates(requestCode);
        requestCode = null;
        setState(() {
          infoText ="Deleted Activity Identification Updates successfully.";
        });

      } catch (e) {
        infoText= e.toString();
      }
    } else {
      setState(() {
        infoText = "Create Activity Identification Updates first.";
      });
      infoText = "Create Activity Identification Updates first.";
    }
  }

  void setChange(int activity, int possibility) {
    switch (activity) {
      case ActivityIdentificationData.VEHICLE:
        setState(() {
          _vehicle = possibility;
        });
        break;
      case ActivityIdentificationData.BIKE:
        setState(() {
          _bike = possibility;
        });
        break;
      case ActivityIdentificationData.FOOT:
        setState(() {
          _foot = possibility;
        });
        break;
      case ActivityIdentificationData.STILL:
        setState(() {
          _still = possibility;
        });
        break;
      case ActivityIdentificationData.OTHERS:
        setState(() {
          _others = possibility;
        });
        break;
      case ActivityIdentificationData.TILTING:
        setState(() {
          _tilting = possibility;
        });
        break;
      case ActivityIdentificationData.WALKING:
        setState(() {
          _walking = possibility;
        });
        break;
      case ActivityIdentificationData.RUNNING:
        setState(() {
          _running = possibility;
        });
        break;
      default:
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Identification Service'),
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
            RaisedButton(
              child:Text("hasPermissions"),
              onPressed: hasPermission,
            ),
            RaisedButton(
              child:Text("requestActivityRecognitionPermission"),
              onPressed: requestActivityRecognitionPermission,
            ),
            RaisedButton(
              child:Text("createActivityIdentificationUpdates"),
              onPressed: createActivityIdentificationUpdates,
            ),
            RaisedButton(
              child:Text("deleteActivityIdentificationUpdates"),
              onPressed: deleteActivityIdentificationUpdates,
            ),
            RaisedButton(
              child:Text("Activity Conversion"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ActivityConversion()),
                );
              },
            ),
            Container(
              padding: EdgeInsets.only(top: 15),
              child: Column(
                children: <Widget>[

                  Text( "Vehicle(100): " + _vehicle.toString()),
                  Text( "Bike(101): " + _bike.toString()),
                  Text( "Foot(102): " + _foot.toString()),
                  Text( "Still(103): " + _still.toString()),
                  Text( "Others(104): " + _others.toString()),
                  Text( "Tilting(105): " + _tilting.toString()),
                  Text( "Walking(107): " + _walking.toString()),
                  Text( "Runnig(108): " + _running.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}








