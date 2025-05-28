import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/my_app.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:weather_app/page/home/auth/auth_screen.dart';

/*
  - Yêu cầu thiết bị cho phép truy cập vị trí hiện tại lat&lon
  - Lên pub.dev gõ: geolocator, để yêu cầu hệ thống cấp quyền
  - Thêm nội dung sau vào tệp "gradle.properties"
    android.useAndroidX=true
    android.enableJetifier=true
  - Mở tệp AndroidManifest.xml
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
 */
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBPUZeUQnQXlgbytnTd24XBRLFBlME4xio",
        authDomain: "weather-8788b.firebaseapp.com",
        databaseURL: "https://weather-8788b-default-rtdb.firebaseio.com",
        projectId: "weather-8788b",
        storageBucket: "weather-8788b.firebasestorage.app",
        messagingSenderId: "337409264740",
        appId: "1:337409264740:web:9539ce12be12ea8b362371",
        measurementId: "G-ZR6ZN08VFX"
      ),
    );
  } else {
    await Firebase.initializeApp(); // Android/iOS lấy từ file json
  }

  // Lấy vị trí người dùng (hàm bạn đã định nghĩa)
  // Position positionCurrent = await _determinePosition();

  // Chạy app truyền vị trí
  runApp(const AppEntry());
}
class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
      future: _determinePosition(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: FirebaseAuth.instance.currentUser == null
              ? const AuthScreen()
              : MyApp(positionCurrent: snapshot.data!),
        );
      },
    );
  }
}