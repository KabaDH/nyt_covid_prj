import 'dart:io';
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;

class APIService {

  APIService._instantiate();
  static final APIService instance = APIService._instantiate();

  final String _baseUrl = 'raw.githubusercontent.com';

  Future<List<List<dynamic>>> fetchCovidDataState() async {
    List<List<dynamic>> data = [];

    Map<String, String> parameters = {
      // 'api-key': api_key,
    };

    Uri uri = Uri.https(
      _baseUrl,
      '/nytimes/covid-19-data/master/live/us-states.csv',
      parameters,
    );

    // Map<String, String> headers = {
    //   HttpHeaders.contentTypeHeader: 'application/json',
    // };

    try {
      var _response = await http.get(uri);
      if (_response.statusCode > 400) {
        print(_response.body);
        print(_response.request);
        throw _response.statusCode.toString();
      } else {
        // print(_response.body.toString());
        data = CsvToListConverter(eol: '\n').convert(_response.body);
        return data;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<List<dynamic>>> fetchCovidDataUsa() async {
    List<List<dynamic>> data = [];

    Map<String, String> parameters = {
      // 'api-key': api_key,
    };

    Uri uri = Uri.https(
      _baseUrl,
      '/nytimes/covid-19-data/master/us.csv',
      parameters,
    );

    // Map<String, String> headers = {
    //   HttpHeaders.contentTypeHeader: 'application/json',
    // };

    try {
      var _response = await http.get(uri);
      if (_response.statusCode > 400) {
        print(_response.body);
        print(_response.request);
        throw _response.statusCode.toString();
      } else {
        // print(_response.body.toString());
        data = CsvToListConverter(eol: '\n').convert(_response.body);
        return data;
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
