// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Novel _$NovelFromJson(Map<String, dynamic> json) => Novel(
      json['id'] as int,
      json['title'] as String,
      json['caption'] as String,
      json['restrict'] as int,
      json['x_restrict'] as int,
      json['is_original'] as bool,
      ImageUrls.fromJson(json['image_urls'] as Map<String, dynamic>),
      json['create_date'] as String,
      (json['tags'] as List<dynamic>)
          .map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['page_count'] as int,
      json['text_length'] as int,
      User.fromJson(json['user'] as Map<String, dynamic>),
      Series.fromJson(json['series'] as Map<String, dynamic>),
      json['total_bookmarks'] as int,
      json['is_bookmarked'] as bool,
      json['total_view'] as int,
      json['visible'] as bool,
      json['total_comments'] as int,
      json['is_muted'] as bool,
      json['is_mypixiv_only'] as bool,
      json['is_x_restricted'] as bool,
    );

Map<String, dynamic> _$NovelToJson(Novel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'caption': instance.caption,
      'restrict': instance.restrict,
      'x_restrict': instance.xRestrict,
      'is_original': instance.isOriginal,
      'image_urls': instance.imageUrls.toJson(),
      'create_date': instance.createDate,
      'tags': instance.tags.map((e) => e.toJson()).toList(),
      'page_count': instance.pageCount,
      'text_length': instance.textLength,
      'user': instance.user.toJson(),
      'series': instance.series.toJson(),
      'total_bookmarks': instance.totalBookmarks,
      'is_bookmarked': instance.isBookmarked,
      'total_view': instance.totalView,
      'visible': instance.visible,
      'total_comments': instance.totalComments,
      'is_muted': instance.isMuted,
      'is_mypixiv_only': instance.isMyPixivOnly,
      'is_x_restricted': instance.isXRestricted,
    };

Series _$SeriesFromJson(Map<String, dynamic> json) => Series(
      json['id'] as int?,
      json['title'] as String?,
    );

Map<String, dynamic> _$SeriesToJson(Series instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
    };
