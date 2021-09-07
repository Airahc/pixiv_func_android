/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:users.dart
 * 创建时间:2021/8/24 下午8:26
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:pixiv_func_android/api/entity/user_preview.dart';

part 'users.g.dart';
@JsonSerializable(explicitToJson: true)
class Users{
  @JsonKey(name: 'user_previews')
  List<UserPreview> userPreviews;
  @JsonKey(name: 'next_url')
  String? nextUrl;

  Users(this.userPreviews, this.nextUrl);
  factory Users.fromJson(Map<String, dynamic> json) =>
      _$UsersFromJson(json);

  Map<String, dynamic> toJson() => _$UsersToJson(this);
}