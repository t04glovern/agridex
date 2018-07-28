import 'package:agridex/models/sheep.dart';
import 'package:flutter/material.dart';

class SheepDetail extends StatelessWidget {
  final Sheep sheep;

  SheepDetail(this.sheep);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var fieldCaption = textTheme.title.copyWith(color: Colors.white);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 10.0),
                child: Text('EID', style: fieldCaption),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.elliptical(50.0, 100.0)),
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
                  child: Text(
                    this.sheep.eid,
                    style: textTheme.body1
                        .copyWith(color: Colors.black, fontSize: 30.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

//    return new Center(
//      child: new Text(
//        "EID: " +
//            sheep.eid +
//            "\nBirth: " +
//            sheep.birth.toString() +
//            "\nGender: " +
//            sheep.sex,
//        textAlign: TextAlign.center,
//        style: textTheme.subhead.copyWith(color: Colors.white),
//      ),
//    );
  }
}

class SheepPedigree extends StatelessWidget {
  final Sheep sheep;

  SheepPedigree(this.sheep);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return new Center(
      child: new Text(
        "EID: " +
            sheep.eid +
            "\nBirth: " +
            sheep.birth.toString() +
            "\nGender: " +
            sheep.sex,
        textAlign: TextAlign.center,
        style: textTheme.subhead.copyWith(color: Colors.white),
      ),
    );
  }
}

class SheepShowcase extends StatefulWidget {
  final Sheep sheep;

  SheepShowcase(this.sheep);

  @override
  _SheepShowcaseState createState() => new _SheepShowcaseState();
}

class _SheepShowcaseState extends State<SheepShowcase>
    with TickerProviderStateMixin {
  List<Tab> _tabs;
  List<Widget> _pages;
  TabController _controller;

  @override
  initState() {
    super.initState();
    _tabs = [
      new Tab(text: 'Details'),
      new Tab(text: 'Pedigree'),
    ];
    _pages = [
      new SheepDetail(widget.sheep),
      new SheepPedigree(widget.sheep),
    ];
    _controller = new TabController(
      length: _tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new Column(
        children: [
          new TabBar(
            labelStyle: Theme.of(context).textTheme.title,
            controller: _controller,
            tabs: _tabs,
            indicatorColor: Colors.white,
          ),
          new SizedBox.fromSize(
            size: const Size.fromHeight(300.0),
            child: new TabBarView(
              controller: _controller,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}
