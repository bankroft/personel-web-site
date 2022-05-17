import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WeiboWebView extends StatefulWidget {
  const WeiboWebView({
    Key? key,
    this.url = "https://flutter.dev",
    this.title = "Flutter",
  }) : super(key: key);
  final String url;
  final String title;
  @override
  WeiboWebViewState createState() => WeiboWebViewState();
}

class WeiboWebViewState extends State<WeiboWebView> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
