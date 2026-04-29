// lib/services/connectivity_service.dart
// Kiểm tra trạng thái kết nối internet

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Kiểm tra có kết nối internet không
  Future<bool> hasInternetConnection() async {
    final result = await _connectivity.checkConnectivity();
    // Trả về true nếu kết nối qua WiFi hoặc Mobile data
    return result != ConnectivityResult.none;
  }

  /// Stream theo dõi thay đổi kết nối
  Stream<ConnectivityResult> get connectivityStream =>
      _connectivity.onConnectivityChanged;
}