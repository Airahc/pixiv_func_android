/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:search_autocomplete.dart
 * 创建时间:2021/8/21 上午9:36
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:pixiv_func_android/api/entity/tag.dart';

part 'search_autocomplete.g.dart';

@JsonSerializable(explicitToJson: true)
class SearchAutocomplete {
  List<Tag> tags;

  SearchAutocomplete(this.tags);

  factory SearchAutocomplete.fromJson(Map<String, dynamic> json) =>
      _$SearchAutocompleteFromJson(json);

  Map<String, dynamic> toJson() => _$SearchAutocompleteToJson(this);
}
