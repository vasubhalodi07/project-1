import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../web/webView.dart';
import 'news_details.dart';

class NewsAll extends StatefulWidget {
  const NewsAll({Key? key}) : super(key: key);

  @override
  State<NewsAll> createState() => _NewsAllState();
}

class _NewsAllState extends State<NewsAll> {
  Future? myFuture;
  bool loading = false;
  List myDataList = [];

  @override
  void initState() {
    myFuture = fetchApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    var current_time = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(0, 21, 214, 1),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: width * 0.04, right: width * 0.04, top: height * 0.01),
          child: FutureBuilder<dynamic>(
            future: myFuture,
            builder: (context, snapshot) {
              ///Condition
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                );
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  print((snapshot.data[index]['urlToImage']).runtimeType);

                  var post_time = snapshot.data[index]['publishedAt'];
                  var startTime = post_time.split("T");

                  var date_time = DateTime(
                    int.parse(startTime[0].substring(0, 4)),
                    int.parse(startTime[0].substring(5, 7)),
                    int.parse(startTime[0].substring(8, 10)),
                    int.parse(startTime[1].substring(0, 2)),
                    int.parse(startTime[1].substring(3, 5)),
                    int.parse(startTime[1].substring(6, 8)),
                  );
                  var diff = current_time.difference(date_time).inMinutes;

                  return GestureDetector(
                    onTap : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Webview(
                            url: snapshot.data[index]['url'],
                          )
                        )
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [

                          Container(
                            height: height * 0.23,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),

                              image: DecorationImage(
                                image: NetworkImage(
                                  (snapshot.data[index]
                                  ['urlToImage'])
                                      .runtimeType !=
                                      String
                                      ? 'https://media.istockphoto.com/id/1174341252/photo/newspaper-with-the-headline-news-and-glasses-and-coffee-cup-on-wooden-table-daily-newspaper.jpg?b=1&s=170667a&w=0&k=20&c=AmkbAgTLnDaJrWB5yWksmD9H5HZQ4DsixbPaDheEcmw='
                                      : (snapshot.data[index]
                                  ['urlToImage']),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),


                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(left: width * 0.03, right: width * 0.05, top: height * 0.01),
                            child: Text(
                              '${snapshot.data[index]['title']}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(
                                fontSize: 17.0,
                              ),
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.only(right: width * 0.03, bottom: height * 0.01),
                            alignment: Alignment.topRight,
                            child: Text(
                              '${diff>= 60
                                  ? '${(diff / 60).toInt()} hour ago'
                                  : '${diff} min ago'}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<List> fetchApi() async {
    try {
      String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
      var url = Uri.parse(
        'https://newsapi.org/v2/everything?q=all&from=$date&sortBy=publishedAt&language=en&apiKey=a749057a8437429bbe3f8e604b15da9f',
      );
      var response = await http.get(url);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      Map<String, dynamic> data1 = json.decode(response.body);
      myDataList = data1["articles"];
      return myDataList;
    } catch (error) {
      throw error;
    }
  }
}

