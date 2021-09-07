// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['id'] as int,
      json['name'] as String,
      json['account'] as String,
      ProfileImageUrls.fromJson(
          json['profile_image_urls'] as Map<String, dynamic>),
      json['is_followed'] as bool?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'account': instance.account,
      'profile_image_urls': instance.profileImageUrls.toJson(),
      'is_followed': instance.isFollowed,
    };
