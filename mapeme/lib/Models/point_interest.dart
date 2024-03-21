
// classe que representa a tabela no bd
class PointInterest {

  // Atributos de inicializacao tardia que representam os campos da tabela
  // id
  late int id;
  // nome do ponto de interesse
  late String name;
  // descricao do ponto de interesse
  late String description;
  // latitude
  late double latitude;
  // longitude
  late double longitude;
  // campos de add a referencia para a imagem 
  late String img1;
  late String img2;
  // tipo do ponto de interesse
  late String typePointInterest;
  // para add se o ponto de interesse é um ponto turístico ou faz parte da rota
  // late int turisticPoint;
  // se ta sicronizado com o banco remoto ou não
  late int synced;


  // Construtor da classe com parametros nomeados e campos opc 
  PointInterest({
    required this.id, 
    required this.name, 
    required this.description,
    required this.latitude, 
    required this.longitude, 
    required this.img1, 
    required this.img2, 
    required this.typePointInterest, 
    // required this.turisticPoint, 
    required this.synced, 
  });
  

  // Para converter um objeto dart em um Map, pq o Sqlite espera um map para aplicar as alteracoes no bd 
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'img1': img1,
      'img2': img2,
      'typePointInterest': typePointInterest,
      // 'turisticPoint': turisticPoint,
      'synced': synced,
      if (id != 0) 'id': id}; // se o id for diferente de zero passa um campo id com o valor do id - (Atualizar)
  }


  // recebe um objeto do tipo map e converte para dart - (Visualizacao)
  PointInterest.fromMap(Map<String, dynamic> map){
    name = map['name'];
    description = map['description'];
    latitude = map['latitude'];
    longitude = map['longitude'];
    img1 = map['img1'];
    img2 = map['img2'];
    typePointInterest = map['typePointInterest'];
    // turisticPoint = map['turisticPoint'];
    synced = map['synced'];
    id = map['id'];
  }

}

