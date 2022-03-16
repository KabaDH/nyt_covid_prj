import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:nyt_covid_prj/api_services/api_service.dart';
import 'package:nyt_covid_prj/models/models.dart';
import 'package:nyt_covid_prj/services/palette.dart';

import 'package:nyt_covid_prj/widgets/widgets.dart';

class StateSelect extends StatefulWidget {
  @override
  _StateSelectState createState() => _StateSelectState();
}

class _StateSelectState extends State<StateSelect> {
  List<List<dynamic>> covidData = [];
  Map<String, String> flags = {};
  bool isLoading = true;
  var s1 = Singleton.instance;

  @override
  void initState() {
    super.initState();
    s1.usaState ??=
        UsaState(name: 'Alabama', flag: 'assets/images/Alabama.jpg');
    s1.currentIndex = 1;
    _getData();
  }

  _getData() async {
    List<List<dynamic>> _covidData = [];
    _covidData = await APIService.instance.fetchCovidDataState();
    setState(() {
      covidData = _covidData;
      loadFlags(); // добавляем сюда, а не в initState, т.к. initState не async и запускает их синхронно, не дожидаясь результата первой функции
      // print(covidData.toString());
    });
  }

//1 Проверяем, можно ли загрузить флаг из локальных assets
  static Future<bool> isLocalAsset(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (_) {
      return false;
    }
  }

  //2 Проверяем, если нельзя загрузить индивидуальный флаг, ставим флаг страны
  Future<String> fetchFlag(String assetPath) async {
    bool haveSource = await isLocalAsset(assetPath);
    // print(haveSource.toString());
    if (haveSource) {
      return assetPath;
    } else
      return 'assets/images/usa.jpg';
  }

  //3 Загрузка всех флагов в список при загрузке страницы
  loadFlags() async {
    Map<String, String> _flags = {};
    int _index = 0;
    covidData.skip(1).forEach((element) async {
      // print(element[1].toString());
      _flags['${element[1]}'] =
          await fetchFlag('assets/images/${element[1]}.jpg');
      _index++;
      if (_index == covidData.length - 1) {
        setState(() {
          flags = _flags;
          isLoading = false;
          // print(flags.toString());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var border = Border.all(color: Colors.lightBlueAccent, width: 5);

    return Scaffold(
      appBar: CustomAppbar(),
      drawer: CustomDrawer(),
      body: Center(
        child: Container(
          // child: covidData.isEmpty ? CircularProgressIndicator() : Text('${covidData[2][0]}'),
          child: isLoading
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount: covidData.length - 1,
                  itemBuilder: (context, i) {
                    var _currentState = covidData[i][1].toString();
                    return i == 0
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                s1.usaState = UsaState(
                                    name: covidData[i][1].toString(),
                                    flag: flags[_currentState] ??
                                        'assets/images/usa.jpg');
                                print(s1.currentIndex);
                                s1.currentIndex = 0;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: i % 2 == 0
                                    ? Palette.thirdColor
                                    : Palette.primaryColor,
                                border: s1.usaState!.name ==
                                        covidData[i][1].toString()
                                    ? border
                                    : null,
                              ),
                              child: Row(children: [
                                Image.asset(
                                  flags[_currentState] ??
                                      'assets/images/usa.jpg',
                                  height: 60,
                                  width: 90,
                                  // filterQuality: FilterQuality.low,
                                ),
                                SizedBox(width: 10,),
                                Text(_currentState, style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16,letterSpacing: 1.2),),
                              ]),
                            ),
                          );
                  }),
        ),
      ),
    );
  }
}
