/*
 - Ta đã tạo được các giá trị phù hợp với các giá trị mà ta call từ API về.
 - Tiếp theo, ta sẽ tạo 1 link, gọi đến API để chuyển đổi từ cascp Map trả về
 thành đối tượng WeatherData của mình
*/

import 'dart:convert';


class Weather {
  int id;
  String main;
  String description;

  Weather(this.id, this.main, this.description);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'main': main,
      'description': description,
    };
  }

  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
        map['id'] as int, map['main'] as String, map['description'] as String);
  }

  String toJson() => json.encode(toMap());

  factory Weather.fromJson(String source) =>
      Weather.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Main {
  num temp;
  num feels_like;
  num temp_min;
  num temp_max;
  num pressure;
  num humidity;
  num sea_level;
  num grnd_level;

  Main(this.temp, this.feels_like, this.temp_min, this.temp_max, this.pressure,
      this.humidity, this.sea_level, this.grnd_level);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'temp': temp,
      'feels_like': feels_like,
      'temp_min': temp_min,
      'temp_max': temp_max,
      'pressure': pressure,
      'humidity': humidity,
      'sea_level': sea_level,
      'grnd_level': grnd_level,
    };
  }

  factory Main.fromMap(Map<String, dynamic> map) {
    return Main(
      map['temp'] as num,
      map['feels_like'] as num,
      map['temp_min'] as num,
      map['temp_max'] as num,
      map['pressure'] as num,
      map['humidity'] as num,
      map['sea_level'] as num,
      map['grnd_level'] as num,
    );
  }

  String toJson() => json.encode(toMap());

  factory Main.fromJson(String source) =>
      Main.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Wind {
  num speed;
  num deg;

  Wind(this.speed, this.deg);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'speed': speed,
      'deg': deg,
    };
  }

  factory Wind.fromMap(Map<String, dynamic> map) {
    return Wind(
      map['speed'] as num,
      map['deg'] as num,
    );
  }

  String toJson() => json.encode(toMap());

  factory Wind.fromJson(String source) =>
      Wind.fromMap(json.decode(source) as Map<String, dynamic>);
}

class WeatherData {
  int id;
  List<Weather> weather;
  String base;
  Main main;
  int visibility;
  Wind wind;
  String name;
  int cod;

  WeatherData(this.id, this.weather, this.base, this.main, this.visibility,
      this.wind, this.name, this.cod);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'weather': weather.map((x) => x.toMap()).toList(),
      'base': base,
      'main': main.toMap(),
      'visibility': visibility,
      'wind': wind.toMap(),
      'name': name,
      'cod': cod,
    };
  }

  factory WeatherData.fromMap(Map<String, dynamic> map) {
    return WeatherData(
      map['id'] as int,
      List<Weather>.from(
        (map['weather'] as List).map<Weather>(
          (x) => Weather.fromMap(x as Map<String, dynamic>),
        ),
      ),
      map['base'] as String,
      Main.fromMap(map['main'] as Map<String, dynamic>),
      map['visibility'] as int,
      Wind.fromMap(map['wind'] as Map<String, dynamic>),
      map['name'] as String,
      map['cod'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory WeatherData.fromJson(String source) =>
      WeatherData.fromMap(json.decode(source) as Map<String, dynamic>);
}

class WeatherDetail {
  Main main;
  List<Weather> weather;
  String dt_txt;

  WeatherDetail(this.main, this.weather, this.dt_txt);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'main': main.toMap(),
      'weather': weather.map((x) => x.toMap()).toList(),
      'dt_txt': dt_txt,
    };
  }

  factory WeatherDetail.fromMap(Map<String, dynamic> map) {
    return WeatherDetail(
      Main.fromMap(map['main'] as Map<String, dynamic>),
      List<Weather>.from(
        (map['weather'] as List).map<Weather>(
              (x) => Weather.fromMap(x as Map<String, dynamic>),
        ),
      ),
      map['dt_txt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WeatherDetail.fromJson(String source) =>
      WeatherDetail.fromMap(json.decode(source) as Map<String, dynamic>);
}
