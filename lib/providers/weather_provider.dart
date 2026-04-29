// lib/providers/weather_provider.dart
// Quản lý trạng thái của toàn bộ dữ liệu thời tiết trong app

import 'package:flutter/foundation.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../models/hourly_weather_model.dart';
import '../services/weather_service.dart';
import '../services/storage_service.dart';
import '../services/connectivity_service.dart';
import '../services/location_service.dart';

// Enum 3 trạng thái: đang tải, thành công, lỗi
enum WeatherStatus { initial, loading, success, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final StorageService _storageService = StorageService();
  final ConnectivityService _connectivityService = ConnectivityService();
  final LocationService _locationService = LocationService();

  // ---- State variables ----
  WeatherStatus _status = WeatherStatus.initial;
  WeatherModel? _currentWeather;
  List<DailyForecastModel> _forecast = [];
  List<HourlyWeatherModel> _hourlyForecast = [];
  String? _errorMessage;
  String? _currentCity;
  bool _isFromCache = false;
  String _temperatureUnit = 'metric'; // metric = Celsius, imperial = Fahrenheit
  List<String> _favorites = [];
  List<String> _searchHistory = [];

  // ---- Getters ----
  WeatherStatus get status => _status;
  WeatherModel? get currentWeather => _currentWeather;
  List<DailyForecastModel> get forecast => _forecast;
  List<HourlyWeatherModel> get hourlyForecast => _hourlyForecast;
  String? get errorMessage => _errorMessage;
  String? get currentCity => _currentCity;
  bool get isLoading => _status == WeatherStatus.loading;
  bool get hasError => _status == WeatherStatus.error;
  bool get hasData => _status == WeatherStatus.success;
  bool get isFromCache => _isFromCache;
  String get temperatureUnit => _temperatureUnit;
  List<String> get favorites => _favorites;
  List<String> get searchHistory => _searchHistory;

  // FIX BUG 2: Getter ký hiệu đơn vị để truyền vào widget
  String get tempUnitSymbol => _temperatureUnit == 'metric' ? '°C' : '°F';

  /// Khởi tạo: load settings và thử load dữ liệu cuối
  Future<void> init() async {
    _temperatureUnit = await _storageService.getTemperatureUnit();
    _favorites = await _storageService.getFavorites();
    _searchHistory = await _storageService.getSearchHistory();

    final lastCity = await _storageService.getLastCity();
    if (lastCity != null) {
      await fetchWeatherByCity(lastCity, forceRefresh: false);
    }
  }

  // ---- Tải theo tên thành phố ----

  Future<void> fetchWeatherByCity(
      String city, {
        bool forceRefresh = true,
      }) async {
    if (city.trim().isEmpty) {
      _setError('Vui lòng nhập tên thành phố');
      return;
    }

    _setLoading();
    _currentCity = city.trim();

    final hasInternet = await _connectivityService.hasInternetConnection();

    if (!hasInternet) {
      await _loadFromCache();
      return;
    }

    if (!forceRefresh && await _storageService.isWeatherCacheValid()) {
      final cacheLoaded = await _loadFromCache();
      if (cacheLoaded) return;
    }

    try {
      // FIX BUG 3: Gọi 3 API song song thay vì tuần tự → nhanh hơn ~3x
      final results = await Future.wait([
        _weatherService.getCurrentWeatherByCity(
          _currentCity!,
          unit: _temperatureUnit, // FIX BUG 2: truyền unit
        ),
        _weatherService.getForecastByCity(
          _currentCity!,
          unit: _temperatureUnit, // FIX BUG 2: truyền unit
        ),
        _weatherService.getHourlyByCity(
          _currentCity!,
          unit: _temperatureUnit, // FIX BUG 2: truyền unit
        ),
      ]);

      _currentWeather = results[0] as WeatherModel;
      _forecast = results[1] as List<DailyForecastModel>;
      final hourly = results[2] as List<HourlyWeatherModel>;
      _hourlyForecast = hourly.take(8).toList();

      // Lưu cache
      await _storageService.cacheWeather(_currentWeather!.toJson());
      await _storageService.cacheForecast(
        hourly.map((h) => h.toJson()).toList(),
      );
      await _storageService.saveLastCity(_currentCity!);

      // Lưu lịch sử tìm kiếm
      await _storageService.saveSearchHistory(_currentCity!);
      _searchHistory = await _storageService.getSearchHistory();

      _isFromCache = false;
      _setSuccess();
    } catch (e) {
      final cacheLoaded = await _loadFromCache();
      if (!cacheLoaded) {
        _setError(e.toString().replaceAll('Exception: ', ''));
      }
    }
  }

