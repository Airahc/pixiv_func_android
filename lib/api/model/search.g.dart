// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Search _$SearchFromJson(Map<String, dynamic> json) => Search(
      (json['illusts'] as List<dynamic>)
          .map((e) => Illust.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['next_url'] as String?,
      json['search_span_limit'] as int,
    );

Map<String, dynamic> _$SearchToJson(Search instance) => <String, dynamic>{
      'illusts': instance.illusts.map((e) => e.toJson()).toList(),
      'next_url': instance.nextUrl,
      'search_span_limit': instance.searchSpanLimit,
    };
