/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : login_page.dart
 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/login_view/login_view.dart';

typedef ResultCallback = void Function(String cookie, String token, int id);

class LoginPage extends StatefulWidget {
  final ResultCallback resultCallback;

  LoginPage(this.resultCallback);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Widget _buildBody() {
    return Container(
      child: LoginView(
        resultCallback: (loginResult) {
          final cookie = loginResult.cookie;
          final s1 = cookie.substring(cookie.indexOf('PHPSESSID'));
          final String php = s1.substring(0, s1.indexOf(';') + 1);

          final Map json = jsonDecode(loginResult.initConfig);

          final String postKey = json['pixiv.context.postKey'] is String
              ? json['pixiv.context.postKey'] as String
              : '';

          final int id = json['pixiv.user.id'] is String
              ? int.parse(json['pixiv.user.id'] as String)
              : 0;
          widget.resultCallback(php, postKey, id);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: _buildBody(),
    );
  }
}
