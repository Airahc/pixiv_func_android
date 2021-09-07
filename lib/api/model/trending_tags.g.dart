// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trending_tags.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrendingTags _$TrendingTagsFromJson(Map<String, dynamic> json) => TrendingTags(
      (json['trend_tags'] as List<dynamic>)
          .map((e) => TrendTag.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TrendingTagsToJson(TrendingTags instance) =>
    <String, dynamic>{
      'trend_tags': instance.trendTags.map((e) => e.toJson()).toList(),
    };

TrendTag _$TrendTagFromJson(Map<String, dynamic> json) => TrendTag(
      json['tag'] as String,
      json['translated_name'] as String?,
      Illust.fromJson(json['illust'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TrendTagToJson(TrendTag instance) => <String, dynamic>{
      'tag': instance.tag,
      'translated_name': instance.translatedName,
      'illust': instance.illust.toJson(),
    };
