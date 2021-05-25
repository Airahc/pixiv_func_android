// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'illust_many.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IllustMany _$IllustManyFromJson(Map<String, dynamic> json) {
  return IllustMany(
    json['error'] as bool,
    json['message'] as String,
    json['body'] is! Map
        ? null
        : IllustManyBody.fromJson(json['body'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$IllustManyToJson(IllustMany instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'body': instance.body?.toJson(),
    };
