/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : account_config_page.dart
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/config/config_util.dart';

class AccountConfigPage extends StatefulWidget {
  @override
  _AccountConfigPageState createState() => _AccountConfigPageState();
}

class _AccountConfigPageState extends State<AccountConfigPage> {
  late final TextEditingController _userIdController;

  late final TextEditingController _cookieController;

  late final TextEditingController _tokenController;

  @override
  void initState() {
    _userIdController =
        TextEditingController(text: '${ConfigUtil.instance.config.userId}');
    _cookieController =
        TextEditingController(text: '${ConfigUtil.instance.config.cookie}');
    _tokenController =
        TextEditingController(text: '${ConfigUtil.instance.config.token}');
    super.initState();
  }

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
              onChanged: (value) async{
                if(value.isNotEmpty){
                  ConfigUtil.instance.config.userId = int.parse(value);
                  await ConfigUtil.instance.updateConfigFile();
                  PixivRequest.instance.updateHeaders();
                }

              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _cookieController,
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(labelText: 'Cookie'),
              onChanged: (value) async{
                ConfigUtil.instance.config.cookie=value;
                await ConfigUtil.instance.updateConfigFile();
                PixivRequest.instance.updateHeaders();
              },
            ),
            TextField(
              controller: _tokenController,
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(labelText: 'Token'),
              onChanged: (value) async{
                ConfigUtil.instance.config.token=value;
                await ConfigUtil.instance.updateConfigFile();
                PixivRequest.instance.updateHeaders();
              },
            ),
          ],
        ),
      ),
    );
  }
}
