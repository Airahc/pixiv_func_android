// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_urls.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageUrls _$ImageUrlsFromJson(Map<String, dynamic> json) => ImageUrls(
      json['square_medium'] as String,
      json['medium'] as String,
      json['large'] as String,
      json['original'] as String?,
    );

Map<String, dynamic> _$ImageUrlsToJson(ImageUrls instance) => <String, dynamic>{
      'square_medium': instance.squareMedium,
      'medium': instance.medium,
      'large': instance.large,
      'original': instance.original,
    };
