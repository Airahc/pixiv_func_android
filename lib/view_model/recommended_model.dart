/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:recommended_model.dart
 * 创建时间:2021/8/25 上午10:21
 * 作者:小草
 */

import 'package:pixiv_func_android/api/entity/illust.dart';
import 'package:pixiv_func_android/api/enums.dart';
import 'package:pixiv_func_android/api/model/illusts.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/provider/base_view_state_refresh_list_model.dart';

class RecommendedModel extends BaseViewStateRefreshListModel<Illust> {
  WorkType _type = WorkType.ILLUST;

  WorkType get type => _type;

  set type(WorkType value) {
    if (value != _type) {
      _type = value;
      notifyListeners();
      refresh();
    } else {
      scrollToTop();
    }
  }

  @override
  Future<List<Illust>> loadFirstDataRoutine() async {
    final result = await pixivAPI.getRecommendedIllusts(type);
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
