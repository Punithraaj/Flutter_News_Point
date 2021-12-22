import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_news_24_7/model/article.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_news_24_7/style/theme.dart' as style;
import 'package:url_launcher/url_launcher.dart';

class DetailNews extends StatefulWidget {
  final Article article;
  const DetailNews({Key? key, required this.article}) : super(key: key);
  @override
  // ignore: no_logic_in_create_state
  _DetailNewsState createState() => _DetailNewsState(article);
}

class _DetailNewsState extends State<DetailNews> {
  final Article article;
  _DetailNewsState(this.article);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GestureDetector(
        onTap: () async {
          // if (await canLaunch(article.url)) {
          await launch(
            article.url,
            forceSafariVC: true,
            // forceWebView: true,
            enableDomStorage: true,
          );
        },
        child: Container(
          height: 48.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: HexColor("1a1a2e")),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Text(
                "Read More",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "SFPro-Bold",
                    fontSize: 15.0),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: HexColor("1a1a2e"),
        title: Text(
          article.title,
          style: TextStyle(
              fontSize: Theme.of(context).platform == TargetPlatform.iOS
                  ? 17.0
                  : 17.0,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16 / 9,
            child: FadeInImage.assetNetwork(
                alignment: Alignment.topCenter,
                placeholder: 'assets/img/placeholder.jpg',
                image: article.urlToImage.isEmpty
                    ? "http://to-let.com.bd/operator/images/noimage.png"
                    : article.urlToImage,
                fit: BoxFit.cover,
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 1 / 3),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(article.publishedAt.toString().substring(0, 10),
                        style: const TextStyle(
                            color: style.Colors.mainColor,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(article.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20.0)),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  timeUntil(article.publishedAt),
                  style: const TextStyle(color: Colors.grey, fontSize: 12.0),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Html(
                  data: article.content,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, allowFromNow: true);
  }
}
