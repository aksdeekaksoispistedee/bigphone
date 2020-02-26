import 'package:beer_runner_extreme/beerrunner.dart';
import 'package:beer_runner_extreme/db/activityCategory.dart';
import 'package:beer_runner_extreme/jsonfucker.dart';
import 'package:flutter/material.dart';
import 'package:beer_runner_extreme/db/user.dart';

class Login extends StatefulWidget
{
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>
{
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  User logInUser = new User();

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
                  Text("LOGIN")
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
                validator: (String value) => value.isEmpty ? 'Required field.' : null,
                onSaved: (String value) {logInUser.accountName = value;},
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
                validator: (String value) => value.isEmpty ? 'Reguired field.' : null,
                onSaved: (String value) {logInUser.accountPassword = value;},
              ),
              ButtonBar 
              (
                children: <Widget>
                [
                  FlatButton
                  (
                    child: Text("REGISTER"),
                    onPressed: ()
                    {
                      Navigator.pushNamed(context, '/registration');
                    }
                  ),
                  RaisedButton
                  (
                    child: Text("LOGIN"),
                    onPressed: ()
                    {
                      logIn();
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

  void logIn() async
  {   
    if(!_formKey.currentState.validate())
    {
      showMessage('U MUST FILL FORM GRR >:(', Colors.red);
    }
    else
    {
      _formKey.currentState.save();
      Jsonfucker jsonfucker = new Jsonfucker();
      User logIn = await jsonfucker.logInUser(logInUser);
      if(logIn.userID == null)
        showMessage("Incorrect username or password.", Colors.red);
      else
      {
        List<ActivityCategory> categoryList = await jsonfucker.getActivityCategories();
        if(categoryList != null && categoryList.length > 0 && categoryList[0].categoryID != 0)
          Navigator.push(context, new MaterialPageRoute(builder: (_) => new BeerRunner(logIn, categoryList)));
        else
          showMessage("Error when retrieving activity categories.", Colors.red);
      } 
    }
  }

  void showMessage(String message, MaterialColor color)
  {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: color, content: new Text(message)));
  }
}