  // ---- Tải theo GPS ----

  Future<void> fetchWeatherByLocation() async {
    _setLoading();

    try {
      final location = await _locationService.getCurrentLocation();

      // FIX BUG 3: Gọi song song
      final results = await Future.wait([
        _weatherService.getCurrentWeatherByCoord(
          location.latitude,
          location.longitude,
          unit: _temperatureUnit, // FIX BUG 2: truyền unit
        ),
        _weatherService.getForecastByCoord(
          location.latitude,
          location.longitude,
          unit: _temperatureUnit, // FIX BUG 2: truyền unit
        ),
      ]);

      _currentWeather = results[0] as WeatherModel;
      _forecast = results[1] as List<DailyForecastModel>;
      _currentCity = _currentWeather!.cityName;

      // Lấy hourly riêng (cần city name từ weather response)
      final hourly = await _weatherService.getHourlyByCity(
        _currentWeather!.cityName,
        unit: _temperatureUnit, // FIX BUG 2: truyền unit
      );
      _hourlyForecast = hourly.take(8).toList();

      await _storageService.cacheWeather(_currentWeather!.toJson());
      await _storageService.saveLastCity(_currentWeather!.cityName);

      _isFromCache = false;
      _setSuccess();
    } on Exception catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // ---- Load từ cache ----

  Future<bool> _loadFromCache() async {
    final cachedWeatherJson = await _storageService.getCachedWeather();
    if (cachedWeatherJson == null) return false;

    try {
      _currentWeather = WeatherModel.fromJson(cachedWeatherJson);

      final cachedForecastJson = await _storageService.getCachedForecast();
      if (cachedForecastJson != null) {
        final hourlyList = cachedForecastJson
            .map((j) => HourlyWeatherModel.fromJson(j))
            .toList();
        _hourlyForecast = hourlyList.take(8).toList();
        _forecast = _groupHourlyToDaily(hourlyList);
      }

      _isFromCache = true;
      _setSuccess();
      return true;
    } catch (e) {
      return false;
    }
  }

  List<DailyForecastModel> _groupHourlyToDaily(
      List<HourlyWeatherModel> hourlyList,
      ) {
    final Map<String, List<HourlyWeatherModel>> grouped = {};
    for (final item in hourlyList) {
      final key =
          '${item.dateTime.year}-${item.dateTime.month}-${item.dateTime.day}';
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(item);
    }
    final list = grouped.entries
        .map((e) =>
        DailyForecastModel.fromHourlyList(e.value.first.dateTime, e.value))
        .toList();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  // ---- Favorites ----

  Future<void> addFavorite(String city) async {
    if (!_favorites.contains(city) && _favorites.length < 5) {
      _favorites.add(city);
      await _storageService.saveFavorites(_favorites);
      notifyListeners();
    }
  }

  Future<void> removeFavorite(String city) async {
    _favorites.remove(city);
    await _storageService.saveFavorites(_favorites);
    notifyListeners();
  }

  bool isFavorite(String city) => _favorites.contains(city);

  // ---- Settings ----

  // FIX BUG 2: Sau khi đổi unit → tự động fetch lại để cập nhật nhiệt độ
  Future<void> setTemperatureUnit(String unit) async {
    if (_temperatureUnit == unit) return; // Không làm gì nếu không đổi
    _temperatureUnit = unit;
    await _storageService.saveTemperatureUnit(unit);
    notifyListeners();

    // Fetch lại với đơn vị mới
    if (_currentCity != null) {
      await fetchWeatherByCity(_currentCity!, forceRefresh: true);
    }
  }

  // ---- Refresh ----

  Future<void> refresh() async {
    if (_currentCity != null) {
      await fetchWeatherByCity(_currentCity!, forceRefresh: true);
    }
  }

  // FIX BUG 1: Reload search history sau khi xóa
  Future<void> reloadSearchHistory() async {
    _searchHistory = await _storageService.getSearchHistory();
    notifyListeners();
  }

  // ---- State setters ----

  void _setLoading() {
    _status = WeatherStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setSuccess() {
    _status = WeatherStatus.success;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = WeatherStatus.error;
    _errorMessage = message;
    notifyListeners();
  }
}