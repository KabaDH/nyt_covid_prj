import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:nyt_covid_prj/api_services/api_service.dart';
import 'package:nyt_covid_prj/models/models.dart';
import 'package:nyt_covid_prj/services/palette.dart';
import 'package:nyt_covid_prj/widgets/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<List<dynamic>> covidData = [];
  List<SnapshotC19Usa> currentUsaSnapshot = [];
  List<SnapshotC19> currentSnapshot = [];
  late UsaState selectedState;
  bool isLoading = true;
  var s1 = Singleton.instance; //Singleton хранит значения между виджетами
  UsaState defState =
      UsaState(name: 'Alabama', flag: 'assets/images/Alabama.jpg');
  int selected = 0;

  @override
  void initState() {
    super.initState();
    selectedState = s1.usaState ?? defState;
    s1.currentIndex = 0;
    _getData();
    _getVersion();
  }

  Future<void> _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    s1.version = packageInfo.version;
    s1.build = packageInfo.buildNumber;
  }

  //загружаем данные о болезнях
  _getData() async {
    List<List<dynamic>> _covidData = [];
    List<List<dynamic>> _covidDataUsa = [];

    _covidData = await APIService.instance.fetchCovidDataState();
    _covidDataUsa = await APIService.instance.fetchCovidDataUsa();

    setState(() {
      covidData = _covidData;

      fetchSnapShot();
      fetchSnapShotUsa(_covidDataUsa.sublist(
          _covidDataUsa.length - 300, _covidDataUsa.length));
    });
  }

  //приводим данные по штатам в понятный вид для работы
  fetchSnapShot() async {
    List<SnapshotC19> _currentSnapshot = [];
    int index = 0;
    covidData.skip(1).forEach((element) {
      _currentSnapshot.add(SnapshotC19.fromCSV(element));
      index++;
      if (index == covidData.length - 1) {
        setState(() {
          currentSnapshot = _currentSnapshot;
        });
      }
    });
  }

//Получаем информацию в целом по стране
  fetchSnapShotUsa(List<List<dynamic>> data) async {
    List<SnapshotC19Usa> _currentSnapshotUsa = [];
    int index = 0;
    data.forEach((element) {
      _currentSnapshotUsa.add(SnapshotC19Usa.fromCSV(element));
      index++;
      if (index == data.length) {
        setState(() {
          currentUsaSnapshot = _currentSnapshotUsa.sublist(
              _currentSnapshotUsa.length - 100, _currentSnapshotUsa.length);
        });
      }
    });
  }

  SliverToBoxAdapter _snapshot(double screenHeight, double screenWidth) {
    return SliverToBoxAdapter(
        child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Palette.primaryColor,
        border: null,
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        covidData.isEmpty
            ? CircularProgressIndicator()
            : Text(
                'Latest snapshot ${covidData[1][0]}',
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              )
      ]),
    ));
  }

  SliverToBoxAdapter _selectionSection(
      double screenHeight, double screenWidth) {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () => s1.currentIndex = 1,
        child: Container(
          height: screenHeight * 0.1,
          width: screenWidth,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Palette.primaryColor,
            border: null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.all(5),
                  height: screenHeight * 0.1,
                  width: screenWidth * 0.25,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(selectedState.flag))),
              Container(
                  height: screenHeight * 0.1,
                  width: screenWidth * 0.5,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    selectedState.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.05),
                  )),
              Container(
                  padding: EdgeInsets.only(right: 10),
                  height: screenHeight * 0.1,
                  decoration: BoxDecoration(
                    border: null,
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  child: Icon(
                    Icons.filter_list,
                    color: Colors.black,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  SliverPadding _stateGlobalselector(double screenHeight, double screenWidth) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 5),
      sliver: SliverToBoxAdapter(
        child: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Container(
            color: Palette.primaryColor,
            padding: EdgeInsets.all(15),
            height: 50,
            child: TabBar(
              physics: ClampingScrollPhysics(),
              unselectedLabelColor: Colors.white30,
              onTap: (index) {
                setState(() {
                  selected = index;
                });
              },
              indicator: BubbleTabIndicator(
                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                  indicatorHeight: 40,
                  indicatorColor: Palette.secondaryColor,
                  indicatorRadius: 40,
                  padding: EdgeInsets.all(10)),
              tabs: [
                Text(
                  'State',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'All USA',
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: CustomAppbar(),
        drawer: CustomDrawer(),
        body: CustomScrollView(
          physics: ClampingScrollPhysics(),
          slivers: [
            _snapshot(screenHeight, screenWidth),
            _selectionSection(screenHeight, screenWidth),
            _stateGlobalselector(screenHeight, screenWidth),
            selected == 0
                ? currentSnapshot.isEmpty
                    ? SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()))
                    : SliverPadding(
                        padding: EdgeInsets.only(top: 5),
                        sliver: SliverToBoxAdapter(
                          child: CovidBarChart(
                              currentSnapshot: currentSnapshot,
                              usaState: selectedState),
                        ),
                      )
                : currentUsaSnapshot.isEmpty
                    ? SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()))
                    : SliverPadding(
                        padding: EdgeInsets.only(top: 5),
                        sliver: SliverToBoxAdapter(
                          child: CovidLineChartUsa(
                            currentUsaSnapshot: currentUsaSnapshot,
                          ),
                        ),
                      )
          ],
        ));
  }
}
