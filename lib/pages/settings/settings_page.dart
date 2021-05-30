/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : settings_page.dart
 */
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pixiv_xiaocao_android/config/config_util.dart';
import 'package:pixiv_xiaocao_android/util.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final storageStatus = Permission.storage.status;
  bool? storagePermission;

  @override
  void initState() {
    storageStatus.isGranted.then((value) {
      setState(() {
        storagePermission = value;
      });
    });
    super.initState();
  }

  Widget _buildBody() {
    return Column(
      children: [
        Card(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                '图片源',
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(height: 20),
              RadioListTile(
                value: false,
                groupValue: ConfigUtil.instance.config.enableImageProxy,
                title: Text('使用原始图片源(i.pximg.net)'),
                selected: !ConfigUtil.instance.config.enableImageProxy,
                onChanged: (bool? value) {
                  if (value != null)
                    setState(() {
                      ConfigUtil.instance.config.enableImageProxy = value;
                      ConfigUtil.instance.updateConfigFile();
                    });
                },
              ),
              SizedBox(height: 20),
              RadioListTile(
                value: true,
                groupValue: ConfigUtil.instance.config.enableImageProxy,
                title: Text('使用代理图片源(i.pixiv.cat)'),
                selected: ConfigUtil.instance.config.enableImageProxy,
                onChanged: (bool? value) {
                  if (value != null)
                    setState(() {
                      ConfigUtil.instance.config.enableImageProxy = value;
                      ConfigUtil.instance.updateConfigFile();
                    });
                },
              ),
            ],
          ),
        ),
        storagePermission != null
            ? Card(
          child: storagePermission!
              ? ListTile(
            title: Text(
              '当前拥有存储权限',
              style: TextStyle(fontSize: 20),
            ),
          )
              : ListTile(
            onTap: () async {
              if (await Permission.storage
                  .request()
                  .isGranted) {
                setState(() {
                  storagePermission = true;
                });
                Util.toast('存储权限被允许');
              } else {
                Util.toast('存储权限被拒绝');
              }
            },
            title: Text(
              '当前没有存储权限',
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Text('点击以尝试获取'),
          ),
        )
            : Container(),
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
