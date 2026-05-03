class LocationModel {
  final double latitude;
  final double longitude;
  final String? cityName;
  final String? country;

  LocationModel({
    required this.latitude,
    required this.longitude,
    this.cityName,
    this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'cityName': cityName,
      'country': country,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      cityName: json['cityName'],
      country: json['country'],
    );
  }

  @override
  String toString() => 'LocationModel($cityName, $latitude, $longitude)';
}