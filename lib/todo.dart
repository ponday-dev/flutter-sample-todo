import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final String todoTable = 'todo';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnCompleted = 'completed';

class Todo {

  int id;
  String title;
  bool completed;

  Todo(this.title,
      {
        this.id,
        this.completed = false
      }) {}

  Todo.fromMap(Map map) {
    title = map[columnTitle];
    id = map[columnId];
    completed = map[columnCompleted] == 1;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnTitle: title,
      columnCompleted: completed ? 1 : 0
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Todo clone({
    String title,
    int id,
    bool completed
  }) {
    final _title = (title != null) ? title : this.title;
    final _id = (id != null) ? id : this.id;
    final _completed = (completed != null) ? completed : this.completed;
    return new Todo(
        _title,
        id: _id,
        completed: _completed
    );
  }

}

class TodoProvider {

  Database db;

  Future open() async {
    String path = await initDatabase();

    db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
          create table $todoTable(
            $columnId integer primary key autoincrement,
            $columnTitle text not null,
            $columnCompleted integet not null
          )
          ''');
        });
  }

  Future<String> initDatabase() async {
    Directory appDir = await getApplicationDocumentsDirectory();

    String path = join(appDir.path, todoTable);
    if (!await new Directory(dirname(path)).exists()) {
      await new Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future close() async => db.close();

  Future<Todo> insert(Todo todo) async {
    todo.id = await db.insert(todoTable, todo.toMap());
    return todo;
  }

  Future<List<Todo>> select({
    int id,
    bool completed
  }) async {
    List<Map> maps = [];
    if (id != null) {
      maps = await _selectById(id);
    } else if (completed != null) {
      maps = await _selectByCompleted(completed);
    } else {
      maps = await db.query(
          todoTable,
          columns: [columnId, columnTitle, columnCompleted]);
    }

    return maps.map((map) => new Todo.fromMap(map)).toList();
  }

  Future<List<Map>> _selectById(int id) async {
    return await db.query(
        todoTable,
        columns: [columnId, columnTitle, columnCompleted],
        where: '$columnId=?',
        whereArgs: [id]
    );
  }

  Future<List<Map>> _selectByCompleted(bool completed) async {
    return await db.query(
        todoTable,
        columns: [columnId, columnTitle, columnCompleted],
        where: '$columnCompleted=?',
        whereArgs: [ completed ? 1 : 0]
    );
  }

  Future<Todo> update(Todo todo) async {
    await db.update(
        todoTable,
        todo.toMap(),
        where: '$columnId=?',
        whereArgs: [todo.id]
    );
    return todo;
  }

}