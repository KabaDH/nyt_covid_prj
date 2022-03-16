import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nyt_covid_prj/models/models.dart';
import 'package:nyt_covid_prj/widgets/widgets.dart';

class CovidBarChart extends StatefulWidget {
  final List<SnapshotC19> currentSnapshot;
  final UsaState usaState;

  const CovidBarChart({required this.currentSnapshot, required this.usaState});

  _CovidBarChartState createState() => _CovidBarChartState();
}

class _CovidBarChartState extends State<CovidBarChart> {
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color middleBarColor = const Color(0xff7fdb4f);
  final Color rightBarColor = const Color(0xffff5182);
  final BorderRadius barCorners = BorderRadius.only(
      bottomRight: Radius.zero,
      bottomLeft: Radius.zero,
      topLeft: Radius.circular(5),
      topRight: Radius.circular(5));
  final double width = 60;
  late double maxY;
  late double grid;
  var graphData = [];

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  @override
  void initState() {
    super.initState();
    //Выбираем штат
    int d = widget.currentSnapshot.indexWhere((element) =>
        element.stateC19 ==
        widget.usaState.name); //находим какая строка нам нужна
    SnapshotC19 _stateSnapshot =
        widget.currentSnapshot.elementAt(d); //забираем эту строку

    List<double> _graphData = [
      _stateSnapshot.cases.toDouble(),
      _stateSnapshot.confirmed_cases.toDouble(),
      _stateSnapshot.probable_cases.toDouble(),
    ];
    // List<double> _graphData = [6254, 1145, 650];

    setState(() {
      graphData = _graphData;
      maxY = getMaxY();
    });

    final barGroup1 = makeGroupData(
      0,
      _graphData[0],
      _graphData[1],
      _graphData[2],
    );

    final items = [
      barGroup1,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  getMaxY() {
    double _maxValue = max(graphData[0], max(graphData[1], graphData[2]));
    return _maxValue * 1.1;
  }

  @override
  Widget build(BuildContext context) {
    //Не обязательно, но позволяет сохранять пропорции квадрата (чтобы ничего не съезжало)
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10,bottom: 10),
        child: Row(
          children: [
            buildCard('cases', graphData[0], leftBarColor),
            buildCard('confirmed_cases', graphData[1], middleBarColor),
            buildCard('probable_cases', graphData[2], rightBarColor),
          ],
        ),
      ),
      AspectRatio(
        aspectRatio: 25/ 18,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                ///Expanded нужно, чтобы график встраивался в размеры карточки
                Expanded(
                  ///Основной виджет
                  child: BarChart(
                    BarChartData(
                      //понятно что это
                      maxY: maxY,

                      ///Не обязательно. Обработка касаний к графику. При касании вычисляется среднее из значений столбцов группы и оба столбца приравниваются к этому значению
                      barTouchData: BarTouchData(enabled: false),

                      ///Подписи с разных сторон
                      titlesData: FlTitlesData(
                        ///можно отключить
                        show: true,
                        rightTitles: SideTitles(showTitles: false),
                        topTitles: SideTitles(showTitles: false),
                        bottomTitles: SideTitles(
                          showTitles: false,
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (context, value) => const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          margin: 8,
                          reservedSize: 50,
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: showingBarGroups,
                      //определяем подписи значений Y и сетку
                      gridData: FlGridData(
                        show: true,
                        checkToShowHorizontalLine: (value) => value % 100 == 0,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.white30,
                          strokeWidth: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }

  ///Конструктор для самих столбиков. х - номер по порядку на оси Х для группы. y - значения столбцов (высота)
  BarChartGroupData makeGroupData(int x, double y1, double y2, double y3) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      ///первый столбец
      BarChartRodData(
        y: y1,
        colors: [leftBarColor],
        width: width,
        borderRadius: barCorners,
      ),

      ///второй столбец
      BarChartRodData(
        y: y2,
        colors: [middleBarColor],
        width: width,
        borderRadius: barCorners,
      ),

      ///третий столбец
      BarChartRodData(
        y: y3,
        colors: [rightBarColor],
        width: width,
        borderRadius: barCorners,
      ),
    ]);
  }
}
