/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:platform_webview.dart
 * 创建时间:2021/8/21 下午9:49
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlatformWebView extends StatefulWidget {
  final String url;
  final Future<dynamic> Function(BuildContext context, dynamic message) onMessageHandler;

  const PlatformWebView({Key? key, required this.url, required this.onMessageHandler}) : super(key: key);

  @override
  _PlatformWebViewState createState() => _PlatformWebViewState();
}

class _PlatformWebViewState extends State<PlatformWebView> {
  static const _pluginName = 'xiaocao/platform/web_view';

  static const _methodLoadUrl = 'loadUrl';


  late final MethodChannel _channel;

  double _progress = 0;

  @override
  void initState() {
    BasicMessageChannel(
      '$_pluginName/result',
      StandardMessageCodec(),
    )..setMessageHandler(
        (dynamic message) async {
          widget.onMessageHandler(context, message);
        },
      );

     BasicMessageChannel(
      '$_pluginName/progress',
      StandardMessageCodec(),
    )..setMessageHandler(
        (dynamic message) async {
          if (message is int) {
            setState(() {
              _progress = message / 100;
            });
          }
        },
      );
    super.initState();
  }

  void onViewCreated(int viewId) {
    _channel = MethodChannel('$_pluginName$viewId');
    _channel.invokeMethod(_methodLoadUrl, {'url': widget.url});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PlatformWebView'),
        bottom: PreferredSize(
          child: LinearProgressIndicator(value: _progress),
          preferredSize: Size.fromHeight(20),
        ),
      ),
      body: AndroidView(
        viewType: _pluginName,
        creationParams: {},
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: onViewCreated,
      ),
    );
  }
}
