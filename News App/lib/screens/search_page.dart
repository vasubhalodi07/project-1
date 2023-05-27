import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api.dart';
import '../web/webView.dart';

class SearchNews extends StatefulWidget {
  const SearchNews({Key? key}) : super(key: key);
  @override
  State<SearchNews> createState() => _SearchNewsState();
}

class _SearchNewsState extends State<SearchNews> {
  Future? myFuture;
  bool loading = false;
  List myDataList = [];
  var TotalResult = 0;

  var SearchFilec = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    var current_time = DateTime.now();

    return Material(
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.white,
          title: TextField(
            controller: SearchFilec,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    SearchFilec.clear();
                  });
                },
              ),
              prefixIcon: GestureDetector(
                onTap: ()  {
                  setState(() {
                    myFuture = fetchApi(SearchFilec.text);
                  });
                },
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
              ),
              hintText: 'Search...',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // onChanged: (value) {
            //   setState(() {
            //     myFuture = fetchApi(SearchFilec.text);
            //   });
            // },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(
              left: width * 0.04, right: width * 0.04, top: height * 0.02),
          child: FutureBuilder<dynamic>(
            future: myFuture,
            builder: (context, snapshot) {
              print(TotalResult);

              if (SearchFilec.text == '') {
                return Center(
                  child: Text(
                    "Search Something...",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.indigo,
                    ),
                  ),
                );
              } else if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.pink,
                  ),
                );
              } else if (TotalResult == 0) {
                return Center(
                  child: Text(
                    "Not Found",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.indigo,
                    ),
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
                      // print(index);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Webview(
                            url: snapshot.data[index]['url'],
                          ),
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
                                        (snapshot.data[index]['urlToImage'])
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
                                  padding: EdgeInsets.only(
                                      bottom: height * 0.004,
                                      right: width * 0.030,
                                      top: width * 0.030),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${snapshot.data[index]['title']}',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.001,
                                      ),
                                      Container(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          (diff >= 525960)
                                              ? '${(diff / 525960).round()} year ago'
                                              : (diff >= 43800 && diff < 525960)
                                                  ? '${(diff / 525960).round()} month ago'
                                                  : (diff >= 10080 &&
                                                          diff < 43800)
                                                      ? '${(diff / 10080).round()} week ago'
                                                      : (diff >= 1440 &&
                                                              diff < 10080)
                                                          ? '${(diff / 1440).round()} day ago'
                                                          : (diff >= 60 &&
                                                                  diff < 1440)
                                                              ? '${(diff / 60).round()} hour ago'
                                                              : '${diff} min ago',
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

  Future<List> fetchApi(String search) async {
    setState(() {
      loading = true;
    });
    try {
      var url = Uri.parse(
        '${Api.search_page_1} $search ${Api.search_page_2}',
      );
      var response = await http.get(url);
      setState(() {
        loading = false;
      });

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      Map<String, dynamic> data1 = json.decode(response.body);
      myDataList = data1["articles"];

      setState(() {
        TotalResult = data1["totalResults"];
      });

      return myDataList;
    } catch (error) {
      setState(() {
        loading = false;
      });
      throw error;
    }
  }
}
