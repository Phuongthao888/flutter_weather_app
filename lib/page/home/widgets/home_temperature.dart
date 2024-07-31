import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/app/utils/Custom.dart';

class HomeTemperature extends StatelessWidget {
  const HomeTemperature({super.key, required this.MyTemp});
  final num MyTemp;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: createTemp(MyTemp)
    );
  }
}
