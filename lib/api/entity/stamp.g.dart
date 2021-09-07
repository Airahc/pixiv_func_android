// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stamp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stamp _$StampFromJson(Map<String, dynamic> json) => Stamp(
      json['stamp_id'] as int,
      json['stamp_url'] as String,
    );

Map<String, dynamic> _$StampToJson(Stamp instance) => <String, dynamic>{
      'stamp_id': instance.stampId,
      'stamp_url': instance.stampUrl,
    };
