import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:weather_app/models/weather.dart';

class Chart extends StatefulWidget {
  const Chart({
    super.key,
    required this.dayData,
    required this.tempSpots,
    required this.humiditySpots, required this.feelLikeSpots,
  });

  final List<WeatherDetail> dayData;
  final List<FlSpot> tempSpots;
  final List<FlSpot> humiditySpots;
  final List<FlSpot> feelLikeSpots;

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _goToPage(int index) {
    if (index >= 0 && index < 3) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildChartContainer(
                title: 'Biểu đồ cảm nhận nhiệt độ của bạn',
                spots: widget.feelLikeSpots,
                dayData: widget.dayData,
              ),
              _buildChartContainer(
                title: 'Biểu đồ Nhiệt độ',
                spots: widget.tempSpots,
                dayData: widget.dayData,
              ),
              _buildChartContainer(
                title: 'Biểu đồ Độ ẩm',
                spots: widget.humiditySpots,
                dayData: widget.dayData,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => _goToPage(_currentPage - 1),
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
            SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: const WormEffect(
                dotColor: Colors.white30,
                activeDotColor: Colors.orangeAccent,
                dotHeight: 10,
                dotWidth: 10,
              ),
            ),
            IconButton(
              onPressed: () => _goToPage(_currentPage + 1),
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChartContainer({
    required String title,
    required List<FlSpot> spots,
    required List<WeatherDetail> dayData,
  }) {
    final minY = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 2;
    final maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 2;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            // height: 300,
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
                          final dt = DateTime.parse(dayData[value.toInt()].dt_txt);
                          final time = DateFormat('HH').format(dt);
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              time,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white70),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                minY: minY,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    spots: spots,
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
    );
  }
}
