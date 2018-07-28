import 'package:agridex/models/sheep.dart';
import 'package:flutter/material.dart';

class DetailsShowcase extends StatelessWidget {
  final Sheep sheep;

  DetailsShowcase(this.sheep);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return new Center(
      child: new Text(
        "EID: " + sheep.eid + "\nBirth: " + sheep.birth.toString() + "\nGender: " + sheep.sex,
        textAlign: TextAlign.center,
        style: textTheme.subhead.copyWith(color: Colors.white),
      ),
    );
  }
}
