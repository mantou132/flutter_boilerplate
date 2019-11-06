import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';

const startUrl = 'http://192.168.0.102:8080';

var isIOS = defaultTargetPlatform == TargetPlatform.iOS;

class App extends StatelessWidget {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  JavascriptChannel _javascriptChannel(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    var data = {
      'notch': {
        // ios webview env support notch
        'left': isIOS ? 0 : padding.left,
        'top': isIOS ? 0 : padding.top,
        'right': isIOS ? 0 : padding.right,
        'bottom': isIOS ? 0 : padding.bottom,
      }
    };
    var base64Str = base64.encode(utf8.encode(jsonEncode(data)))
      .replaceAll(new RegExp(r'=+$'), '');

    return JavascriptChannel(
      // js 能用同步的方式解析出数据
      name: '__FLUTTER__MT__BRIDGE____$base64Str',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }
    );
  }

  Future<bool> _onWillPop() async {
    var controller = await _controller.future;
    if (await controller.canGoBack()) {
      controller.goBack();
      return false;
    } else {
      // exit app
      return true;
    }
  }

  @override
  Widget build(BuildContext _context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) {
          // MediaQuery must use MaterialApp context
          if (MediaQuery.of(context).padding.top > 28) {
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
            ));
          }
          return WillPopScope(
            onWillPop: _onWillPop,
            child: WebView(
              initialUrl: startUrl,
              javascriptChannels: <JavascriptChannel>[
                _javascriptChannel(context),
              ].toSet(),
              debuggingEnabled: true,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              navigationDelegate: (NavigationRequest request) {
                print('============>$request');
                if (request.isForMainFrame && !request.url.startsWith(startUrl)) {
                  // TODO: open in browserinapp
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            )
          );
        },
      },
    );
  }
}

void main() => runApp(App());
