// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookmarkDetail _$BookmarkDetailFromJson(Map<String, dynamic> json) =>
    BookmarkDetail(
      json['is_bookmarked'] as bool,
      (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      json['restrict'] as String,
    );

Map<String, dynamic> _$BookmarkDetailToJson(BookmarkDetail instance) =>
    <String, dynamic>{
      'is_bookmarked': instance.isBookmarked,
      'tags': instance.tags,
      'restrict': instance.restrict,
    };
