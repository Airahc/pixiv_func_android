// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchUsers _$SearchUsersFromJson(Map<String, dynamic> json) {
  return SearchUsers(
    json['error'] as bool,
    json['message'] as String,
    json['body'] is! Map
        ? null
        : SearchUsersBody.fromJson(json['body'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SearchUsersToJson(SearchUsers instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'body': instance.body?.toJson(),
    };
