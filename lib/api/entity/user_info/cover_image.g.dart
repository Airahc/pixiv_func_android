// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cover_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoverImage _$CoverImageFromJson(Map<String, dynamic> json) {
  return CoverImage(
    json['profile_cover_ext'] as String,
    Map<String, String>.from(json['profile_cover_image'] as Map),
  );
}

Map<String, dynamic> _$CoverImageToJson(CoverImage instance) =>
    <String, dynamic>{
      'profile_cover_ext': instance.profileCoverExt,
      'profile_cover_image': instance.profileCoverImage,
    };
