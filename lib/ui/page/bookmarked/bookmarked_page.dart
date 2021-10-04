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
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    child: CupertinoSlidingSegmentedControl(
                      children: <int, Widget>{
                        0: Container(
                          alignment: Alignment.center,
                          child: const Text('插画·漫画'),
                          width: constraints.maxWidth / 2,
                        ),
                        1: Container(
                          alignment: Alignment.center,
                          child: const Text('小说'),
                          width: constraints.maxWidth / 2,
                        ),
                      },
                      groupValue: model.type,
                      onValueChanged: (int? value) {
                        if (null != value) {
                          model.type = value;
                        }
                      },
                    ),
                  );
                },
              ),
              Expanded(
                child: 0 == model.type
                    ? BookmarkedIllustContent(
                        model.filter,
                        key: Key('BookmarkedIllustContent:${model.filter.hashCode}'),
                      )
                    : BookmarkedNovelContent(
                        model.filter,
                        key: Key('BookmarkedNovelContent:${model.filter.hashCode}'),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
