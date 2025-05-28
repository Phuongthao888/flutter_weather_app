import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:weather_app/page/home/chart.dart';
import 'package:weather_app/repositories/firebase_database.dart';

import '../../../app/utils/custom.dart';
import '../../../models/weather.dart';

class DetailBody extends StatefulWidget {
  const DetailBody({super.key, required this.listData});

  final List<WeatherDetail> listData;

  @override
  State<DetailBody> createState() => _DetailBodyState();
}

class _DetailBodyState extends State<DetailBody> {
  late Map<String, List<WeatherDetail>> groupedData;
  late List<String> weekdaysSorted;
  String selectedDay = '';

  @override
  void initState() {
    super.initState();
    // Gọi lưu dữ liệu lên Firebase (chú ý await nếu async)
    saveWeatherDataToFirebase(widget.listData);

    groupedData = {};
    for (var item in widget.listData) {
      DateTime dt = DateTime.parse(item.dt_txt);
      String weekday = DateFormat('EEEE').format(dt);
      groupedData.putIfAbsent(weekday, () => []).add(item);
    }

    weekdaysSorted = groupedData.keys.toList();
    if (weekdaysSorted.isNotEmpty) {
      selectedDay = weekdaysSorted[0]; // mặc định chọn ngày đầu tiên
    }
  }

  List<FlSpot> _generateSpotsForDay(String day) {
    final List<WeatherDetail> dayData = groupedData[day]!;
    return List.generate(
      dayData.length,
      (index) => FlSpot(index.toDouble(), dayData[index].main.temp.toDouble()),
    );
  }

  List<FlSpot> _generateHumiditySpotsForDay(String day) {
    final List<WeatherDetail> dayData = groupedData[day]!;
    return List.generate(
      dayData.length,
      (index) =>
          FlSpot(index.toDouble(), dayData[index].main.humidity.toDouble()),
    );
  }

  List<FlSpot> _generateFeelLikepotsForDay(String day) {
    final List<WeatherDetail> dayData = groupedData[day]!;
    return List.generate(
      dayData.length,
      (index) =>
          FlSpot(index.toDouble(), dayData[index].main.feels_like.toDouble()),
    );
  }

  String getWeatherAlert(String weather) {
    final weatherLower = weather.toLowerCase();
    String baseMessage;

    if (weatherLower.contains('rain') || weatherLower.contains('shower')) {
      baseMessage = 'trời có mưa, bạn nhớ mang ô nhé!';
    } else if (weatherLower.contains('sunny') ||
        weatherLower.contains('clear')) {
      baseMessage = 'trời nắng, nhớ mang áo chống nắng và kính râm!';
    } else if (weatherLower.contains('cloud') ||
        weatherLower.contains('overcast')) {
      baseMessage = 'trời nhiều mây, có thể hơi âm u đấy.';
    } else if (weatherLower.contains('mist') || weatherLower.contains('fog')) {
      baseMessage = 'trời có sương mù, cẩn thận khi di chuyển!';
    } else if (weatherLower.contains('thunder')) {
      baseMessage = 'có thể có sấm chớp, hãy ở nơi an toàn!';
    } else {
      baseMessage = 'hãy kiểm tra thời tiết trước khi ra ngoài nhé!';
    }

    return 'Trong khoảng thời gian này, $baseMessage';
  }

  @override
  Widget build(BuildContext context) {
    final tempSpots = _generateSpotsForDay(selectedDay);
    final humiditySpots = _generateHumiditySpotsForDay(selectedDay);
    final feelLikeSpots = _generateFeelLikepotsForDay(selectedDay);
    final dayData = groupedData[selectedDay]!;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        // --- Dropdown chọn ngày ---
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: DropdownButton<String>(
            value: selectedDay,
            dropdownColor: Colors.black,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            iconEnabledColor: Colors.white,
            items: weekdaysSorted.map((day) {
              return DropdownMenuItem(
                value: day,
                child: Text(day),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedDay = value!;
              });
            },
          ),
        ),

        // --- Biểu đồ nhiệt độ---
        Chart(
            dayData: dayData,
            tempSpots: tempSpots,
            humiditySpots: humiditySpots,
            feelLikeSpots: feelLikeSpots,
        ),
        // --- Danh sách thời tiết của ngày được chọn ---
        Text(
          selectedDay,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 10),
        ...dayData.map((data) {
          DateTime dt = DateTime.parse(data.dt_txt);
          String time = DateFormat('HH:mm').format(dt);
          String alertMessage =
              getWeatherAlert(data.weather[0].main); // lấy thông báo nhắc nhở

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Text Thông Tin
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          infoRow(Icons.wb_sunny, "Hiện tượng",
                              data.weather[0].main),
                          const SizedBox(height: 6),
                          infoRow(Icons.thermostat, "Nhiệt độ",
                              "${data.main.temp.toStringAsFixed(1)}°C"),
                          const SizedBox(height: 6),
                          infoRow(Icons.water_drop, "Độ ẩm",
                              "${data.main.humidity.round()}%"),
                          const SizedBox(height: 6),
                          infoRow(Icons.access_time, "Thời điểm", time),
                        ],
                      ),
                    ),

                    // Ảnh thời tiết
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        AssetCustom.getLinkImage(data.weather[0].main),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Lời nhắc
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 165, 0, 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: Colors.orangeAccent, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          alertMessage,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                            color: Colors.orangeAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

Widget infoRow(IconData icon, String label, String value) {
  return Row(
    children: [
      Icon(icon, color: Colors.white70, size: 18),
      const SizedBox(width: 6),
      Text("$label: ",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          )),
      Expanded(
        child: Text(value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            )),
      ),
    ],
  );
}
