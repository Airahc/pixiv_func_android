// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaPage _$MetaPageFromJson(Map<String, dynamic> json) => MetaPage(
      ImageUrls.fromJson(json['image_urls'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MetaPageToJson(MetaPage instance) => <String, dynamic>{
      'image_urls': instance.imageUrls.toJson(),
    };
