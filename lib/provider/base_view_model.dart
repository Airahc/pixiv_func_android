/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:base_view_model.dart
 * 创建时间:2021/8/23 下午5:58
 * 作者:小草
 */

import 'package:flutter/cupertino.dart';

abstract class BaseViewModel with ChangeNotifier{
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}