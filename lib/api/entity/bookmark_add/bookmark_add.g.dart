// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_add.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookmarkAdd _$BookmarkAddFromJson(Map<String, dynamic> json) {
  return BookmarkAdd(
    json['error'] != null ? json['error'] as bool : false,
    json['message'] != null ? json['message'] as String : '',
    json['isSucceed'] != null ? json['isSucceed'] as bool : false,
    json['lastBookmarkId'] != null
        ? int.parse(json['lastBookmarkId'] as String)
        : null,
    json['restrict'] != null ? json['restrict'] as int : 0,
  );
}

Map<String, dynamic> _$BookmarkAddToJson(BookmarkAdd instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'isSucceed': instance.isSucceed,
      'lastBookmarkId': instance.lastBookmarkId,
      'restrict': instance.restrict,
    };
