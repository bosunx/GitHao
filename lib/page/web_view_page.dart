import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:githao_v2/network/entity/token_request_model.dart';
import 'package:githao_v2/network/dio_client.dart';
import 'package:githao_v2/network/github_service.dart';
import 'package:githao_v2/util/const.dart';
import 'package:githao_v2/util/prefs_manager.dart';
import 'package:oktoast/oktoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  static const clientId = 'c868cf1dc9c48103bb55';
  final clientSecret = '20bf38742868ad776331c718d98b4670c0eddb8b';
  static const redirectUri = 'http://localhost/oauth/redirect';
  CancelToken cancelToken = CancelToken();
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  void _accessToken(String code) async {
    try {
      GithubService(dioClient.dio).accessToken(
          TokenRequestModel(clientId, clientSecret, code, null),
          cancelToken: cancelToken
      ).then((tokenEntity) async {
        await prefsManager.setToken(tokenEntity.accessToken);
        showToast(prefsManager.getToken() ?? 'no token');
        GithubService(dioClient.dio).getUser().then((userEntity) async {
          prefsManager.addUsername(userEntity.login!);
          prefsManager.setToken(tokenEntity.accessToken, userName: userEntity.login);
          prefsManager.setUser(userEntity);
          showToast(userEntity.login!);
        }).catchError((exception) {
          showToast(exception.toString());
        });
      }).catchError((exception) {
        showToast(exception.toString());
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authorizeUrl = 'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&scope=${Const.scope}&login=flutter-lib';
    // final authorizeUrl = 'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&scope=${Const.scope}&login=conghaonet';
    return Scaffold(
      appBar: AppBar(

      ),
      body: WebView(
        // initialUrl: 'https://m.baidu.com',
        initialUrl: authorizeUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onPageStarted: (String url) {
          print('Page started loading: $url');
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith(redirectUri)) {
            // http://localhost/oauth/redirect?code=514107b8ccd509ed8c48
            final code = Uri.parse(request.url).queryParameters['code'];
            if(code!.isNotEmpty) {
              _accessToken(code);
            } else {
              showToast('token is empty!');
            }
            return NavigationDecision.navigate;
          } else {
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    cancelToken.cancel();
    super.dispose();
  }
}
