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

  _onCharacteristicForServiceClick(BleService service) async {
    FlutterBleLib.instance
        .characteristicsForService(service.id)
        .then((characteristics) {
      List<Characteristic> _newCharacteristics = _characteristics;
      for (Characteristic _characteristic in characteristics) {
        _newCharacteristics.add(_characteristic);
        _onReadCharacteristic(_characteristic);
      }
      setState(() {
        _characteristics = _newCharacteristics;
      });
    });
  }

  _onReadCharacteristic(Characteristic characteristic) {
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

    var actionButtons = new Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          new ClipRRect(
            borderRadius: new BorderRadius.circular(30.0),
            child: new MaterialButton(
              minWidth: 100.0,
              color: theme.accentColor,
              textColor: Colors.white,
              onPressed: () {},
              child: new Text('Log Data'),
            ),
          ),
        ],
      ),
    );

    var tagInfo = new Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 16.0),
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Flexible(
                  child: new Column(children: <Widget>[
                new Text("Value Data: \n" + _values.toString(),
                    style: TextStyle(color: Colors.white))
              ]))
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
                          children: [
                            avatar,
                            deviceInfo,
                            actionButtons,
                            tagInfo
                          ],
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
