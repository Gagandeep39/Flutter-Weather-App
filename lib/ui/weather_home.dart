import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_weather_app/util/util.dart';
import 'package:http/http.dart' as http;

///Created on Android Studio Canary Version
///User: Gagandeep
///Date: 03-05-2019
///Time: 10:15
///Project Name: flutter_weather_app

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            tooltip: "Menu",
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              child: Image.asset(
                "images/umbrella.png",
                fit: BoxFit.fitHeight,
                height: double.infinity, //infinity constant i.e 1/0
                width: double.infinity,
              ),
            ),
          ), //background wallpaper
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.90),
            child: Text(
              "Mumbai",
              style: cityStyle(),
            ),
          ), //City Name
          Container(
            alignment: Alignment.center,
            child: Image.asset("images/light_rain.png"),
          ), //Rain Icon
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(30.0, 290.0, 0.0, 0.0),
            child: Text(
              "26.8F",
              style: temperatureStyle(),
            ),
          ), //Weather data
        ],
      ),
    );

    Future<Map> getWeather(String apiId, String city) async {
      final apiUrl = "http://api.openweathermap.org/data/2.5/forecast?id=$cityId&APPID=$apiId&units=metric";
      http.Response response = await http.get(apiUrl);
      return jsonDecode(response.body);
    }
  }

  TextStyle temperatureStyle() {
    return TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.normal,
      fontSize: 49.9,
      fontWeight: FontWeight.w500);
  }

  TextStyle cityStyle() {
    return TextStyle(
      color: Colors.white, fontSize: 22.9, fontStyle: FontStyle.italic);
  }
}
