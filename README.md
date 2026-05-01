## Flutter Weather App

Ứng dụng thời tiết toàn diện xây dựng bằng Flutter, cung cấp dữ liệu thời tiết thời gian thực, dự báo và phát hiện thời tiết theo vị trí GPS.

## Mô tả dự án

Flutter Weather App là ứng dụng di động được phát triển trong khuôn khổ **Lab 4 - Lập trình Mobile** tại **Trường Đại học Thủ Dầu Một**. Ứng dụng kết nối với OpenWeatherMap API để cung cấp thông tin thời tiết chính xác, cập nhật theo thời gian thực với giao diện trực quan, thay đổi màu sắc động theo điều kiện thời tiết hiện tại.

## Tính năng chính

Tính năng - Mô tả

- Thời tiết hiện tại - Nhiệt độ, cảm giác như, độ ẩm, tốc độ & hướng gió, tầm nhìn, áp suất, mây che 
- Dự báo 5 ngày - Nhiệt độ cao/thấp từng ngày kèm icon thời tiết 
- Dự báo theo giờ - 8 khung giờ tiếp theo với xác suất mưa 
- Định vị GPS - Tự động lấy vị trí hiện tại và hiển thị thời tiết 
- Tìm kiếm - Tìm thời tiết theo tên thành phố 
- Yêu thích - Lưu tối đa 5 thành phố yêu thích 
- Lịch sử - Lưu 10 thành phố tìm kiếm gần đây 
- Hỗ trợ Offline - Cache dữ liệu, hiển thị khi mất internet 
- Pull-to-refresh - Kéo xuống để cập nhật dữ liệu mới 
- Giao diện động - Gradient thay đổi theo thời tiết (nắng, mưa, mây, đêm) 
- Cài đặt - Đổi đơn vị nhiệt độ °C / °F 

## Screenshots

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/537eb6e9-1595-4e20-8dcf-0e0cd78fc366" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/1114f7b8-95ac-4e88-9fe7-ec194a4aaedc" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/92b24e25-bf8b-4326-abd0-21492743af12" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/64698196-5f21-48a8-b8d3-eb535598f3f6" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/d01d2a68-6b33-4751-a45d-7f2f5fc63800" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/b85ada2f-c04c-4293-aab2-651b8dc680de" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/6fd8c1bc-4cc7-47ad-91c8-7753aab5608f" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/1327bf5e-5bac-42e8-b77f-de6a4eca50fe" />

## Video demo

https://drive.google.com/file/d/1vuobRDI3ZARXTCzipZ6bhKV---HHnEiY/view?usp=drive_link

## Cấu hình API

Bước 1 — Đăng ký API key

