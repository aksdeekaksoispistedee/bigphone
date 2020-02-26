import 'dart:io';
import 'package:flutter/material.dart';

class ViewImage extends StatefulWidget
{
  final File image;

  ViewImage(this.image, {Key key}): super(key: key);

  @override 
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage>
{

  @override 
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      body: SafeArea
      ( 
        child: Form
        (
          child: ListView
          (  
            children: <Widget>
            [
              Image.file(widget.image),
              SizedBox(height: 6.0),
              FlatButton
              (
                child: Text("BACK"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          )
        ),
      )
    );
  }
}