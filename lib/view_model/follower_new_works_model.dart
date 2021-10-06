/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:follower_new_works_model.dart
 * 创建时间:2021/10/5 下午12:22
 * 作者:小草
 */

import 'package:pixiv_func_android/provider/base_view_model.dart';

class FollowerNewWorksModel extends BaseViewModel {
  int _index = 0;

  bool? _restrict = true;

  final restrictItems = [const MapEntry(null,'全部'), const MapEntry(true,'公开'),const MapEntry(false,'悄悄')];

  int get index => _index;

  set index(int value) {
    if (value != _index) {
      _index = value;
      notifyListeners();
    }
  }

  bool? get restrict => _restrict;

  set restrict(bool? value) {
    if (value != _restrict) {
      _restrict = value;
      notifyListeners();
    }
  }
}
