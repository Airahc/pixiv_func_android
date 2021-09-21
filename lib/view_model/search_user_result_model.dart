/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:search_user_result_model.dart
 * 创建时间:2021/9/6 下午5:19
 * 作者:小草
 */

import 'package:pixiv_func_android/api/entity/user_preview.dart';
import 'package:pixiv_func_android/api/model/users.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/provider/base_view_state_refresh_list_model.dart';

class SearchUserResultModel extends BaseViewStateRefreshListModel {
  final String word;

  SearchUserResultModel(this.word);

  @override
  Future<List<UserPreview>> loadFirstDataRoutine() async {
    final result = await pixivAPI.searchUsers(word);
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
