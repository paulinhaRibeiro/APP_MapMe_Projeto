import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/database_helper.dart';
import 'package:mapeme/Models/route.dart';


// classe de manipulação do bd
class ManipuTableRoute {
  // CREATE - gravar as funções no bd
  Future<void> insertRoute(Route route) async {
    // Resgata a conexão com bd - instancia da classe DataBaseHelper que é gerenciada pelo getIt
    var db = await GetIt.I.get<DataBaseHelper>().getDB();

    // Cadastrar - como foi configurado na classe Route - pegando o obj dart e convertendo para map
    await db.insert('tableroute', route.toMapRoute());

    // fecha conexão com o bd
    await db.close();
  }

  //

  // READ - devolve tds os objs - lista de Routes
  Future<List<Route>> getRoute() async {
    // Resgata a conexão com bd - instancia da classe DataBaseHelper que é gerenciada pelo getIt
    var db = await GetIt.I.get<DataBaseHelper>().getDB();

    // lista de Maps
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM tableroute ORDER BY nameRoute");
    await db.close();

    // Cria a lista - passa o tamanho e retorna para cada elemento desta lista um obj Map que vai ser convertido para obj Dart - fromMap da classe Route - para cada elemento da lista
    return List.generate(
        maps.length, (index) => Route.fromMapRoute(maps[index]));
  }


  //

  // UPDATE
  Future<void> updateRoute(Route route) async {
    // Resgata a conexão com bd - instancia da classe DataBaseHelper que é gerenciada pelo getIt
    var db = await GetIt.I.get<DataBaseHelper>().getDB();

    // Atualiza onde o id seja == a point.id
    await db.update('tableroute', route.toMapRoute(),
        where: 'idRoute = ?', whereArgs: [route.idRoute]);
    await db.close();
  }

  //

  // DELETE
  Future<void> deleteRoute(int idRoute) async {
    var db = await GetIt.I.get<DataBaseHelper>().getDB();
    await db.delete('tableroute', where: 'idRoute = ?', whereArgs: [idRoute]);
    await db.close();
  }
}
