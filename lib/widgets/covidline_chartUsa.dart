import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:nyt_covid_prj/models/models.dart';
import 'package:nyt_covid_prj/widgets/widgets.dart';

class CovidLineChartUsa extends StatefulWidget {
  final List<SnapshotC19Usa> currentUsaSnapshot;

  const CovidLineChartUsa({required this.currentUsaSnapshot});

  _CovidLineChartUsaState createState() => _CovidLineChartUsaState();
}

class _CovidLineChartUsaState extends State<CovidLineChartUsa> {
  late double maxY;
  late List<String> botGrid;
  late List<LineChartBarData> dataLines = [];

  List<Color> gradientColors1 = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  List<Color> gradientColors2 = [
    const Color(0xfff3aaaa),
    const Color(0xfff84a4a),
  ];

  @override
  void initState() {
    super.initState();
    getItems();
  }

  getItems() {
    int indexCases = 0;
    int indexDeaths = 0;
    double _maxY = 0;
    List<String> _botGrid = [];
    List<FlSpot> _cases = [];
    List<FlSpot> _deaths = [];

    widget.currentUsaSnapshot.forEach((element) {
      _cases.add(
          FlSpot(indexCases.roundToDouble(), element.cases.roundToDouble()));
      //cохраняем все даты
      _botGrid.add(element.snapshotDate);
      indexCases++;
      if (_maxY < element.cases.toDouble()) {
        _maxY = element.cases.toDouble();
      }
      if (indexCases == widget.currentUsaSnapshot.length) {
        setState(() {
          maxY = _maxY;
          botGrid = _botGrid;
          dataLines.add(makeLineData(_cases, 1));
        });
      }
    });
    widget.currentUsaSnapshot.forEach((element) {
      _deaths.add(FlSpot(indexDeaths.toDouble(), element.deaths.toDouble()));
      indexDeaths++;
      if (indexDeaths == widget.currentUsaSnapshot.length) {
        setState(() {
          dataLines.add(makeLineData(_deaths, 2));
        });
      }
    });
  }

  ///Конструктор для самих столбиков. х - номер по порядку на оси Х для группы. y - значения столбцов (высота)
  LineChartBarData makeLineData(List<FlSpot> spots, int n) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      colors: n == 1 ? gradientColors1 : gradientColors2,
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: true,
        colors: n == 1
            ? gradientColors1.map((color) => color.withOpacity(0.3)).toList()
            : gradientColors2.map((color) => color.withOpacity(0.3)).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.only(left: 10,right: 10,top: 10),
        child: Container(
          width: double.infinity,
          height: 50,
          child: Row(
            children: [
              buildCard(
                  'cases',
                  widget.currentUsaSnapshot.last.cases.toDouble(),
                  Color(0xff02d39a)),
              buildCard(
                  'deaths',
                  widget.currentUsaSnapshot.last.deaths.toDouble(),
                  Color(0xfff84a4a)),
            ],
          ),
        ),
      ),
      Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 21/18,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  color: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 24.0, left: 12.0, top: 24, bottom: 12),
                child: LineChart(
                  mainData(),
                ),
              ),
            ),
          ),
        ],
      ),
    ]);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        // checkToShowHorizontalLine: (value) => value % 10000 == 0,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 80,
          interval: 1,
          rotateAngle: -90,
          getTextStyles: (context, value) => const TextStyle(
              color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return botGrid.first;
              case 25:
                return botGrid.elementAt(25);
              case 50:
                return botGrid.elementAt(50);
              case 75:
                return botGrid.elementAt(75);
              case 100:
                return botGrid.last;
            }
            return '';
          },
          margin: 5,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),

          ///Не обязательно указывать getTitles, оно само нарисует по каждой горизонтальной линии
          // getTitles: (value) {
          //   if (value.toInt() % 1000 == 0)
          //     return value.toInt().toString();
          //   else
          //     return '';
          // },
          reservedSize: 32,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: widget.currentUsaSnapshot.length.toDouble(),
      minY: 0,
      maxY: maxY * 1.1,
      lineBarsData: dataLines,
    );
  }
}
