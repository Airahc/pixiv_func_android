/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:comments.dart
 * 创建时间:2021/8/21 上午9:33
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:pixiv_func_android/api/entity/comment.dart';

part 'comments.g.dart';

@JsonSerializable(explicitToJson: true)
class Comments {
  List<Comment> comments;
  @JsonKey(name: 'next_url')
  String? nextUrl;

  Comments(this.comments, this.nextUrl);

  factory Comments.fromJson(Map<String, dynamic> json) =>
      _$CommentsFromJson(json);

  Map<String, dynamic> toJson() => _$CommentsToJson(this);
}
