import 'package:beer_runner_extreme/changepassword.dart';
import 'package:flutter/material.dart';
import 'package:beer_runner_extreme/db/user.dart';
import 'package:beer_runner_extreme/jsonfucker.dart';
import 'package:beer_runner_extreme/addactivity.dart';
import 'package:beer_runner_extreme/db/activityCategory.dart';

class EditInformation extends StatefulWidget
{
  final User user;
  final List<ActivityCategory> categoryList;
  EditInformation(this.user, this.categoryList, {Key key}): super(key: key);

  @override
  _EditInformationState createState() => _EditInformationState();
}

class _EditInformationState extends State<EditInformation>
{
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  User information = new User();
  
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
                  Text("Edit your info if ya wanna.")
                ],
              ),
              SizedBox(height: 30.0),
              TextFormField
              (
                decoration: InputDecoration
                (
                  labelText: "Name",
                  filled: true
                ),
                initialValue: widget.user.usersName,
                validator: (String value) => value.isEmpty ? 'SURELY U HAS NAEM?' : null,
                onSaved: (String value) {information.usersName = value;},
              ),
              SizedBox(height: 6.0),
              TextFormField
              (
                decoration: InputDecoration
                (
                  labelText: "Height",
                  filled: true
                ),
                initialValue: widget.user.userHeight.toString(),
                validator: (String value) => value.isEmpty ? 'TALL CAT IS TALL?' : null,
                onSaved: (String value) {information.userHeight = int.tryParse(value);},
              ),
              SizedBox(height: 6.0),
              TextFormField
              (
                decoration: InputDecoration
                (
                  labelText: "Weight",
                  filled: true
                ),
                initialValue: widget.user.userWeight.toString(),
                validator: (String value) => value.isEmpty ? 'GIB FORCE OF G' : null,
                onSaved: (String value) {information.userWeight = int.tryParse(value);},
              ),
              SizedBox(height: 6.0),
              TextFormField
              (
                decoration: InputDecoration
                (
                  labelText: "DOB AS YYYY-MM-DD",
                  filled: true
                ),
                initialValue: widget.user.userBirth.substring(0,10),
                validator: (String value) => value.isEmpty || value.length != 10 ? 'YYYY-MM-DD IS THE SOLE ACCEPTED FORMAT' : null,
                onSaved: (String value) {information.userBirth = value;},
              ),
              SizedBox(height: 24.0),
              ButtonBar 
              (
                children: <Widget>
                [
                  RaisedButton
                  (
                    child: Text("SAVE INFORMATION"),
                    onPressed: ()
                    {
                      _submitInformation();
                    }
                  ),
                  SizedBox(height: 6.0),
                  FlatButton
                  ( 
                    child: Text("PASSWORD CHANGE"),
                    onPressed: ()
                    {
                      Navigator.push(context, new MaterialPageRoute(builder: (_) => new ChangePassword(widget.user.userID)));
                    },
                  ),
                  FlatButton
                  ( 
                    child: Text("ADD NEW ACTIVITY"),
                    onPressed: ()
                    {
                       Navigator.push(context, new MaterialPageRoute(builder: (_) => new AddActivity(widget.user.userID, widget.categoryList)));
                    },
                  ),
                ],
              )
            ],
          )
        )
      )
    );
  }

  void _submitInformation() async
  {
    if(!_formKey.currentState.validate())
    {
      showMessage("Please fill all fields before saving.", Colors.red);
    }
    else
    {
      _formKey.currentState.save();
      Jsonfucker jsonfucker = new Jsonfucker();
      information.userID = widget.user.userID;
      bool informationChanged = await jsonfucker.editUserInformation(information);
      if(informationChanged) showMessage("Information changed.", Colors.green);
      else showMessage("Server was confused about the input, check data.", Colors.red);
    }
  }

  void showMessage(String message, MaterialColor color)
  {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
  }

}