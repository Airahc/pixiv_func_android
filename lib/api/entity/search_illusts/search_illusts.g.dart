// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_illusts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchIllusts _$SearchFromJson(Map<String, dynamic> json) {
  return SearchIllusts(
    json['error'] as bool,
    json['message'] as String,
    json['body'] is!Map
        ? null
        : SearchBody.fromJson(json['body'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SearchToJson(SearchIllusts instance) => <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'body': instance.body?.toJson(),
    };
