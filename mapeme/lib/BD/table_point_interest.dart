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
    // mostra apenas os ponto onde o foreignidRoute seja igual a nulo
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM tablepointInterest WHERE foreignidRoute IS NULL ORDER BY name");
    await db.close();

    // Cria a lista - passa o tamanho e retorna para cada elemento desta lista um obj Map que vai ser convertido para obj Dart - fromMap da classe PointInterest - para cada elemento da lista
    return List.generate(
        maps.length, (index) => PointInterest.fromMap(maps[index]));
  }

  //

  //
  // Leitura - Filtra os pontos de interesse pelo o nome
  Future<List<PointInterest>> getSearchNamePoint(String name) async {
    var db = await GetIt.I.get<DataBaseHelper>().getDB();

    final List<Map<String, dynamic>> maps = await db.query(
      "tablepointInterest",
      where: "foreignidRoute IS NULL AND name LIKE ?",
      whereArgs: ['%$name%'],
      orderBy: "name",
    );
    await db.close();

    return List.generate(
      maps.length,
      (index) => PointInterest.fromMap(maps[index]),
    );
  }

  // 

  // Método para obter os tipos de ponto de interesse
  Future<List<String>> getPointInterestTypes() async {
    var db = await GetIt.I.get<DataBaseHelper>().getDB();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT DISTINCT typePointInterest FROM tablepointInterest ORDER BY typePointInterest");
    await db.close();

    // Extrair os tipos de ponto de interesse da lista de mapas
    List<String> types =
        maps.map((map) => map['typePointInterest'] as String).toList();
    return types;
  }

  //

  //Metodo para retornar todas as imagens1 que não são vazias
  Future<List<String>> getPointInterestImages1(int foreignidRoute) async {
    var db = await GetIt.I.get<DataBaseHelper>().getDB();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT img1 FROM tablepointInterest WHERE foreignidRoute = ? AND img1 != ''",
        [foreignidRoute]);
    await db.close();

    // Extrair as imagens da lista de mapas
    List<String> images = maps.map((map) => map['img1'] as String).toList();
    return images;
  }
//

  //Metodo para retornar todas as imagens1 que não são vazias
  Future<List<String>> getPointInterestImages2(int foreignidRoute) async {
    var db = await GetIt.I.get<DataBaseHelper>().getDB();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT img2 FROM tablepointInterest WHERE foreignidRoute = ? AND img2 != ''",
        [foreignidRoute]);
    await db.close();

    // Extrair as imagens da lista de mapas
    List<String> images = maps.map((map) => map['img2'] as String).toList();
    return images;
  }

  //

// retorna os pontos de interesse com base no foreignIdRoute
  Future<List<PointInterest>> getPointInterestByForeignIdRoute(
      int foreignIdRoute) async {
    var db = await GetIt.I.get<DataBaseHelper>().getDB();

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM tablepointInterest WHERE foreignidRoute = ? ORDER BY name",
        [foreignIdRoute]); // Passa o valor de foreignIdRoute como um parâmetro

    await db.close();

    return List.generate(
        maps.length, (index) => PointInterest.fromMap(maps[index]));
  }

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

  // Retorna o ultimo id cadastrado
  Future<int> getLastInsertedPointInterestId() async {
    var db = await GetIt.I.get<DataBaseHelper>().getDB();
    final List<Map<String, dynamic>> result =
        await db.rawQuery("SELECT MAX(id) as last_id FROM tablepointInterest");
    await db.close();

    // Verifica se há resultados e retorna o último ID, ou 0 se nenhum registro estiver presente
    if (result.isNotEmpty && result.first['last_id'] != null) {
      return result.first['last_id'] as int;
    } else {
      return 0;
    }
  }
}
