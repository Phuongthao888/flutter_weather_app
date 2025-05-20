/*
     - ở Provider nên là nơi quản lý các giá trị.
     - Lấy các biến, các giá trị đổ ra bên ngoài.
     - Còn lại, CALL API sẽ được thực hiện ở Repositories.

     - Mục đích của việc chuyển đổi các MAP là khi chỉ cần . thì sẽ nhắc lệnh
     cho chúng ta các giá trị, thì khi cần giá trị gì ta có thể lấy nó ra.
*/

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:home_widget/home_widget.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/repositories/api_repository.dart';

class WeatherProvider extends ChangeNotifier {
  /*
    -  Ta truyền positionCurrent vào trong position
   */
  Position? position;

  updatePosition(Position positionCurrent){
    position = positionCurrent;
    notifyListeners();
  }

  Future<WeatherData> getWeatherCurrent() async {
    WeatherData result = await ApiRepository.callApiGetWeather(position);
    return result;
  }

  Future<List<WeatherDetail>> getWeatherCurrentForecast() async {
    List<WeatherDetail> result = await ApiRepository.callApiGetWeatherForecast(position);
    return result;
  }

  Future<void> updateHomeWidget(WeatherData data) async {
    await HomeWidget.saveWidgetData('city', data.name);
    await HomeWidget.saveWidgetData('temperature', '${data.main.temp.round()}°C');
    await HomeWidget.saveWidgetData('description', data.weather[0].main);
    await HomeWidget.updateWidget(
      androidName: 'WeatherWidgetProvider',
    );
  }
}
