/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:image_scale_model.dart
 * 创建时间:2021/9/21 下午5:10
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:pixiv_func_android/provider/base_view_model.dart';

class ImageScaleModel extends BaseViewModel {
  final List<String> urls;
  final int initialPage;

  ImageScaleModel({required this.urls, this.initialPage = 0})
      : _currentPage = initialPage,
        pageController = PageController(initialPage: initialPage);

  final PageController pageController;

  int _currentPage;

  int get currentPage => _currentPage;

  set currentPage(int value) {
    _currentPage = value;
    notifyListeners();
  }
}
