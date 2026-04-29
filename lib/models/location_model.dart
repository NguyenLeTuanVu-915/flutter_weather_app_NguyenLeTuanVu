// lib/models/location_model.dart
// Model cho dữ liệu vị trí GPS

class LocationModel {
  final double latitude;   // Vĩ độ
  final double longitude;  // Kinh độ
  final String? cityName;  // Tên thành phố (từ geocoding)
  final String? country;   // Mã quốc gia

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