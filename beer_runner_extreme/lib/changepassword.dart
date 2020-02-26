import 'package:flutter/material.dart';
import 'package:beer_runner_extreme/db/password.dart';
import 'package:beer_runner_extreme/jsonfucker.dart';

class ChangePassword extends StatefulWidget
{
  final int userID;

  ChangePassword(this.userID, {Key key}): super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword>
{
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Password password = new Password();

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
                  Text("Fill fields to change password.")
                ],
              ),
              SizedBox(height: 30.0),
              TextFormField
              (
                decoration: InputDecoration
                (
                  labelText: "Current password.",
                  filled: true
                ),
                obscureText: true,
                validator: (String value) => value.isEmpty ? 'Required.' : null,
                onSaved: (String value) {password.oldPassword = value;},
              ),
              SizedBox(height: 6.0),
              TextFormField
              (
                decoration: InputDecoration
                (
                  labelText: "New password",
                  filled: true
                ),
                obscureText: true,
                validator: (String value) => value.isEmpty ? 'Required.' : null,
                onSaved: (String value) {password.newPassword = value;},
              ),
              SizedBox(height: 6.0),
              TextFormField
              (
                decoration: InputDecoration
                (
                  labelText: "Repeat new password",
                  filled: true
                ),
                obscureText: true,
                validator: (String value) => value.isEmpty ? 'Required.' : null,
                onSaved: (String value) {password.repetition = value;},
              ),
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
                    child: Text("CHANGE PASSWORD"),
                    onPressed: ()
                    {
                      _changePassword();
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
  void _changePassword() async
  {
    if(!_formKey.currentState.validate())
    {
      showMessage("Error. Please check the passwords.", Colors.red);
    }
    else
    {
      _formKey.currentState.save();
      if(password.newPassword.compareTo(password.repetition) == 0)
      {
        Jsonfucker jsonfucker = new Jsonfucker();
        password.userID = widget.userID;
        bool verifyPassword = await jsonfucker.verifyPassword(password);
        if(verifyPassword)
        {
          bool changePassword = await jsonfucker.changePassword(password);
          if(changePassword) showMessage("Password changed.", Colors.green);
          else showMessage("Server was confused, try again.", Colors.red);
        }
        else
        {
          showMessage(">:(", Colors.purple);
        }   
      }
      else
      {
        showMessage("New passwords must match.", Colors.red);
      }   
    }
  }

  void showMessage(String message, MaterialColor color)
  {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
  }
}