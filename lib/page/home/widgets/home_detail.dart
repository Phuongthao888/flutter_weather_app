import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeDetail extends StatelessWidget {
  const HomeDetail({super.key, required this.mySpeed, required this.myHumidity, this.height});
  final num mySpeed;
  final num myHumidity;
  final double? height;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: size.height / 50,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Image.asset(
                'assets/images/icons/Vector.png',
                fit: BoxFit.cover,
                height: height,
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 15
                ),
                child: Text(
                  '$mySpeed Km/h',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/icons/humidity.png',
                fit: BoxFit.cover,
                height: height,
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: 15
                ),
                child: Text(
                  '${myHumidity.round()} %',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
