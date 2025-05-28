import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/weather.dart';

Future<void> saveWeatherDataToFirebase(List<WeatherDetail> listData) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    // print('Chưa đăng nhập, không thể lưu dữ liệu.');
    return;
  }

  final database = FirebaseDatabase.instance.ref('weather_data/$uid');

  try {
    // Nhóm theo ngày yyyy-MM-dd
    Map<String, List<WeatherDetail>> grouped = {};
    for (var item in listData) {
      DateTime dt = DateTime.parse(item.dt_txt);
      String dateKey = DateFormat('yyyy-MM-dd').format(dt);
      grouped.putIfAbsent(dateKey, () => []).add(item);
    }

    for (var entry in grouped.entries) {
      String dateKey = entry.key;
      List<WeatherDetail> newList = entry.value;

      // Lấy dữ liệu cũ của ngày đó từ Firebase
      final snapshot = await database.child(dateKey).get();
      Map<String, dynamic> oldData = {};
      if (snapshot.exists) {
        oldData = Map<String, dynamic>.from(snapshot.value as Map);
      }

      // Gộp dữ liệu mới vào, ghi đè những dt_txt trùng
      for (var wd in newList) {
        oldData[wd.dt_txt] = wd.toJson();
      }

      // Ghi lại toàn bộ dữ liệu đã gộp
      await database.child(dateKey).set(oldData);
    }

    // print('Cập nhật dữ liệu thời tiết cho user $uid thành công.');
  } catch (e) {
    // print('Lỗi khi cập nhật dữ liệu thời tiết: $e');
  }
}


