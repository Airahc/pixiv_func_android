/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:illusts.dart
 * 创建时间:2021/8/21 上午9:34
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';
import '../entity/illust.dart';

part 'illusts.g.dart';

@JsonSerializable(explicitToJson: true)
class Illusts {
  List<Illust> illusts;
  @JsonKey(name: 'next_url')
  String? nextUrl;

  Illusts(this.illusts, this.nextUrl);

  factory Illusts.fromJson(Map<String, dynamic> json) =>
      _$IllustsFromJson(json);

  Map<String, dynamic> toJson() => _$IllustsToJson(this);
}
