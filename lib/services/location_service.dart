// lib/services/location_service.dart
// Lấy vị trí GPS và chuyển đổi tọa độ thành tên thành phố

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/location_model.dart';

class LocationService {
  /// Kiểm tra và xin quyền vị trí, sau đó trả về LocationModel
  Future<LocationModel> getCurrentLocation() async {
    // Bước 1: Kiểm tra Location Service có bật không
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Dịch vụ vị trí chưa được bật. Vui lòng bật GPS.');
    }

    // Bước 2: Kiểm tra quyền
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // Chưa có quyền → xin quyền
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Quyền vị trí bị từ chối.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Người dùng từ chối vĩnh viễn
      throw Exception(
        'Quyền vị trí bị từ chối vĩnh viễn.\n'
            'Vui lòng vào Cài đặt > Ứng dụng để cấp quyền.',
      );
    }

    // Bước 3: Lấy vị trí hiện tại
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium, // Độ chính xác trung bình (tiết kiệm pin)
    );

    // Bước 4: Chuyển tọa độ thành tên thành phố (Reverse Geocoding)
    String? cityName;
    String? country;
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        // Lấy tên thành phố (locality) hoặc tỉnh (administrativeArea)
        cityName = place.locality?.isNotEmpty == true
            ? place.locality
            : place.administrativeArea;
        country = place.isoCountryCode;
      }
    } catch (e) {
      // Nếu geocoding lỗi thì vẫn dùng tọa độ
      cityName = null;
    }

    return LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
      cityName: cityName,
      country: country,
    );
  }

  /// Chuyển tên thành phố thành tọa độ (Forward Geocoding)
  Future<LocationModel?> getLocationFromCityName(String cityName) async {
    try {
      final locations = await locationFromAddress(cityName);
      if (locations.isEmpty) return null;

      final loc = locations.first;
      return LocationModel(
        latitude: loc.latitude,
        longitude: loc.longitude,
        cityName: cityName,
      );
    } catch (e) {
      return null;
    }
  }
}