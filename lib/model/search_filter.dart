/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:search_filter.dart
 * 创建时间:2021/9/4 上午10:46
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:pixiv_func_android/api/enums.dart';

class SearchFilter {
  SearchTarget target;
  SearchSort sort;
  bool enableDateRange;
  DateTimeRange dateTimeRange;
  int? bookmarkTotal;
  SearchFilter({
    required this.target,
    required this.sort,
    required this.enableDateRange,
    required this.dateTimeRange,
    required this.bookmarkTotal,
  });

  ///因为Dart直接传对线是引用类型 所以需要创建一个副本 用于编辑
  factory SearchFilter.copy(SearchFilter filter) => SearchFilter(
        target: filter.target,
        sort: filter.sort,
        enableDateRange: filter.enableDateRange,
        dateTimeRange: filter.dateTimeRange,
        bookmarkTotal: filter.bookmarkTotal,
      );

  factory SearchFilter.create({
    SearchTarget target = SearchTarget.PARTIAL_MATCH_FOR_TAGS,
    SearchSort sort = SearchSort.DATE_DESC,
    bool enableDateLimit = false,
  }) {
    final DateTime _currentDate = DateTime.now();
    return SearchFilter(
      target: target,
      sort: sort,
      enableDateRange: enableDateLimit,
      dateTimeRange: DateTimeRange(
        start: DateTime(_currentDate.year - 1, _currentDate.month, _currentDate.day),
        end: DateTime(_currentDate.year, _currentDate.month, _currentDate.day),
      ),
      bookmarkTotal: null,
    );
  }

  String get formatStartDate => '${dateTimeRange.start.year}-${dateTimeRange.start.month}-${dateTimeRange.start.day}';
  String get formatEndDate => '${dateTimeRange.end.year}-${dateTimeRange.end.month}-${dateTimeRange.end.day}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchFilter &&
          runtimeType == other.runtimeType &&
          target == other.target &&
          sort == other.sort &&
          enableDateRange == other.enableDateRange &&
          dateTimeRange == other.dateTimeRange &&
          bookmarkTotal == other.bookmarkTotal;

  @override
  int get hashCode =>
      target.hashCode ^ sort.hashCode ^ enableDateRange.hashCode ^ dateTimeRange.hashCode ^ bookmarkTotal.hashCode;
}
