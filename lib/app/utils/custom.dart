
import 'package:flutter/material.dart';
/*
 - Format tên hình ảnh lại 1 kiểu nhất định.
 - Set API KEY ở đây, sau có cần đổi KEY thì chỉ cần thay ở đây
 - Nhiều vị trí cần gọi đến nhiệt độ, nên ở đây ta làm phương thức chung
*/


const MyLinkAsset = 'assets/images/weathers/';

class AssetCustom {
  static String getLinkImage(String name) =>
      '$MyLinkAsset${name.replaceAll(' ', 'replace').toLowerCase()}.png';
}

class MyKey {
  static const String api_token = 'e346c05cd29f1a5ffd0f3d12f1043498';
}

Widget createTemp(num MyTemp, {double size = 100}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        MyTemp.round().toString(),
        style: TextStyle(
          fontSize: size,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        '0',
        style: TextStyle(
          fontSize: size / 3,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        'C',
        style: TextStyle(
          fontSize: size,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
