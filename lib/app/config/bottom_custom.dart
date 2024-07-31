import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/page/details/detail_page.dart';
import 'package:weather_app/page/home/home_page.dart';

class BottomCustom extends StatefulWidget {
  const BottomCustom({super.key});

  @override
  State<BottomCustom> createState() => _BottomCustomState();
}

class _BottomCustomState extends State<BottomCustom> {
  List<BottomNavigationBarItem> ListHandleItems = [
    const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.home), label: 'Home'),
    const BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.list_bullet), label: 'Detail'),
  ];

  List<Widget> listWidget = [const HomePage(), const DetailPage()];
  int activePage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true, //làm cho đối tượng tràn màn hình
      body: listWidget[activePage],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: activePage,
          //Chọn icon nào thì nổi icon đó lên dựa vào các thuộc tính phía dưới
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          backgroundColor: Colors.lightBlueAccent,
          elevation: 0,
          onTap: (index) {
            setState(() {
              activePage = index;
            });
          },
          items: ListHandleItems),
    );
  }
}
