import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _search() {
    final query = _controller.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên thành phố')),
      );
      return;
    }
    Navigator.pop(context, query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2C3E50), Color(0xFF4A5568)],
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
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Nhập tên thành phố... (VD: Hanoi)',
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.white12,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          suffixIcon: _controller.text.isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.white54),
                            onPressed: () {
                              _controller.clear();
                              setState(() {});
                            },
                          )
                              : null,
                        ),
                        onChanged: (_) => setState(() {}),
                        onSubmitted: (_) => _search(),
                        textInputAction: TextInputAction.search,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _search,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Tìm'),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Consumer<WeatherProvider>(
                  builder: (context, provider, _) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppStyles.screenPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (provider.favorites.isNotEmpty) ...[
                            _sectionHeader('Yêu thích'),
                            const SizedBox(height: 8),
                            _buildCityList(provider.favorites),
                            const SizedBox(height: 24),
                          ],

                          if (provider.searchHistory.isNotEmpty) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _sectionHeader('Tìm kiếm gần đây'),
                                TextButton(
                                  onPressed: () async {
                                    final prefs = await SharedPreferences.getInstance();
                                    await prefs.remove('search_history');
                                    if (context.mounted) {
                                      context.read<WeatherProvider>().reloadSearchHistory();
                                    }
                                  },
                                  child: const Text(
                                    'Xóa',
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _buildCityList(provider.searchHistory),
                            const SizedBox(height: 24),
                          ],

                          _sectionHeader('Thành phố phổ biến'),
                          const SizedBox(height: 8),
                          _buildCityList(const [
                            'Ho Chi Minh City',
                            'Hanoi',
                            'Da Nang',
                            'Can Tho',
                            'Bien Hoa',
                            'Hue',
                            'Nha Trang',
                            'Tokyo',
                            'Seoul',
                            'Bangkok',
                            'Singapore',
                            'London',
                            'New York',
                            'Paris',
                            'Sydney',
                          ]),
                        ],
                      ),
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

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildCityList(List<String> cities) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: cities
          .map(
            (city) => GestureDetector(
          onTap: () => Navigator.pop(context, city),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, color: Colors.white70, size: 14),
                const SizedBox(width: 4),
                Text(
                  city,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      )
          .toList(),
    );
  }
}