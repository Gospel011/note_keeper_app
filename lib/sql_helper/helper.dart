import 'dart:async';
import 'dart:io';
// import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'note_model.dart';
import 'package:path_provider/path_provider.dart';

class SQLHelper {
  //create database getter
  // if a database exists at the given path, it returns it, otherwise it
  // creates a new one and then call the onCreate call back function in openDatabase.
  static Future<Database> get db async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    // print('${documentsDir.path}notes.db');
    return await openDatabase(
      '${documentsDir.path}/notes.db',
      version: 1,
      onCreate: (db, version) async {
        print('Creating database');
        return await _createTables(db);
      },
    );
  }

  //This _createTables function would be passed as a callback in the onCreate
  // parameter of openDatabase function
  static Future<void> _createTables(Database database) async {
    return await database.execute("""
      CREATE TABLE NotesDB(
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        date TEXT,
        priority TEXT
      )
    """);
  }

  //Create/insert item
  //TODO debug if return value == 0
  static Future<int> insertItem(
      {required String title,
      String? description,
      required String priority}) async {
    Database db = await SQLHelper.db;
    String onlyStrNumId =
        SQLHelper._extractNumbersFromString(DateTime.now().toString());
    int id = await db.rawInsert(
        '''INSERT INTO NotesDB(id, title, description, date, priority) VALUES (
        "$onlyStrNumId",
        "$title",
        "$description",
        "${DateTime.now().toString().substring(0, 10)}",
        "$priority")''');
    print('''
      Items inserted successfully with row no: $id.\n
      title: $title,
      description: $description,
      date: ${DateTime.now().toString().substring(0, 10)}
''');
    return id;
  }

  //get all items in database
  static Future<List<Map<String, dynamic>>> getAllItems() async {
    Database db = await SQLHelper.db;
    List<Map<String, dynamic>> items =
        await db.rawQuery('SELECT * FROM NotesDB ORDER BY priority, id DESC');
    return items;
  }

  static Future<Note> getLastInsertedItem() async {
    Database db = await SQLHelper.db;
    List<Map<String, dynamic>> noteMap =
        await db.rawQuery('SELECT * FROM NotesDB ORDER BY id DESC LIMIT 1');
    Note note = Note.fromMap(noteMap[0]);
    return note;
  }

  // convert all items in database to list of notes
  static Future<List<Note>> getNotesList() async {
    List<Map<String, dynamic>> items = await getAllItems();
    int count = items.length;
    List<Note> noteList = [];
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMap(items[i]));
      print('notes = ${Note.fromMap(items[i]).toMap()}');
    }
    return noteList;
  }

  //Read/retrieve item
  static Future<List<Map<String, dynamic>>> retrieveItem(String id) async {
    Database db = await SQLHelper.db;
    List<Map<String, dynamic>> item =
        await db.rawQuery('SELECT * FROM NotesDB WHERE id = $id');
    return item;
  }

  //Update
  static Future<int> updateItem(String id, String priority,
      {String? title, String? description}) async {
    Database db = await SQLHelper.db;
    if (title != null && description != null) {
      final int result = await db.rawUpdate(
          'UPDATE NotesDB SET id = ?, title = ?, description = ?, priority = ? WHERE id = ?',
          [
            SQLHelper._extractNumbersFromString(DateTime.now().toString()),
            title,
            description,
            priority,
            id
          ]);
      return result;
    }
    // else if (title == null && description != null) {
    //   final int result = await db.rawUpdate(
    //       'UPDATE NotesDB SET description = $description WHERE id = $id');
    //   return result;
    // }
    else {
      final int result = await db.rawUpdate(
          'UPDATE NotesDB SET id = ?, title = ?, priority = ? WHERE id = ?', [
        SQLHelper._extractNumbersFromString(DateTime.now().toString()),
        title,
        priority,
        id
      ]);
      return result;
    }
  }

  //Delete item
  static Future<void> deleteItem(String id) async {
    Database db = await SQLHelper.db;
    int response = await db.rawDelete('DELETE FROM NotesDB WHERE id = ?', [id]);
    print('delete response is $response');
  }

  static String _extractNumbersFromString(String input) {
    String result = '';
    String currentNumber = '';

    for (int i = 0; i < input.length; i++) {
      String currentChar = input[i];

      if (RegExp(r'\d').hasMatch(currentChar)) {
        // If the character is a digit, append it to the current number string
        currentNumber += currentChar;
      } else {
        // If the character is not a digit and there's a current number string, append it to the result
        if (currentNumber.isNotEmpty) {
          result += currentNumber;
          currentNumber = '';
        }
      }
    }

    // If there's a remaining number string at the end of the input, append it to the result
    if (currentNumber.isNotEmpty) {
      result += currentNumber;
    }

    return result;
  }
}
