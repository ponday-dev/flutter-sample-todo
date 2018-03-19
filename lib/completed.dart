import 'dart:async';
import 'package:flutter/material.dart';
import 'todo.dart';
import 'page.dart';

class CompletedList extends StatefulWidget {

  final Function onTapDrawerMenu;

  CompletedList({ this.onTapDrawerMenu });

  @override
  createState() => new CompletedListState();

}

class CompletedListState extends State<CompletedList> {

  List<Todo> items = [];

  @override
  void initState() {
    super.initState();
    _getTodoList();
  }

  @override
  Widget build(BuildContext context) {

    return new AppPage(
      title: '完了済のタスク',
      onTapDrawerMenu: (page) => widget.onTapDrawerMenu(page),
      body: new Center(
          child: new ListView(
              children: _buildRows(items))
      ),
    );

  }


  List<Widget> _buildRows(List<Todo> list) {
    return ListTile
        .divideTiles(
        context: context,
        tiles: list.map((todo) => _buildRow(todo))
    ).toList();
  }

  Widget _buildRow(Todo todo) {
    return new ListTile(
      title: new Text(todo.title),
      trailing: new IconButton(
          icon: new Icon(
            Icons.check_circle,
            color: Colors.blue,
          ),
          onPressed: () {
            return showDialog(
              context: context,
              barrierDismissible: false,
              child: new AlertDialog(
                title: new Text('未完了に変更'),
                content: new Text('このタスクを未完了に変更しますか？'),
                actions: <Widget>[
                  new FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: new Text('cancel')
                  ),
                  new RaisedButton(
                    onPressed: () async {
                      final _todo = todo.clone(completed: !todo.completed);

                      final provider = new TodoProvider();
                      await provider.open();
                      await provider.update(_todo);
                      final _items = await provider.select(completed: true);
                      await provider.close();

                      setState(() {
                        items = _items;
                        Navigator.of(context).pop();
                      });
                    },
                    child: new Text('ok'),
                    color: Colors.blue,
                    textColor: Colors.white,
                  ),
                ],
              ),
            );
          }),
    );
  }

  Future<void> _getTodoList() async {
    final provider = new TodoProvider();
    await provider.open();
    final _items = await provider.select(completed: true);
    setState(() {
      items = _items;
    });
    await provider.close();
  }
}
