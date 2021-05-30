/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : config_entity.dart
 */

import 'package:json_annotation/json_annotation.dart';

part 'config_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class AccountEntity {
  int userId;
  String cookie;
  String token;

  AccountEntity(this.userId, this.cookie, this.token);

  factory AccountEntity.fromJson(Map<String, dynamic> json) =>
      _$AccountEntityFromJson(json);

  factory AccountEntity.empty()=>AccountEntity(0, '', '');

  Map<String, dynamic> toJson() => _$AccountEntityToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ConfigEntity {
  List<AccountEntity> accounts;
  AccountEntity currentAccount;
  bool enableImageProxy;


  ConfigEntity(this.accounts, this.currentAccount, this.enableImageProxy);

  factory ConfigEntity.fromJson(Map<String, dynamic> json) =>
      _$ConfigEntityFromJson(json);

  factory ConfigEntity.empty()=>ConfigEntity([], AccountEntity.empty(), true);

  Map<String, dynamic> toJson() => _$ConfigEntityToJson(this);
}
