import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../config/api.dart';
import '../web/webView.dart';
import 'news_details.dart';

class CategoryView extends StatefulWidget {
  var key_api, title_api;
  CategoryView({Key? key, required this.key_api, required this.title_api}) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
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
        title: Text('${widget.title_api}', style: TextStyle(color: Color.fromRGBO(0, 21, 214, 1)),),
        centerTitle: true,
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Webview(url: snapshot.data[index]['url'],),
                        ),
                      );
                    },

                    child: Card(
                      margin: EdgeInsets.only(bottom: height * 0.01),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                      child: Column(
                        children: [

                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  height: height * 0.099,
                                  margin: EdgeInsets.only(right: width * 0.025),
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
                              ),

                              Expanded(
                                flex: 4,
                                child: Container(
                                  padding: EdgeInsets.only(bottom: height * 0.004, right: width * 0.030, top: width * 0.030),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${snapshot.data[index]['title']}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                      ),

                                      SizedBox(height: height * 0.001,),

                                      Container(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          diff >= 60 ? '${(diff / 60).toInt()} hour ago' : '${diff} min ago',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
        '${Api.category_view_1} ${widget.key_api} ${Api.category_view_2}',
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

