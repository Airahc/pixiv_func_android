/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:bookmarked_filter_model.dart
 * 创建时间:2021/10/4 下午3:08
 * 作者:小草
 */

import 'package:pixiv_func_android/model/bookmarked_filter.dart';
import 'package:pixiv_func_android/provider/base_view_model.dart';

class BookmarkedFilterModel extends BaseViewModel {
  final BookmarkedFilter filter;

  BookmarkedFilterModel(BookmarkedFilter filter) : filter = BookmarkedFilter.copy(filter);

  bool get restrict => filter.restrict;

  set restrict(bool value) {
    filter.restrict = value;
    notifyListeners();
  }
}
