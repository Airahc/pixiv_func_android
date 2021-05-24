/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao
 * 文件名称 : about_page.dart
 */

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String? _currentVersion;

  String? _latestVersion;

  @override
  void initState() {
    PackageInfo.fromPlatform().then((packageInfo) {
      _currentVersion = packageInfo.version;
    });
    _getReleasesLatestVersion().then((version) {
      setState(() {
        _latestVersion = version;
      });
    });
    super.initState();
  }

  Future<String?> _getReleasesLatestVersion() async {
    final httpClient = Dio();
    final result = await httpClient.get<String>(
      "https://api.github.com/repos/xiao-cao-x/pixiv-android-xiaocao/releases",
    );
    final json = (jsonDecode(result.data!) as List<dynamic>).first;

    httpClient.close();
    return json['tag_name'] as String?;
  }

  Widget _buildBody() {
    return ListView(
      children: [
        SizedBox(height: 20),
        Card(
          child: ListTile(
            leading: Image.asset(
              'assets/xiaocao.png',
              width: 50,
            ),
            title: Text('这是小草的个人玩具项目'),
            subtitle: _currentVersion != null && _latestVersion != null
                ? Text('最新版本:$_latestVersion(当前版本:$_currentVersion)')
                : null,
          ),
        ),
        SizedBox(height: 20),
        Card(
          child: ListTile(
            onTap: () async {
              final url = "https://github.com/xiao-cao-x/pixiv-xiaocao-android";
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
            title: Text('此软件项目地址'),
            subtitle: Text('github.com/xiao-cao-x/pixiv-xiaocao-android'),
          ),
        ),
        Card(
          child: ListTile(
            onTap: () async {
              final url = "https://github.com/xiao-cao-x/pixiv-xiaocao-desktop";
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
            title: Text('桌面版项目地址'),
            subtitle: Text('github.com/xiao-cao-x/pixiv-xiaocao-desktop'),
          ),
        ),
        SizedBox(height: 20),
        Card(
          child: ListTile(
            title: Text('免费软件(不要用我的代码赚钱 包括打赏)'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关于此应用'),
      ),
      body: _buildBody(),
    );
  }
}
