import 'package:flutter/material.dart';

class NewsDetails extends StatefulWidget {
  final source, author, description, url, urlToImage, publishedAt, content, title;
  const NewsDetails({Key? key,
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  }) : super(key: key);

  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color.fromRGBO(0, 21, 214, 1),),
        // actions: [
        //   IconButton(onPressed: (){}, icon: const Icon(Icons.share_outlined, color: Color.fromRGBO(0, 21, 214, 1),),),
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              height: height * 0.25,
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(5),
                image: DecorationImage(
                  image: NetworkImage(
                    '${
                        widget.urlToImage.runtimeType != String ?
                        'https://media.istockphoto.com/id/1174341252/photo/newspaper-with-the-headline-news-and-glasses-and-coffee-cup-on-wooden-table-daily-newspaper.jpg?b=1&s=170667a&w=0&k=20&c=AmkbAgTLnDaJrWB5yWksmD9H5HZQ4DsixbPaDheEcmw=' :
                        '${widget.urlToImage}'
                    }',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            
            Container(
              padding: EdgeInsets.only(left: width * 0.035, right: width * 0.035, top: height * 0.010),
              child: Text(
                '${widget.title}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: width * 0.035, right: width * 0.035, top: height * 0.010),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                   children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage('assets/images/profile.png'),
                      ),

                      Container(
                        padding: EdgeInsets.only(left: width * 0.01),
                        width: width * 0.480,
                        child: Text(
                          '${widget.author == null ? 'unknown' : widget.author}',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(left: width * 0.020),
                    child: Text(
                      '${widget.publishedAt >= 60
                          ? '${(widget.publishedAt / 60).toInt()} hour ago'
                          : '${widget.publishedAt} min ago'}',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),

                ],
              ),
            ),

            Container(
              padding: EdgeInsets.only(left: width * 0.035, right: width * 0.035, top: height * 0.010),
              child: Text(
                '${widget.description}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.only(left: width * 0.035, right: width * 0.035, top: height * 0.010),
              child: Text(
                'Source Link : ${widget.url == null ? 'Not Avaliable' : widget.url}',
                style: TextStyle(
                  fontSize: 16, color: Colors.grey.shade600
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

