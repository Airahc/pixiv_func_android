/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : settings_page.dart
 */
import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/pages/settings/account_config/account_config_page.dart';
import 'package:pixiv_xiaocao_android/pages/settings/network_config/network_config_page.dart';
import 'package:pixiv_xiaocao_android/util.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  Widget _buildBody() {
    return Column(
      children: [
        Card(
          child: ListTile(
            onTap: (){
              Util.gotoPage(context, NetworkConfigPage());
            },
            title: Text('网络'),
          ),
        ),
        Card(
          child: ListTile(
            onTap: (){
              Util.gotoPage(context, AccountConfigPage());
            },
            title: Text('账号'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: _buildBody(),
    );
  }
}
