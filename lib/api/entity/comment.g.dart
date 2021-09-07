// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      json['id'] as int,
      json['comment'] as String,
      json['date'] as String,
      User.fromJson(json['user'] as Map<String, dynamic>),
      json['has_replies'] as bool,
      json['stamp'] == null
          ? null
          : Stamp.fromJson(json['stamp'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'comment': instance.comment,
      'date': instance.date,
      'user': instance.user.toJson(),
      'has_replies': instance.hasReplies,
      'stamp': instance.stamp?.toJson(),
    };
