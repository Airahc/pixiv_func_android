/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:following_user_page.dart
 * 创建时间:2021/8/29 下午11:22
 * 作者:小草
 */

import 'package:flutter/material.dart';

import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/widget/refresher_footer.dart';
import 'package:pixiv_func_android/ui/widget/segment_bar.dart';
import 'package:pixiv_func_android/ui/widget/user_preview_card.dart';
import 'package:pixiv_func_android/view_model/following_user_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FollowingUserPage extends StatelessWidget {
  final int userId;

  const FollowingUserPage(this.userId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: FollowingUserModel(userId),
      builder: (BuildContext context, FollowingUserModel model, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: SegmentBar(
              items: ['公开', '私有'],
              values: [true, false],
              onSelected: (bool value) {
                model.restrict = value;
              },
              selectedValue: model.restrict,
            ),
          ),
          body: SmartRefresher(
            controller: model.refreshController,
            enablePullDown: true,
            enablePullUp: model.initialized && model.hasNext,
            header: MaterialClassicHeader(
              color: Theme.of(context).colorScheme.primary,
            ),
            footer: model.initialized ? RefresherFooter() : null,
            onRefresh: model.refreshRoutine,
            onLoading: model.nextRoutine,
            child: ListView(
              children: model.list.map((e) => UserPreviewCard(e)).toList(),
            ),
          ),
        );
      },
    );
  }
}
