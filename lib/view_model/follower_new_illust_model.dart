/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:follower_new_novel_model.dart
 * 创建时间:2021/10/5 下午8:23
 * 作者:小草
 */

import 'package:pixiv_func_android/api/entity/illust.dart';
import 'package:pixiv_func_android/api/model/illusts.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/provider/base_view_state_refresh_list_model.dart';

class FollowerNewIllustModel extends BaseViewStateRefreshListModel<Illust> {
  final bool? restrict;

  FollowerNewIllustModel(this.restrict);

  @override
  Future<List<Illust>> loadFirstDataRoutine()async {
    final result = await pixivAPI.getFollowerNewIllusts(restrict: restrict);
    nextUrl = result.nextUrl;

    return result.illusts;
  }

  @override
  Future<List<Illust>> loadNextDataRoutine()async {
    final result = await pixivAPI.next<Illusts>(nextUrl!);
    nextUrl = result.nextUrl;

    return result.illusts;
  }
}
