// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'illust_many_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IllustManyBody _$IllustManyBodyFromJson(Map<String, dynamic> json) {
  return IllustManyBody(
    (json['illust_details'] as List<dynamic>)
        .map((e) => Illust.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$IllustManyBodyToJson(IllustManyBody instance) =>
    <String, dynamic>{
      'related': instance.illustDetails,
    };
