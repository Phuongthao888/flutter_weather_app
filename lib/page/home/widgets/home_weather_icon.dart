import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/app/utils/Custom.dart';

class HomeWeatherIcon extends StatelessWidget {
  const HomeWeatherIcon({super.key, required this.nameIcon});
  final String nameIcon;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context); // Vị trí theo tỉ lệ tùy màn hình
    return Container(
      width: size.width / 2,
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(
        top: size.height / 19,
      ),
      child: Image.asset(
        AssetCustom.getLinkImage(nameIcon),
        fit: BoxFit.cover,
      ),
    );
  }
}
