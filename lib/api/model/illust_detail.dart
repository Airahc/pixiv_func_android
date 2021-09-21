/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:illust_detail.dart
 * 创建时间:2021/9/8 上午8:54
 * 作者:小草
 */
import 'package:json_annotation/json_annotation.dart';
import '../entity/illust.dart';

part 'illust_detail.g.dart';

@JsonSerializable(explicitToJson: true)
class IllustDetail {
  Illust illust;

  IllustDetail(this.illust);

  factory IllustDetail.fromJson(Map<String, dynamic> json) => _$IllustDetailFromJson(json);

  Map<String, dynamic> toJson() => _$IllustDetailToJson(this);
}
