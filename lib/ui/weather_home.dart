import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_weather_app/util/util.dart' as util;
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
  String receivedData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            tooltip: "Menu",
            onPressed: () {
              _goToNextScreen(context);
            },
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
              receivedData == null || receivedData == ""
                ? util.defaultCity
                : "$receivedData",
              style: cityStyle(),
            ),
          ), //City Name
          Container(
            alignment: Alignment.center,
            child: Image.asset("images/light_rain.png"),
          ), //Rain Icon
          Container(
            alignment: Alignment.bottomLeft,
            child: updateTemperatureWidget(
              receivedData == null || receivedData == ""
                ? util.defaultCity
                : "$receivedData")), //Weather data
        ],
      ),
    );
  }

  Future _goToNextScreen(BuildContext context) async {
    //hint: Dont use "new" as its not required in dart 2.0 and using it will prevent autocomplete from working
    //hint: Type MaterialPageRoute() to get autocomplete instead of MaterialPageRoute<Map>
    var form = MaterialPageRoute<Map>(builder: (BuildContext context) {
      return ChangeCity();
    });
    Map result = await Navigator.of(context).push(form);

    if (result != null && result.containsKey('city')) {
      if (result['city'] == "")
        receivedData = util.defaultCity;
      else
        receivedData = result['city'];
    }
  }

  Future<Map> getWeather(String apiId, String cityId) async {
    final apiUrl =
      "http://api.openweathermap.org/data/2.5/forecast?q=$cityId&APPID=$apiId&units=metric";
    http.Response response = await http.get(apiUrl);
    return jsonDecode(response.body);
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

  Widget updateTemperatureWidget(String city) {
    return FutureBuilder(
      future: getWeather(util.apiId, city == "" ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map content = snapshot.data;
          if (content['cod'] == "404")
            return Text("Invalid City Name");
          else
            return Container(
            child: ListTile(
              title: Text("${content['list'][0]['main']['temp']} C",
                style: temperatureStyle(),
              ),
              subtitle: ListTile(
                title: Text(
                  "Humidity: ${content['list'][0]['main']['humidity']} \n"
                    + "Min: ${content['list'][0]['main']['temp_min']} \n"
                    + "Max: ${content['list'][0]['main']['temp_max']} \n",
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
            ),
          );
        } else {
          return Container(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class ChangeCity extends StatelessWidget {
  var _cityNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Change Ciy"),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'images/white_snow.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          ListView(
            children: <Widget>[
              ListTile(
                title: TextField(
                  controller: _cityNameController,
                  decoration: InputDecoration(labelText: "Enter City"),
                ),
              ),
              ListTile(
                title: FlatButton(
                  onPressed: () {
                    Navigator.pop(context, {'city': _cityNameController.text});
                  },
                  child: Text("Get Weather"),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
