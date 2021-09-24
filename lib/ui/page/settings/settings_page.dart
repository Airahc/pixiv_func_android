/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:settings_page.dart
 * 创建时间:2021/8/25 上午11:59
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/view_model/settings_model.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: ProviderWidget(
        model: SettingsModel(),
        builder: (BuildContext context, SettingsModel model, Widget? child) {
          return ListView(
            children: [
              Card(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        '图片源',
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    RadioListTile(
                      activeColor: Theme.of(context).colorScheme.primary,
                      title: Text('使用代理图片源(i.pixiv.cat)'),
                      value: 'i.pixiv.cat',
                      groupValue: model.imageSource,
                      onChanged: (String? value) {
                        if (null != value) {
                          model.imageSource = value;
                        }
                      },
                    ),
                    RadioListTile(
                      activeColor: Theme.of(context).colorScheme.primary,
                      title: Text('使用IP直连(210.140.92.139)'),
                      value: '210.140.92.139',
                      groupValue: model.imageSource,
                      onChanged: (String? value) {
                        if (null != value) {
                          model.imageSource = value;
                        }
                      },
                    ),
                    RadioListTile(
                      activeColor: Theme.of(context).colorScheme.primary,
                      title: Text('使用原始图片源(i.pximg.net)'),
                      value: 'i.pximg.net',
                      groupValue: model.imageSource,
                      onChanged: (String? value) {
                        if (null != value) {
                          model.imageSource = value;
                        }
                      },
                    ),
                    RadioListTile(
                      activeColor: Theme.of(context).colorScheme.primary,
                      title: Text('使用自定义图片源'),
                      value: model.customImageSourceInput.text,
                      groupValue: model.imageSource,
                      onChanged: (String? value) {
                        if (null != value) {
                          model.imageSource = value;
                        }
                      },
                    ),
                    ListTile(
                      title: TextField(
                        decoration: InputDecoration(label: Text('自定义图片源')),
                        controller: model.customImageSourceInput,
                        onChanged: (String value) {
                          model.imageSource = value;
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
