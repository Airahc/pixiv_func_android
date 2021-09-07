/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:ranking_model.dart
 * 创建时间:2021/8/31 下午10:22
 * 作者:小草
 */
import 'package:pixiv_func_android/api/entity/illust.dart';
import 'package:pixiv_func_android/api/enums.dart';
import 'package:pixiv_func_android/api/model/illusts.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/provider/base_view_state_refresh_list_model.dart';

class RankingModel extends BaseViewStateRefreshListModel<Illust>{
  final RankingMode _mode;

  RankingModel(this._mode);

  @override
  Future<List<Illust>> loadFirstDataRoutine() async {
    final result = await pixivAPI.getRanking(_mode);
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
