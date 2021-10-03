/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:novel.dart
 * 创建时间:2021/10/3 下午2:38
 * 作者:小草
 */
import 'package:json_annotation/json_annotation.dart';
import 'package:pixiv_func_android/api/entity/image_urls.dart';
import 'package:pixiv_func_android/api/entity/tag.dart';
import 'package:pixiv_func_android/api/entity/user.dart';

part 'novel.g.dart';

@JsonSerializable(explicitToJson: true)
class Novel {
  int id;
  String title;
  String caption;
  int restrict;
  @JsonKey(name: 'x_restrict')
  int xRestrict;
  @JsonKey(name: 'is_original')
  bool isOriginal;
  @JsonKey(name: 'image_urls')
  ImageUrls imageUrls;
  @JsonKey(name: 'create_date')
  String createDate;
  List<Tag> tags;
  @JsonKey(name: 'page_count')
  int pageCount;
  @JsonKey(name: 'text_length')
  int textLength;
  User user;
  Series series;
  @JsonKey(name: 'total_bookmarks')
  int totalBookmarks;
  @JsonKey(name: 'is_bookmarked')
  bool isBookmarked;
  @JsonKey(name: 'total_view')
  int totalView;
  bool visible;
  @JsonKey(name: 'total_comments')
  int totalComments;
  @JsonKey(name: 'is_muted')
  bool isMuted;
  @JsonKey(name: 'is_mypixiv_only')
  bool isMyPixivOnly;
  @JsonKey(name: 'is_x_restricted')
  bool isXRestricted;

  Novel(
    this.id,
    this.title,
    this.caption,
    this.restrict,
    this.xRestrict,
    this.isOriginal,
    this.imageUrls,
    this.createDate,
    this.tags,
    this.pageCount,
    this.textLength,
    this.user,
    this.series,
    this.totalBookmarks,
    this.isBookmarked,
    this.totalView,
    this.visible,
    this.totalComments,
    this.isMuted,
    this.isMyPixivOnly,
    this.isXRestricted,
  );

  factory Novel.fromJson(Map<String, dynamic> json) => _$NovelFromJson(json);

  Map<String, dynamic> toJson() => _$NovelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Series {
  int? id;
  String? title;

  Series(this.id, this.title);

  factory Series.fromJson(Map<String, dynamic> json) => _$SeriesFromJson(json);

  Map<String, dynamic> toJson() => _$SeriesToJson(this);
}
