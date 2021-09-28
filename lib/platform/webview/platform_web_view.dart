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
  static const _methodReload = 'reload';

  late final MethodChannel _channel;

  double _progress = 0;

  @override
  void initState() {
    const BasicMessageChannel(
      '$_pluginName/result',
      StandardMessageCodec(),
    ).setMessageHandler(
        (dynamic message) async {
          widget.onMessageHandler(context, message);
        },
      );

    const BasicMessageChannel(
      '$_pluginName/progress',
      StandardMessageCodec(),
    ).setMessageHandler(
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
      //不设置这个点输入框的时候 键盘会直接弹回很难输入进去东西
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('PlatformWebView'),
        actions: [
          IconButton(
            onPressed: () => _channel.invokeMethod(_methodReload),
            icon: const Icon(Icons.refresh_outlined),
          )
        ],
      ),
      body: Column(
        children: [
          Visibility(
            visible: _progress < 1.0,
            child: LinearProgressIndicator(value: _progress),
          ),
          Expanded(
            child: AndroidView(
              viewType: _pluginName,
              creationParams: const {},
              creationParamsCodec: const StandardMessageCodec(),
              onPlatformViewCreated: onViewCreated,
            ),
          )
        ],
      ),
    );
  }
}
