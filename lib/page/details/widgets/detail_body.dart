import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/utils/Custom.dart';
import '../../../models/weather.dart';

class DetailBody extends StatelessWidget {
  const DetailBody({super.key, required this.listData});
  final List<WeatherDetail> listData;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (context, index) {
        DateTime dateTime = DateTime.parse(listData[index].dt_txt);
        String formatWeekdays = DateFormat('EEEE').format(dateTime);
        String formatTime = DateFormat('HH:MM').format(dateTime);
        return Container(
          // List Card thời tiết
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white30, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  // List chi tiết trong Card
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        createTemp(listData[index].main.temp, size: 25),
                        SizedBox(width: size.width / 10,),
                        Text(
                          listData[index].weather[0].main,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    Text(
                      formatWeekdays,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      formatTime,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: size.width / 4,
                child: Image.asset(AssetCustom.getLinkImage(listData[index].weather[0].main)),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 15,
      ),
      itemCount: 10,
    );
  }
}
