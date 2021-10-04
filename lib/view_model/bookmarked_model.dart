/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:bookmarked_model.dart
 * 创建时间:2021/10/4 下午2:50
 * 作者:小草
 */

import 'package:pixiv_func_android/model/bookmarked_filter.dart';
import 'package:pixiv_func_android/provider/base_view_model.dart';

class BookmarkedModel extends BaseViewModel {
  BookmarkedFilter _filter = BookmarkedFilter.create();

  int _type = 0;

  bool _restrict = true;


  BookmarkedFilter get filter => _filter;

  set filter(BookmarkedFilter value) {
    _filter = value;
    notifyListeners();
  }

  int get type => _type;

  set type(int value) {
    if (value != _type) {
      _type = value;
      notifyListeners();
    }
  }



  bool get restrict => _restrict;

  set restrict(bool value) {
    if (value != _restrict) {
      _restrict = value;
      notifyListeners();
    }
  }


}
