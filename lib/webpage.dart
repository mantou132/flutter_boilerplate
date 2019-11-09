import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import './utils.dart';
import './eventbus.dart';
import './config.dart';

class WebPage extends StatelessWidget {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  final String url;
  WebPage(this.url);

  _close(BuildContext context) {
    Navigator.pop(context);
  }

  JavascriptChannel _getJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: '__MT__APP__BRIDGE',
      onMessageReceived: (JavascriptMessage message) {
        try {
          var msg = json.decode(message.message);
          var type = msg['type'];
          switch (type) {
            case 'close':
              _close(context);
              break;
          }
        } finally {
          print(message.message);
        }
      }
    );
  }

  NavigationDecision _navigationDelegate(BuildContext context, NavigationRequest request) {
    print('webpage============>$request');
    if (isExternalUrl(request.url)) {
      return NavigationDecision.navigate;
    } else {
      Navigator.pop(context);
      eventBus.fire(HomePageChangeEvent(request.url));
      return NavigationDecision.prevent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TODO: color
        backgroundColor: Colors.white,
        // TODO: change title
        title: const Text('Flutter WebView example'),
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          debuggingEnabled: DEBUG,
          javascriptChannels: <JavascriptChannel>[
            _getJavascriptChannel(context),
          ].toSet(),
          navigationDelegate: (NavigationRequest request) {
            return _navigationDelegate(context, request);
          },
        );
      }),
    );
  }
}
