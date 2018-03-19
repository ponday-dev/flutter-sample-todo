import 'package:flutter/material.dart';
import 'pages.dart';

class AppDrawer extends StatelessWidget {

  final Function onTap;

  AppDrawer({
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
          children: [
            new ListTile(
              leading: new Icon(Icons.list),
              title: new Text('未完了のタスク'),
              onTap: () {
                this.onTap(Pages.HOME);
                Navigator.pop(context);
              },
            ),
            new ListTile(
              leading: new Icon(Icons.check),
              title: new Text('完了したタスク'),
              onTap: () {
                this.onTap(Pages.COMPLETED);
                Navigator.pop(context);
              },
            )
          ]),
    );
  }

}