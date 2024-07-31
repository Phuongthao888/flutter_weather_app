import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/app/config/appbar_custom.dart';

import '../../models/weather.dart';
import '../../providers/weather_provider.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<WeatherProvider>().getWeatherCurrent(),
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(!snapshot.hasData){
            return const Text('no data');
          }
          WeatherData data = snapshot.data as WeatherData;
        return Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff1D6CF3),
                Color(0xff19D2FE),
              ],
            ),
          ),
          child: AppbarCustom(nameLocation: data.name,),
        );
      }
    );
  }
}
