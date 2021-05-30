/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : login_view.dart
 */


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginResult {
  String cookie;
  String initConfig;

  LoginResult(this.cookie, this.initConfig);

  @override
  String toString() {
    return '{cookie: $cookie, initConfig: $initConfig}';
  }
}

class LoginView extends StatelessWidget {
  final void Function(LoginResult loginResult) resultCallback;
  late final BasicMessageChannel loginResultMessage;

  LoginView({
    required this.resultCallback,
  }) {
    loginResultMessage = BasicMessageChannel(
      "pixiv.xiaocao/login_result",
      StandardMessageCodec(),
    )..setMessageHandler((message) async {
        try {
          final map = message as Map;
          resultCallback(LoginResult(map['cookie'], map['initConfig']));
        } catch (_) {}
      });
  }

  late final MethodChannel _channel;

  void onViewCreated(int viewId) {
    _channel = new MethodChannel('pixiv.xiaocao/login_view$viewId');
    doLogin();
  }

  Future<void> doLogin() async {
    await _channel.invokeMethod('do_login');
  }

  @override
  Widget build(BuildContext context) {
    return AndroidView(
      viewType: 'pixiv.xiaocao/login_view',
      creationParams: {},
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: this.onViewCreated,
    );
  }
}
