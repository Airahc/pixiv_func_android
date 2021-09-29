/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:search_image_result_model.dart
 * 创建时间:2021/9/29 下午6:36
 * 作者:小草
 */

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/model/search_image_item.dart';
import 'package:pixiv_func_android/model/search_image_result.dart';
import 'package:pixiv_func_android/provider/base_view_model.dart';

class SearchImageResultModel extends BaseViewModel {
  final list = <SearchImageItem>[];

  SearchImageResultModel(List<SearchImageResult> results) {
    list.addAll(results.map((result) => SearchImageItem(result)));
  }

  void loadData(SearchImageItem item) {
    item.loadFailed = false;
    item.loading = true;
    notifyListeners();
    pixivAPI.getIllustDetail(item.result.illustId).then((result) {
      item.illust = result.illust;
      item.loading = false;
      notifyListeners();
    }).catchError((e, s) {
      item.loading = false;
      if (e is DioError && HttpStatus.notFound == e.response?.statusCode) {
        remove(item.result.illustId);
      } else {
        item.loadFailed = true;
        notifyListeners();
      }
    });
  }

  void loadAll() {
    for (final item in list) {
      loadData(item);
    }
  }

  void remove(int id) {
    list.removeWhere((item) => id == item.result.illustId);
    notifyListeners();
  }
}
