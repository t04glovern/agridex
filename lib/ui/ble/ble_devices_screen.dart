import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:agridex/ui/sheep_ble_screen.dart';


class BleScanResultList extends StatefulWidget {

  final List<ScanResult> _scanResults;

  final BuildContext _mainBuildContext;

  BleScanResultList(this._scanResults, this._mainBuildContext);

  @override
  State<StatefulWidget> createState() =>
      new BleScanResultListState(_scanResults, _mainBuildContext);
}

class ScanResultItem extends StatelessWidget {

  final ScanResult _scanResult;
  final VoidCallback _onConnectClick;

  ScanResultItem(this._scanResult,
      this._onConnectClick,);

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle = Theme
        .of(context)
        .textTheme
        .title;
    final TextStyle body1Style = Theme
        .of(context)
        .textTheme
        .body1;
    final TextStyle buttonStyle = Theme
        .of(context)
        .textTheme
        .body2;
    return new Card(
      color: Colors.white,
      child: new Container(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Container(
                    child: new Column(
                      children: <Widget>[
                        new Text(_deviceName(), style: titleStyle),
                        new Text(_deviceMac(), style: body1Style),
                      ],
                    )
                  ),
                  new MaterialButton(
                    onPressed: _onConnectClick,
                    color: Colors.amberAccent,
                    child: new Text("CONNECT", style: buttonStyle),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _deviceName() => "${_scanResult.bleDevice.name}";

  _deviceMac() => "MAC : ${_scanResult.bleDevice.id}";

}


class BleScanResultListState extends State<StatefulWidget> {

  final List<ScanResult> _scanResults;

  final BuildContext _mainBuildContext;

  BleScanResultListState(this._scanResults, this._mainBuildContext);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: _scanResults == null ? 0 : _scanResults.length,
        itemBuilder: (BuildContext context, int index) =>
            buildItem(_scanResults[ index], _mainBuildContext)
    );
  }


  Widget buildItem(ScanResult scanResults, BuildContext context) {
    return new ScanResultItem(scanResults,
            () => _onConnectButtonClick(scanResults)
    );
  }

  _onConnectButtonClick(ScanResult scanResults) {
    FlutterBleLib.instance.connectToDevice(
        scanResults.bleDevice.id, isAutoConnect: true).then((connectedDevice) =>
        Navigator.of(_mainBuildContext).push(new MaterialPageRoute(
            builder: (BuildContext buildContext) =>
            new SheepBleScreen(connectedDevice))));
  }
}

class BleDevicesScreen extends StatefulWidget {
  @override
  BleDevicesState createState() => new BleDevicesState();
}

class BleDevicesState extends State<BleDevicesScreen> {

  StreamSubscription _scanDevicesSub;
  StreamSubscription _bluetoothStateSub;

  bool _isScan = false;
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  final List<ScanResult> _scanResults = new List();

  @override
  initState() {
    super.initState();
    _bluetoothStateSub = FlutterBleLib.instance.onStateChange()
        .listen((bluetoothState) =>
        setState(() => this._bluetoothState = bluetoothState));
    FlutterBleLib.instance.state().then((bluetoothState) =>
        setState(() => this._bluetoothState = bluetoothState));
  }

  @override
  dispose() {
    _onStopScan();
    _cancelStateChange();
    FlutterBleLib.instance.destroyClient();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.green,
        title: new Text('Bluetooth Scan List')
      ),
      backgroundColor: Colors.green,
      floatingActionButton: new FloatingActionButton(
        child: new Icon(_isScan ? Icons.close : Icons.search),
        onPressed: _isScan ? _onStopScan : _onStartScan,
        tooltip: 'Bluetooth Scan',
      ),
      body: new BleScanResultList(_scanResults, context),
      bottomNavigationBar: new PreferredSize(
        preferredSize: const Size.fromHeight(24.0),
        child: new Theme(
          data: Theme.of(context).copyWith(
              accentColor: Colors.white, backgroundColor: Colors.green),
          child:
          new Container(
            color: Colors.green,
            padding: const EdgeInsets.all(10.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text("Bluetooth state", style: new TextStyle(color: Colors.white)),
                new Icon(_bleStateIcon(), size: 20.0, color: Colors.white)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _bleStateIcon() {
    switch (_bluetoothState) {
      case BluetoothState.UNKNOWN :
        return Icons.device_unknown;
      case BluetoothState.RESETTING :
        return Icons.bluetooth_searching;
      case BluetoothState.UNSUPPORTED :
        return Icons.close;
      case BluetoothState.UNAUTHORIZED :
        return Icons.lock;
      case BluetoothState.POWERED_OFF :
        return Icons.bluetooth_disabled;
      case BluetoothState.POWERED_ON :
        return Icons.bluetooth;
    }
  }

  _cancelStateChange() {
    _bluetoothStateSub?.cancel();
    _bluetoothStateSub = null;
  }

  _onStopScan() {
    _scanDevicesSub?.cancel();
    _scanDevicesSub = null;
    FlutterBleLib.instance.stopDeviceScan();
    setState(() {
      _isScan = false;
    });
  }

  _onStartScan() {
    //TODO pass this list as arg to scan only filtered devices
    List<String> uuids = new List();
    uuids.add("917649A0-D98E-11E5-9EEC-0002A5D5C51B");
    _scanDevicesSub = FlutterBleLib.instance
        .startDeviceScan(1, 1, uuids)
        .listen(
            (scanResult) => setState(() => _addOrUpdateIfNecessary(scanResult)),
        onDone: _onStopScan);

    setState(() {
      _isScan = true;
    });
  }

  _addOrUpdateIfNecessary(ScanResult scanResultItem) {
    for (var scanResult in _scanResults) {
      if (scanResult.hasTheSameDeviceAs(scanResultItem)) {
        scanResult.update(scanResultItem);
        return;
      }
    }
    _scanResults.add(scanResultItem);
  }
}
