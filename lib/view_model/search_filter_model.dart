/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_android
 * 文件名称:search_filter_model.dart
 * 创建时间:2021/9/3 下午11:18
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:pixiv_func_android/api/enums.dart';
import 'package:pixiv_func_android/model/search_filter.dart';
import 'package:pixiv_func_android/provider/base_view_model.dart';

class SearchFilterModel extends BaseViewModel {
  SearchFilter filter;

  SearchFilterModel({required SearchFilter filter}) : filter = SearchFilter.copy(filter);

  SearchTarget get target => filter.target;

  DateTime get currentDate => DateTime.now();

  int _dateTimeRangeType = 0;

  int get dateTimeRangeType => _dateTimeRangeType;



  int get bookmarkTotalSelected => bookmarkTotalItems.indexWhere((item) => item == filter.bookmarkTotal);

  final bookmarkTotalItems = <int?>[null, 100, 250, 500, 1000, 5000, 10000, 20000, 30000, 50000];

  set bookmarkTotalSelected(int value) {
    bookmarkTotal = bookmarkTotalItems[value];
    notifyListeners();
  }

  set dateTimeRangeType(int value) {
    _dateTimeRangeType = value;
    notifyListeners();
  }

  set target(SearchTarget value) {
    filter.target = value;
    notifyListeners();
  }

  SearchSort get sort => filter.sort;

  set sort(SearchSort value) {
    filter.sort = value;
    notifyListeners();
  }

  bool get enableDateRange => filter.enableDateRange;

  set enableDateRange(bool value) {
    filter.enableDateRange = value;
    notifyListeners();
  }

  String get startDate => filter.formatStartDate;

  String get endDate => filter.formatEndDate;

  DateTimeRange get dateTimeRange => filter.dateTimeRange;

  set dateTimeRange(DateTimeRange value) {
    filter.dateTimeRange = value;
    notifyListeners();
  }

  int? get bookmarkTotal => filter.bookmarkTotal;

  set bookmarkTotal(int? value) {
    filter.bookmarkTotal = value;
    notifyListeners();
  }

  String get bookmarkTotalText {
    final item = bookmarkTotalItems[bookmarkTotalSelected];
    if (null == item) {
      return '收藏数量不限';
    } else {
      return '超过$item的收藏';
    }
  }
}
