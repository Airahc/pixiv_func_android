// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_users_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchUsersBody _$SearchUsersBodyFromJson(Map<String, dynamic> json) {
  return SearchUsersBody(
    (json['users'] as List<dynamic>)
        .map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['total'] as int,
    json['lastPage'] as int,
  );
}

Map<String, dynamic> _$SearchUsersBodyToJson(SearchUsersBody instance) =>
    <String, dynamic>{
      'users': instance.users.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'lastPage': instance.lastPage,
    };
