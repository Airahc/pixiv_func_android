/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:bookmarked_novel_content.dart
 * 创建时间:2021/10/4 下午3:17
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/model/bookmarked_filter.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/widget/novel_previewer.dart';
import 'package:pixiv_func_android/ui/widget/refresher_widget.dart';
import 'package:pixiv_func_android/view_model/bookmarked_novel_model.dart';

class BookmarkedNovelContent extends StatelessWidget {
  final BookmarkedFilter filter;

  const BookmarkedNovelContent(this.filter, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: BookmarkedNovelModel(filter),
      builder: (BuildContext context, BookmarkedNovelModel model, Widget? child) {
        return RefresherWidget(
          model,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    for (final novel in model.list)
                      Card(
                        child: NovelPreviewer(novel),
                      )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
