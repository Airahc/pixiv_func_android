// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_tags.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookmarkTags _$BookmarkTagsFromJson(Map<String, dynamic> json) => BookmarkTags(
      (json['bookmark_tags'] as List<dynamic>)
          .map((e) => BookmarkTag.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['next_url'] as String?,
    );

Map<String, dynamic> _$BookmarkTagsToJson(BookmarkTags instance) =>
    <String, dynamic>{
      'bookmark_tags': instance.bookmarkTags.map((e) => e.toJson()).toList(),
      'next_url': instance.nextUrl,
    };
