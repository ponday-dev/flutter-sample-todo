import 'dart:async';
import 'package:flutter/material.dart';
import 'todo.dart';
import 'page.dart';
import 'create-todo.dart';

class TodoList extends StatefulWidget {

  final Function onTapDrawerMenu;

  TodoList({ this.onTapDrawerMenu });

  @override
  createState() => new TodoListState();

}

class TodoListState extends State<TodoList> {

  List<Todo> items = [];

  @override
  void initState() {
    super.initState();
    _getTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return new AppPage(
      title: '未完了のタスク',
      onTapDrawerMenu: (page) => widget.onTapDrawerMenu(page),
      body: new Center(
          child: new ListView(
              children: _buildRows(items))
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.add),
          backgroundColor: Colors.green,
          onPressed: () async {
            await Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
              return new CreateTodo();
            }));
            _getTodoList();
          }
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
            Icons.check_circle_outline,
            color: null,
          ),
          onPressed: () {
            return showDialog(
              context: context,
              barrierDismissible: false,
              child: new AlertDialog(
                title: new Text('完了済に変更'),
                content: new Text('このタスクを完了済に変更しますか?'),
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
                      final _items = await provider.select(completed: false);
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
    final _items = await provider.select(completed: false);
    setState(() {
      items = _items;
    });
    await provider.close();
  }
}
