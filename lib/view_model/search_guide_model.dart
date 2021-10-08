/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:search_guide_model.dart
 * 创建时间:2021/10/8 下午9:22
 * 作者:小草
 */

import 'package:pixiv_func_android/provider/base_view_model.dart';

class SearchGuideModel extends BaseViewModel {
  int _index = 0;

  int get index => _index;

  set index(int value) {
    _index = value;
    notifyListeners();
  }
}
