import 'dart:async';

import 'package:agridex/models/sheep.dart';
import 'package:agridex/services/api.dart';
import 'package:agridex/ui/sheep_details/details_page.dart';
import 'package:agridex/utils/routes.dart';
import 'package:agridex/ui/ble/screen_names.dart' as ScreenNames;
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

class TagColor {
  static final _postBreederColor =
  TagColor(Colors.black, Color.fromARGB(255, 255, 140, 235));

  static final _colors = [
    TagColor(Colors.white, Colors.black),
    TagColor(Colors.black, Colors.white),
    TagColor(Colors.white, Colors.orange),
    TagColor(Colors.white, Colors.lightGreen),
    TagColor(Colors.white, Colors.purple),
    TagColor(Colors.black, Colors.yellow),
    TagColor(Colors.white, Colors.red),
    TagColor(Colors.white, Colors.blue),
  ];

  Color foreground;
  Color background;

  TagColor(this.foreground, this.background);

  TagColor.fromYear(int year) {
    var color = TagColor._colors[year % TagColor._colors.length];

    this.foreground = color.foreground;
    this.background = color.background;
  }

  TagColor.fromPostBreeder() {
    this.foreground = TagColor._postBreederColor.foreground;
    this.background = TagColor._postBreederColor.background;
  }
}

class SheepList extends StatefulWidget {
  @override
  _SheepListState createState() => new _SheepListState();
}

class _SheepListState extends State<SheepList> {
  List<Sheep> _sheep = [];
  SheepApi _api;
  NetworkImage _profileImage;

  @override
  void initState() {
    super.initState();
    _loadFromFirebase();
  }

  _loadFromFirebase() async {
    final api = await SheepApi.signInWithGoogle();
    final sheep = await api.getAllSheep();
    setState(() {
      _api = api;
      _sheep = sheep;
      _profileImage = new NetworkImage(api.firebaseUser.photoUrl);
    });
  }

  _reloadSheep() async {
    if (_api != null) {
      final sheep = await _api.getAllSheep();
      setState(() {
        _sheep = sheep;
      });
    }
  }

  Widget _buildSheepItem(BuildContext context, int index) {
    Sheep sheep = _sheep[index];

    var tagColor = sheep.postBreeder
        ? TagColor.fromPostBreeder()
        : TagColor.fromYear(sheep.birth);

    return new Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: new Card(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              onTap: () => _navigateToSheepDetails(sheep, index),
              leading: new Hero(
                tag: index,
                child: new CircleAvatar(
                  backgroundColor: tagColor.background,
                  child: new Text(sheep.origin, style: new TextStyle(color: tagColor.foreground)),
                ),
              ),
              title: new Text(
                "EID: " + sheep.eid,
                style: new TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              subtitle: new Text("Birth Year: " + sheep.birth.toString()),
              isThreeLine: false,
              dense: false,
            ),
          ],
        ),
      ),
    );
  }

  _navigateToSheepDetails(Sheep sheep, Object avatarTag) {
    Navigator.of(context).push(
      new FadePageRoute(
        builder: (c) {
          return new SheepDetailsPage(sheep, avatarTag: avatarTag);
        },
        settings: new RouteSettings(),
      ),
    );
  }

  Widget _getAppTitleWidget() {
    return new Text(
      'AgDex Sheep',
      style: new TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 32.0,
      ),
    );
  }

  Widget _buildBody() {
    return new Container(
      margin: const EdgeInsets.fromLTRB(
          8.0, // A left margin of 8.0
          56.0, // A top margin of 56.0
          8.0, // A right margin of 8.0
          0.0 // A bottom margin of 0.0
          ),
      child: new Column(
        // A column widget can have several
        // widgets that are placed in a top down fashion
        children: <Widget>[_getAppTitleWidget(), _getListViewWidget()],
      ),
    );
  }

  Future<Null> refresh() {
    _reloadSheep();
    return new Future<Null>.value();
  }

  Widget _getListViewWidget() {
    return new Flexible(
        child: new RefreshIndicator(
            onRefresh: refresh,
            child: new ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _sheep.length,
                itemBuilder: _buildSheepItem)));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.green,
        body: _buildBody(),
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new FloatingActionButton(
              heroTag: null,
              onPressed: () => _onBluetoothSetupClick(context),
              child: Icon(Icons.bluetooth, color: Colors.white),
              tooltip: 'Bluetooth Connect',
            )
          ],
        ));
  }

  _onBluetoothSetupClick(BuildContext context) {
    FlutterBleLib.instance.createClient(null).then((data) =>
        Navigator.of(context).pushNamed(ScreenNames.bleDevicesScreen));
  }
}
