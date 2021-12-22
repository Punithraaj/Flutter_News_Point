import 'package:flutter/material.dart';
import 'package:flutter_news_24_7/bloc/get_sources_bloc.dart';
import 'package:flutter_news_24_7/model/source.dart';
import 'package:flutter_news_24_7/model/source_response.dart';
import 'package:flutter_news_24_7/repository/repository.dart';
import 'package:flutter_news_24_7/screens/source_detail.dart';
import 'package:flutter_news_24_7/style/theme.dart' as style;

class TopChannelsWidget extends StatefulWidget {
  const TopChannelsWidget({Key? key}) : super(key: key);

  @override
  _TopChannelsWidgetState createState() => _TopChannelsWidgetState();
}

class _TopChannelsWidgetState extends State<TopChannelsWidget> {
  final NewsRepository _repository = NewsRepository();

  @override
  void initState() {
    super.initState();
    getSourcesBloc.getSources();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SourceResponse>(
      stream: getSourcesBloc.subject.stream,
      builder: (context, AsyncSnapshot<SourceResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.error != null && snapshot.data!.error.isNotEmpty) {
            return Container();
          }
          return _buildSourcesWidget(snapshot.data!);
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildSourcesWidget(SourceResponse data) {
    List<Source> sources = data.sources;
    if (sources.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: const <Widget>[
                Text(
                  "No More Sources",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.27,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          scrollDirection: Axis.horizontal,
          itemCount: sources.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.only(top: 10.0, right: 0.0),
              width: 80.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SourceDetail(
                                source: sources[index],
                              )));
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: sources[index].id.toString(),
                        child: Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(
                                    1.0,
                                    1.0,
                                  ),
                                )
                              ],
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      "assets/logos/${sources[index].id}.png")),
                            )),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        sources[index].name,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            height: 1.4,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0),
                      ),
                      const SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        sources[index].category.toString(),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            height: 1.4,
                            color: style.Colors.secondColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 9.0),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
