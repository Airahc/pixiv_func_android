// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountEntity _$AccountEntityFromJson(Map<String, dynamic> json) {
  return AccountEntity(
    json['userId'] is int ? json['userId'] as int : 0,
    json['cookie'] is String ? json['cookie'] as String : '',
    json['token'] is String ? json['token'] as String : '',
  );
}

Map<String, dynamic> _$AccountEntityToJson(AccountEntity instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'cookie': instance.cookie,
      'token': instance.token,
    };

ConfigEntity _$ConfigEntityFromJson(Map<String, dynamic> json) {
  return ConfigEntity(
    json['accounts'] is List
        ? (json['accounts'] as List<dynamic>)
            .map((e) => AccountEntity.fromJson(e as Map<String, dynamic>))
            .toList()
        : [],
    json['currentAccount'] is Map<String, dynamic>
        ? AccountEntity.fromJson(json['currentAccount'] as Map<String, dynamic>)
        : AccountEntity.empty(),
    json['enableImageProxy'] is bool ? json['enableImageProxy'] as bool : true,
  );
}

Map<String, dynamic> _$ConfigEntityToJson(ConfigEntity instance) =>
    <String, dynamic>{
      'accounts': instance.accounts.map((e) => e.toJson()).toList(),
      'currentAccount': instance.currentAccount.toJson(),
      'enableImageProxy': instance.enableImageProxy,
    };
