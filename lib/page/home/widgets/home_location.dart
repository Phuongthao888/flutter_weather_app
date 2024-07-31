import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class HomeLocation extends StatelessWidget {
  const HomeLocation({super.key, required this.nameLocation});
  final String nameLocation;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final datetime_format = DateFormat('dd/MM/yyyy HH:mm');
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/icons/location.png'),
            SizedBox(width: size.width / 50,),
             Text(
              nameLocation.toString(),
              style: const TextStyle(
                fontSize: 25
              ),
            ),
          ],
        ),
        Text(
          datetime_format.format(DateTime.now()),
          style: const TextStyle(
              fontSize: 20
          ),
        ),
      ],
    );
  }
}
