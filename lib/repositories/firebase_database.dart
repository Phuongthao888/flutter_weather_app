import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/weather.dart';

Future<void> saveWeatherDataToFirebase(List<WeatherDetail> listData) async {
  final database = FirebaseDatabase.instance.ref('weather_data');
  try {
    Map<String, List<WeatherDetail>> grouped = {};
    for (var item in listData) {
      DateTime dt = DateTime.parse(item.dt_txt);
      String dateKey = DateFormat('yyyy-MM-dd').format(dt);
      grouped.putIfAbsent(dateKey, () => []).add(item);
    }

    for (var entry in grouped.entries) {
      String dateKey = entry.key;
      List<WeatherDetail> dayList = entry.value;

      Map<String, dynamic> dayMap = {};
      for (var wd in dayList) {
        dayMap[wd.dt_txt] = wd.toJson();
      }

      await database.child(dateKey).set(dayMap);
    }
    print('Lưu dữ liệu lên Firebase thành công.');
  } catch (e) {
    print('Lỗi khi lưu dữ liệu: $e');
  }
}

