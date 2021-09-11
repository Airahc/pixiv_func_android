/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_android
 * 文件名称:illust_model.dart
 * 创建时间:2021/9/11 上午11:32
 * 作者:小草
 */

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pixiv_func_android/api/model/illust_detail.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/log/log.dart';
import 'package:pixiv_func_android/provider/base_view_state_model.dart';

class IllustModel extends BaseViewStateModel {
  final int id;
  IllustDetail? illustDetail;

  IllustModel(this.id);

  bool _bookmarkRequestWaiting = false;

  bool get bookmarkRequestWaiting => _bookmarkRequestWaiting;

  set bookmarkRequestWaiting(bool value) {
    _bookmarkRequestWaiting = value;
    notifyListeners();
  }

  set isBookmarked(bool value) {
    illustDetail!.illust.isBookmarked = value;
    notifyListeners();
  }

  void loadData() async {
    illustDetail = null;
    setBusy();

    pixivAPI.getIllustDetail(id).then((result) {
      illustDetail = result;
      initialized = true;
      setIdle();
    }).catchError((e, s) {
      if (e is DioError && e.response?.statusCode == HttpStatus.notFound) {
        setEmpty();
      } else {
        setInitFailed(e, s);
      }
      Log.e('获取插画详细异常', e);
    });
  }
}
