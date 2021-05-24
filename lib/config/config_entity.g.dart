/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : config_entity.g.dart
 */

part of 'config_entity.dart';

ConfigEntity _$ConfigFromJson(Map<String, dynamic> json) {
  return ConfigEntity(
    json['UserId'] != null ? json['UserId'] as int : 0,
    json['Cookie'] != null ? json['Cookie'] as String : '',
    json['Token'] != null ? json['Token'] as String : '',
    json['ProxyIP'] != null ? json['ProxyIP'] as String : '127.0.0.1',
    json['ProxyPort'] != null ? json['ProxyPort'] as int : 12345,
    json['EnableProxy'] != null ? json['EnableProxy'] as bool : false,
    json['EnableImageProxy'] != null ? json['EnableImageProxy'] as bool : true,
    json['CreateUserFolder'] != null ? json['CreateUserFolder'] as bool : false,
  );
}

Map<String, dynamic> _$ConfigToJson(ConfigEntity instance) => <String, dynamic>{
      'UserId': instance.userId,
      'Cookie': instance.cookie,
      'Token': instance.token,
      'ProxyIP': instance.proxyIP,
      'ProxyPort': instance.proxyPort,
      'EnableProxy': instance.enableProxy,
      'EnableImageProxy': instance.enableImageProxy,
      'CreateUserFolder': instance.createUserFolder,
    };
