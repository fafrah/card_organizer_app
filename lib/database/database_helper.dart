import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cards.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE folders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        folder_name TEXT,
        timestamp TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE cards(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        card_name TEXT,
        suit TEXT,
        image_url TEXT,
        folder_id INTEGER,
        FOREIGN KEY(folder_id) REFERENCES folders(id) ON DELETE CASCADE
      )
    ''');

    await _insertFolders(db);
    await _insertCards(db);
  }

  Future _insertFolders(Database db) async {
    List suits = ['Hearts', 'Spades'];

    for (var suit in suits) {
      await db.insert('folders', {
        'folder_name': suit,
        'timestamp': DateTime.now().toString(),
      });
    }
  }

  Future _insertCards(Database db) async {
    List suits = ['Hearts', 'Spades'];

    List cards = [
      'Ace',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      'Jack',
      'Queen',
      'King',
    ];

    for (int folderId = 1; folderId <= suits.length; folderId++) {
      for (var card in cards) {
        await db.insert('cards', {
          'card_name': card,
          'suit': suits[folderId - 1],
          'image_url': '',
          'folder_id': folderId,
        });
      }
    }
  }
}
