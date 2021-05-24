/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : search_page.dart
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/pages/left_drawer/left_drawer.dart';
import 'package:pixiv_xiaocao_android/pages/search/search_input.dart';
import 'package:pixiv_xiaocao_android/pages/search/search_settings.dart';
import 'package:pixiv_xiaocao_android/pages/search/search_suggestion.dart';
import 'package:pixiv_xiaocao_android/util.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController = TabController(length: 3, vsync: this);

  int _currentIndex = 0;

  @override
  void dispose(){
    _tabController.dispose();
    super.dispose();
  }

  List<GlobalKey<SearchSuggestionContentState>> _globalKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: LeftDrawer(),
      appBar: AppBar(
        titleSpacing: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              splashRadius: 20,
              icon: Icon(
                Icons.menu,
                color: Colors.white.withAlpha(220),
              ),
              onPressed: () {

                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                splashRadius: 20,
                icon: Icon(
                  Icons.settings,
                  color: Colors.white.withAlpha(220),
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          )
        ],
        title: Text('搜索'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: TabBar(
            controller: _tabController,
            tabs: [
              Text('全部'),
              Text('全年龄'),
              Text('R-18'),
            ],
            onTap: (int index) {
              if (_currentIndex != index && _tabController.index == index) {
                _currentIndex = index;
              } else {
                _globalKeys[index].currentState?.scrollToTop();
              }
            },
          ),
        ),
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            heroTag: '进入搜索输入页面',
            backgroundColor: Colors.black.withAlpha(200),
            child: Icon(
              Icons.search_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Util.gotoPage(context, SearchInputPage());
            },
          );
        },
      ),
      endDrawer: SearchSettings(),
      body: TabBarView(
        controller: _tabController,
        children: [
          SearchSuggestionContent('all', key: _globalKeys[0]),
          SearchSuggestionContent('safe', key: _globalKeys[1]),
          SearchSuggestionContent('r18', key: _globalKeys[2]),
        ],
      ),
    );
  }
}
