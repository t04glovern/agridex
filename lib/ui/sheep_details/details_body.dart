import 'package:agridex/models/sheep.dart';
import 'package:flutter/material.dart';

class SheepDetailBody extends StatelessWidget {
  final Sheep sheep;

  SheepDetailBody(this.sheep);

  _createCircleBadge(IconData iconData, Color color) {
    return new Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: new CircleAvatar(
        backgroundColor: color,
        child: new Icon(
          iconData,
          color: Colors.white,
          size: 16.0,
        ),
        radius: 16.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    var tagInfo = new Row(
      children: [
        new Icon(
          Icons.format_indent_decrease,
          color: Colors.white,
          size: 16.0,
        ),
        new Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: new Text(
            "RFID Tag will go here",
            style: textTheme.subhead.copyWith(color: Colors.white),
          ),
        ),
      ],
    );

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: tagInfo,
        )
      ],
    );
  }
}
