import 'dart:io';
import 'package:beer_runner_extreme/db/activityCategory.dart';
import 'package:beer_runner_extreme/editactivity.dart';
import 'package:beer_runner_extreme/jsonfucker.dart';
import 'package:beer_runner_extreme/db/activity.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'db/user.dart';

class ActivityList extends StatefulWidget
{
  final User user;
  final List<ActivityCategory> categoryList;
  ActivityList(this.user, this.categoryList, {Key key}): super(key: key);

  @override 
  _ActivityListState createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList>
{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  File _image;
  
  @override
  Widget build(BuildContext context)
  {
    FutureBuilder futureBuilder = new FutureBuilder
    (
      future: _buildRows(),
      builder: (BuildContext context, AsyncSnapshot snapshot)
      {
        switch(snapshot.connectionState)
        {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text("Loading data...");
          default:
            if(snapshot.hasError)
              return new Text(snapshot.error.toString());
            else
              return createListView(context, snapshot);
        }
      }
    );

    return Scaffold
    (
      body: futureBuilder
    );
  } 

  Widget createListView(BuildContext context, AsyncSnapshot snapshot)
  {
    List<Activity> activityList = snapshot.data;
    return ListView.builder
    (
      itemCount: activityList.length,
      itemBuilder: (BuildContext context, int index)
      {
        return Column
        (
          children: <Widget>
          [
            Card
            (
              child: ListTile
              (
                leading: Icon(_parseIcon(activityList[index].activityLogo), color: Colors.lightGreen),
                title: Text(activityList[index].getCategoryString(activityList[index].categoryID)),
                subtitle: Text("on " + activityList[index].activityDate.substring(0,10) + " for " + activityList[index].activityMeasurement.toString() + " units"),
                trailing: IconButton
                  (
                    icon: Icon(Icons.image, color: Colors.blue),
                    onPressed: () => _uploadImage(activityList[index].activityID),
                  ),
                onTap: () => showActivity(activityList[index]),
              ),
            ),
          ],
        );
      },
    );
  }

  void showActivity(Activity activity)
  {
    Navigator.push(context, new MaterialPageRoute(builder: (_) => new EditActivity(widget.user.userID, widget.categoryList, activity)));
  }

  void showMessage(String message, MaterialColor color)
  {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  Future<List<Activity>> _buildRows() async
  {
    Jsonfucker jsonfucker = new Jsonfucker();
    List<Activity> activityList = await jsonfucker.getActivities(widget.user.userID);
    return activityList;
  }

  IconData _parseIcon(String activityLogo)
  {
    if(activityLogo.compareTo("Beach") == 0) return Icons.beach_access;
    else if (activityLogo.compareTo("Shuffle") == 0) return Icons.shuffle;
    else if (activityLogo.compareTo("Warning") == 0) return Icons.warning;
    else return Icons.train;
  }

  void _uploadImage(int activityID) async
  {
    File image = await ImagePicker.pickImage
    (
      source: ImageSource.gallery
    );

    setState(() {
      _image = image;
    });

    Jsonfucker jsonfucker = new Jsonfucker();
    await jsonfucker.uploadImage(activityID, _image);
  }
}