import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_24_7/bloc/get_top_headlines_bloc.dart';
import 'package:flutter_news_24_7/elements/error_element.dart';
import 'package:flutter_news_24_7/elements/loader_element.dart';
import 'package:flutter_news_24_7/model/article.dart';
import 'package:flutter_news_24_7/model/article_response.dart';
import 'package:flutter_news_24_7/repository/repository.dart';
import 'package:flutter_news_24_7/screens/news_detail.dart';
import 'package:flutter_news_24_7/utility/utility.dart';
import 'package:timeago/timeago.dart' as timeago;

class HeadlingSliderWidget extends StatefulWidget {
  const HeadlingSliderWidget({Key? key}) : super(key: key);

  @override
  _HeadlingSliderWidgetState createState() => _HeadlingSliderWidgetState();
}

class _HeadlingSliderWidgetState extends State<HeadlingSliderWidget> {
  final NewsRepository _repository = NewsRepository();
  @override
  void initState() {
    super.initState();
    getTopHeadlinesBloc.getHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleResponse>(
      stream: getTopHeadlinesBloc.subject.stream,
      builder: (context, AsyncSnapshot<ArticleResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.error.isNotEmpty) {
            return buildErrorWidget(snapshot.data!.error);
          }
          return _buildHeadlineSliderWidget(snapshot.data!);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.error.toString());
        } else {
          return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildHeadlineSliderWidget(ArticleResponse data) {
    List<Article>? articles = data.articles;
    return CarouselSlider(
        options: CarouselOptions(
          enlargeCenterPage: false,
          height: 180.0,
          viewportFraction: 0.7,
        ),
        items: getExpenseSliders(articles));
  }

  getExpenseSliders(List<Article> articles) {
    return articles
        .map(
          (article) => GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailNews(
                            article: article,
                          )));
            },
            child: Container(
              padding: const EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
              child: Stack(
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Utility.getImageCompnent(article.urlToImage)),
                  )),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: const [
                            0.1,
                            0.9
                          ],
                          colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.white.withOpacity(0.0)
                          ]),
                    ),
                  ),
                  Positioned(
                      bottom: 30.0,
                      child: Container(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        width: 250.0,
                        child: Column(
                          children: <Widget>[
                            Text(
                              article.title,
                              style: const TextStyle(
                                  height: 1.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0),
                            ),
                          ],
                        ),
                      )),
                  Positioned(
                      bottom: 10.0,
                      left: 10.0,
                      child: Text(
                        article.source.name,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 9.0),
                      )),
                  Positioned(
                      bottom: 10.0,
                      right: 10.0,
                      child: Text(
                        timeUntil(article.publishedAt),
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 9.0),
                      )),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }

  getImageCompnent(String img) {
    return img.isEmpty
        ? const AssetImage("assets/img/placeholder.jpg")
        : NetworkImage(img);
  }
}
