import 'package:beer_runner_extreme/jsonfucker.dart';
import 'package:flutter/material.dart';
import 'package:beer_runner_extreme/db/user.dart';

class Registration extends StatefulWidget
{
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration>
{
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  User newUser = new User();

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
              SizedBox(height: 80.0),
              Column 
              (
                children: <Widget>
                [
                  SizedBox(height: 20.0),
                  Text("REGISTRATION")
                ],
              ),
              SizedBox(height: 120.0),
              TextFormField
              (

                decoration: InputDecoration
                (
                  labelText: "Username",
                  filled: true
                ),
                validator: (String value) => value.isEmpty ? 'GIB NAEM' : null,
                onSaved: (String value) {newUser.accountName = value;},
              ),
              SizedBox(height: 12.0),
              TextFormField
              (
                decoration: InputDecoration
                (
                  labelText: "Password",
                  filled: true
                ),
                obscureText: true,
                validator: (String value) => value.isEmpty ? 'GIB SEKRIT WURD' : null,
                onSaved: (String value) {newUser.accountPassword = value;},
              ),
              SizedBox(height: 12.0),
              TextFormField
              (
                decoration: InputDecoration
                (
                  labelText: "Name",
                  filled: true
                ),
                validator: (String value) => value.isEmpty ? 'BIGGUS DICKUS? >:)' : null,
                onSaved: (String value) {newUser.usersName = value;},
              ),
              SizedBox(height: 12.0),
              TextFormField
              (
                decoration: InputDecoration
                (
                  labelText: "Cool random information",
                  filled: true
                ),
                validator: (String value) => value.isEmpty ? 'TELL ME SMTHING NICE :D' : null,
                onSaved: (String value) {newUser.userInformation = value;},
              ),
              ButtonBar 
              (
                children: <Widget>
                [
                  FlatButton
                  (
                    child: Text("CANCEL"),
                    onPressed: ()
                    {
                      Navigator.pop(context);
                    }
                  ),
                  RaisedButton
                  (
                    child: Text("REGISTER"),
                    onPressed: ()
                    {
                        _submitRegistration();
                    }
                  )
                ],
              )
            ],
          )
        )
      )
    );
  }

  void _submitRegistration() async
  {
    if(!_formKey.currentState.validate())
    {
      showMessage('U MUST FILL FORM GRR >:(', Colors.red);
    }
    else
    {
      _formKey.currentState.save();
      Jsonfucker jsonfucker = new Jsonfucker();
      int result = await jsonfucker.createUser(newUser);
      if(result == 0) showMessage("Account " + newUser.accountName + " created.", Colors.green);
      else if(result == 2) showMessage("Username unavailable.", Colors.red);
      else showMessage("Account creation failed.", Colors.red);
    }
  }

  void showMessage(String message, MaterialColor color)
  {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
  }
}

