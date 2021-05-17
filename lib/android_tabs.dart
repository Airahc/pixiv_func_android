/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : android_tabs.dart
 */

import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/pages/left_drawer/left_drawer.dart';
import 'package:pixiv_xiaocao_android/pages/ranking/ranking.dart';
import 'package:pixiv_xiaocao_android/pages/recommender/recommender.dart';
import 'package:pixiv_xiaocao_android/pages/search/search.dart';

class AndroidTabs extends StatefulWidget {
  @override
  _AndroidTabsState createState() => _AndroidTabsState();
}

class _AndroidTabsState extends State<AndroidTabs> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: LeftDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_sharp),
            label: '主页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment_outlined),
            label: '排行',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image_search_sharp),
            label: '搜索',
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
        ],
      ),
    );
  }
}
