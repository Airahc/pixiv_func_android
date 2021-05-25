// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_delete.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookmarkDelete _$BookmarkDeleteFromJson(Map<String, dynamic> json) {
  return BookmarkDelete(
    json['error'] != null ? json['error'] as bool : false,
    json['message'] != null ? json['message'] as String : '',
    json['isSucceed'] != null ? json['isSucceed'] as bool : false,
  );
}

Map<String, dynamic> _$BookmarkDeleteToJson(BookmarkDelete instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'isSuccess': instance.isSucceed,
    };
