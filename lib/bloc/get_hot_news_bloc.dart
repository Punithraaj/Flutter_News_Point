import 'package:flutter_news_24_7/model/article_response.dart';
import 'package:flutter_news_24_7/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetHotNewsBloc {
  final NewsRepository _repository = NewsRepository();
  final BehaviorSubject<ArticleResponse> _subject =
      BehaviorSubject<ArticleResponse>();

  getHotNews() async {
    try {
    ArticleResponse response = await _repository.getHotNews();
    _subject.sink.add(response);
    } catch (error) {
    _subject.sink.add(ArticleResponse.withError(error.toString()));
    }
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<ArticleResponse> get subject => _subject;
}

final getHotNewsBloc = GetHotNewsBloc();
