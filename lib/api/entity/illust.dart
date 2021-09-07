/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:illust.dart
 * 创建时间:2021/8/21 上午9:21
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:pixiv_func_android/api/entity/image_urls.dart';
import 'package:pixiv_func_android/api/entity/meta_single_page.dart';
import 'package:pixiv_func_android/api/entity/tag.dart';
import 'package:pixiv_func_android/api/entity/user.dart';
import 'package:pixiv_func_android/api/model/meta_page.dart';

part 'illust.g.dart';

@JsonSerializable(explicitToJson: true)
class Illust {
  int id;
  String title;
  String type;
  @JsonKey(name: 'image_urls')
  ImageUrls imageUrls;
  String caption;
  int restrict;
  User user;
  List<Tag> tags;

  ///画师制作这个作品使用的工具 如 "PS" "SAI" "Live2D" 等
  List<String> tools;
  @JsonKey(name: 'create_date')
  String createDate;
  @JsonKey(name: 'page_count')
  int pageCount;
  int width;
  int height;
  @JsonKey(name: 'sanity_level')
  int sanityLevel;
  @JsonKey(name: 'x_restrict')
  int xRestrict;
  ///当[pageCount]等于1时 图片的originalImageUrl存在这里
  @JsonKey(name: 'meta_single_page')
  MetaSinglePage metaSinglePage;
  ///当[pageCount]大于1时 图片的[ImageUrls]存在这里
  @JsonKey(name: 'meta_pages')
  List<MetaPage> metaPages;
  @JsonKey(name: 'total_view')
  int totalView;
  @JsonKey(name: 'total_bookmarks')
  int totalBookmarks;
  @JsonKey(name: 'is_bookmarked')
  bool isBookmarked;
  bool visible;
  @JsonKey(name: 'is_muted')
  bool isMuted;
  ///这个字段必须在获取 "detail" 的时候才有值
  @JsonKey(name: 'total_comments')
  int? totalComments;
  Illust(
    this.id,
    this.title,
    this.type,
    this.imageUrls,
    this.caption,
    this.restrict,
    this.user,
    this.tags,
    this.tools,
    this.createDate,
    this.pageCount,
    this.width,
    this.height,
    this.sanityLevel,
    this.xRestrict,
    this.metaSinglePage,
    this.metaPages,
    this.totalView,
    this.totalBookmarks,
    this.isBookmarked,
    this.visible,
    this.isMuted,
  );

  factory Illust.fromJson(Map<String, dynamic> json) => _$IllustFromJson(json);

  Map<String, dynamic> toJson() => _$IllustToJson(this);
}
