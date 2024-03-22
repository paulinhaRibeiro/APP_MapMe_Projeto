import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  static late var database;

  Future<Database> getDB() async {
    database = await _initDatabase();
    return database;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'bdprojeto.db'),
      onCreate: _onCreate,
      version: 1,
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







// // classe que realiza a conexão com bd
// class DataBaseHelper {
//   // GetIt (Gerenciar a injeção de dependência) - para garantir que apenas uma instância de cada serviço seja criada e compartilhada em todo o aplicativo. Isso significa que não há necessidade de adicionar a lógica adicional para verificar se o banco de dados já foi aberto antes de tentar abri-lo novamente

//   // static late dynamic database;

//   // retorna o bd - uma unica instancia em memoria
//   static late var database;

//   // Abertura da conexão com bd
//   Future<Database> getDB() async {
//     database = await openDatabase(
//         join(await getDatabasesPath(), 'bdprojeto.db'),
//         // o onCreate é executado apenas uma vez quando é executado a primeira vez o bd
//         onCreate: (db, version) async {
//       await db.execute(
//         "CREATE TABLE IF NOT EXISTS tablepointInterest(id INTEGER PRIMARY KEY AUTOINCREMENT, foreignidRoute INTEGER, name TEXT, description TEXT, latitude DOUBLE, longitude DOUBLE, img1 TEXT, img2 TEXT, typePointInterest Text, synced INTEGER)",
//       );
//     }, version: 1);
//     return database;
//   }
// }










// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// // classe que realiza a conexão com bd
// class DataBaseHelper {
//   // GetIt (Gerenciar a injeção de dependência) - para garantir que apenas uma instância de cada serviço seja criada e compartilhada em todo o aplicativo. Isso significa que não há necessidade de adicionar a lógica adicional para verificar se o banco de dados já foi aberto antes de tentar abri-lo novamente

//   // static late dynamic database;

//   // retorna o bd - uma unica instancia em memoria
//   static late var database;

//   // Abertura da conexão com bd
//   Future<Database> getDB() async {
//     database = await openDatabase(
//         join(await getDatabasesPath(), 'bdprojeto.db'),
//         // o onCreate é executado apenas uma vez quando é executado a primeira vez o bd
//         onCreate: (db, version) {
//       return db.execute(
//         '''CREATE TABLE IF NOT EXISTS tablepointInterest(
//               id INTEGER PRIMARY KEY AUTOINCREMENT, 
//               foreignidRoute INTEGER, 
//               name TEXT, 
//               description TEXT, 
//               latitude DOUBLE, 
//               longitude DOUBLE, 
//               img1 TEXT, 
//               img2 TEXT, 
//               typePointInterest Text, 
//               synced INTEGER, 
//               FOREIGN KEY (foreignidRoute) REFERENCES tableroute (idRoute)
//           ); 
//           CREATE TABLE IF NOT EXISTS tableroute(
//               idRoute INTEGER PRIMARY KEY AUTOINCREMENT, 
//               nameRoute TEXT, 
//               descriptionRoute TEXT, 
//               imgRoute TEXT)''',
//       );
//     }, version: 4);
//     return database;
//   }
// }
