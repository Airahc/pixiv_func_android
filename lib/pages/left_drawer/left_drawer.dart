/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : left_drawer.dart
 */

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/config/config_util.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';
import 'package:pixiv_xiaocao_android/pages/about/about_page.dart';
import 'package:pixiv_xiaocao_android/pages/bookmarked/bookmarked_page.dart';
import 'package:pixiv_xiaocao_android/pages/config/account_config/account_config_page.dart';
import 'package:pixiv_xiaocao_android/pages/config/network_config/network_config_page.dart';
import 'package:pixiv_xiaocao_android/pages/followed_users/followed_users_page.dart';
import 'package:pixiv_xiaocao_android/pages/new_works/new_works_page.dart';
import 'package:pixiv_xiaocao_android/util.dart';

class LeftDrawer extends StatefulWidget {
  @override
  _LeftDrawerState createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Util.gotoPage(context, AccountConfigPage());
              },
              title: Text(
                '账号配置',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () {
                Util.gotoPage(context, NetworkConfigPage());
              },
              title: Text(
                '网络配置',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () async {
                final clipboardContent = await Util.readClipboard();
                if (clipboardContent != null) {
                  await ConfigUtil.instance
                      .updateJsonStringToConfig(clipboardContent);
                  PixivRequest.instance.updateHeaders();
                } else {
                  Util.toast('获取剪切板内容失败');
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
                Util.copyToClipboard(
                  jsonEncode(
                    ConfigUtil.instance.config.toJson(),
                  ),
                );
                Util.toast('已将配置信息复制到剪切板');
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
                Util.gotoPage(context, NewWorksPage());
              },
              title: Text(
                '已关注用户的新作品',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () {
                Util.gotoPage(context, FollowedUsersPage());
              },
              title: Text(
                '已关注的用户',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () {
                Util.gotoPage(context, BookmarkedPage());
              },
              title: Text(
                '已收藏的书签',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () {
                Util.gotoPage(context, AboutPage());
              },
              title: Text(
                '关于此应用',
                style: TextStyle(fontSize: 20),
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
