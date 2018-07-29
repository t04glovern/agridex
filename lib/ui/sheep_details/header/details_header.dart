import 'dart:async';

import 'package:agridex/models/sheep.dart';
import 'package:agridex/services/api.dart';
import 'package:agridex/ui/sheep_details/header/cut_colored_image.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class SheepDetailHeader extends StatefulWidget {
  final Sheep sheep;
  final Object avatarTag;

  SheepDetailHeader(
    this.sheep, {
    @required this.avatarTag,
  });

  @override
  _SheepDetailHeaderState createState() => new _SheepDetailHeaderState();
}

class _SheepDetailHeaderState extends State<SheepDetailHeader> {
  static const BACKGROUND_IMAGE = 'images/profile_header_background.png';

  bool _likeDisabled = true;
  String _likeText = "";
  int _likeCounter = 0;
  StreamSubscription _watcher;

  Future<SheepApi> _api;

  @override
  void initState() {
    super.initState();

    // TODO: Pull out.
    _api = SheepApi.signInWithGoogle();
  }

  @override
  void dispose() {
    if (_watcher != null) {
      _watcher.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var screenWidth = MediaQuery.of(context).size.width;

    var diagonalBackground = new DiagonallyCutColoredImage(
      new Image.asset(
        BACKGROUND_IMAGE,
        width: screenWidth,
        height: 180.0,
        fit: BoxFit.cover,
      ),
      color: const Color(0x5588D897),
    );

    var avatar = new Hero(
      tag: widget.avatarTag,
      child: new CircleAvatar(
        backgroundImage: new NetworkImage(widget.sheep.avatarUrl),
        radius: 50.0,
      ),
    );

    return new Stack(
      children: [
        diagonalBackground,
        new Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 1.4,
          child: new Column(
            children: [
              avatar
            ],
          ),
        ),
        new Positioned(
          top: 26.0,
          left: 4.0,
          child: new BackButton(color: Colors.white),
        ),
      ],
    );
  }
}
