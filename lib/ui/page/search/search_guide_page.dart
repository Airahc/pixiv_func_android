/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:search_guide_model.dart
 * 创建时间:2021/9/2 上午10:51
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/ui/page/search/recommend_user/recommend_user.dart';
import 'package:pixiv_func_android/ui/page/search/search_input/search_input_page.dart';
import 'package:pixiv_func_android/ui/page/search/trending_illust/trending_illust.dart';
import 'package:pixiv_func_android/ui/widget/lazy_indexed_stack.dart';
import 'package:pixiv_func_android/ui/widget/sliding_segmented_control.dart';
import 'package:pixiv_func_android/util/page_utils.dart';
import 'package:pixiv_func_android/view_model/search_guide_model.dart';

class SearchGuidePage extends StatefulWidget {
  const SearchGuidePage({Key? key}) : super(key: key);

  @override
  _SearchGuidePageState createState() => _SearchGuidePageState();
}

class _SearchGuidePageState extends State<SearchGuidePage> {
  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: SearchGuideModel(),
      builder: (BuildContext context, SearchGuideModel model, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('搜索'),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.onBackground,
            onPressed: () => PageUtils.to(context, const SearchInputPage()),
            child: const Icon(Icons.search_outlined),
          ),
          body: Column(
            children: [
              SlidingSegmentedControl(
                children: const <int, Widget>{
                  0: Text('推荐标签'),
                  1: Text('推荐用户'),
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
                  index: model.index,
                  children: const [
                    TrendingIllust(),
                    RecommendUser(),
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
