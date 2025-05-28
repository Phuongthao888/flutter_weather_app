import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/app/config/theme_custom.dart';
import 'package:weather_app/app/config/bottom_custom.dart';
import 'package:weather_app/providers/user_provider.dart';
import 'package:weather_app/providers/weather_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key , required this.positionCurrent});
  final Position positionCurrent;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WeatherProvider()..updatePosition(positionCurrent),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),  // thêm UserProvider ở đây
        ),
      ],
      child: MaterialApp(
        theme: ThemeCustom.themeLight,
        debugShowCheckedModeBanner: false,
        home: const BottomCustom(),
      ),
    );

  }
}
