import 'package:agridex/models/sheep.dart';
import 'package:flutter/material.dart';

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

class SheepDetailBody extends StatelessWidget {
  final Sheep sheep;

  SheepDetailBody(this.sheep);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    var tagColor = this.sheep.postBreeder
        ? TagColor.fromPostBreeder()
        : TagColor.fromYear(this.sheep.birth);

    var yearLastDigit = this
        .sheep
        .birth
        .toString()
        .substring(this.sheep.birth.toString().length - 1);

    var yearLastTwoDigits = this
        .sheep
        .birth
        .toString()
        .substring(this.sheep.birth.toString().length - 2);

    var tagText = yearLastDigit + '.' + this.sheep.tag;
    var rfidTagText = yearLastTwoDigits + '..' + this.sheep.tag;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.elliptical(50.0, 100.0)),
              gradient: LinearGradient(
                begin: FractionalOffset.centerRight,
                end: FractionalOffset.bottomLeft,
                colors: [
                  tagColor.background,
                  tagColor.background,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0),
              child: Text(
                tagText,
                textAlign: TextAlign.end,
                style: textTheme.subhead
                    .copyWith(color: tagColor.foreground, fontSize: 30.0),
              ),
            ),
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
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
              padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text(
                  rfidTagText,
                  textAlign: TextAlign.end,
                  style: textTheme.subhead
                      .copyWith(color: Colors.black, fontSize: 30.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(this.sheep.origin,
                          style: textTheme.subhead
                              .copyWith(color: Colors.black, fontSize: 22.0))),
                )
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
