import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../services/location_service.dart';

enum LocationStatus { initial, loading, success, error }

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  LocationStatus _status = LocationStatus.initial;
  LocationModel? _location;
  String? _errorMessage;

  LocationStatus get status => _status;
  LocationModel? get location => _location;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == LocationStatus.loading;
  bool get hasLocation => _location != null;

  Future<void> getCurrentLocation() async {
    _status = LocationStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _location = await _locationService.getCurrentLocation();
      _status = LocationStatus.success;
    } on Exception catch (e) {
      _status = LocationStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}