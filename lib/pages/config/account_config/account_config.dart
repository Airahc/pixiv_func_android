/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : account_config.dart
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixiv_xiaocao_android/config.dart';
import 'package:pixiv_xiaocao_android/util.dart';

class AccountConfigPage extends StatefulWidget {
  @override
  _AccountConfigPageState createState() => _AccountConfigPageState();
}

class _AccountConfigPageState extends State<AccountConfigPage> {

  final TextEditingController _userIdController = TextEditingController(
      text: '${Config.userId}');

  final TextEditingController _cookieController = TextEditingController(
      text: '${Config.cookie}');

  final TextEditingController _tokenController = TextEditingController(
      text: '${Config.token}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('账号配置'),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          children: [
            TextField(
              controller: _userIdController,
              decoration: InputDecoration(labelText: '你自己的用户ID'),
              onChanged: (value) {
                Config.userId = int.parse(value);
                Util.updateConfig<int>('UserId', int.parse(value));
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _cookieController,
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(labelText: 'Cookie'),
              onChanged: (value) {
                Config.cookie = value;
                Util.updateConfig<String>('Cookie', value);
              },
            ),
            TextField(
              controller: _tokenController,
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(labelText: 'Token'),
              onChanged: (value) {
                Config.token = value;
                Util.updateConfig<String>('Token', value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
