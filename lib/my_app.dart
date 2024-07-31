import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/app/config/theme_custom.dart';
import 'package:weather_app/app/config/bottom_custom.dart';
import 'package:weather_app/providers/weather_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key , required this.positionCurrent});
  final Position positionCurrent;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      /* bọc nó lại, để bất kỳ màn hình nào trong MyApp cũng có thể lấy nó ra
      để sử dụng */
      create: (_) => WeatherProvider()..updatePosition(positionCurrent),
      child: MaterialApp(
        theme: ThemeCustom.themeLight,
        debugShowCheckedModeBanner: false,
        home: const BottomCustom(),
      ),
    );
  }
}
