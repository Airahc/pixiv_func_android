/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_android
 * 文件名称:search_image_result_item_model.dart
 * 创建时间:2021/9/7 下午6:16
 * 作者:小草
 */

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pixiv_func_android/api/entity/illust.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/provider/base_view_state_model.dart';

class SearchImageResultItemModel extends BaseViewStateModel {
  final int illustId;

  SearchImageResultItemModel(this.illustId);

  Illust? illust;

  void loadData() {
    setBusy();
    pixivAPI.getIllustDetail(illustId).then((result) {
      illust = result.illust;
      setIdle();
    }).catchError((e, s) {
      if (e is DioError && HttpStatus.notFound == e.response?.statusCode) {
        setEmpty();
      } else {
        setInitFailed(e, s);
      }
    });
  }
}
