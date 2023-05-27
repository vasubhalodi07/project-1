import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webview extends StatefulWidget {
  var url;
  Webview({Key? key, required this.url}) : super(key: key);

  @override
  State<Webview> createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {

  late WebViewController controller;
  double webProgess = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web View', style: TextStyle(color: Color.fromRGBO(0, 21, 214, 1)),),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(0, 21, 214, 1),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [

          webProgess < 1 ?
            SizedBox(
              child: LinearProgressIndicator(
                value: webProgess,
                color: Color.fromRGBO(0, 21, 214, 1),
                backgroundColor: Colors.white,
              ),
              ) : SizedBox(),

          Expanded(
            child: WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: widget.url,
              onWebViewCreated: (controller) {
                this.controller = controller;
              },
              onProgress: (progess) => setState(() {
                this.webProgess = progess / 100;
              }),
            ),
          ),
        ],
      ),
    );
  }
}

