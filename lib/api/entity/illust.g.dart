// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'illust.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Illust _$IllustFromJson(Map<String, dynamic> json) => Illust(
      json['id'] as int,
      json['title'] as String,
      json['type'] as String,
      ImageUrls.fromJson(json['image_urls'] as Map<String, dynamic>),
      json['caption'] as String,
      json['restrict'] as int,
      User.fromJson(json['user'] as Map<String, dynamic>),
      (json['tags'] as List<dynamic>).map((e) => Tag.fromJson(e as Map<String, dynamic>)).toList(),
      (json['tools'] as List<dynamic>).map((e) => e as String).toList(),
      json['create_date'] as String,
      json['page_count'] as int,
      json['width'] as int,
      json['height'] as int,
      json['sanity_level'] as int,
      json['x_restrict'] as int,
      MetaSinglePage.fromJson(json['meta_single_page'] as Map<String, dynamic>),
      (json['meta_pages'] as List<dynamic>).map((e) => MetaPage.fromJson(e as Map<String, dynamic>)).toList(),
      json['total_view'] as int,
      json['total_bookmarks'] as int,
      json['is_bookmarked'] as bool,
      json['visible'] as bool,
      json['is_muted'] as bool,
      json['total_comments'] as int?,
    );

Map<String, dynamic> _$IllustToJson(Illust instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'image_urls': instance.imageUrls.toJson(),
      'caption': instance.caption,
      'restrict': instance.restrict,
      'user': instance.user.toJson(),
      'tags': instance.tags.map((e) => e.toJson()).toList(),
      'tools': instance.tools,
      'create_date': instance.createDate,
      'page_count': instance.pageCount,
      'width': instance.width,
      'height': instance.height,
      'sanity_level': instance.sanityLevel,
      'x_restrict': instance.xRestrict,
      'meta_single_page': instance.metaSinglePage.toJson(),
      'meta_pages': instance.metaPages.map((e) => e.toJson()).toList(),
      'total_view': instance.totalView,
      'total_bookmarks': instance.totalBookmarks,
      'is_bookmarked': instance.isBookmarked,
      'visible': instance.visible,
      'is_muted': instance.isMuted,
      'total_comments': instance.totalComments,
    };
