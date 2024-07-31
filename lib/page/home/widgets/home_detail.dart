import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeDetail extends StatelessWidget {
  const HomeDetail({super.key, required this.MySpeed, required this.MyHumidity});
  final num MySpeed;
  final num MyHumidity;
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
                height: 40,
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 15
                ),
                child: Text(
                  MySpeed.toString() + ' Km/h',
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
                height: 40,
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: 15
                ),
                child: Text(
                  MyHumidity.round().toString() + ' %',
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
