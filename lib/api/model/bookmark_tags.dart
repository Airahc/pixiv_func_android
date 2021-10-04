/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:bookmark_tags.dart
 * 创建时间:2021/10/4 下午7:01
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:pixiv_func_android/api/entity/bookmark_tag.dart';

part 'bookmark_tags.g.dart';

@JsonSerializable(explicitToJson: true)
class BookmarkTags {
  @JsonKey(name: 'bookmark_tags')
  List<BookmarkTag> bookmarkTags;
  @JsonKey(name: 'next_url')
  String? nextUrl;

  BookmarkTags(this.bookmarkTags, this.nextUrl);

  factory BookmarkTags.fromJson(Map<String, dynamic> json) => _$BookmarkTagsFromJson(json);

  Map<String, dynamic> toJson() => _$BookmarkTagsToJson(this);
}
