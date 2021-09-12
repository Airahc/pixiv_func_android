// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ugoira_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UgoiraMetadata _$UgoiraMetadataFromJson(Map<String, dynamic> json) =>
    UgoiraMetadata(
      UgoiraMetadataContent.fromJson(
          json['ugoira_metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UgoiraMetadataToJson(UgoiraMetadata instance) =>
    <String, dynamic>{
      'ugoira_metadata': instance.ugoiraMetadata.toJson(),
    };

UgoiraMetadataContent _$UgoiraMetadataContentFromJson(
        Map<String, dynamic> json) =>
    UgoiraMetadataContent(
      ZipUrls.fromJson(json['zip_urls'] as Map<String, dynamic>),
      (json['frames'] as List<dynamic>)
          .map((e) => Frame.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UgoiraMetadataContentToJson(
        UgoiraMetadataContent instance) =>
    <String, dynamic>{
      'zip_urls': instance.zipUrls.toJson(),
      'frames': instance.frames.map((e) => e.toJson()).toList(),
    };

ZipUrls _$ZipUrlsFromJson(Map<String, dynamic> json) => ZipUrls(
      json['medium'] as String,
    );

Map<String, dynamic> _$ZipUrlsToJson(ZipUrls instance) => <String, dynamic>{
      'medium': instance.medium,
    };

Frame _$FrameFromJson(Map<String, dynamic> json) => Frame(
      json['file'] as String,
      json['delay'] as int,
    );

Map<String, dynamic> _$FrameToJson(Frame instance) => <String, dynamic>{
      'file': instance.file,
      'delay': instance.delay,
    };
