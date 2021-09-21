/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:stamps.dart
 * 创建时间:2021/8/21 上午9:36
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';
import '../entity/stamp.dart';

part 'stamps.g.dart';

@JsonSerializable(explicitToJson: true)
class Stamps {
  List<Stamp> stamps;

  Stamps(this.stamps);

  factory Stamps.fromJson(Map<String, dynamic> json) => _$StampsFromJson(json);

  Map<String, dynamic> toJson() => _$StampsToJson(this);
}
