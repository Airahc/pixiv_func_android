/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:recommend_user_model.dart
 * 创建时间:2021/9/2 下午2:15
 * 作者:小草
 */

import 'package:pixiv_func_android/api/entity/user_preview.dart';
import 'package:pixiv_func_android/api/model/users.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/provider/base_view_state_refresh_list_model.dart';

class RecommendUserModel extends BaseViewStateRefreshListModel<UserPreview>{

  @override
  Future<List<UserPreview>> loadFirstDataRoutine() async {
    final result = await pixivAPI.getRecommendedUsers();
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