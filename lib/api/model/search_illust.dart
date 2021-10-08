/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:illusts.dart
 * 创建时间:2021/8/21 上午9:34
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';
import '../entity/illust.dart';

part 'search_illust.g.dart';

@JsonSerializable(explicitToJson: true)
class SearchIllust {
  List<Illust> illusts;
  @JsonKey(name: 'next_url')
  String? nextUrl;
  @JsonKey(name: 'search_span_limit')
  int searchSpanLimit;

  SearchIllust(this.illusts, this.nextUrl, this.searchSpanLimit);

  factory SearchIllust.fromJson(Map<String, dynamic> json) => _$SearchIllustFromJson(json);

  Map<String, dynamic> toJson() => _$SearchIllustToJson(this);
}
