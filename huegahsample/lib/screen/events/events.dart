import 'package:flutter/material.dart';
import 'package:huegahsample/screen/events/event1.dart';
import 'package:huegahsample/screen/events/event2.dart';
import 'package:huegahsample/screen/events/event3.dart';
import 'package:huegahsample/screen/events/event4.dart';
import 'package:huegahsample/screen/events/event5.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> with SingleTickerProviderStateMixin {
  static const _tabCount = 5;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: Text('Events'),
        centerTitle: true,
        backgroundColor: Colors.green,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            for (var i = 1; i <= _tabCount; i++)
              Tab(
                child: Text('Event $i'),
              ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          /*
          for (var i = 1; i <= _tabCount; i++)
            Column(children: [
              Text('Event $i'),
            ]),
            */
          //Tab 1
          Event1(),
          //Tab 2
          Event2(),

          //Tab 3
          Event3(),
          //Tab 4
          Event4(),
          //Tab 5
          Event5(),
        ],
      ),
    );
  }
}
