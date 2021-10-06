/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:recommended_model.dart
 * 创建时间:2021/8/25 上午10:21
 * 作者:小草
 */

import 'package:pixiv_func_android/api/enums.dart';
import 'package:pixiv_func_android/provider/base_view_model.dart';

class RecommendedModel extends BaseViewModel {
  WorkType _type = WorkType.illust;

  WorkType get type => _type;

  set type(WorkType value) {
    if (value != _type) {
      _type = value;
      notifyListeners();
    }
  }

}
