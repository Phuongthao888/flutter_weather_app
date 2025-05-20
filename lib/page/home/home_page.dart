import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/page/home/widgets/home_detail.dart';
import 'package:weather_app/page/home/widgets/home_weather_icon.dart';
import 'package:weather_app/page/home/widgets/home_location.dart';
import 'package:weather_app/page/home/widgets/home_temperature.dart';
import 'package:weather_app/providers/weather_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // Khi mở app ra thì nó gọi luôn phương thức ra
    super.initState();
    context.read<WeatherProvider>().getWeatherCurrent();
  }

  String getWeatherAlert(String weather) {
    final weatherLower = weather.toLowerCase();
    String baseMessage;

    if (weatherLower.contains('rain') || weatherLower.contains('shower')) {
      baseMessage = 'trời có mưa, bạn nhớ mang ô nhé!';
    } else if (weatherLower.contains('sunny') || weatherLower.contains('clear')) {
      baseMessage = 'trời nắng, nhớ mang áo chống nắng và kính râm!';
    } else if (weatherLower.contains('cloud') || weatherLower.contains('overcast')) {
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
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2C2C2C),
              Color(0xFF121212),
            ],
          ),
        ),
        child: FutureBuilder(
          future: context.read<WeatherProvider>().getWeatherCurrent(),
          initialData: null,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return const Text('no data');
            }
            WeatherData data = snapshot.data as WeatherData;
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HomeWeatherIcon(nameIcon: data.weather[0].main),
                  HomeTemperature(myTemp: data.main.temp),
                  HomeLocation(nameLocation: data.name),
                  HomeDetail(
                    mySpeed: data.wind.speed,
                    myHumidity: data.main.humidity,
                  ),
                  weatherAlertCard(getWeatherAlert(data.weather[0].main)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget weatherAlertCard(String message) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xD936260F), // deepOrange.shade900 + 85% opacity
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Color(0xB936260F), // deepOrange.shade900 + 70% opacity
          blurRadius: 12,
          offset: Offset(0, 6),
          spreadRadius: 1,
        ),
        BoxShadow(
          color: Color(0x80000000), // black + 50% opacity
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
      border: Border.all(
        color: const Color(0xE9363B0F), // deepOrangeAccent.shade700 + 90% opacity
        width: 1.5,
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0x26FFFFFF), // white + 15% opacity
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8),
          child: const Icon(
            Icons.info,
            color: Colors.white70,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              shadows: [
                Shadow(
                  color: Color(0x8A000000), // black54 ~ 54% opacity
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

