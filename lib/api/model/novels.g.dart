// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novels.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Novels _$NovelsFromJson(Map<String, dynamic> json) => Novels(
      (json['novels'] as List<dynamic>)
          .map((e) => Novel.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['nextUrl'] as String?,
    );

Map<String, dynamic> _$NovelsToJson(Novels instance) => <String, dynamic>{
      'novels': instance.novels.map((e) => e.toJson()).toList(),
      'nextUrl': instance.nextUrl,
    };
