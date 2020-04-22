import 'dart:collection';
import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;

class NewsUtil {
  
  Map<String, Object> dm = new LinkedHashMap();
  static String _api = "YOUR_SECRET_KEY";
  String _url = "http://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=$_api";

  Future<Map<String, Object>> getNews() async{
    Map<String, Object> news = new LinkedHashMap();
    var response = await http.get(_url);
    news['data'] = json.decode(response.body);
    dm['getNews'] = news['data'];
    return news['data'];
  }
}
