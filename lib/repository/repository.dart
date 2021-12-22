// import 'dart:async';

// import 'package:newsapi/newsapi.dart';

// class NewsRepository {
//   NewsApi newsApi = NewsApi(
//     debugLog: true,
//     apiKey: '3c8673ddff2f42eb81b5dfe63aec7be0',
//   );

//   Future<SourceResponse> getSources() async {
//     return await newsApi.sources(language: "en", country: "us");
//   }

//   Future<ArticleResponse> getTopHeadlines() async {
//     return await newsApi.topHeadlines(country: "us");
//   }

//   Future<ArticleResponse> search(String value) async {
//     return await newsApi.everything(q: value, sortBy: "popularity");
//   }

//   Future<ArticleResponse> getHotNews() async {
//     return await newsApi.everything(q: "covid", sortBy: "popularity");
//   }

//   Future<ArticleResponse> getSourceNews(String sourceId) async {
//     return await newsApi.topHeadlines(sources: sourceId);
//   }
// }

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_news_24_7/model/article_response.dart';
import 'package:flutter_news_24_7/model/source_response.dart';

class NewsRepository {
  static String mainUrl = "https://newsapi.org/v2/";
  final String apiKey = "b22389aad8184ae1a8378ca74922e8ec";

  final Dio _dio = Dio();

  var getSourcesUrl = '$mainUrl/sources';
  var getTopHeadlinesUrl = '$mainUrl/top-headlines';
  var everythingUrl = "$mainUrl/everything";

  Future<SourceResponse> getSources() async {
    var params = {"apiKey": apiKey, "language": "en", "country": "us"};
    try {
      Response response =
          await _dio.get(getSourcesUrl, queryParameters: params);
      return SourceResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      // ignore: avoid_print
      print("Exception occured: $error stackTrace: $stacktrace");
      return SourceResponse.withError("$error");
    }
  }

  Future<ArticleResponse> getTopHeadlines() async {
    var params = {"apiKey": apiKey, "country": "us"};
    try {
      Response response =
          await _dio.get(getTopHeadlinesUrl, queryParameters: params);
      return ArticleResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      // ignore: avoid_print
      print("Exception occured: $error stackTrace: $stacktrace");
      return ArticleResponse.withError("$error");
    }
  }

  Future<ArticleResponse> search(String value) async {
    var params = {"apiKey": apiKey, "q": value, "sortBy": "popularity"};
    try {
      Response response =
          await _dio.get(everythingUrl, queryParameters: params);
      return ArticleResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      // ignore: avoid_print
      print("Exception occured: $error stackTrace: $stacktrace");
      return ArticleResponse.withError("$error");
    }
  }

  Future<ArticleResponse> getHotNews() async {
    var params = {"apiKey": apiKey, "q": "apple", "sortBy": "popularity"};
    try {
      Response response =
          await _dio.get(everythingUrl, queryParameters: params);
      return ArticleResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      // ignore: avoid_print
      print("Exception occured: $error stackTrace: $stacktrace");
      return ArticleResponse.withError("$error");
    }
  }

  Future<ArticleResponse> getSourceNews(String sourceId) async {
    var params = {"apiKey": apiKey, "sources": sourceId};
    try {
      Response response =
          await _dio.get(getTopHeadlinesUrl, queryParameters: params);
      return ArticleResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      // ignore: avoid_print
      print("Exception occured: $error stackTrace: $stacktrace");
      return ArticleResponse.withError("$error");
    }
  }
}
