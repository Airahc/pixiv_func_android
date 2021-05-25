// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommender.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recommender _$RecommenderFromJson(Map<String, dynamic> json) {
  return Recommender(
    json['error'] as bool,
    json['message'] as String,
    json['body'] == null
        ? null
        : RecommenderBody.fromJson(json['body'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RecommenderToJson(Recommender instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'body': instance.body?.toJson(),
    };
