/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : left_drawer.dart
 */

import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/pages/about/about.dart';
import 'package:pixiv_xiaocao_android/pages/bookmarks/bookmarks.dart';
import 'package:pixiv_xiaocao_android/pages/config/account_config/account_config.dart';
import 'package:pixiv_xiaocao_android/pages/config/network_config/network_config.dart';
import 'package:pixiv_xiaocao_android/pages/followed/followed.dart';
import 'package:pixiv_xiaocao_android/pages/new_works/new_works.dart';
import 'package:pixiv_xiaocao_android/util.dart';

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
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Util.gotoPage(context, AccountConfigPage());
              },
              // leading: Icon(Icons.switch_account),
              title: Text(
                '账号配置',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () {
                Util.gotoPage(context, NetworkConfigPage());
              },
              // leading: Icon(Icons.wifi_outlined),
              title: Text(
                '网络配置',
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
              // leading: Icon(Icons.image_outlined),
              title: Text(
                '已关注用户的新作品',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () {
                Util.gotoPage(context, FollowedPage());
              },
              // leading: Icon(Icons.image_outlined),
              title: Text(
                '已关注的用户',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () {
                Util.gotoPage(context, BookmarksPage());
              },
              // leading: Icon(Icons.image_outlined),
              title: Text(
                '已收藏的书签',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              onTap: () {
                Util.gotoPage(context, AboutPage());
              },
              // leading: Icon(Icons.image_outlined),
              title: Text(
                '关于此应用',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
