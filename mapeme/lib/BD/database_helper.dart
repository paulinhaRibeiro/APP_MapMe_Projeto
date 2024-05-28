import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  // ignore: prefer_typing_uninitialized_variables
  static late var database;

  Future<Database> getDB() async {
    database = await _initDatabase();
    return database;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'bdprojeto.db'),
      onCreate: _onCreate,
      version: 2,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE IF NOT EXISTS tablepointInterest(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          foreignidRoute INTEGER, 
          name TEXT, 
          description TEXT, 
          latitude DOUBLE, 
          longitude DOUBLE, 
          img1 TEXT, 
          img2 TEXT, 
          typePointInterest TEXT, 
          statusPoint TEXT,
          synced INTEGER, 
          FOREIGN KEY (foreignidRoute) REFERENCES tableroute (idRoute) ON DELETE CASCADE
      );''');

    await db.execute('''CREATE TABLE IF NOT EXISTS tableroute(
          idRoute INTEGER PRIMARY KEY AUTOINCREMENT, 
          nameRoute TEXT, 
          descriptionRoute TEXT, 
          imgRoute TEXT)''');
  }
}
