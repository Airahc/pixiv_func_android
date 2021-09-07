/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:image_urls.dart
 * 创建时间:2021/8/21 上午9:22
 * 作者:小草
 */
import 'package:json_annotation/json_annotation.dart';

part 'image_urls.g.dart';

@JsonSerializable(explicitToJson: true)
class ImageUrls {
  @JsonKey(name: 'square_medium')
  String squareMedium;
  String medium;
  String large;
  String? original;

  ImageUrls(this.squareMedium, this.medium, this.large, this.original);

  factory ImageUrls.fromJson(Map<String, dynamic> json) =>
      _$ImageUrlsFromJson(json);

  Map<String, dynamic> toJson() => _$ImageUrlsToJson(this);
}
