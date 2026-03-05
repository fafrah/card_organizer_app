import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'cards.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    // Create Folders table
    await db.execute('''
      CREATE TABLE folders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        folder_name TEXT
      )
    ''');

    // Create Cards table with foreign key
    await db.execute('''
      CREATE TABLE cards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        card_name TEXT,
        suit TEXT,
        image_url TEXT,
        folder_id INTEGER,
        FOREIGN KEY(folder_id) REFERENCES folders(id) ON DELETE CASCADE
      )
    ''');

    await db.insert('folders', {'folder_name': 'Hearts'});
    await db.insert('folders', {'folder_name': 'Spades'});

    // Prepopulate cards
    await _prepopulateCards(db);
  }

  Future _prepopulateCards(Database db) async {
    final suits = ['hearts', 'spades'];
    final ranks = [
      'ace',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      'jack',
      'queen',
      'king',
    ];

    for (int folderId = 1; folderId <= suits.length; folderId++) {
      for (var rank in ranks) {
        await db.insert('cards', {
          'card_name': rank,
          'suit': suits[folderId - 1],
          'image_url':
              'assets/cards/${suits[folderId - 1].toLowerCase()}_$rank.jpg',
          'folder_id': folderId,
        });
      }
    }
  }

  Future<List<Map<String, dynamic>>> getAllCards() async {
    final database = await db;
    return await database.query('cards');
  }
}
