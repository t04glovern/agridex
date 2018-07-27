import 'package:agridex/models/sheep.dart';
import 'package:agridex/ui/sheep_details/footer/showcase_details.dart';
import 'package:flutter/material.dart';

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
    ];
    _pages = [
      new DetailsShowcase(widget.sheep),
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
