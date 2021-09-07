/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:stamp.dart
 * 创建时间:2021/8/21 上午9:20
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';

part 'stamp.g.dart';

@JsonSerializable(explicitToJson: true)
class Stamp {
  @JsonKey(name: 'stamp_id')
  int stampId;
  @JsonKey(name: 'stamp_url')
  String stampUrl;

  Stamp(this.stampId, this.stampUrl);

  factory Stamp.fromJson(Map<String, dynamic> json) => _$StampFromJson(json);

  Map<String, dynamic> toJson() => _$StampToJson(this);
}
