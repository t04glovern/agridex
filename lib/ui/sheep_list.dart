import 'dart:async';

import 'package:agridex/models/sheep.dart';
import 'package:agridex/services/api.dart';
import 'package:agridex/ui/sheep_details/details_page.dart';
import 'package:agridex/utils/routes.dart';
import 'package:agridex/ui/ble/screen_names.dart' as ScreenNames;
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';

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
                child: new Text('#' + (index + 1).toString(),
                    style: Theme.of(this.context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 30.0)),
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
      'AgDex',
      style: new TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 32.0,
      ),
    );
  }

  void _sortByCondition() {
    var sheep = this._sheep;
    sheep.sort((lhs, rhs) {
      var lhsSum = 0.0;
      var rhsSum = 0.0;

      for (var cond in lhs.conditions) lhsSum += cond['score'];
      for (var cond in rhs.conditions) rhsSum += cond['score'];

      return (rhsSum - lhsSum).round();
    });

    this.setState(() {
      this._sheep = new List.from(sheep);
    });
  }

  void _sortByWeight() {
    var sheep = this._sheep;
    sheep.sort((lhs, rhs) {
      var lhsSum = 0.0;
      var rhsSum = 0.0;

      for (var cond in lhs.weights) lhsSum += cond['weight'];
      for (var cond in rhs.weights) rhsSum += cond['weight'];

      return (rhsSum - lhsSum).round();
    });

    this.setState(() {
      this._sheep = new List.from(sheep);
    });
  }

  void _sortByGfw() {
    var sheep = this._sheep;
    sheep.sort((lhs, rhs) {
      var lhsSum = 0.0;
      var rhsSum = 0.0;

      for (var cond in lhs.fleece) lhsSum += cond['gfw'];
      for (var cond in rhs.fleece) rhsSum += cond['gfw'];

      return (rhsSum - lhsSum).round();
    });

    this.setState(() {
      this._sheep = new List.from(sheep);
    });
  }

  void _sortByMicron() {
    var sheep = this._sheep;
    sheep.sort((lhs, rhs) {
      var lhsSum = 0.0;
      var rhsSum = 0.0;

      for (var cond in lhs.fleece) lhsSum += cond['micron'];
      for (var cond in rhs.fleece) rhsSum += cond['micron'];

      return (rhsSum - lhsSum).round();
    });

    this.setState(() {
      this._sheep = new List.from(sheep);
    });
  }

  Widget _buildSortButtonRow() {
    var textStyle =
        Theme.of(this.context).textTheme.title.copyWith(fontSize: 15.0);

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              padding: EdgeInsets.all(5.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('Condition', style: textStyle),
              ),
              onPressed: () {
                this._sortByCondition();
              },
            ),
            RaisedButton(
              padding: EdgeInsets.all(5.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('Weight', style: textStyle),
              ),
              onPressed: () {
                this._sortByWeight();
              },
            ),
            RaisedButton(
              padding: EdgeInsets.all(5.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('GFW', style: textStyle),
              ),
              onPressed: () {
                this._sortByGfw();
              },
            ),
            RaisedButton(
              padding: EdgeInsets.all(5.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('Micron', style: textStyle),
              ),
              onPressed: () {
                this._sortByMicron();
              },
            ),
          ],
        ),
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
        children: <Widget>[
          _getAppTitleWidget(),
          _buildSortButtonRow(),
          _getListViewWidget(),
        ],
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
