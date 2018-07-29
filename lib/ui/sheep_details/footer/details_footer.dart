import 'package:agridex/models/sheep.dart';
import 'package:agridex/ui/sheep_buttons/sheep_buttons.dart';
import 'package:agridex/utils/routes.dart';
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
      buildField('Conditions', this.extractConditions()),
      buildField('Weights', this.extractWeights()),
      buildField('Fleece', this.extractFleeces()),
      buildField('Pregnancies', this.extractPregnancies()),
      Padding(
        padding: const EdgeInsets.fromLTRB(60.0, 20.0, 60.0, 20.0),
        child: RaisedButton(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('View Pedigree', style: this.fieldTextStyle),
          ),
          onPressed: () {
            Navigator.of(context).push(new FadePageRoute(
                builder: (c) {
                  return new SheepButtons(this.sheep);
                },
                settings: new RouteSettings()));
          },
        ),
      )
    ]);
  }

  String formatDate(DateTime date) {
    return date.day.toString().padLeft(2, '0') +
        '-' +
        date.month.toString().padLeft(2, '0') +
        '-' +
        date.year.toString();
  }

  String monthByNumber(int month) {
    return [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ][month - 1];
  }

  String extractConditions() {
    var text = '';

    for (var condition in this.sheep.conditions) {
      text += this.formatDate(DateTime.parse(condition['date']));
      text += '    |    ';
      text += condition['score'].toString();
      text += '\n';
    }

    return text.trimRight();
  }

  String extractWeights() {
    var text = '';

    for (var condition in this.sheep.weights) {
      text += this.formatDate(DateTime.parse(condition['date']));
      text += '    |    ';
      text += condition['weight'].toStringAsFixed(1).padLeft(2) + ' kg';
      text += '\n';
    }

    return text.trimRight();
  }

  String extractFleeces() {
    var text = '';

    for (var condition in this.sheep.fleece) {
      text += this.formatDate(DateTime.parse(condition['date']));
      text += '    |    ';
      text += condition['gfw'].toString();
      text += ' / ';
      text += condition['micron'].toString();
      text += '\n';
    }

    return text.trimRight();
  }

  String extractPregnancies() {
    var text = '';

    for (var condition in this.sheep.pregnancies) {
      var date = DateTime.parse(condition['dateGroup']);

      text += condition['num'].toString();
      text += '    |    ';
      text += this.monthByNumber(date.month) + ', ' + date.year.toString();
      text += '\n';
    }

    return text.trimRight();
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
