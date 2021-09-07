/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:ranking_content.dart
 * 创建时间:2021/9/2 上午8:48
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixiv_func_android/api/enums.dart';
import 'package:pixiv_func_android/provider/automatic_keep_provider_widget.dart';
import 'package:pixiv_func_android/ui/widget/illust_previewer.dart';
import 'package:pixiv_func_android/ui/widget/refresher_footer.dart';
import 'package:pixiv_func_android/view_model/ranking_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RankingContent extends StatelessWidget {
  final RankingMode mode;

  const RankingContent(this.mode, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutomaticKeepProviderWidget(
      model: RankingModel(mode),
      builder: (BuildContext context, RankingModel model, Widget? child) {
        return SmartRefresher(
          controller: model.refreshController,
          enablePullDown: true,
          enablePullUp: model.initialized && model.hasNext,
          header: MaterialClassicHeader(
            color: Theme.of(context).colorScheme.primary,
          ),
          footer: model.initialized ? RefresherFooter() : null,
          onRefresh: model.refreshRoutine,
          onLoading: model.nextRoutine,
          child: CustomScrollView(
            slivers: [
              SliverStaggeredGrid.countBuilder(
                crossAxisCount: 2,
                itemBuilder: (BuildContext context, int index) => IllustPreviewer(illust: model.list[index]),
                staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                itemCount: model.list.length,
              )
            ],
          ),
        );
      },
    );
  }
}
