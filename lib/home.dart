import 'package:flutter/material.dart';
import 'todolist.dart';
import 'completed.dart';
import 'pages.dart';

class Home extends StatefulWidget {

  @override
  createState() => new HomeState();

}

class HomeState extends State<Home> {

  Pages current = Pages.HOME;

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch(current) {
      case Pages.HOME:
        page = new TodoList(onTapDrawerMenu: _setCurrentPage);
        break;
      case Pages.COMPLETED:
        page = new CompletedList(onTapDrawerMenu: _setCurrentPage);
        break;
    }

    return page;
  }

  void _setCurrentPage(Pages page) {
    setState(() {
      this.current = page;
    });
  }
}
