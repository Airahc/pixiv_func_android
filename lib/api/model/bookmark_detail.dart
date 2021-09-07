/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:bookmark_detail.dart
 * 创建时间:2021/8/26 下午7:14
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';

part 'bookmark_detail.g.dart';

@JsonSerializable(explicitToJson: true)
class BookmarkDetail{
  @JsonKey(name: 'is_bookmarked')
  bool isBookmarked;
  List<String> tags;
  String restrict;

  BookmarkDetail(this.isBookmarked, this.tags, this.restrict);
  factory BookmarkDetail.fromJson(Map<String, dynamic> json) =>
      _$BookmarkDetailFromJson(json);

  Map<String, dynamic> toJson() => _$BookmarkDetailToJson(this);
}