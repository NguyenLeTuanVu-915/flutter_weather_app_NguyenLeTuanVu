import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../utils/constants.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/weather_error_widget.dart';
import 'search_screen.dart';
import 'forecast_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, _) {
        final gradientColors = provider.currentWeather != null
            ? getWeatherGradient(
          weatherMain: provider.currentWeather!.main,
          isNight: provider.currentWeather!.isNight,
        )
            : [const Color(0xFF2C3E50), const Color(0xFF4A5568)];

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildAppBar(context, provider),

                  Expanded(
                    child: _buildBody(context, provider),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context, WeatherProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppStyles.screenPadding,
        vertical: 12,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.white),
            tooltip: 'Lấy vị trí hiện tại',
            onPressed: provider.isLoading
                ? null
                : () => provider.fetchWeatherByLocation(),
          ),

          const Spacer(),

          if (provider.currentCity != null)
            Text(
              provider.currentCity!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

          const Spacer(),

          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            tooltip: 'Tìm kiếm thành phố',
            onPressed: () => _navigateToSearch(context),
          ),

          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            tooltip: 'Cài đặt',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, WeatherProvider provider) {
    switch (provider.status) {
      case WeatherStatus.initial:
        return _buildWelcome(context);

      case WeatherStatus.loading:
        return const LoadingShimmer();

      case WeatherStatus.error:
        return WeatherErrorWidget(
          message: provider.errorMessage ?? 'Lỗi không xác định',
          onRetry: provider.currentCity != null
              ? () => provider.fetchWeatherByCity(provider.currentCity!)
              : null,
          onSearch: () => _navigateToSearch(context),
        );

      case WeatherStatus.success:
        return _buildSuccessContent(context, provider);
    }
  }

  Widget _buildWelcome(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🌤️', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          const Text(
            'Weather App',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tìm kiếm thành phố hoặc dùng vị trí GPS',
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _navigateToSearch(context),
            icon: const Icon(Icons.search),
            label: const Text('Tìm thành phố'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => context.read<WeatherProvider>().fetchWeatherByLocation(),
            icon: const Icon(Icons.gps_fixed, color: Colors.white),
            label: const Text(
              'Dùng vị trí của tôi',
              style: TextStyle(color: Colors.white),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white54),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent(BuildContext context, WeatherProvider provider) {
    return RefreshIndicator(
      onRefresh: () => provider.refresh(),
      color: Colors.white,
      backgroundColor: Colors.blueAccent,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppStyles.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CurrentWeatherCard(
              weather: provider.currentWeather!,
              isFromCache: provider.isFromCache,
              tempUnit: provider.tempUnitSymbol,
            ),
            const SizedBox(height: 24),

            if (provider.hourlyForecast.isNotEmpty) ...[
              HourlyForecastList(hourlyList: provider.hourlyForecast),
              const SizedBox(height: 24),
            ],

            if (provider.forecast.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Dự báo 5 ngày', style: AppStyles.sectionTitle),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ForecastScreen(
                          forecast: provider.forecast,
                          cityName: provider.currentCity ?? '',
                        ),
                      ),
                    ),
                    child: const Text(
                      'Xem thêm →',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...provider.forecast.take(5).map(
                    (day) => DailyForecastCard(forecast: day),
              ),
            ],

            if (provider.currentCity != null) ...[
              const SizedBox(height: 16),
              _buildFavoriteButton(context, provider),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(BuildContext context, WeatherProvider provider) {
    final city = provider.currentCity!;
    final isFav = provider.isFavorite(city);

    return Center(
      child: OutlinedButton.icon(
        onPressed: () {
          if (isFav) {
            provider.removeFavorite(city);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Đã xóa $city khỏi yêu thích')),
            );
          } else {
            if (provider.favorites.length >= 5) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chỉ lưu được tối đa 5 thành phố yêu thích')),
              );
            } else {
              provider.addFavorite(city);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã thêm $city vào yêu thích')),
              );
            }
          }
        },
        icon: Icon(
          isFav ? Icons.favorite : Icons.favorite_border,
          color: isFav ? Colors.red : Colors.white,
        ),
        label: Text(
          isFav ? 'Đã yêu thích' : 'Thêm vào yêu thích',
          style: TextStyle(color: isFav ? Colors.red : Colors.white),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: isFav ? Colors.red : Colors.white54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  void _navigateToSearch(BuildContext context) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
    if (result != null && mounted) {
      context.read<WeatherProvider>().fetchWeatherByCity(result);
    }
  }
}