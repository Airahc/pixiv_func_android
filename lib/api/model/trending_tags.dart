/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:trending_tags.dart
 * 创建时间:2021/8/21 上午9:37
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:pixiv_func_android/api/entity/illust.dart';

part 'trending_tags.g.dart';

@JsonSerializable(explicitToJson: true)
class TrendingTags {
  @JsonKey(name: 'trend_tags')
  List<TrendTag> trendTags;

  TrendingTags(this.trendTags);

  factory TrendingTags.fromJson(Map<String, dynamic> json) =>
      _$TrendingTagsFromJson(json);

  Map<String, dynamic> toJson() => _$TrendingTagsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TrendTag {
  String tag;
  @JsonKey(name: 'translated_name')
  String? translatedName;
  Illust illust;

  TrendTag(this.tag, this.translatedName, this.illust);

  factory TrendTag.fromJson(Map<String, dynamic> json) =>
      _$TrendTagFromJson(json);

  Map<String, dynamic> toJson() => _$TrendTagToJson(this);
}
