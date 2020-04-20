import 'dart:convert';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:icovid19/pages/countryPage.dart';
import 'package:icovid19/pages/indiaPage.dart';
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
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Theme.of(context).brightness == Brightness.light
                  ? Icons.lightbulb_outline
                  : Icons.highlight),
              onPressed: () {
                DynamicTheme.of(context).setBrightness(
                    Theme.of(context).brightness == Brightness.light
                        ? Brightness.dark
                        : Brightness.light);
              })
        ],
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
                padding: EdgeInsets.all(5),
                child: Image(
                  image: AssetImage('images/homepage_banner.png'),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'WORLDWIDE :',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                                fontWeight: FontWeight.bold),
                          )),
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
                            'India',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
                  'Most Affected Countries :',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                height: 20,
              ),
              InfoPanel(),
              SizedBox(
                height: 50,
              ),
              Center(
                  child: Text(
                'STAY AWARE!',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    color: Colors.deepPurple),
              )),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
