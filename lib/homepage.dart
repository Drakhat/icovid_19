import 'dart:convert';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:icovid19/pages/countryPage.dart';
import 'package:icovid19/pages/indiaPage.dart';
import 'package:icovid19/panels/indiaPanel.dart';
import 'package:icovid19/panels/infoPanel.dart';
import 'package:icovid19/panels/mostaffectedcountries.dart';
import 'package:icovid19/panels/worldwidepanel.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';

import 'datasource.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map worldData;
  fetchWorldWideData() async {
    http.Response response = await http.get('https://corona.lmao.ninja/v2/all');
    setState(() {
      worldData = json.decode(response.body);
    });
  }

  List indiaData2;
  String indiaData1;
  fetchIndiaData() async {
    http.Response response =
        await http.get('https://api.covid19india.org/data.json');
    setState(() {
      indiaData1 = response.body;
      var tagsJson = jsonDecode(indiaData1)['statewise'];
      indiaData2 = tagsJson != null ? List.from(tagsJson) : null;
    });
  }

  List countryData;
  fetchCountryData() async {
    http.Response response =
        await http.get('https://corona.lmao.ninja/v2/countries?sort=cases');
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  Future fetchData() async {
    fetchWorldWideData();
    fetchCountryData();
    fetchIndiaData();
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent[100],
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'iCOVID-19',
        ),
        backgroundColor: appBarColor,
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 100,
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage('images/homepage_banner.png'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'WORLDWIDE',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: "RobotoCondensed"),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CountryPage()));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: regColor,
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Regional',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: "RobotoCondensed"),
                          )),
                    ),
                  ],
                ),
              ),
              worldData == null
                  ? CircularProgressIndicator()
                  : WorldwidePanel(
                      worldData: worldData,
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: Text(
                  'Most Affected Countries',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: "RobotoCondensed"),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              countryData == null
                  ? Container()
                  : MostAffectedPanel(
                      countryData: countryData,
                    ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'INDIA',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: "RobotoCondensed"),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IndiaPage()));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: regColor,
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Regional ',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: "RobotoCondensed"),
                          )),
                    ),
                  ],
                ),
              ),
              indiaData2 == null
                  ? CircularProgressIndicator()
                  : IndiaPanel(
                      indiaData2: indiaData2,
                    ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 30,
              ),
              InfoPanel(),
              SizedBox(
                height: 15,
              ),
              Center(
                  child: Text(
                'STAY AWARE!!',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: "RobotoCOndensed",
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              )),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}
