import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_news_24_7/bloc/get_source_news_bloc.dart';
import 'package:flutter_news_24_7/elements/loader.dart';
import 'package:flutter_news_24_7/model/article.dart';
import 'package:flutter_news_24_7/model/article_response.dart';
import 'package:flutter_news_24_7/model/source.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'news_detail.dart';

class SourceDetail extends StatefulWidget {
  final Source source;
  const SourceDetail({Key? key, required this.source}) : super(key: key);
  @override
  // ignore: no_logic_in_create_state
  _SourceDetailState createState() => _SourceDetailState(source);
}

class _SourceDetailState extends State<SourceDetail> {
  final Source source;
  _SourceDetailState(this.source);
  @override
  void initState() {
    super.initState();
    getSourceNewsBloc.getSourceNews(source.id.toString());
  }

  @override
  void dispose() {
    getSourceNewsBloc.drainStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            centerTitle: false,
            elevation: 0.0,
            backgroundColor: HexColor("1a1a2e"),
            title: const Text(
              "",
            )),
      ),
      body: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
            color: HexColor("1a1a2e"),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Hero(
                  tag: source.id.toString(),
                  child: SizedBox(
                      height: 80.0,
                      width: 80.0,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 2.0, color: Colors.white),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/logos/${source.id}.png"),
                                fit: BoxFit.cover)),
                      )),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  source.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  source.description.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: StreamBuilder<ArticleResponse>(
            stream: getSourceNewsBloc.subject.stream,
            builder: (context, AsyncSnapshot<ArticleResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.error.isNotEmpty) {
                  return Container();
                }
                return _buildSourceNewsWidget(snapshot.data!);
              } else if (snapshot.hasError) {
                return Container();
              } else {
                return buildLoadingWidget();
              }
            },
          ))
        ],
      ),
    );
  }

  Widget _buildSourceNewsWidget(ArticleResponse data) {
    List<Article> articles = data.articles;

    if (articles.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Text(
              "No more news",
              style: TextStyle(color: Colors.black45),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailNews(
                              article: articles[index],
                            )));
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200, width: 1.0),
                  ),
                  color: Colors.white,
                ),
                height: 150,
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 10.0, bottom: 10.0, right: 10.0),
                      width: MediaQuery.of(context).size.width * 3 / 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(articles[index].title,
                              maxLines: 3,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14.0)),
                          Expanded(
                              child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(timeUntil(articles[index].publishedAt),
                                        style: const TextStyle(
                                            color: Colors.black26,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0))
                                  ],
                                ),
                              ],
                            ),
                          ))
                        ],
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.only(right: 10.0),
                        width: MediaQuery.of(context).size.width * 2 / 5,
                        height: 130,
                        child: FadeInImage.assetNetwork(
                            alignment: Alignment.topCenter,
                            placeholder: 'assets/img/placeholder.jpg',
                            image: articles[index].urlToImage.isEmpty
                                ? "http://to-let.com.bd/operator/images/noimage.png"
                                : articles[index].urlToImage,
                            fit: BoxFit.fitHeight,
                            width: double.maxFinite,
                            height: MediaQuery.of(context).size.height * 1 / 3))
                  ],
                ),
              ),
            );
          });
    }
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}
