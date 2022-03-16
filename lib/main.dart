import 'package:flutter/material.dart';
import 'package:nyt_covid_prj/screens/rootscreen.dart';
import 'package:nyt_covid_prj/services/palette.dart';
import 'screens/screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid-19 live',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Palette.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home: RootScreen(),
    );
  }
}
