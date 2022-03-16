import 'package:nyt_covid_prj/models/models.dart';

class Singleton {
  static final Singleton _singleton = new Singleton._internal();
  Singleton._internal();
  static Singleton get instance => _singleton;
  UsaState? usaState;
  int? currentIndex;
}