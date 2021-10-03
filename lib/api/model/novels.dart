/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:novels.dart
 * 创建时间:2021/10/3 下午4:05
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:pixiv_func_android/api/entity/novel.dart';

part 'novels.g.dart';

@JsonSerializable(explicitToJson: true)
class Novels {
  List<Novel> novels;
  String? nextUrl;

  Novels(this.novels, this.nextUrl);

  factory Novels.fromJson(Map<String, dynamic> json) => _$NovelsFromJson(json);

  Map<String, dynamic> toJson() => _$NovelsToJson(this);
}
