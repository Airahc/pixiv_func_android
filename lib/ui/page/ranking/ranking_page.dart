/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:ranking_page.dart
 * 创建时间:2021/8/31 下午10:19
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:pixiv_func_android/instance_setup.dart';

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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('排行榜'),
      ),
      body: Column(
        children: [
          TabBar(
            isScrollable: true,
            controller: _tabController,
            labelColor: settingsManager.isLightTheme ? Colors.black : null,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: [
              for (final item in widget.typeItems)
                Tab(
                  text: item.name,
                )
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [for (final item in widget.typeItems) RankingContent(item.mode)],
            ),
          ),
        ],
      ),
    );
  }
}
