/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:trending_illust_model.dart
 * 创建时间:2021/9/2 下午2:11
 * 作者:小草
 */

import 'package:pixiv_func_android/api/model/trending_tags.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/provider/base_view_state_refresh_list_model.dart';

class TrendingIllustModel extends BaseViewStateRefreshListModel<TrendTag> {
  @override
  Future<List<TrendTag>> loadFirstDataRoutine() async {
    final result = await pixivAPI.getTrendingTags();
    return result.trendTags;
  }

  @override
  Future<List<TrendTag>> loadNextDataRoutine() async {
    return [];
  }
}
