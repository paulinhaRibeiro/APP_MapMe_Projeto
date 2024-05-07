class PointOfInterestLatLong {
  late double latitude;
  late double longitude;
  late String name;
  double distancia = 0;

  PointOfInterestLatLong(this.name,
      {required this.latitude, required this.longitude});

  Map<String, dynamic> toMap(Map<String, dynamic> map) {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
    };
  }

  PointOfInterestLatLong.fromMap(Map<String, dynamic> map) {
    latitude = map['latitude'];
    longitude = map['longitude'];
    name = map['name'];
  }
}
