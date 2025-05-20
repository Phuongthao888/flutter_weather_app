import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
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
    final Size size = MediaQuery.sizeOf(context);
    final tempSpots = _generateSpotsForDay(selectedDay);
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

        // --- Biểu đồ ---
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white30,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              const Text(
                'Biểu đồ Nhiệt độ (Temp)',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: LineChart(
                  LineChartData(
                    backgroundColor: Colors.black,
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      getDrawingHorizontalLine: (value) =>
                          const FlLine(color: Colors.white12, strokeWidth: 1),
                      getDrawingVerticalLine: (value) =>
                          const FlLine(color: Colors.white12, strokeWidth: 1),
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() < dayData.length) {
                              final dt =
                                  DateTime.parse(dayData[value.toInt()].dt_txt);
                              final time = DateFormat('HH').format(dt);
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(time,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white70)),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    minY: tempSpots
                            .map((e) => e.y)
                            .reduce((a, b) => a < b ? a : b) -
                        2,
                    maxY: tempSpots
                            .map((e) => e.y)
                            .reduce((a, b) => a > b ? a : b) +
                        2,
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        spots: tempSpots,
                        color: Colors.orangeAccent.shade400,
                        gradient: LinearGradient(
                          colors: [
                            Colors.orangeAccent.shade200,
                            Colors.deepOrangeAccent.shade700,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                            radius: 6,
                            color: Colors.orangeAccent.shade700,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: const LinearGradient(
                            colors: [
                              Colors.orangeAccent,
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              createTemp(data.main.temp, size: 25),
                              SizedBox(width: size.width / 10),
                              Text(
                                data.weather[0].main,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(time,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.width / 4,
                      child: Image.asset(AssetCustom.getLinkImage(data.weather[0].main)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Container lời nhắc với icon, nền nhẹ, padding, bo góc
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 165, 0, 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info, color: Colors.orangeAccent, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          alertMessage,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
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
