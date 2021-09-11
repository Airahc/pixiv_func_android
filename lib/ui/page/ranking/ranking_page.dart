/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:ranking_page.dart
 * 创建时间:2021/8/31 下午10:19
 * 作者:小草
 */

import 'package:flutter/material.dart';

import 'package:pixiv_func_android/model/ranking_type_item.dart';
import 'package:pixiv_func_android/ui/page/ranking/ranking_content.dart';

class RankingPage extends StatefulWidget {
  final List<RankingTypeItem> typeItems;

  const RankingPage(this.typeItems, {Key? key}) : super(key: key);

  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: widget.typeItems.length, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('排行榜'),
      ),
      body: Column(
        children: [
          TabBar(
            isScrollable: true,
            controller: _tabController,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: widget.typeItems
                .map(
                  (item) => Tab(
                    text: item.name,
                  ),
                )
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: widget.typeItems
                  .map(
                    (item) => RankingContent(
                      item.mode,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
