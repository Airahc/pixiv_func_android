/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_android
 * 文件名称:search_user_result_page.dart
 * 创建时间:2021/9/6 下午5:21
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/widget/refresher_footer.dart';
import 'package:pixiv_func_android/ui/widget/user_preview_card.dart';
import 'package:pixiv_func_android/view_model/search_user_result_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchUserResultPage extends StatelessWidget {
  final String word;

  const SearchUserResultPage(this.word, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: SearchUserResultModel(word),
      builder: (BuildContext context, SearchUserResultModel model, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('搜索用户:$word'),
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
