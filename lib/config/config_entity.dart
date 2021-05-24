/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : config_entity.dart
 */

import 'package:json_annotation/json_annotation.dart';

part 'config_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class ConfigEntity {
  @JsonKey(name: 'UserId')
  int userId;
  @JsonKey(name: 'Cookie')
  String cookie;
  @JsonKey(name: 'Token')
  String token;
  @JsonKey(name: 'ProxyIP')
  String proxyIP;
  @JsonKey(name: 'ProxyPort')
  int proxyPort;
  @JsonKey(name: 'EnableProxy')
  bool enableProxy;
  @JsonKey(name: 'EnableImageProxy')
  bool enableImageProxy;
  @JsonKey(name: 'CreateUserFolder')
  bool createUserFolder;

  ConfigEntity(this.userId, this.cookie, this.token, this.proxyIP, this.proxyPort,
      this.enableProxy, this.enableImageProxy, this.createUserFolder);

  factory ConfigEntity.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigToJson(this);
}