1. Truy cập [https://openweathermap.org/](https://openweathermap.org/)
2. Nhấn Sign U để tạo tài khoản miễn phí
3. Sau khi đăng nhập, vào tab API Keys
4. Copy API key của bạn

> API key mới cần 2–3 giờ để được kích hoạt sau khi đăng ký.

Bước 2 — Tạo file .env

Copy file mẫu
```
cp .env.example .env
```
Mở file .env vừa tạo và thêm API key:
```
OPENWEATHER_API_KEY=your_api_key_here
```
Bước 3 — Kiểm tra API hoạt động

Dán URL sau vào trình duyệt (thay your_api_key_here bằng key của bạn):

https://api.openweathermap.org/data/2.5/weather?q=Hanoi&appid=YOUR_KEY&units=metric

Nếu trả về JSON thời tiết → API key hoạt động bình thường

## Hướng dẫn chạy dự án

Yêu cầu hệ thống

- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 3.0.0
- Android Studio / VS Code
- Thiết bị Android hoặc iOS (hoặc máy ảo)

## Các bước thực hiện

1. Clone repository
```
git clone https://github.com/your-username/flutter_weather_app_yourname.git
cd flutter_weather_app_yourname
```
2. Cài đặt dependencies
```
flutter pub get
```
3. Tạo file .env và thêm API key (xem hướng dẫn bên trên)
```
cp .env.example .env
```
4. Chạy ứng dụng (debug)
```
flutter run
```
5. Chạy ở chế độ release (nhanh hơn)
```
flutter run --release
```
## Cấu hình quyền

Android — thêm vào android/app/src/main/AndroidManifest.xml:
```
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```
iOS — thêm vào ios/Runner/Info.plist:
```
<key>NSLocationWhenInUseUsageDescription</key>
<string>App cần vị trí để hiển thị thời tiết tại nơi bạn đang ở</string>
```
## Công nghệ sử dụng

Thư viện - Phiên bản - Mục đích

- [Flutter](https://flutter.dev/) - ≥ 3.0.0 - Framework chính 
- [provider](https://pub.dev/packages/provider) - ^6.1.1 - State management 
- [http](https://pub.dev/packages/http) - ^1.1.0 - Gọi REST API 
- [geolocator](https://pub.dev/packages/geolocator) - ^10.1.0 - Lấy vị trí GPS 
- [geocoding](https://pub.dev/packages/geocoding) - ^2.1.1 - Chuyển tọa độ → tên thành phố 
- [shared_preferences](https://pub.dev/packages/shared_preferences) - ^2.2.2 - Cache offline 
- [connectivity_plus](https://pub.dev/packages/connectivity_plus) - ^5.0.2 - Kiểm tra kết nối mạng 
- [cached_network_image](https://pub.dev/packages/cached_network_image) - ^3.3.0 - Load ảnh icon thời tiết 
- [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) - ^5.1.0 - Đọc file .env
- [intl](https://pub.dev/packages/intl) - ^0.18.1 - Format ngày giờ 

API: [OpenWeatherMap](https://openweathermap.org/api) — Free tier (1.000 calls/ngày)

## Cấu trúc dự án
```
lib/
├── main.dart
├── config/
│   └── api_config.dart          # Cấu hình URL, endpoints
├── models/
│   ├── weather_model.dart       # Model thời tiết hiện tại
│   ├── forecast_model.dart      # Model dự báo ngày
│   ├── hourly_weather_model.dart# Model dự báo giờ
│   └── location_model.dart      # Model vị trí GPS
├── services/
│   ├── weather_service.dart     # Gọi API thời tiết
│   ├── location_service.dart    # Lấy GPS, geocoding
│   ├── storage_service.dart     # Cache SharedPreferences
│   └── connectivity_service.dart# Kiểm tra internet
├── providers/
│   ├── weather_provider.dart    # State management thời tiết
│   └── location_provider.dart   # State management vị trí
├── screens/
│   ├── home_screen.dart         # Màn hình chính
│   ├── search_screen.dart       # Tìm kiếm thành phố
│   ├── forecast_screen.dart     # Dự báo 5 ngày chi tiết
│   └── settings_screen.dart     # Cài đặt
├── widgets/
│   ├── current_weather_card.dart
│   ├── hourly_forecast_list.dart
│   ├── daily_forecast_card.dart
│   ├── weather_detail_item.dart
│   ├── loading_shimmer.dart
│   └── weather_error_widget.dart
└── utils/
    ├── constants.dart            # Màu sắc, style
    ├── weather_icons.dart        # Mapping emoji icon
    └── date_formatter.dart       # Format ngày giờ
```
## Hạn chế đã biết

- Icon thời tiết đôi khi load chậm do phải tải từ server OpenWeatherMap (cần internet)
- Geocoding (chuyển tọa độ → tên thành phố) có thể không chính xác ở một số vùng nông thôn
- Cache offline chỉ lưu dữ liệu của lần tải gần nhất, không phân biệt theo từng thành phố
- Free API giới hạn 1.000 lần gọi/ngày — nếu dùng nhiều có thể bị giới hạn
- Dự báo theo giờ chỉ hiển thị 8 khung giờ tiếp theo (API trả về mỗi 3 giờ)
- Chưa hỗ trợ thông báo đẩy (push notification) cho cảnh báo thời tiết
- Giao diện chưa được tối ưu hoàn toàn cho màn hình tablet

## Cải tiến trong tương lai

- Thêm thông báo đẩy khi thời tiết thay đổi đột ngột
- Tích hợp bản đồ radar thời tiết
- Hiển thị chỉ số chất lượng không khí (AQI)
- Hỗ trợ đa ngôn ngữ (Tiếng Anh / Tiếng Việt)
- Widget màn hình chính (Android & iOS)
- Chế độ Dark / Light theme thủ công
- Biểu đồ nhiệt độ theo giờ (line chart)
- So sánh thời tiết giữa nhiều thành phố
- Fallback sang API dự phòng (WeatherAPI, Open-Meteo) khi hết quota
- Viết thêm unit test và widget test
