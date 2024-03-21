
// classe que representa a tabela no bd
class Route {

  // Atributos de inicializacao tardia que representam os campos da tabela
  // id
  late int idRoute;
  // nome do ponto de interesse
  late String nameRoute;
  // descricao do ponto de interesse
  late String descriptionRoute;
  // campos de add a referencia para a imagem 
  late String imgRoute;
  


  // Construtor da classe com parametros nomeados e campos opc 
  Route({
    required this.idRoute, 
    required this.nameRoute, 
    required this.descriptionRoute,
    required this.imgRoute, 
 
  });
  

  // Para converter um objeto dart em um Map, pq o Sqlite espera um map para aplicar as alteracoes no bd 
  Map<String, dynamic> toMapRoute(){
    return {
      'nameRoute': nameRoute,
      'descriptionRoute': descriptionRoute,
      'imgRoute': imgRoute,
      if (idRoute != 0) 'idRoute': idRoute}; // se o id for diferente de zero passa um campo id com o valor do id - (Atualizar)
  }


  // recebe um objeto do tipo map e converte para dart - (Visualizacao)
  Route.fromMapRoute(Map<String, dynamic> map){
    nameRoute = map['nameRoute'];
    descriptionRoute = map['descriptionRoute'];
    imgRoute = map['imgRoute'];
    idRoute = map['idRoute'];
  }

}

