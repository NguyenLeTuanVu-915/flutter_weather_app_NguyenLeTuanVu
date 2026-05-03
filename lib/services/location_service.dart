import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/location_model.dart';

class LocationService {
  Future<LocationModel> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Dịch vụ vị trí chưa được bật. Vui lòng bật GPS.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Quyền vị trí bị từ chối.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Quyền vị trí bị từ chối vĩnh viễn.\n'
            'Vui lòng vào Cài đặt > Ứng dụng để cấp quyền.',
      );
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );

    String? cityName;
    String? country;
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        cityName = place.locality?.isNotEmpty == true
            ? place.locality
            : place.administrativeArea;
        country = place.isoCountryCode;
      }
    } catch (e) {
      cityName = null;
    }

    return LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
      cityName: cityName,
      country: country,
    );
  }

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