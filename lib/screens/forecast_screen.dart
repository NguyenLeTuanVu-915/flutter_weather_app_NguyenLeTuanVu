import 'package:flutter/material.dart';
import '../models/forecast_model.dart';
import '../utils/constants.dart';
import '../utils/date_formatter.dart';
import '../utils/weather_icons.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/hourly_forecast_list.dart';

class ForecastScreen extends StatelessWidget {
  final List<DailyForecastModel> forecast;
  final String cityName;

  const ForecastScreen({
    super.key,
    required this.forecast,
    required this.cityName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.all(AppStyles.screenPadding),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'Dự báo 5 ngày - $cityName',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppStyles.screenPadding,
                  ),
                  itemCount: forecast.length,
                  itemBuilder: (context, index) {
                    final day = forecast[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DailyForecastCard(forecast: day),

                        if (day.hourlyList.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          HourlyForecastList(hourlyList: day.hourlyList.take(8).toList()),
                          const SizedBox(height: 16),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}