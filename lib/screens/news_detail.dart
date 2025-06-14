import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_news_24_7/model/article.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_news_24_7/style/theme.dart' as style;
import 'package:url_launcher/url_launcher.dart';

class DetailNews extends StatelessWidget {
  final Article article;

  const DetailNews({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GestureDetector(
        onTap: () async {
          final String rawUrl = article.url.trim();
          if (rawUrl.isEmpty || !rawUrl.startsWith('http')) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid article URL')),
            );
            return;
          }

          final Uri url = Uri.parse(rawUrl);

          // Try opening in in-app WebView
          if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
            // Fallback to external browser
            if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not launch article')),
              );
            }
          }
        },
        child: Container(
          height: 48.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: HexColor("1a1a2e")),
          child: const Center(
            child: Text(
              "Read More",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "SFPro-Bold",
                fontSize: 15.0,
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: HexColor("1a1a2e"),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          article.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Hero(
              tag: article.urlToImage,
              child: _buildNewsImage(article.urlToImage),
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10.0),
                  Text(
                    DateFormat('yyyy-MM-dd').format(article.publishedAt),
                    style: const TextStyle(
                      color: style.Colors.mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    timeago.format(article.publishedAt, allowFromNow: true),
                    style: const TextStyle(color: Colors.grey, fontSize: 12.0),
                  ),
                  const SizedBox(height: 5.0),
                  Html(data: article.content),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsImage(String imageUrl) {
    final fallbackImage =
        'https://via.placeholder.com/640x360.png?text=No+Image';

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: FadeInImage.assetNetwork(
        placeholder: 'assets/img/placeholder.jpg',
        image: imageUrl.isEmpty ? fallbackImage : imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        imageErrorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/img/placeholder.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
          );
        },
      ),
    );
  }
}
