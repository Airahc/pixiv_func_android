/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : save_config_page.dart
 */

import 'package:flutter/material.dart';

class SaveConfigPage extends StatefulWidget {

  @override
  _SaveConfigPageState createState() => _SaveConfigPageState();
}

class _SaveConfigPageState extends State<SaveConfigPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('保存配置'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(onTap: (){

            }, title: Text(''),)
          ],
        ),
      ),
    );
  }
}
