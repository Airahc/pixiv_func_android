// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Users _$UsersFromJson(Map<String, dynamic> json) => Users(
      (json['user_previews'] as List<dynamic>)
          .map((e) => UserPreview.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['next_url'] as String?,
    );

Map<String, dynamic> _$UsersToJson(Users instance) => <String, dynamic>{
      'user_previews': instance.userPreviews.map((e) => e.toJson()).toList(),
      'next_url': instance.nextUrl,
    };
