import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/util.dart' as util;
import 'package:http/http.dart' as http;


class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {

  String _cityEntered;

  Future _gotToNextScreen(BuildContext context) async{
    Map results = await Navigator.of(context).push(
      new MaterialPageRoute(builder: (BuildContext context){
        return new ChangeCity();
      })
    );

    if ( results !=null && results.containsKey('enter')){
      _cityEntered = results['enter'];
      //print(results['enter'].toString());
    }
  }

  void _showData() async {
    Map data = await getWeather(util.appId, util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Klimatic'),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.menu, color: Colors.black,),
              onPressed: () {_gotToNextScreen(context);}
          ),],
      ),

      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/umbrella_pic.jpg',
            width: 490.0,
            height: 1200.0,
            fit: BoxFit.fill,
            ),

          ),
         
          // This is the City Text  
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(40.0, 40.9, 40.0, 0.0),
            child: new Text('${_cityEntered == null ? util.defaultCity : _cityEntered}',
              style: cityStyle(),),
          ),

          // light rain image
          new Container(
            alignment: Alignment.center,
            child: new Image.asset('images/light_rain.png'),
          ),

          //This is the temp value
          new Container(
            margin: const EdgeInsets.fromLTRB(30.0, 360.0, 0.0, 0.0),
            child: updateTempWidget(_cityEntered)
          ),

        ],
      ),
    );
  }

  Future<Map> getWeather(String appId, String city) async{
    String apiUrl = 'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.appId}'
        '&units=imperial';

    http.Response response = await http.get(apiUrl);

    return json.decode(response.body);

    }
    
    Widget updateTempWidget(String city){
      return new FutureBuilder(
          future: getWeather(util.appId, city == null ? util.defaultCity : city),
          builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
          // where we get all the json data, we setup widgets etc.
            if(snapshot.hasData){
              Map content = snapshot.data;
              return new Container(
               // margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
                child: new Column(
                  children: <Widget>[
                    new ListTile(
                      title: new Text(content['main']['temp'].toString() + " F" ,
                      style: new TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        fontSize: 49.9,
                        color: Colors.white
                      ),),

                      subtitle: new ListTile(
                        title: new Text(
                          "Humidity: ${content['main']['humidity'].toString()}  F \n"
                              "Min: ${content['main']['temp_min'].toString()}  F\n"
                              "Max: ${content['main']['temp_max'].toString()}  F",
                          style: extraDataStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else{
              return new Container();
            }
      });
    }
}

TextStyle cityStyle() {
  return new TextStyle(
    color: Colors.black,
    fontSize: 30.9,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w500,


  );
}

TextStyle extraDataStyle() {
  return new TextStyle(
    color: Colors.white,
    fontSize: 20.9,
    fontWeight: FontWeight.w500

  );
}




// Next Page
class ChangeCity extends StatelessWidget {

  var _cityFieldController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: new Text('Change City',
        style: new TextStyle(
          color: Colors.black
        ),),
        centerTitle: true,

      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/clouds_pic.jpg',
            width: 490.0,
            height: 1200.0,
            fit: BoxFit.fill,),
          ),

          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: 'Enter your City'
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ) ,
              new ListTile(
                title: new FlatButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'enter': _cityFieldController.text
                      });
                    },
                    textColor: Colors.black,
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


TextStyle tempStyle(){
  return new TextStyle(
    fontSize: 25.9,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );


}