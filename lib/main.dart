import 'package:agridex/ui/sheep_list.dart';
import 'package:agridex/ui/ble/ble_devices_screen.dart';
import 'package:agridex/ui/ble/screen_names.dart' as ScreenNames;
import 'package:flutter/material.dart';

void main() async {
  runApp(new SheepBoxApp());
}

class SheepBoxApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.amberAccent,
          fontFamily: 'Ubuntu'),
      home: new SheepList(),
      routes: <String, WidgetBuilder>{
        ScreenNames.bleDevicesScreen: (BuildContext context) =>
            new BleDevicesScreen(),
      },
    );
  }
}
