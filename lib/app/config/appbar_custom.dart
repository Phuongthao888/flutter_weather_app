import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/page/details/widgets/detail_body.dart';

import '../../providers/weather_provider.dart';

class AppbarCustom extends StatelessWidget{
  const AppbarCustom({super.key, required this.nameLocation});
  final String nameLocation;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return FutureBuilder(
        future: context.read<WeatherProvider>().getWeatherCurrentForecast(),
        builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(!snapshot.hasData){
            return const Center(
                child: CircularProgressIndicator(),
            );
          }
          List<WeatherDetail> listData = snapshot.data as List<WeatherDetail>;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              children: [
                const Icon(CupertinoIcons.location),
                SizedBox(
                  width: size.width / 20,
                ),
                AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      nameLocation.toString(),
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      speed: const Duration(milliseconds: 100),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              const Icon(CupertinoIcons.search),
              SizedBox(
                width: size.width / 20,
              )
            ],
          ),
          body: DetailBody(listData: listData,),
        );
      }
    );
  }

}