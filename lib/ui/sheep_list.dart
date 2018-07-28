import 'dart:async';

import 'package:agridex/models/sheep.dart';
import 'package:agridex/services/api.dart';
import 'package:agridex/ui/sheep_details/details_page.dart';
import 'package:agridex/utils/routes.dart';
import 'package:flutter/material.dart';

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
                child: new CircleAvatar(
                  backgroundImage: new NetworkImage(sheep.avatarUrl),
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
      'Sheep',
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
              onPressed: () {},
              child: Icon(Icons.camera, color: Colors.white),
              tooltip: 'Scan Tag',
            ),
//            new FloatingActionButton(
//              heroTag: null,
//              onPressed: () {},
//              tooltip: _api != null
//                  ? 'Signed-in: ' + _api.firebaseUser.displayName
//                  : 'Not Signed-in',
//              backgroundColor: Colors.green,
//              child: new CircleAvatar(
//                backgroundImage: _profileImage,
//                radius: 50.0,
//              ),
//            )
          ],
        ));
  }
}
