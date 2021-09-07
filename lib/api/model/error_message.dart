/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:error_message.dart
 * 创建时间:2021/8/24 下午12:16
 * 作者:小草
 */

import 'package:json_annotation/json_annotation.dart';
part 'error_message.g.dart';

@JsonSerializable(explicitToJson: true)
class ErrorMessage {
  Error error;

  ErrorMessage({
    required this.error,
  });

  factory ErrorMessage.fromJson(Map<String, dynamic> json) =>
      _$ErrorMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorMessageToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Error {
  @JsonKey(name: 'user_message')
  String? userMessage;
  String? message;
  String? reason;
  @JsonKey(name: 'user_message_details')
  Object? userMessageDetails;


  Error(this.userMessage, this.message, this.reason, this.userMessageDetails);

  factory Error.fromJson(Map<String, dynamic> json) => _$ErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorToJson(this);
}
