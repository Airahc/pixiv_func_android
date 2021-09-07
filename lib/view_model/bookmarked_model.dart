/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:bookmarked_model.dart
 * 创建时间:2021/8/29 上午10:34
 * 作者:小草
 */

import 'package:pixiv_func_android/api/entity/illust.dart';
import 'package:pixiv_func_android/api/model/illusts.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/provider/base_view_state_refresh_list_model.dart';

class BookmarkedModel extends BaseViewStateRefreshListModel<Illust> {
  bool _restrict = true;

  bool get restrict => _restrict;

  set restrict(bool value) {
    if (value != _restrict) {
      _restrict = value;
      notifyListeners();
      refresh();
    }
  }

  @override
  Future<List<Illust>> loadFirstDataRoutine() async {
    if (null == accountManager.current) {
      return [];
    }
    final result = await pixivAPI.getUserBookmarks(int.parse(accountManager.current!.user.id), restrict: restrict);
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
