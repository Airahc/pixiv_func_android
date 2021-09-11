/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:illust_related_model.dart
 * 创建时间:2021/8/28 上午11:20
 * 作者:小草
 */

import 'package:pixiv_func_android/api/entity/illust.dart';
import 'package:pixiv_func_android/api/model/illusts.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/log/log.dart';
import 'package:pixiv_func_android/provider/base_view_state_list_model.dart';

class IllustRelatedModel extends BaseViewStateListModel<Illust> {
  final int id;

  IllustRelatedModel(this.id);

  void loadFirstData() {
    setBusy();
    pixivAPI.getIllustRelated(id).then((result) {
      if (result.illusts.isNotEmpty) {
        list.addAll(result.illusts);
        setIdle();
      } else {
        setEmpty();
      }

      nextUrl = result.nextUrl;
      initialized = true;
    }).catchError((e,s) {
      Log.e('首次加载数据异常', e);
      setInitFailed(e,s);
    });
  }

  void loadNextData() {
    setBusy();
    pixivAPI.next<Illusts>(nextUrl!).then((result) {
      list.addAll(result.illusts);
      nextUrl = result.nextUrl;
      setIdle();
    }).catchError((e) {
      Log.e('加载下一条数据异常', e);
      setLoadFailed();
    });
  }
}
