import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart'; // Import path package for `join`
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


import 'model.dart';

class DbHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  Future<Database> initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "notes.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, description TEXT NOT NULL)");
  }

  Future<NotesModel> insert(NotesModel notesModel) async {
    var dbClient = await db;
    await dbClient!.insert('notes', notesModel.toMap());
    return notesModel;
  }

  Future<List<NotesModel>> getNotesList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult = await dbClient!.query("notes");
    return queryResult.map((e) => NotesModel.forMap(e)).toList();
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(
        "notes",
        where: "id = ?",
        whereArgs: [id]
    );
  }

  Future<int> edit(NotesModel notesModel) async {
    var dbClient = await db;
    return await dbClient!.update(
        "notes",
        notesModel.toMap(),
        where: 'id = ?',
        whereArgs: [notesModel.id]
    );
  }
}
