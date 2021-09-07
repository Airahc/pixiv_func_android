/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:tag.dart
 * 创建时间:2021/8/21 上午9:24
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@JsonSerializable(explicitToJson: true)
class Tag {
  String name;
  @JsonKey(name: 'translated_name')
  String? translatedName;

  Tag(this.name, this.translatedName);

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);
}
