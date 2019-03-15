import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../util/utils.dart' as util;


class Klimatic extends StatefulWidget {
   @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {

  String _cityEntered;

  Future _goToNextScreen(BuildContext context) async {
    Map result = await Navigator.of(context).push(
      new MaterialPageRoute<Map>(builder: (BuildContext context){
        return new ChangeCity();
      })
    );

    if(result != null && result.containsKey('enter')){
      _cityEntered = result['enter'];
    }
  }

  void showWeather() async {
   Map data = await getWeather(util.apiId, util.defaultCity);
   print(data.toString());
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('WeatherApp'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.edit_location),
              tooltip: "Enter City",
              iconSize: 40.0,
              onPressed: () {_goToNextScreen(context);})

        ],
      ),

      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/homescreen.png',width: 490.0,
            height: 1200.0,
            fit: BoxFit.fill,),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: new Text(
              '${_cityEntered == null? util.defaultCity: _cityEntered}',
            style: cityStyle(),),
          ),
//          new Container(
//            alignment: Alignment.center,
//            child: new Image.asset('images/light_rain.png'),
//          ),

          //Contain weather data
          new Container(
            //margin: const EdgeInsets.fromLTRB(30.0, 320.0, 0.0, 0.0),
            child: updateTempWidget(_cityEntered),
          )
        ],
      ),
    );
  }

 Future<Map> getWeather(String appId, String city) async {
  String apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$appId&units=metric";
  http.Response response = await http.get(apiUrl);
  return json.decode(response.body);
 }

 Widget updateTempWidget(String city) {
    return new FutureBuilder(
      future: getWeather(util.apiId, city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
        //get all of the json data
          if(snapshot.hasData){
            Map content = snapshot.data;
            if(content['main'] != null){
            return new Container(
              margin: const EdgeInsets.fromLTRB(10.0, 270.0, 0.0, 5.0),
              child: new Column(
                children: <Widget>[
                  new Expanded(
                      child: new ListTile(
                        trailing: new Image.network('https://openweathermap.org/img/w/'+content['weather'][0]['icon']+'.png',
                          scale: 0.4,),
                        title: new Text(content['main']['temp'].toString()+"°C",
                          style: tempStyle(),),
                        subtitle: new ListTile(
                          title: new Text(
                            "Country: ${content['sys']['country']}\n"
                                "City: ${content['name']}\n"
                                "Humidity: ${content['main']['humidity'].toString()}%\n"
                                "Min: ${content['main']['temp_min'].toString()}°C\n"
                                "Max: ${content['main']['temp_max'].toString()}°C\n"
                                "Weather Description: ${content['weather'][0]['description']}",
                            style: extraData(),

                          ),
                        ),
                      ))

                ],
              ),
            );
            }else{

              return new Container(
                margin: const EdgeInsets.fromLTRB(30.0, 340.0, 0.0, 0.0),
                child: new Column(
                  children: <Widget>[
                    new ListTile(
                      title: new Text("No Data",
                        style: tempStyle(),),

                    )
                  ],
                ),
              );

            }
          }else{
            return new Container();
          }

    });
 }

}

class ChangeCity extends StatelessWidget {
  var _cityFieldController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text("Change City"),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/entercity.png',
            width: 490.0,
            height: 1200.0,
            fit: BoxFit.fill,),
          ),

          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: 'Enter City',
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
              new ListTile(
                title: new FlatButton(
                    onPressed: (){
                      Navigator.pop(context,{
                        'enter': _cityFieldController.text
                      });
                    },
                    textColor: Colors.white70,
                    color: Colors.redAccent,
                    child: new Text('Get Weather')),
              )
            ],
          )

        ],

      ),
    );
  }
}


TextStyle cityStyle(){
  return new TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic
  );
}

TextStyle tempStyle(){
  return new TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 49.9
  );
}

TextStyle extraData(){
  return new TextStyle(
      color: Colors.white70,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.bold,
      fontSize: 17.0
  );
}