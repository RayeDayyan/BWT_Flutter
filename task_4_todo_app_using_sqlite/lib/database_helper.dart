import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:task_4/addToList.dart';
import 'package:task_4/note.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper; // Changed to nullable type
  static Database? _database; // Changed to nullable type

  String noteTable = 'note_table';
  String colId = 'id';
  String colNote = 'note';
  String colStatus = 'status';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance(); // Use null-aware operator
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase(); // Use null-aware operator
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colNote TEXT, $colStatus TEXT, $colDate TEXT)');
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $noteTable ORDER BY $colDate ASC');
    return result;
  }

  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toJson());
    return result;
  }

  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    var result = await db.update(noteTable, note.toJson(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  Future<int?> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT(*) FROM $noteTable');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Note>> getNoteList () async{

    var mapObjects = await getNoteMapList();
    var count = mapObjects.length;

    List<Note> noteList = <Note>[];

    for(int i = 0 ; i <count;i++){

      noteList.add(Note.fromJson(mapObjects[i]));

    }

    return noteList;



  }

}
