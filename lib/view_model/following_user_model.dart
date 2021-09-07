/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:following_user_model.dart
 * 创建时间:2021/8/29 下午11:13
 * 作者:小草
 */

import 'package:pixiv_func_android/api/entity/user_preview.dart';
import 'package:pixiv_func_android/api/model/users.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/provider/base_view_state_refresh_list_model.dart';

class FollowingUserModel extends BaseViewStateRefreshListModel<UserPreview> {
  final int userId;

  FollowingUserModel(this.userId);

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
  Future<List<UserPreview>> loadFirstDataRoutine() async {
    final result = await pixivAPI.getFollowingUsers(userId, restrict: restrict);
    nextUrl = result.nextUrl;
    return result.userPreviews;
  }

  @override
  Future<List<UserPreview>> loadNextDataRoutine() async {
    final result = await pixivAPI.next<Users>(nextUrl!);
    nextUrl = result.nextUrl;
    return result.userPreviews;
  }
}
