// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'candidate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Candidate _$CandidateFromJson(Map<String, dynamic> json) {
  return Candidate(
    json['tag_name'] as String,
    json['access_count'] as String,
    json['type'] as String,
  );
}

Map<String, dynamic> _$CandidateToJson(Candidate instance) => <String, dynamic>{
      'tag_name': instance.tagName,
      'access_count': instance.accessCount,
      'type': instance.type,
    };
