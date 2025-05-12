import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Note {
  final int id;
  final String title;
  final String content;

  Note({required this.id, required this.title, required this.content});

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'content': content,
  };
}

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    return await _initDB();
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'notes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT
          )
        ''');
      },
    );
  }

  static Future<List<Note>> getNotes() async {
    final db = await database;
    final data = await db.query('notes');
    return data
        .map((e) => Note(id: e['id'] as int, title: e['title'] as String, content: e['content'] as String))
        .toList();
  }

  static Future<void> insertNote(String title, String content) async {
    final db = await database;
    await db.insert('notes', {'title': title, 'content': content});
  }

  static Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
