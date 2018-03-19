import 'package:flutter/material.dart';
import 'drawer.dart';

class AppPage extends StatelessWidget {

  final String title;
  final Function onTapDrawerMenu;
  final Widget body;
  final Widget floatingActionButton;

  AppPage({
    this.title: '',
    this.onTapDrawerMenu: null,
    this.body: null,
    this.floatingActionButton: null
  });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(title)),
      drawer: new AppDrawer(
        onTap: (page) {
          if (onTapDrawerMenu != null) {
            onTapDrawerMenu(page);
          }
        },
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }

}