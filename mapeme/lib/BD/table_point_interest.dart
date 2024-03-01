import 'package:get_it/get_it.dart';
import 'package:mapeme/BD/database_helper.dart';
import 'package:mapeme/Models/point_interest.dart';

// classe de manipulação do bd
class ManipuTablePointInterest {
  // CREATE - gravar as funções no bd
  Future<void> insertPointInterest(PointInterest point) async {
    // Resgata a conexão com bd - instancia da classe DataBaseHelper que é gerenciada pelo getIt
    var db = await GetIt.I.get<DataBaseHelper>().getDB();

    // Cadastrar - como foi configurado na classe PointInterest - pegando o obj dart e convertendo para map
    await db.insert('tablepointInterest', point.toMap());

    // fecha conexão com o bd
    await db.close();
  }

  //

  // READ - devolve tds os objs - lista de Pontos de interesse
  Future<List<PointInterest>> getPointInterest() async {
    // Resgata a conexão com bd - instancia da classe DataBaseHelper que é gerenciada pelo getIt
    var db = await GetIt.I.get<DataBaseHelper>().getDB();

    // lista de Maps
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM tablepointInterest ORDER BY name");
    await db.close();

    // Cria a lista - passa o tamanho e retorna para cada elemento desta lista um obj Map que vai ser convertido para obj Dart - fromMap da classe PointInterest - para cada elemento da lista
    return List.generate(
        maps.length, (index) => PointInterest.fromMap(maps[index]));
  }

  //

  // UPDATE
  Future<void> updatePointInterest(PointInterest point) async {
    // Resgata a conexão com bd - instancia da classe DataBaseHelper que é gerenciada pelo getIt
    var db = await GetIt.I.get<DataBaseHelper>().getDB();

    // Atualiza onde o id seja == a point.id
    await db.update('tablepointInterest', point.toMap(),
        where: 'id = ?', whereArgs: [point.id]);
    await db.close();
  }

  //

  // DELETE
  Future<void> deletePointInterest(int id) async {
    var db = await GetIt.I.get<DataBaseHelper>().getDB();
    await db.delete('tablepointInterest', where: 'id = ?', whereArgs: [id]);
    await db.close();
  }
}
