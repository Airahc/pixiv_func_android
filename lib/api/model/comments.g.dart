// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comments _$CommentsFromJson(Map<String, dynamic> json) => Comments(
      (json['comments'] as List<dynamic>)
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['next_url'] as String?,
    );

Map<String, dynamic> _$CommentsToJson(Comments instance) => <String, dynamic>{
      'comments': instance.comments.map((e) => e.toJson()).toList(),
      'next_url': instance.nextUrl,
    };
