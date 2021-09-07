/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:meta_single_page.dart
 * 创建时间:2021/8/21 上午9:25
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';

part 'meta_single_page.g.dart';

@JsonSerializable(explicitToJson: true)
class MetaSinglePage {
  @JsonKey(name: 'original_image_url')
  String? originalImageUrl;

  MetaSinglePage(this.originalImageUrl);

  factory MetaSinglePage.fromJson(Map<String, dynamic> json) =>
      _$MetaSinglePageFromJson(json);

  Map<String, dynamic> toJson() => _$MetaSinglePageToJson(this);
}
