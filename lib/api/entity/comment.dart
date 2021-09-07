/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:comment.dart
 * 创建时间:2021/8/21 上午9:19
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:pixiv_func_android/api/entity/stamp.dart';
import 'package:pixiv_func_android/api/entity/user.dart';

part 'comment.g.dart';

@JsonSerializable(explicitToJson: true)
class Comment{
  int id;
  ///内容
  String comment;
  String date;
  User user;
  @JsonKey(name: 'has_replies')
  bool hasReplies;
  Stamp? stamp;


  Comment(this.id, this.comment, this.date, this.user, this.hasReplies, this.stamp);

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
