/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:ugoira_metadata.dart
 * 创建时间:2021/9/12 下午7:35
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';

part 'ugoira_metadata.g.dart';

@JsonSerializable(explicitToJson: true)
class UgoiraMetadata {
  @JsonKey(name: 'ugoira_metadata')
  UgoiraMetadataContent ugoiraMetadata;

  UgoiraMetadata(this.ugoiraMetadata);

  factory UgoiraMetadata.fromJson(Map<String, dynamic> json) => _$UgoiraMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$UgoiraMetadataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UgoiraMetadataContent {
  @JsonKey(name: 'zip_urls')
  ZipUrls zipUrls;
  List<Frame> frames;

  UgoiraMetadataContent(this.zipUrls, this.frames);

  factory UgoiraMetadataContent.fromJson(Map<String, dynamic> json) => _$UgoiraMetadataContentFromJson(json);

  Map<String, dynamic> toJson() => _$UgoiraMetadataContentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ZipUrls {
  String medium;

  ZipUrls(this.medium);

  factory ZipUrls.fromJson(Map<String, dynamic> json) => _$ZipUrlsFromJson(json);

  Map<String, dynamic> toJson() => _$ZipUrlsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Frame {
  String file;
  int delay;

  Frame(this.file, this.delay);

  factory Frame.fromJson(Map<String, dynamic> json) => _$FrameFromJson(json);

  Map<String, dynamic> toJson() => _$FrameToJson(this);
}
