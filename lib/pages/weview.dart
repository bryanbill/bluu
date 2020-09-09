import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WeViewPage extends StatefulWidget {
  final url;

  const WeViewPage({Key key, this.url}) : super(key: key);
  @override
  _WeViewPageState createState() => _WeViewPageState();
}

class _WeViewPageState extends State<WeViewPage> {
  final _key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).canvasColor,
            title: Text("Terms of Service")),
        body: Column(
          children: [
            Expanded(
                child: WebView(
              key: _key,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: widget.url,
            ))
          ],
        ));
  }
}
