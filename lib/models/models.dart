class UsaState {
  String name;
  String flag;

  UsaState({required this.name, required this.flag});
}

class SnapshotC19 {
  String stateC19;
  int cases;
  int deaths;
  int confirmed_cases;
  int confirmed_deaths;
  int probable_cases;
  int probable_deaths;
  String snapshotDate;

  SnapshotC19(
      {required this.stateC19,
      required this.cases,
      required this.deaths,
      required this.confirmed_cases,
      required this.confirmed_deaths,
      required this.probable_cases,
      required this.probable_deaths,
      required this.snapshotDate});

  factory SnapshotC19.fromCSV(List<dynamic> covidDataRow) {
    return SnapshotC19(
        stateC19: covidDataRow[1].toString(),
        cases: covidDataRow[3],
        deaths: covidDataRow[4],
        confirmed_cases: covidDataRow[5] == '' ? 0 : covidDataRow[5],
        confirmed_deaths: covidDataRow[6] == '' ? 0 : covidDataRow[6],
        probable_cases: covidDataRow[7] == '' ? 0 : covidDataRow[7],
        probable_deaths: covidDataRow[8] == '' ? 0 : covidDataRow[8],
        snapshotDate: covidDataRow[0].toString());
    // stateC19: 'Hi',
    // cases: 1,
    // deaths: 1,
    // confirmed_cases: 1,
    // confirmed_deaths: 1,
    // probable_cases: 1,
    // probable_deaths: 1,
    // snapshotDate: 'ddd');
  }
}

class SnapshotC19Usa {
  String snapshotDate;
  int cases;
  int deaths;

  SnapshotC19Usa(
      {required this.snapshotDate, required this.cases, required this.deaths});

  factory SnapshotC19Usa.fromCSV(List<dynamic> covidDataRow) {
    return SnapshotC19Usa(
      snapshotDate: covidDataRow[0].toString(),
      cases: covidDataRow[1],
      deaths: covidDataRow[2],
    );

  }
}
