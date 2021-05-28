/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : android_tabs.dart
 */

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';
import 'package:pixiv_xiaocao_android/pages/left_drawer/left_drawer.dart';
import 'package:pixiv_xiaocao_android/pages/log/log_page.dart';
import 'package:pixiv_xiaocao_android/pages/ranking/ranking_page.dart';
import 'package:pixiv_xiaocao_android/pages/recommender/recommender_page.dart';
import 'package:pixiv_xiaocao_android/pages/search/search_page.dart';

import 'package:pixiv_xiaocao_android/config/config_util.dart';

class AndroidTabs extends StatefulWidget {
  @override
  _AndroidTabsState createState() => _AndroidTabsState();
}

class _AndroidTabsState extends State<AndroidTabs> {
  int _currentIndex = 0;

  final storageStatus = Permission.storage.status;

  ValueNotifier<bool> _loading = ValueNotifier(true);

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  Future _initialize() async {
    if (await storageStatus.isGranted) {
      await ConfigUtil.instance.loadConfigFile();
    } else {
      if (await Permission.storage.request().isGranted) {
        await ConfigUtil.instance.loadConfigFile();
      }
    }
    _loading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _loading,
      builder: (BuildContext context, bool loading, Widget? child) {
        if (loading) {
          return Container();
        } else {
          return Scaffold(
            drawer: LeftDrawer(),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_sharp),
                  label: '推荐作品',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.assessment_outlined),
                  label: '排行榜',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search_outlined),
                  label: '搜索',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.info_outlined),
                  label: '日志',
                ),
              ],
              // iconSize: 45,
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            body: IndexedStack(
              index: _currentIndex,
              children: [
                RecommenderPage(),
                RankingPage(),
                SearchPage(),
                LogPage(LogUtil.instance.globalKey),
              ],
            ),
          );
        }
      },
    );
  }
}
