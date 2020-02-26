import 'package:beer_runner_extreme/login.dart';
import 'package:beer_runner_extreme/registration.dart';
import 'package:flutter/material.dart';

void main() => runApp(Belgium());

class Belgium extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
    (
      title: "SUPER BEER RUNNER EXTREME",
      theme: ThemeData
      (
        primaryColor: Colors.green,
      ),
      home: Login(),
      routes: <String, WidgetBuilder>
      {
        '/registration': (BuildContext context) => Registration(),
      }
    );
  }
}