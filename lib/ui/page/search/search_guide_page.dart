/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:search_guide_page.dart
 * 创建时间:2021/9/2 上午10:51
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/ui/page/search/recommend_user/recommend_user.dart';
import 'package:pixiv_func_android/ui/page/search/search_input/search_input_page.dart';
import 'package:pixiv_func_android/ui/page/search/trending_illust/trending_illust.dart';
import 'package:pixiv_func_android/util/page_utils.dart';

class SearchGuidePage extends StatefulWidget {
  const SearchGuidePage({Key? key}) : super(key: key);

  @override
  _SearchGuidePageState createState() => _SearchGuidePageState();
}

class _SearchGuidePageState extends State<SearchGuidePage> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        indicatorColor: Theme.of(context).colorScheme.primary,
        controller: _tabController,
        tabs: [
          Tab(
            text: '推荐标签',
          ),
          Tab(
            text: '推荐用户',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        onPressed: () => PageUtils.to(context, SearchInputPage()),
        child: Icon(Icons.search_outlined),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TrendingIllust(),
          RecommendUser(),
        ],
      ),
    );
  }
}
