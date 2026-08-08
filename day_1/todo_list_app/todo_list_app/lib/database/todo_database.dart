import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list_app/model/todo.dart';

class TodoDatabase {

  // version harus diupdate jika ada perubahan struktur table
  Future<Database> get database async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "todo.db");
    return await openDatabase(path, version: 1, onCreate: (db, version){
      final sql = '''
      CREATE TABLE $tableTodo(
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
      $columnTitle TEXT NOT NULL,
      $columnCategory TEXT NOT NULL,
      $columnPriority TEXT NOT NULL,
      $columnDays TEXT NOT NULL,
      $columnIsCompleted INTEGER NOT NULL,
      $columnTime TEXT NOT NULL
      )
      ''';
      return db.execute(sql);
    });
  }

  Future insertTodo(Todo todo) async {
    final db = await database;
    return db.insert(tableTodo, todo.toMap());
  }

  Future<List<Todo>> getAllTodo() async {
    final db = await database;
    final result = await db.query(
      tableTodo,
      orderBy: "$columnTime DESC"
    );
    return result.map((todo) => Todo.fromMap(todo)).toList();
  }

  Future<Todo> getTodoById(int id) async {
    final db = await database;
    final result = await db.query(
      tableTodo,
      where: "$columnId = ?",
      whereArgs: [id]
    );
    if (result.isNotEmpty){
      return Todo.fromMap(result.first);
    } else {
      throw "Data dengan id $id tidak ditemukan";
    }
  }

  Future updateTodo(Todo todo) async {
    final db = await database;
    return await db.update(
        tableTodo,
        todo.toMap(),
        where: "$columnId = ?",
        whereArgs: [todo.id]
    );
  }

  Future deleteTodo(int id) async {
    final db = await database;
    return await db.delete(
        tableTodo,
        where: "$columnId = ?",
        whereArgs: [id]
    );
  }


}