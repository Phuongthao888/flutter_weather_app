import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/app/utils/custom.dart';

class HomeTemperature extends StatelessWidget {
  const HomeTemperature({super.key, required this.myTemp});
  final num myTemp;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: createTemp(myTemp)
    );
  }
}
