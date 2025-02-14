import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../savings_entry/model/savings_model.dart';

/// Repository class for handling database operations related to savings
class SavingsRepository {
  static Database? _database;

  /// Getter for accessing the database instance
  Future<Database> get database async {
    // Return existing database instance if available
    if (_database != null) return _database!;
    
    // Initialize and return a new database instance
    _database = await _initDB();
    return _database!;
  }

  /// Initialize the database
  Future<Database> _initDB() async {
    // Get the database path
    final dbPath = await getDatabasesPath();
    
    // Open the database and create the table if it doesn't exist
    return openDatabase(
      join(dbPath, 'savings.db'),
      onCreate: (db, version) {
        // Create 'savings' table with required columns
        return db.execute(
          '''CREATE TABLE savings(
          id INTEGER PRIMARY KEY,
          initialCompA REAL,
          initialCompB REAL,
          compA REAL,
          compB REAL,
          totalSavings REAL,
          withdrawnCompA REAL,
          withdrawnCompB REAL,
          year TEXT
        )''',
        );
      },
      version: 1,
    );
  }

  /// Adds a new savings entry to the database
  Future<void> addSavings(Savings savings) async {
    final db = await database;
    await db.insert('savings', {
      'id': savings.id,
      'compA': savings.compA,
      'compB': savings.compB,
      'initialCompA': savings.initialCompA,
      'initialCompB': savings.initialCompB,
      'totalSavings': savings.totalSavings,
      'withdrawnCompA': savings.withdrawnCompA,
      'withdrawnCompB': savings.withdrawnCompB,
      'year': savings.year,
    });
  }

  /// Retrieves all savings entries from the database
  Future<List<Savings>> getAllSavings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('savings');

    // Convert the retrieved maps into a list of Savings objects
    return List.generate(maps.length, (i) {
      return Savings(
        id: maps[i]['id'],
        compA: maps[i]['compA'],
        compB: maps[i]['compB'],
        initialCompA: maps[i]['initialCompA'],
        initialCompB: maps[i]['initialCompB'],
        totalSavings: maps[i]['totalSavings'],
        withdrawnCompA: maps[i]['withdrawnCompA'],
        withdrawnCompB: maps[i]['withdrawnCompB'],
        year: maps[i]['year'],
      );
    });
  }

  /// Updates an existing savings entry in the database
  Future<void> updateSavings(Savings savings) async {
    final db = await database;
    await db.update(
      'savings',
      {
        'compA': savings.compA,
        'compB': savings.compB,
        'withdrawnCompA': savings.withdrawnCompA,
        'withdrawnCompB': savings.withdrawnCompB,
      },
      where: 'id = ?',
      whereArgs: [savings.id],
    );
  }
}
