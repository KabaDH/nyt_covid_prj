import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nyt_covid_prj/services/palette.dart';
import 'screens/screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(MyApp()));
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
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: RootScreen(),
    );
  }
}
