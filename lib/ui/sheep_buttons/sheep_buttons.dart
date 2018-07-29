import 'package:agridex/models/sheep.dart';
import 'package:flutter/material.dart';
import 'package:agridex/ui/sheep_details/header/cut_colored_image.dart';

class SheepButtons extends StatefulWidget {
  Sheep sheep;

  SheepButtons(this.sheep);

  @override
  State<StatefulWidget> createState() {
    return new SheepButtonsState(this.sheep);
  }
}

class SheepButtonsState extends State<StatefulWidget> {
  Sheep sheep;

  SheepButtonsState(this.sheep);

  static const BACKGROUND_IMAGE = 'images/profile_header_background.png';

  Widget buildFakeButton(TextStyle style, String text, Color color) {
    return RaisedButton(
      padding: EdgeInsets.all(10.0),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(text, style: style),
      ),
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var screenWidth = MediaQuery.of(context).size.width;

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

    var diagonalBackground = new DiagonallyCutColoredImage(
      new Image.asset(
        BACKGROUND_IMAGE,
        width: screenWidth,
        height: 245.0,
        fit: BoxFit.cover,
      ),
      color: const Color(0x8888D897),
    );

    var avatar = new Hero(
      tag: 'XXXXXXX',
      child: new CircleAvatar(
        backgroundImage: new NetworkImage(
            'https://stockhead.com.au/wp-content/uploads/2017/09/Getty-sheep.jpg'),
        radius: 50.0,
      ),
    );

    var deviceInfo = new Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Text(
            _deviceLabel(),
            style: textTheme.subhead
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );

    var tagInfo = new Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 10.0),
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Flexible(
                  child: new Column(children: <Widget>[
                new Text('Visual ID: ' + this.sheep.visualNum.toString(),
                    style: TextStyle(color: Colors.white))
              ]))
            ]));

    var captionTextStyle =
        Theme.of(context).textTheme.body1.copyWith(fontSize: 30.0);

    var buttonGrid = GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(10.0),
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        shrinkWrap: true,
        children: [
          buildFakeButton(captionTextStyle, 'Condition',
              Color.fromARGB(255, 140, 240, 140)),
          buildFakeButton(
              captionTextStyle, 'Fleece', Color.fromARGB(255, 220, 220, 220)),
          buildFakeButton(captionTextStyle, 'Pregnancy',
              Color.fromARGB(255, 230, 140, 140)),
          buildFakeButton(
              captionTextStyle, 'Weight', Color.fromARGB(255, 150, 150, 240)),
        ]);

    return new Scaffold(
        backgroundColor: Colors.green,
        body: new SingleChildScrollView(
          child: new Container(
            decoration: linearGradient,
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Stack(
                    children: [
                      diagonalBackground,
                      new Align(
                        alignment: FractionalOffset.bottomCenter,
                        heightFactor: 1.4,
                        child: new Column(
                          children: [avatar, deviceInfo, tagInfo],
                        ),
                      ),
                      new Positioned(
                        top: 26.0,
                        left: 4.0,
                        child: new BackButton(color: Colors.white),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: buttonGrid,
                  ),
                ]),
          ),
        ));
  }

  _deviceLabel() => "EID : ${this.sheep.eid}";
}
