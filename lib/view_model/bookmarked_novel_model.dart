/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:bookmarked_novel_model.dart
 * 创建时间:2021/10/4 下午2:40
 * 作者:小草
 */

import 'package:pixiv_func_android/api/entity/novel.dart';
import 'package:pixiv_func_android/api/model/novels.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/model/bookmarked_filter.dart';
import 'package:pixiv_func_android/provider/base_view_state_refresh_list_model.dart';

class BookmarkedNovelModel extends BaseViewStateRefreshListModel<Novel> {
  final BookmarkedFilter filter;

  BookmarkedNovelModel(this.filter);

  @override
  Future<List<Novel>> loadFirstDataRoutine() async {
    if (null == accountManager.current) {
      return [];
    }
    final result =
        await pixivAPI.getUserNovelBookmarks(int.parse(accountManager.current!.user.id), restrict: filter.restrict);
    nextUrl = result.nextUrl;

    return result.novels;
  }

  @override
  Future<List<Novel>> loadNextDataRoutine() async {
    final result = await pixivAPI.next<Novels>(nextUrl!);

    nextUrl = result.nextUrl;

    return result.novels;
  }
}
