/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:search_illust_result_model.dart
 * 创建时间:2021/9/3 下午6:49
 * 作者:小草
 */

import 'package:pixiv_func_android/api/entity/illust.dart';
import 'package:pixiv_func_android/api/model/illusts.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/model/search_filter.dart';
import 'package:pixiv_func_android/provider/base_view_state_refresh_list_model.dart';

class SearchIllustResultModel extends BaseViewStateRefreshListModel<Illust> {
  final String _word;
  SearchFilter _filter;

  SearchIllustResultModel({required String word, required SearchFilter filter})
      : _word = word,
        _filter = filter;

  SearchFilter get filter => _filter;

  set filter(SearchFilter value) {
    if (value != _filter) {
      _filter = value;
      notifyListeners();
      refresh();
    }
  }

  @override
  Future<List<Illust>> loadFirstDataRoutine() async {
    final result = await pixivAPI.searchIllust(
      _word,
      filter.sort,
      filter.target,
      startDate: filter.enableDateRange ? filter.formatStartDate : null,
      endDate: filter.enableDateRange ? filter.formatEndDate : null,
      bookmarkTotal: filter.bookmarkTotal,
    );
    nextUrl = result.nextUrl;

    return result.illusts;
  }

  @override
  Future<List<Illust>> loadNextDataRoutine() async {
    final result = await pixivAPI.next<Illusts>(nextUrl!);

    nextUrl = result.nextUrl;

    return result.illusts;
  }
}
