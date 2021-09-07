// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stamps.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stamps _$StampsFromJson(Map<String, dynamic> json) => Stamps(
      (json['stamps'] as List<dynamic>)
          .map((e) => Stamp.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StampsToJson(Stamps instance) => <String, dynamic>{
      'stamps': instance.stamps.map((e) => e.toJson()).toList(),
    };
