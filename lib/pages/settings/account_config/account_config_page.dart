/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : account_config_page.dart
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/config/config_util.dart';
import 'package:pixiv_xiaocao_android/pages/login/login_page.dart';
import 'package:pixiv_xiaocao_android/util.dart';

class AccountConfigPage extends StatefulWidget {
  @override
  _AccountConfigPageState createState() => _AccountConfigPageState();
}

class _AccountConfigPageState extends State<AccountConfigPage> {
  final TextEditingController _userIdController =
      TextEditingController(text: '${ConfigUtil.instance.config.userId}');

  final TextEditingController _cookieController =
      TextEditingController(text: '${ConfigUtil.instance.config.cookie}');

  final TextEditingController _tokenController =
      TextEditingController(text: '${ConfigUtil.instance.config.token}');

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
              onChanged: (value) async {
                if (value.isNotEmpty) {
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
              onChanged: (value) async {
                ConfigUtil.instance.config.cookie = value;
                await ConfigUtil.instance.updateConfigFile();
                PixivRequest.instance.updateHeaders();
              },
            ),
            TextField(
              controller: _tokenController,
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(labelText: 'Token'),
              onChanged: (value) async {
                ConfigUtil.instance.config.token = value;
                await ConfigUtil.instance.updateConfigFile();
                PixivRequest.instance.updateHeaders();
              },
            ),
            SizedBox(height: 20),
            Card(
              child: ListTile(
                onTap: () {
                  Util.gotoPage(
                    context,
                    LoginPage(
                      (String cookie, String token, int id) {
                        if (id != 0) {
                          Util.toast('登录成功 ID:$id');
                          setState(() {
                            ConfigUtil.instance.config.cookie = cookie;
                            _cookieController.text = cookie;
                            ConfigUtil.instance.config.token = token;
                            _tokenController.text = token;
                            ConfigUtil.instance.config.userId = id;
                            _userIdController.text = '$id';
                          });
                          ConfigUtil.instance.updateConfigFile();
                          PixivRequest.instance.updateHeaders();
                        } else {
                          Util.toast('登录失败');
                        }
                      },
                    ),
                  );
                },
                title: Text('前往登录'),
                subtitle: Text('目前需要VPN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
