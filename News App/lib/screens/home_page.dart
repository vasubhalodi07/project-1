import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../config/api.dart';
import '../web/webView.dart';
import 'news_all.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future? myFuture;
  Future? myFuture1;
  bool loading = false;
  List myDataList = [];
  List sliderList = [];

  @override
  void initState() {
    myFuture = fetchApi();
    myFuture1 = sliderApi();
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
        title: Image.asset('assets/images/daily-news.png', fit: BoxFit.cover, width: width * 0.70,),
        centerTitle: true,
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.help_outline_outlined,
                  color: Color.fromRGBO(0, 21, 214, 1),
                ),
              ),
            ],
          ),
        ],
      ),

      drawer: Drawer(),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: width * 0.04, right: width * 0.04, top: height * 0.01),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              FutureBuilder<dynamic>(
                future: myFuture,
                builder: (context, snapshot) {

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

                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        FutureBuilder(
                            future: myFuture1,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator(
                                  backgroundColor: Colors.transparent,
                                  color: Colors.transparent,
                                );
                              }
                              if (snapshot.hasError) {
                                return const Center(child: Text('Something went wrong'));
                              }
                              return CarouselSlider(
                                options: CarouselOptions(
                                  viewportFraction: 0.8,
                                  autoPlayAnimationDuration: Duration(milliseconds: 400),
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                ),
                                items: [
                                  for (var i = 0; i < snapshot.data.length; i++)
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Webview(url: snapshot.data[i]['url'],),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              (snapshot.data[i]
                                              ['urlToImage'])
                                                  .runtimeType != String
                                                  ? 'https://media.istockphoto.com/id/1174341252/photo/newspaper-with-the-headline-news-and-glasses-and-coffee-cup-on-wooden-table-daily-newspaper.jpg?b=1&s=170667a&w=0&k=20&c=AmkbAgTLnDaJrWB5yWksmD9H5HZQ4DsixbPaDheEcmw='
                                                  : (snapshot.data[i]
                                              ['urlToImage']),
                                            ),
                                            fit: BoxFit.fitHeight,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Container(
                                          alignment: Alignment.bottomCenter,
                                          padding: EdgeInsets.all(20),
                                          child: Text(
                                            '${snapshot.data[i]['title']}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              color: Colors.black,
                                              backgroundColor: Colors.white54.withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            }
                        ),

                        SizedBox(height: height * 0.02,),

                        Padding(
                          padding: EdgeInsets.only(left: width * 0.020, right: width * 0.020),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Trending', style: TextStyle(fontSize: 20, color: Color.fromRGBO(0, 21, 214, 1)),),

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewsAll(),),);
                                },
                                child: Row(
                                  children: [
                                    Text('view more', style: TextStyle(fontSize: 15, color: Colors.grey.shade600,),),
                                    Icon(Icons.arrow_right, color: Colors.grey.shade600, size: 25,),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: height * 0.01,),

                        Flexible(
                          child: ListView.builder(
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
                                  // print(index);
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
                                  elevation: 1,
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
                                                      (diff >= 525960) ? '${(diff/525960).round()} year ago' :
                                                      (diff >= 43800 && diff < 525960) ? '${(diff/525960).round()} month ago' :
                                                      (diff >= 10080 && diff < 43800) ? '${(diff/10080).round()} week ago' :
                                                      (diff >= 1440 && diff < 10080) ? '${(diff/1440).round()} day ago' :
                                                      (diff >= 60 && diff < 1440) ? '${(diff/60).round()} hour ago' :
                                                      '${diff} min ago',

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
                          ),
                        ),

                      ],

                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List> fetchApi() async {
    try {
      String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
      var url = Uri.parse(
        '${Api.home_page_treading_1} $date ${Api.home_page_treading_2}',
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

  Future<List> sliderApi() async {
    try {
      String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
      var url = Uri.parse(
        '${Api.home_page_carousel_1} $date ${Api.home_page_carousel_2}',
      );
      var response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      Map<String, dynamic> data1 = json.decode(response.body);
      sliderList = data1["articles"];
      return sliderList;
    } catch (error) {
      throw error;
    }
  }
}



/*
void main() {

  var current_time = DateTime.now();
  var post_time = "2020-02-04T02:10:00Z";
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

  if(diff >= 525960) {
    print('${(diff/525960).round()} year ago');
  }
  else if(diff >= 43800 && diff < 525960) {
    print('${(diff/43800).round()} month ago');
  }
  else if(diff >= 10080 && diff < 43800) {
    print('${(diff/10080).round()} week ago');
  }
  else if(diff >= 1440 && diff < 10080) {
    print('${(diff/1440).round()} day ago');
  }
  else if(diff >= 60 && diff < 1440) {
    print('${(diff/60).round()} hour ago');
  }
  else {
    print('${diff} min ago');
  }

  (diff >= 525960) ? '${(diff/525960).round()} year ago' :
  (diff >= 43800 && diff < 525960) ? '${(diff/525960).round()} month ago' :
  (diff >= 10080 && diff < 43800) ? '${(diff/10080).round()} week ago' :
  (diff >= 1440 && diff < 10080) ? '${(diff/1440).round()} day ago' :
  (diff >= 60 && diff < 1440) ? '${(diff/60).round()} hour ago' :
  '${diff} min ago';
}

*/