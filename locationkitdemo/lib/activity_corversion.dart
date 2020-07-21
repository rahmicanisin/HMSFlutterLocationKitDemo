





import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:huawei_location/activity/activity_conversion_data.dart';
import 'package:huawei_location/activity/activity_conversion_info.dart';
import 'package:huawei_location/activity/activity_conversion_response.dart';
import 'package:huawei_location/activity/activity_identification_data.dart';
import 'package:huawei_location/activity/activity_identification_service.dart';


class ActivityConversion extends StatefulWidget {
  @override
  _ActivityConversionState createState() => _ActivityConversionState();
}

class _ActivityConversionState extends State<ActivityConversion> {

  String infoText = "Unknown";
  String bottomText = "Unknown";
  int callbackId;
  ActivityIdentificationService activityIdentificationService;
  StreamSubscription<ActivityConversionResponse> streamSubscription;
  static const int NUM_OF_ACTIVITY = 6;
  static const double CONT_WIDTH1 = 100;
  static const double CONT_WIDTH2 = 100;
  static const double CONT_WIDTH3 = 100;

  static const List<int> _validTypes = <int>[
    ActivityIdentificationData.VEHICLE,
    ActivityIdentificationData.BIKE,
    ActivityIdentificationData.FOOT,
    ActivityIdentificationData.STILL,
    ActivityIdentificationData.WALKING,
    ActivityIdentificationData.RUNNING
  ];

  int requestCode;
  List<String> _activityTypes;
  List<bool> _inStates;
  List<bool> _outStates;

  @override
  void initState() {
    super.initState();
    _activityTypes = <String>[
      "VEHICLE[100]",
      "BIKE[101]",
      "FOOT[102]",
      "STILL[103]",
      "WALKING[107]",
      "RUNNING[108]"
    ];
    _inStates = List.filled(NUM_OF_ACTIVITY, false);
    _outStates = List.filled(NUM_OF_ACTIVITY, false);
    activityIdentificationService =
        ActivityIdentificationService();
    streamSubscription = activityIdentificationService.onActivityConversion.listen(onConversionData);
  }

  void onConversionData(ActivityConversionResponse response) {
    for (ActivityConversionData data in response.activityConversionDatas) {
      print(data.toString());
    }
  }
  List<ActivityConversionInfo> getConversionList() {
    List<ActivityConversionInfo> conversions = <ActivityConversionInfo>[];

    for (int i = 0; i < NUM_OF_ACTIVITY; i++) {
      if (_inStates[i]) {
        conversions.add(ActivityConversionInfo(
            activityType: _validTypes[i], conversionType: 0));
      }
      if (_outStates[i]) {
        conversions.add(ActivityConversionInfo(
            activityType: _validTypes[i], conversionType: 1));
      }
    }
    return conversions;
  }

  void createActivityConversionUpdates() async {
    if (requestCode == null) {
      try {
        int _requestCode =
        await activityIdentificationService.createActivityConversionUpdates(getConversionList());
        requestCode = _requestCode;
        setTopText("Created Activity Conversion Updates successfully.");
      } catch (e) {
        setTopText(e.toString());
      }
    } else {
      setTopText("Already receiving Activity Conversion Updates.");
    }
  }

  void deleteActivityConversionUpdates() async {
    if (requestCode != null) {
      try {
        await activityIdentificationService.deleteActivityConversionUpdates(requestCode);
        requestCode = null;
        clearBottomText();
        setTopText("Deleted Activity Conversion Updates successfully.");
      } catch (e) {
        setTopText(e.toString());
      }
    } else {
      setTopText("Create Activity Conversion Updates first.");
    }
  }

  void deleteUpdatesOnDispose() async {
    if (requestCode != null) {
      try {
        await activityIdentificationService.deleteActivityConversionUpdates(requestCode);
        requestCode = null;
      } catch (e) {
        print(e.toString());
      }
    }
  }

  void setTopText(String text) {
    setState(() {
      infoText = text;
    });
  }

  void setBottomText(String text) {
    setState(() {
      bottomText = text;
    });
  }

  void appendBottomText(String text) {
    setState(() {
      bottomText = "$bottomText\n\n$text";
    });
  }

  void clearTopText() {
    setState(() {
      infoText = "";
    });
  }

  void clearBottomText() {
    setState(() {
      bottomText = "";
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activity Conversion"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 15, bottom: 6),
              child: Text(infoText),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(width: CONT_WIDTH1, child: Text("Activity")),
                Container(width: CONT_WIDTH2, child: Text("Transition")),
                Container(width: CONT_WIDTH3, child: Text("Transition")),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(width: CONT_WIDTH1),
                Container(width: CONT_WIDTH2, child: Text("IN(0)")),
                Container(width: CONT_WIDTH3, child: Text("OUT(1)")),
              ],
            ),
            Container(
              child: Column(
                children: List.generate(NUM_OF_ACTIVITY, (i) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: CONT_WIDTH1,
                          child: Text(_activityTypes[i]),
                        ),
                        Container(
                          width: CONT_WIDTH2,
                          child: Checkbox(
                            value: _inStates[i],
                            onChanged: (bool value) => setState(() {
                              _inStates[i] = value;
                            }),
                          ),
                        ),
                        Container(
                          width: CONT_WIDTH3,
                          child: Checkbox(
                            value: _outStates[i],
                            onChanged: (bool value) => setState(() {
                              _outStates[i] = value;
                            }),
                          ),
                        ),
                      ]);
                }),
              ),
            ),
            RaisedButton(
              child:Text("createActivityConversionUpdates"),
              onPressed: createActivityConversionUpdates,
            ),
            RaisedButton(
              child:Text("deleteActivityConversionUpdates"),
              onPressed: deleteActivityConversionUpdates,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(bottomText),
            ),
          ],
        ),
      ),
    );
  }


}
