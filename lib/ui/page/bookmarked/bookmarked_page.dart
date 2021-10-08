/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:bookmarked_page.dart
 * 创建时间:2021/10/4 下午2:48
 * 作者:小草
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/model/bookmarked_filter.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/page/bookmarked/bookmarked_filter_editor.dart';
import 'package:pixiv_func_android/ui/page/bookmarked/bookmarked_illust_content.dart';
import 'package:pixiv_func_android/ui/page/bookmarked/bookmarked_novel_content.dart';
import 'package:pixiv_func_android/ui/widget/lazy_indexed_stack.dart';
import 'package:pixiv_func_android/ui/widget/sliding_segmented_control.dart';
import 'package:pixiv_func_android/view_model/bookmarked_model.dart';

class BookmarkedPage extends StatelessWidget {
  const BookmarkedPage({Key? key}) : super(key: key);

  void _openFilterEditor(BuildContext context, BookmarkedModel model) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BookmarkedFilterEditor(
          filter: model.filter,
          onChanged: (BookmarkedFilter value) => model.filter = value,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: BookmarkedModel(),
      builder: (BuildContext context, BookmarkedModel model, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('收藏'),
            actions: [
              IconButton(
                tooltip: '打开搜索过滤编辑器',
                onPressed: () => _openFilterEditor(context, model),
                icon: const Icon(Icons.filter_alt_outlined),
              ),
            ],
          ),
          body: Column(
            children: [
              SlidingSegmentedControl(
                children: const <int, Widget>{
                  0: Text('插画&漫画'),
                  1: Text('小说'),
                },
                groupValue: model.index,
                onValueChanged: (int? value) {
                  if (null != value) {
                    model.index = value;
                  }
                },
              ),
              Expanded(
                child: LazyIndexedStack(
                  key: Key('LazyIndexedStack:${model.filter.hashCode + model.filter.hashCode}'),
                  index: model.index,
                  children: [
                    BookmarkedIllustContent(
                      model.filter,
                    ),
                    BookmarkedNovelContent(
                      model.filter,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
