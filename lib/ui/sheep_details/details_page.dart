import 'package:flutter/material.dart';
import 'package:agridex/ui/sheep_details/footer/details_footer.dart';
import 'package:agridex/ui/sheep_details/details_body.dart';
import 'package:agridex/ui/sheep_details/header/details_header.dart';
import 'package:agridex/models/sheep.dart';
import 'package:meta/meta.dart';

class SheepDetailsPage extends StatefulWidget {
  final Sheep sheep;
  final Object avatarTag;

  SheepDetailsPage(
    this.sheep, {
    @required this.avatarTag,
  });

  @override
  _SheepDetailsPageState createState() => new _SheepDetailsPageState();
}

class _SheepDetailsPageState extends State<SheepDetailsPage> {
  @override
  Widget build(BuildContext context) {
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

    return new Scaffold(
      body: new SingleChildScrollView(
        child: new Container(
          decoration: linearGradient,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new SheepDetailHeader(
                widget.sheep,
                avatarTag: widget.avatarTag,
              ),
              new Padding(
                padding: const EdgeInsets.all(24.0),
                child: new SheepDetailBody(widget.sheep),
              ),
              new SheepShowcase(widget.sheep),
            ],
          ),
        ),
      ),
    );
  }
}
