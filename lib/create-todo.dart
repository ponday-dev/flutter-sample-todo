import 'package:flutter/material.dart';
import 'todo.dart';

class CreateTodo extends StatefulWidget {

  @override
  createState() => new CreateTodoState();

}

class CreateTodoState extends State<CreateTodo> {

  String value;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Add new Todo.'),
        actions: <Widget>[
          new FlatButton(
              child: new Text('保存'),
              textColor: Colors.white,
              onPressed: () async {
                final provider = new TodoProvider();
                await provider.open();
                await provider.insert(new Todo(this.value));
                await provider.close();
                Navigator.pop(context);
              })
        ],
      ),
      body: new Container(
          padding: new EdgeInsets.all(16.0),
          child: new Column(
              children: [
                new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(
                      hintText: 'Input Todo'
                  ),
                  onChanged: (value) {
                    this.value = value;
                  },
                )
              ]
          )
      ),
    );
  }

}