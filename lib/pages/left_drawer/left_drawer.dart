/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : left_drawer.dart
 */

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/config/config_util.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';
import 'package:pixiv_xiaocao_android/pages/about/about_page.dart';
import 'package:pixiv_xiaocao_android/pages/account/account_page.dart';
import 'package:pixiv_xiaocao_android/pages/bookmarking/bookmarking_page.dart';
import 'package:pixiv_xiaocao_android/pages/following_users/following_users_page.dart';
import 'package:pixiv_xiaocao_android/pages/following_latest_illusts/following_latest_illusts_page.dart';
import 'package:pixiv_xiaocao_android/pages/settings/settings_page.dart';
import 'package:pixiv_xiaocao_android/utils.dart';

class LeftDrawer extends StatefulWidget {
  @override
  _LeftDrawerState createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
        child: ListView(
          children: [
            ListTile(
              onTap: () {
                Utils.gotoPage(context, SettingsPage());
              },
              title: Text(
                '设置',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () {
                Utils.gotoPage(context, AccountPage());
              },
              title: Text(
                '账号',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () async {
                final clipboardContent = await Utils.readClipboard();
                if (clipboardContent != null) {
                  await ConfigUtil.instance
                      .updateJsonStringToConfig(clipboardContent);
                  PixivRequest.instance.updateHeaders();
                } else {
                  Utils.toast('获取剪切板内容失败');
                  LogUtil.instance.add(
                    type: LogType.Info,
                    id: -1,
                    title: '获取剪切板内容失败',
                    url: '',
                    context: '',
                  );
                }
              },
              title: Text(
                '从剪切板导入配置信息',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () {
                Utils.copyToClipboard(
                  jsonEncode(
                    ConfigUtil.instance.config.toJson(),
                  ),
                );
                Utils.toast('已将配置信息复制到剪切板');
              },
              title: Text(
                '将配置信息导出到剪切板',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Divider(
              thickness: 1.5,
              color: Theme.of(context).primaryColor,
            ),
            ListTile(
              onTap: () {
                Utils.gotoPage(context, FollowingLatestIllustsPage());
              },
              title: Text(
                '已关注(用户)的新插画',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () {
                Utils.gotoPage(context, FollowingUsersPage());
              },
              title: Text(
                '已关注的用户',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () {
                Utils.gotoPage(context, BookmarkingPage());
              },
              title: Text(
                '已收藏的书签',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () {
                Utils.gotoPage(context, AboutPage());
              },
              title: Text(
                '关于此应用',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Card(
              child: ListTile(
                onTap: () {
                  exit(0);
                },
                title: Text('关闭软件'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
