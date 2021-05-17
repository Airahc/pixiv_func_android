// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_works.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserWorks _$UserWorksFromJson(Map<String, dynamic> json) {
  return UserWorks(
    json['error'] as bool,
    json['message'] as String,
    json['body'] is Map
        ? UserWorksBody.fromJson(json['body'] as Map<String, dynamic>)
        : null,
  );
}

Map<String, dynamic> _$UserWorksToJson(UserWorks instance) => <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'body': instance.body?.toJson(),
    };
