/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:illusts.dart
 * 创建时间:2021/8/21 上午9:34
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:pixiv_func_android/api/entity/novel.dart';

part 'search_novel.g.dart';

@JsonSerializable(explicitToJson: true)
class SearchNovel {
  List<Novel> novels;
  @JsonKey(name: 'next_url')
  String? nextUrl;
  @JsonKey(name: 'search_span_limit')
  int searchSpanLimit;

  SearchNovel(this.novels, this.nextUrl, this.searchSpanLimit);

  factory SearchNovel.fromJson(Map<String, dynamic> json) => _$SearchNovelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchNovelToJson(this);
}
