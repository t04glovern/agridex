import 'package:agridex/models/sheep.dart';
import 'package:flutter/material.dart';

class SheepDetail extends StatelessWidget {
  final Sheep sheep;
  TextStyle fieldCaptionStyle;
  TextStyle fieldTextStyle;

  SheepDetail(this.sheep);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    this.fieldCaptionStyle = textTheme.title.copyWith(color: Colors.white);
    this.fieldTextStyle =
        textTheme.body1.copyWith(color: Colors.black, fontSize: 25.0);

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      buildField('EID', this.sheep.eid),
      buildField(
          'Birth',
          this.sheep.birth.toString() +
              ' / ' +
              (this.sheep.sex == 'M' ? '♂ Male' : '♀ Female')),
      buildField('Visual Num.', this.sheep.visualNum.toString()),
      buildField('Visual Id.', this.sheep.visualId.toString()),
      buildField('Conditions', this.sheep.conditions.toString()),
      buildField('Weights', this.sheep.weights.toString()),
      buildField('Fleece', this.sheep.fleece.toString()),
      buildField('Pregnancies', this.sheep.pregnancies.toString()),
      Padding(
        padding: const EdgeInsets.fromLTRB(60.0, 20.0, 60.0, 20.0),
        child: RaisedButton(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('More Details', style: this.fieldTextStyle),
          ),
          onPressed: () {},
        ),
      )
    ]);
  }

  Padding buildField(String caption, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 5.0),
            child: Text(caption, style: this.fieldCaptionStyle),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.elliptical(50.0, 100.0)),
              gradient: LinearGradient(
                begin: FractionalOffset.centerRight,
                end: FractionalOffset.bottomLeft,
                colors: [
                  Colors.white,
                  Colors.white,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
              child: Text(
                text,
                style: this.fieldTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
