/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:refresher_widget.dart
 * 创建时间:2021/9/10 下午6:07
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/provider/base_view_state_refresh_list_model.dart';
import 'package:pixiv_func_android/ui/widget/scroll_to_top_button.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefresherWidget extends StatelessWidget {
  final BaseViewStateRefreshListModel model;
  final ScrollView child;

  const RefresherWidget(this.model, {Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: SmartRefresher(
            scrollController: model.scrollController,
            controller: model.refreshController,
            primary: false,
            enablePullDown: true,
            enablePullUp: model.initialized,
            onRefresh: model.refreshRoutine,
            onLoading: model.nextRoutine,
            child: child,
          ),
        ),
        Positioned(
          bottom: 10,
          left: MediaQuery.of(context).size.width / 2 - 12,
          child: model.showToTop ? ScrollToTopButton(model) : Container(),
        ),
      ],
    );
  }
}
