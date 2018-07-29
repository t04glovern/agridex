import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:agridex/ui/sheep_details/header/cut_colored_image.dart';
import 'package:uuid/uuid.dart';

class SheepBleScreen extends StatefulWidget {
  final BleDevice _connectedDevice;

  SheepBleScreen(this._connectedDevice);

  @override
  State<StatefulWidget> createState() {
    return new SheepBleScreenState(_connectedDevice);
  }
}

class SheepBleScreenState extends State<StatefulWidget> {
  final BleDevice _connectedDevice;
  String _serviceDiscoveringState = "Unknown";
  List<BleService> _services;
  List<Characteristic> _characteristics = new List<Characteristic>();
  List<String> _values = new List<String>();
  String _sheep1 = "Loading...";
  String _sheep2 = "Loading...";

  SheepBleScreenState(this._connectedDevice);

  static const BACKGROUND_IMAGE = 'images/profile_header_background.png';

  @override
  initState() {
    super.initState();
    FlutterBleLib.instance.onDeviceConnectionChanged().listen((device) =>
        setState(() => _connectedDevice.isConnected = device.isConnected));
    _onDiscoverAllServicesClick();
  }

  _onDiscoverAllServicesClick() async {
    FlutterBleLib.instance
        .discoverAllServicesAndCharacteristicsForDevice(_connectedDevice.id)
        .then((device) {
      _onServicesForDeviceClick();
      setState(() {
        _serviceDiscoveringState = "DONE";
      });
    });
  }

  _onServicesForDeviceClick() async {
    FlutterBleLib.instance
        .servicesForDevice(_connectedDevice.id)
        .then((services) {
      for (BleService bs in services) {
        _onCharacteristicForServiceClick(bs);
      }
      setState(() {
        _services = services;
      });
    });
  }

  _onCharacteristicForServiceClick(BleService service) {
    FlutterBleLib.instance
        .characteristicsForService(service.id)
        .then((characteristics) {
      List<Characteristic> _newCharacteristics = _characteristics;
      for (Characteristic _characteristic in characteristics) {
        _newCharacteristics.add(_characteristic);
        _onReadCharacteristic(_characteristic);
      }
      _populateValues();
      setState(() {
        _characteristics = _newCharacteristics;
      });
    });
  }

  _onReadCharacteristic(Characteristic characteristic) async {
    FlutterBleLib.instance
        .readCharacteristic(characteristic.id, new Uuid().v1())
        .then((value) {
      List<String> _newValues = _values;
      _newValues.add(value.value);
      setState(() {
        _values = _newValues;
      });
    });
  }

  _populateValues() async {
    print(_values);
    setState(() {
      _sheep1 = "951 000301588724";
      _sheep2 = "951 000301612242";
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var screenWidth = MediaQuery.of(context).size.width;

    var linearGradient = new BoxDecoration(
      gradient: new LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: [
          Colors.green,
          Colors.green,
        ],
      ),
    );

    var diagonalBackground = new DiagonallyCutColoredImage(
      new Image.asset(
        BACKGROUND_IMAGE,
        width: screenWidth,
        height: 280.0,
        fit: BoxFit.cover,
      ),
      color: const Color(0x8888D897),
    );

    var avatar = new Hero(
      tag: _connectedDevice.id,
      child: new CircleAvatar(
        backgroundImage: new NetworkImage(
            'https://stockhead.com.au/wp-content/uploads/2017/09/Getty-sheep.jpg'),
        radius: 50.0,
      ),
    );

    var deviceInfo = new Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Text(
            _deviceLabel(),
            style: textTheme.subhead
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );

    final TextStyle titleStyle = Theme.of(context).textTheme.title;
    final TextStyle buttonStyle = Theme.of(context).textTheme.body2;

    var sheeps = new Card(
      color: Colors.white,
      child: new Container(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              child: new Column(
                children: <Widget>[
                  new Container(
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                        new Text("Lamb", style: titleStyle),
                        new Text(_sheep1, style: buttonStyle),
                        new Text("Confidence", style: titleStyle),
                        new Text("0.75", style: buttonStyle)
                      ])),
                  new Padding(padding: const EdgeInsets.all(8.0)),
                  new Container(
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                        new Text("Lamb", style: titleStyle),
                        new Text(_sheep2, style: buttonStyle),
                        new Text("Confidence", style: titleStyle),
                        new Text("0.63", style: buttonStyle)
                      ])),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    var tagInfo = new Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 16.0),
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Flexible(child: new Column(children: <Widget>[sheeps]))
            ]));

    return new Scaffold(
        backgroundColor: Colors.green,
        body: new SingleChildScrollView(
          child: new Container(
            decoration: linearGradient,
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Stack(
                    children: [
                      diagonalBackground,
                      new Align(
                        alignment: FractionalOffset.bottomCenter,
                        heightFactor: 1.4,
                        child: new Column(
                          children: [avatar, deviceInfo, tagInfo],
                        ),
                      ),
                      new Positioned(
                        top: 26.0,
                        left: 4.0,
                        child: new BackButton(color: Colors.white),
                      ),
                    ],
                  )
                ]),
          ),
        ));
  }

  _deviceLabel() => "EID : ${_connectedDevice.name}";
}
