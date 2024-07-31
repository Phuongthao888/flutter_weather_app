/*
      - Ở đâu gọi phương thức thì ở đó nhận giá trị.
      - Provider gọi thì Provider nhận
*/

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/app/utils/Custom.dart';
import 'package:weather_app/models/weather.dart';

class ApiRepository {
  /*
    - Position? là tham số không bắt buộc nên ta cần kiểm tra
    - Sau khi ta truyền vào 2 tham số lat&lon thì ra sẽ truyền tham số
    position vào bên Provider
   */
  static Future<WeatherData> callApiGetWeather(Position? position) async {
    try {
      final dio = Dio();
      final res = await dio.get(
          'https://api.openweathermap.org/data/2.5/weather?lat=${position?.latitude}&lon=${position?.longitude}&units=metric&appid=${MyKey.api_token}');
      final data = res.data;
      WeatherData result = WeatherData.fromMap(data);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<WeatherDetail>> callApiGetWeatherForecast(Position? position) async {
    try {
      final dio = Dio();
      final res = await dio.get(
          'https://api.openweathermap.org/data/2.5/forecast?lat=${position?.latitude}&lon=${position?.longitude}&units=metric&appid=${MyKey.api_token}');
      List data = res.data['list'];
      List<WeatherDetail> result = List<WeatherDetail>.from(
          data.map((e) => WeatherDetail.fromMap(e)).toList());
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
