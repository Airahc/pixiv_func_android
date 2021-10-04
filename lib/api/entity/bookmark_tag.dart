/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:bookmark_tag.dart
 * 创建时间:2021/10/4 下午6:58
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';

part 'bookmark_tag.g.dart';

@JsonSerializable(explicitToJson: true)
class BookmarkTag{
  String name;
  int count;

  BookmarkTag(this.name, this.count);

  factory BookmarkTag.fromJson(Map<String, dynamic> json) =>
      _$BookmarkTagFromJson(json);

  Map<String, dynamic> toJson() => _$BookmarkTagToJson(this);
}