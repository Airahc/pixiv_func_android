/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:search_image_result_page.dart
 * 创建时间:2021/9/7 下午6:21
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:pixiv_func_android/model/search_image_result.dart';
import 'package:pixiv_func_android/ui/page/search/search_image_result/search_image_result_item.dart';

class SearchImageResultPage extends StatelessWidget {
  final List<SearchImageResult> results;

  const SearchImageResultPage(this.results, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('搜索图片'),
      ),
      body: ListView(
        children: results.map((result) => SearchImageResultItem(result)).toList(),
      ),
    );
  }
}
