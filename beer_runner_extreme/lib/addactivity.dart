import 'package:beer_runner_extreme/db/activityCategory.dart';
import 'package:beer_runner_extreme/jsonfucker.dart';
import 'package:flutter/material.dart';
import 'package:beer_runner_extreme/db/activity.dart';

class AddActivity extends StatefulWidget
{
  final int userID;
  final List<ActivityCategory> categoryList;
  AddActivity(this.userID, this.categoryList, {Key key}): super(key: key);

  @override
  _AddActivityState createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity>
{
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Activity newActivity = new Activity.whoneedsoverloadinganyway();
  
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
                  Text("GIB DATA FOR NEW ACTIVITY.")
                ],
              ),
              SizedBox(height: 30.0),
              TextFormField
              (
                decoration: InputDecoration
                (
                  labelText: "Date of activity as YYYY-MM-DD.",
                  filled: true
                ),
                validator: (String value) => value.isEmpty || value.length != 10 ? 'Required.' : null,
                onSaved: (String value) {newActivity.activityDate = value;},
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
                    newActivity.categoryID = selectedCategory.categoryID;
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
              DropdownButton<String>
              (
                hint: Text("Select an icon."),
                value: selectedIcon,
                onChanged: (String icon) 
                {
                  setState(() 
                  {
                    selectedIcon = icon;
                    newActivity.activityLogo = selectedIcon;
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
                validator: (String value) => value.isEmpty ? 'Give a number.' : null,
                onSaved: (String value) {newActivity.activityMeasurement = int.parse(value);},
              ),
              SizedBox(height: 6.0),
              TextFormField
              (
                decoration: InputDecoration
                (
                  labelText: "Comment.",
                  filled: true
                ),
                validator: (String value) => value.isEmpty ? 'Required.' : null,
                onSaved: (String value) {newActivity.activityComment = value;},
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
                  RaisedButton
                  ( 
                    child: Text("SAVE"),
                    onPressed: ()
                    {
                      _addActivity();
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

  void _addActivity() async
  {
    if(!_formKey.currentState.validate())
    {
      showMessage("Please fill the fields.", Colors.red);
    }
    else
    {
      _formKey.currentState.save();
      Jsonfucker jsonfucker = new Jsonfucker();
      bool result = await jsonfucker.addActivity(widget.userID, newActivity);
      if (result)
        showMessage("Activity record added.", Colors.green);
      else 
        showMessage("Error when adding activity record.", Colors.red);
    }
  }

  void showMessage(String message, MaterialColor color)
  {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
  }
}
