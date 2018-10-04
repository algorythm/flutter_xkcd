import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './Xkcd.dart';

class XkcdReader {
  Xkcd _latestXkcd;
  Xkcd _currentXkcd;

  Future<Xkcd> fetchLatestXkcd() async {
    final response = await http.get('https://xkcd.com/info.0.json');

    if (response.statusCode == 200) {
      Xkcd xkcd = Xkcd.fromJson(json.decode(response.body));

      _latestXkcd = xkcd;
      _currentXkcd = _latestXkcd;

      return xkcd;
    } else {
      throw TimeoutException("Failed to load xkcd.");
    }
  }

  Future<Xkcd> fetchXkcd(int number) async {
    if (number > _latestXkcd.number || number <= 0) return null;
    final response = await http.get('https://xkcd.com/' + number.toString() + '/info.0.json');

    if (response.statusCode == 200) {
      Xkcd xkcd =  Xkcd.fromJson(json.decode(response.body));
      _currentXkcd = xkcd;
      return xkcd;
    } else {
      throw TimeoutException("Failed to load xkcd.");
    }
  }

  Future<Xkcd> nextXkcd() async {
    return await fetchXkcd(_currentXkcd.number - 1);
  }

  Future<Xkcd> previousXkcd() async {
    return await fetchXkcd(_currentXkcd.number + 1);
  }

  Xkcd get current => _currentXkcd;
  Xkcd get latest => _latestXkcd;
  bool get isLatest => _currentXkcd.number == _latestXkcd.number;
}
