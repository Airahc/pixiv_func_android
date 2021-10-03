// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_js_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NovelJSData _$NovelJSDataFromJson(Map<String, dynamic> json) => NovelJSData(
      json['id'] as String,
      json['seriesId'] as String?,
      json['userId'] as String,
      json['coverUrl'] as String,
      json['seriesNavigation'] == null
          ? null
          : SeriesNavigation.fromJson(
              json['seriesNavigation'] as Map<String, dynamic>),
      json['text'] as String,
    );

Map<String, dynamic> _$NovelJSDataToJson(NovelJSData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seriesId': instance.seriesId,
      'userId': instance.userId,
      'coverUrl': instance.coverUrl,
      'text': instance.text,
      'seriesNavigation': instance.seriesNavigation?.toJson(),
    };

SeriesNavigation _$SeriesNavigationFromJson(Map<String, dynamic> json) =>
    SeriesNavigation(
      json['nextNovel'] == null
          ? null
          : TurnPageNovel.fromJson(json['nextNovel'] as Map<String, dynamic>),
      json['prevNovel'] == null
          ? null
          : TurnPageNovel.fromJson(json['prevNovel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SeriesNavigationToJson(SeriesNavigation instance) =>
    <String, dynamic>{
      'nextNovel': instance.nextNovel?.toJson(),
      'prevNovel': instance.prevNovel?.toJson(),
    };

TurnPageNovel _$TurnPageNovelFromJson(Map<String, dynamic> json) =>
    TurnPageNovel(
      json['id'] as int,
      json['viewable'] as bool,
      json['contentOrder'] as String,
      json['title'] as String,
      json['coverUrl'] as String,
    );

Map<String, dynamic> _$TurnPageNovelToJson(TurnPageNovel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'viewable': instance.viewable,
      'contentOrder': instance.contentOrder,
      'title': instance.title,
      'coverUrl': instance.coverUrl,
    };
