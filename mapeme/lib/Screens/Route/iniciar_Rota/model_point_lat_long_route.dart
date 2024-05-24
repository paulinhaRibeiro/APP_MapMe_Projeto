class PointOfInterestLatLong {
  late int id;
  late String name;
  late String description;
  late double latitude;
  late double longitude;
  late String img1;
  late String img2;
  late String typePointInterest;
  double distancia = 0;

  PointOfInterestLatLong(this.name,
      {required this.latitude, required this.longitude});

  Map<String, dynamic> toMap(Map<String, dynamic> map) {
    return {
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'img1': img1,
      'img2': img2,
      'typePointInterest': typePointInterest,
      if (id != 0) 'id': id
    };
  }

  PointOfInterestLatLong.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    description = map['description'];
    latitude = map['latitude'];
    longitude = map['longitude'];
    img1 = map['img1'];
    img2 = map['img2'];
    typePointInterest = map['typePointInterest'];
    id = map['id'];
  }
}
