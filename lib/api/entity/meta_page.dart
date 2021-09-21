/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:meta_page.dart
 * 创建时间:2021/9/19 下午6:28
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';
import 'image_urls.dart';
part 'meta_page.g.dart';

@JsonSerializable(explicitToJson: true)
class MetaPage{
  @JsonKey(name: 'image_urls')
  ImageUrls imageUrls;

  MetaPage(this.imageUrls);

  factory MetaPage.fromJson(Map<String, dynamic> json) => _$MetaPageFromJson(json);

  Map<String, dynamic> toJson() => _$MetaPageToJson(this);
}