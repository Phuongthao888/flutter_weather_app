import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/page/home/widgets/home_detail.dart';
import 'package:weather_app/page/home/widgets/home_weather_icon.dart';
import 'package:weather_app/page/home/widgets/home_location.dart';
import 'package:weather_app/page/home/widgets/home_temperature.dart';
import 'package:weather_app/providers/user_provider.dart';
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
    } else
    if (weatherLower.contains('sunny') || weatherLower.contains('clear')) {
      baseMessage = 'trời nắng, nhớ mang áo chống nắng và kính râm!';
    } else
    if (weatherLower.contains('cloud') || weatherLower.contains('overcast')) {
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

  String getGreetingMessage(String username) {
    final hour = DateTime.now().hour;
    String greeting;

    if (hour >= 5 && hour < 11) {
      greeting = 'Chào buổi sáng';
    } else if (hour >= 11 && hour < 14) {
      greeting = 'Chào buổi trưa';
    } else if (hour >= 14 && hour < 18) {
      greeting = 'Chào buổi chiều';
    } else {
      greeting = 'Chào buổi tối';
    }

    return '$greeting, $username';
  }


  @override
  Widget build(BuildContext context) {
    final username = context
        .watch<UserProvider>()
        .username;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2C2C),
        title: Text(
          getGreetingMessage(username),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
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
        child: Column(
          children: [
            Expanded(
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
                          height: 40,
                        ),
                        weatherAlertCard(getWeatherAlert(data.weather[0].main)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget weatherAlertCard(String message) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFF696969),
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.4),
          blurRadius: 15,
          offset: Offset(0, 8),
        ),
      ],
      border: Border.all(
        color: const Color.fromRGBO(255, 255, 255, 0.2),
        width: 1.5,
      ),
    ),
    child: Row(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.2),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(10),
          child: const Icon(
            Icons.info_outline,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.4,
              shadows: [
                Shadow(
                  color: Colors.black54,
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


