// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPreview _$UserPreviewFromJson(Map<String, dynamic> json) => UserPreview(
      User.fromJson(json['user'] as Map<String, dynamic>),
      (json['illusts'] as List<dynamic>)
          .map((e) => Illust.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['is_muted'] as bool,
    );

Map<String, dynamic> _$UserPreviewToJson(UserPreview instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'illusts': instance.illusts.map((e) => e.toJson()).toList(),
      'is_muted': instance.isMuted,
    };
