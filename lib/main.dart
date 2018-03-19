import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(new App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Todo App',
      theme: new ThemeData(
          primaryColor: Colors.green
      ),
      home: new Home()
    );
  }
}
