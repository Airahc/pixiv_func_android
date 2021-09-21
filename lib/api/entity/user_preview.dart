/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:user_preview.dart
 * 创建时间:2021/8/21 上午9:30
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';
import 'illust.dart';
import 'user.dart';


part 'user_preview.g.dart';

@JsonSerializable(explicitToJson: true)
class UserPreview {
  User user;
  List<Illust> illusts;

  //novels : List<Novel> 小说

  @JsonKey(name: 'is_muted')
  bool isMuted;

  UserPreview(this.user, this.illusts, this.isMuted);

  factory UserPreview.fromJson(Map<String, dynamic> json) =>
      _$UserPreviewFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreviewToJson(this);
}