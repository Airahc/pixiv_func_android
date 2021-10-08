/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:ranking_page.dart
 * 创建时间:2021/8/31 下午10:19
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:pixiv_func_android/api/enums.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/page/ranking/ranking_content.dart';
import 'package:pixiv_func_android/ui/widget/lazy_indexed_stack.dart';
import 'package:pixiv_func_android/view_model/ranking_model.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: RankingModel(),
      builder: (BuildContext context, RankingModel model, Widget? child) {
        return Column(
          children: [
            DefaultTabController(
              length: RankingMode.values.length,
              child: TabBar(
                labelColor: Theme.of(context).textTheme.button?.color,
                indicatorColor: Theme.of(context).colorScheme.primary,
                isScrollable: true,
                onTap: (int value) => model.index = value,
                tabs: const [
                  Tab(text: '每日'),
                  Tab(text: '每日(R-18)'),
                  Tab(text: '每日(男性欢迎)'),
                  Tab(text: '每日(男性欢迎 & R-18)'),
                  Tab(text: '每日(女性欢迎)'),
                  Tab(text: '每日(女性欢迎 & R-18)'),
                  Tab(text: '每周'),
                  Tab(text: '每周(R-18)'),
                  Tab(text: '每周(原创)'),
                  Tab(text: '每周(新人)'),
                  Tab(text: '每月'),
                ],
              ),
            ),
            Expanded(
              child: LazyIndexedStack(
                index: model.index,
                children: [
                  for (final mode in RankingMode.values) RankingContent(mode),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
