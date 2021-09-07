/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:recommend_user.dart
 * 创建时间:2021/9/2 下午2:18
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/provider/automatic_keep_provider_widget.dart';
import 'package:pixiv_func_android/ui/widget/refresher_footer.dart';
import 'package:pixiv_func_android/ui/widget/user_preview_card.dart';
import 'package:pixiv_func_android/view_model/recommend_user_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RecommendUser extends StatefulWidget {
  const RecommendUser({Key? key}) : super(key: key);

  @override
  _RecommendUserState createState() => _RecommendUserState();
}

class _RecommendUserState extends State<RecommendUser> {
  @override
  Widget build(BuildContext context) {
    return AutomaticKeepProviderWidget(
      model: RecommendUserModel(),
      builder: (BuildContext context, RecommendUserModel model, Widget? child) {
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
          child: ListView(
            children: model.list.map((e) => UserPreviewCard(e)).toList(),
          ),
        );
      },
    );
  }
}
