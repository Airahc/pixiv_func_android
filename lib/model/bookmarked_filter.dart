/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:bookmarked_filter.dart
 * 创建时间:2021/10/4 下午2:57
 * 作者:小草
 */

class BookmarkedFilter {
  bool restrict;
  String? tag;

  //未分类(日语)
  static const uncategorized = '未分類';

  BookmarkedFilter({required this.restrict, required this.tag});

  factory BookmarkedFilter.create() => BookmarkedFilter(
        restrict: true,
        tag: null,
      );

  factory BookmarkedFilter.copy(BookmarkedFilter filter) => BookmarkedFilter(
        restrict: filter.restrict,
        tag: filter.tag,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkedFilter && runtimeType == other.runtimeType && restrict == other.restrict && tag == other.tag;

  @override
  int get hashCode => restrict.hashCode ^ tag.hashCode;
}
