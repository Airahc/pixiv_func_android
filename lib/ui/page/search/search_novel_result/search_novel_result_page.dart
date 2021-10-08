/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:search_novel_result_page.dart
 * 创建时间:2021/10/8 下午5:08
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/model/search_filter.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/page/search/search_filter_editor/search_filter_editor.dart';
import 'package:pixiv_func_android/ui/widget/novel_previewer.dart';
import 'package:pixiv_func_android/ui/widget/refresher_widget.dart';
import 'package:pixiv_func_android/view_model/search_novel_result_model.dart';

class SearchNovelResultPage extends StatelessWidget {
  final String word;
  final SearchFilter filter;

  SearchNovelResultPage({Key? key, required this.word, required SearchFilter filter})
      : filter = SearchFilter.copy(filter),
        super(key: key);

  void _openSearchFilterEditor(BuildContext context, SearchNovelResultModel model) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SearchFilterEditor(
          filter: model.filter,
          onChanged: (SearchFilter value) => model.filter = value,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: SearchNovelResultModel(word: word, filter: filter),
      builder: (BuildContext context, SearchNovelResultModel model, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('搜索:$word'),
            actions: [
              IconButton(
                tooltip: '打开搜索过滤编辑器',
                onPressed: () => _openSearchFilterEditor(context, model),
                icon: const Icon(Icons.filter_alt_outlined),
              ),
            ],
          ),
          body: RefresherWidget(
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
          ),
        );
      },
    );
  }
}
