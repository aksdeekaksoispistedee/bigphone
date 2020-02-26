import 'package:beer_runner_extreme/db/activityCategory.dart';
import 'package:beer_runner_extreme/editinformation.dart';
import 'package:beer_runner_extreme/activitylist.dart';
import 'package:beer_runner_extreme/infopage.dart';
import 'package:flutter/material.dart';
import 'db/user.dart';

class BeerRunner extends StatefulWidget
{
  final User user;
  final List<ActivityCategory> categoryList;
  BeerRunner(this.user, this.categoryList, {Key key}): super(key: key);

  @override
  _BeerRunnerState createState() => _BeerRunnerState();
}

class _BeerRunnerState extends State<BeerRunner>
{
  @override 
  Widget build(BuildContext context)
  {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    return DefaultTabController
    ( 
      length: 3,
      child: Scaffold
      (
        key: _scaffoldKey, 
        appBar: AppBar
        (  
          title: Text("BEER RUNNER EXTREME"),
          actions: <Widget>
          [
            IconButton
            ( 
              icon: Icon(Icons.beach_access),
              color: Colors.teal,
              onPressed: () {},
            )
          ],
          bottom: TabBar
          (  
            tabs: <Widget>
            [
              Text('Beer runs'),
              Text('User info'),
              Text('App info'),
            ],
          ),
        ),
        body: TabBarView
        (
          children: <Widget>
          [
            ActivityList(widget.user, widget.categoryList),
            EditInformation(widget.user, widget.categoryList),
            InfoPage(),
          ],
        ),
      ),
    );
  }
}