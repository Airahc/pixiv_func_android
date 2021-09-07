/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:user.dart
 * 创建时间:2021/8/21 上午9:16
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';

import 'package:pixiv_func_android/api/entity/profile_image_urls.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  int id;
  String name;
  String account;
  @JsonKey(name: 'profile_image_urls')
  ProfileImageUrls profileImageUrls;
  ///当[User]在Comment中的时候没有这个字段
  @JsonKey(name: 'is_followed')
  bool? isFollowed;

  User(
    this.id,
    this.name,
    this.account,
    this.profileImageUrls,
    this.isFollowed,
  );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
