/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:profile_image_urls.dart
 * 创建时间:2021/8/21 上午9:17
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';

part 'profile_image_urls.g.dart';

@JsonSerializable(explicitToJson: true)
class ProfileImageUrls {
  String medium;

  ProfileImageUrls(this.medium);

  factory ProfileImageUrls.fromJson(Map<String, dynamic> json) =>
      _$ProfileImageUrlsFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileImageUrlsToJson(this);
}
