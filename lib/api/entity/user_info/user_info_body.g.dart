// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoBody _$UserInfoBodyFromJson(Map<String, dynamic> json) {
  return UserInfoBody(
    UserDetails.fromJson(json['user_details'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserInfoBodyToJson(UserInfoBody instance) => <String, dynamic>{
      'user_details': instance.userDetails.toJson(),
    };
