// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'illusts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Illusts _$IllustsFromJson(Map<String, dynamic> json) => Illusts(
      (json['illusts'] as List<dynamic>)
          .map((e) => Illust.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['next_url'] as String?,
    );

Map<String, dynamic> _$IllustsToJson(Illusts instance) => <String, dynamic>{
      'illusts': instance.illusts.map((e) => e.toJson()).toList(),
      'next_url': instance.nextUrl,
    };
