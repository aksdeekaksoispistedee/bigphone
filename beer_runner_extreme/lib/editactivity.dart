import 'dart:io';
import 'package:beer_runner_extreme/db/activity.dart';
import 'package:beer_runner_extreme/viewimage.dart';
import 'package:flutter/material.dart';
import 'package:beer_runner_extreme/db/activityCategory.dart';
import 'package:beer_runner_extreme/jsonfucker.dart';
import 'package:simple_permissions/simple_permissions.dart';

class EditActivity extends StatefulWidget
{
  final int userID;
  final Activity activity;
  final List<ActivityCategory> categoryList;
  EditActivity(this.userID, this.categoryList, this.activity, {Key key}): super(key: key);

  @override
  _EditActivityState createState() => _EditActivityState();
}

class _EditActivityState extends State<EditActivity>
{
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Activity editedActivity = new Activity.whoneedsoverloadinganyway();
  
  ActivityCategory selectedCategory;
  String selectedIcon;

  @override 
  Widget build(BuildContext context)
  {
    return Scaffold
    (  
      key: _scaffoldKey,
      body: SafeArea
      (
        child: Form
        ( 
          key: _formKey,
          child: ListView
          (  
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            children: <Widget>
            [
              SizedBox(height: 30.0),
              Column
              (                
                children: <Widget>
                [
                  Text("EDIT THE ACTIVITY IF YA WANNA.")
                ],
              ),
              SizedBox(height: 18.0),
              TextFormField
              (
                decoration: InputDecoration
                (
                  labelText: "Date of activity as YYYY-MM-DD.",
                  filled: true
                ),
                initialValue: widget.activity.activityDate.substring(0,10),
                validator: (String value) => value.isEmpty || value.length != 10 ? 'Required.' : null,
                onSaved: (String value) {editedActivity.activityDate = value;},
              ),
              SizedBox(height: 6.0),
              DropdownButton<ActivityCategory>
              ( 
                hint: Text("Select a category"),
                value: selectedCategory,
                onChanged: (ActivityCategory category)
                {
                  setState(() 
                  {
                    selectedCategory = category;
                    editedActivity.categoryID = selectedCategory.categoryID;
                  });
                },
                items: widget.categoryList.map((ActivityCategory category)
                {
                  return DropdownMenuItem<ActivityCategory>
                  ( 
                    value: category,
                    child: Row
                    (  
                      children: <Widget>
                      [
                        SizedBox(width: 10,),
                        Text(category.categoryID.toString() + " - "),
                        Text(category.categoryName),
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 6.0),
              DropdownButton<String>
              (
                hint: Text("Select an icon."),
                value: selectedIcon,
                onChanged: (String icon) 
                {
                  setState(() 
                  {
                    selectedIcon = icon;
                    editedActivity.activityLogo = selectedIcon;
                  });
                },
                items: <String>['Beach', 'Shuffle', 'Warning'].map<DropdownMenuItem<String>>((String icon) 
                  {
                    return DropdownMenuItem<String>
                    (
                      value: icon,
                      child: Text(icon),
                    );
                  }).toList(),
              ),
              SizedBox(height: 6.0),
              TextFormField
              (
                decoration: InputDecoration
                (
                  labelText: "Measure the activity, number.",
                  filled: true
                ),
                initialValue: widget.activity.activityMeasurement.toString(),
                validator: (String value) => value.isEmpty ? 'Give a number.' : null,
                onSaved: (String value) {editedActivity.activityMeasurement = int.parse(value);},
              ),
              SizedBox(height: 6.0),
              TextFormField
              (
                decoration: InputDecoration
                (
                  labelText: "Comment.",
                  filled: true
                ),
                initialValue: widget.activity.activityComment,
                validator: (String value) => value.isEmpty ? 'Required.' : null,
                onSaved: (String value) {editedActivity.activityComment = value;},
              ),
              SizedBox(height: 6.0),
              ButtonBar
              (  
                children: <Widget>
                [
                  FlatButton
                  ( 
                    child: Text("BACK"),
                    onPressed: ()
                    {
                      Navigator.pop(context);
                    }, 
                  ),
                  SizedBox(height: 6.0),
                  RaisedButton
                  ( 
                    child: Text("IMAGE"),
                    onPressed: () => _downloadImage(widget.activity.activityID)
                  ),
                  SizedBox(height: 6.0),
                  RaisedButton
                  ( 
                    child: Text("DELETE"),
                    onPressed: ()
                    {
                      AlertDialog alertDialog = AlertDialog
                      (
                        title: Text("WARNING"),
                        content: Text("Are you sure you want to delete this activity?"),
                        actions: <Widget>
                        [
                          FlatButton
                          ( 
                            child: Text("CANCEL"),
                            onPressed: ()
                            {
                              Navigator.of(context).pop();
                            }
                          ),
                          SizedBox(height: 6.0),
                          RaisedButton
                          ( 
                            child: Text("DELETE"),
                            onPressed: () 
                            {
                              _deleteActivity();
                              Navigator.of(context).pop();
                            }
                          )
                        ],
                      );
                      showDialog(context: context, builder: (BuildContext context) {return alertDialog;});
                    },
                  ),
                  SizedBox(height: 6.0),
                  RaisedButton
                  ( 
                    child: Text("SAVE"),
                    onPressed: ()
                    {
                      _editActivity();
                    },
                  )
                ],
              )
            ],
          )
        )
      )
    );
  }

  void _deleteActivity() async
  {
    Jsonfucker jsonfucker = new Jsonfucker();
    bool result = await jsonfucker.deleteActivity(widget.activity.activityID);
    if (result)
      showMessage("Activity record deleted.", Colors.green);
    else 
      showMessage("Error when deleting activity record.", Colors.red);
  }

  void _editActivity() async
  {
    if(!_formKey.currentState.validate())
    {
      showMessage("Please fill the fields.", Colors.red);
    }
    else
    {
      _formKey.currentState.save();
      Jsonfucker jsonfucker = new Jsonfucker();
      editedActivity.userID = widget.userID;
      bool result = await jsonfucker.editActivity(widget.activity.activityID, editedActivity);
      if (result)
        showMessage("Activity record edited.", Colors.green);
      else 
        showMessage("Error when editing activity record.", Colors.red);
    }
  }

  void _downloadImage(int activityID) async
  {
    Jsonfucker jsonfucker = new Jsonfucker();
    List<int> image = await jsonfucker.downloadImage(activityID);
    if(image == null)
      showMessage("This activity does not have an picture to it.", Colors.red);
    else
    {
      PermissionStatus permissionResult = await SimplePermissions.requestPermission(Permission. WriteExternalStorage);
      final path = "/storage/self/primary/beer";
      final file = File('$path/$activityID.png');
      await file.writeAsBytes(image);
      Navigator.push(context, new MaterialPageRoute(builder: (_) => new ViewImage(file)));
    } 
  }

  void showMessage(String message, MaterialColor color)
  {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
  }
}