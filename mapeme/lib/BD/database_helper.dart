import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// classe que realiza a conexão com bd
class DataBaseHelper {
  // GetIt (Gerenciar a injeção de dependência) - para garantir que apenas uma instância de cada serviço seja criada e compartilhada em todo o aplicativo. Isso significa que não há necessidade de adicionar a lógica adicional para verificar se o banco de dados já foi aberto antes de tentar abri-lo novamente

  // static late dynamic database;

  // retorna o bd - uma unica instancia em memoria
  static late var database;

  // Abertura da conexão com bd
  Future<Database> getDB() async {
    database =
        await openDatabase(join(await getDatabasesPath(), 'bdprojeto.db'),
            onCreate: (db, version) async {
      await db.execute(
        "CREATE TABLE IF NOT EXISTS tablepointInterest(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT, latitude DOUBLE, longitude DOUBLE, img1 TEXT, img2 TEXT, turisticPoint INTEGER, synced INTEGER)",
      );
    }, version: 1);
    return database;
  }
}

