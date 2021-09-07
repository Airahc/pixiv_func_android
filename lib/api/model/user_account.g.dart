// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAccount _$UserAccountFromJson(Map<String, dynamic> json) => UserAccount(
      json['access_token'] as String,
      json['expires_in'] as int,
      json['token_type'] as String,
      json['scope'] as String,
      json['refresh_token'] as String,
      LocalUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserAccountToJson(UserAccount instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'expires_in': instance.expiresIn,
      'token_type': instance.tokenType,
      'scope': instance.scope,
      'refresh_token': instance.refreshToken,
      'user': instance.user.toJson(),
    };
