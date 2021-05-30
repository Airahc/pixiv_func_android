// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommender_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommenderBody _$RecommenderBodyFromJson(Map<String, dynamic> json) {
  return RecommenderBody(
    (json['recommended_work_ids'] as List<dynamic>)
        .map(
          (e) => e is int
              ? e
              : e is String
                  ? int.parse(e)
                  : 0,
        )
        .toList(),
    json['methods'] is Map
        ? (json['methods'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(int.parse(k),
                RecommenderMethod.fromJson(e as Map<String, dynamic>)),
          )
        : {},
  );
}

Map<String, dynamic> _$RecommenderBodyToJson(RecommenderBody instance) =>
    <String, dynamic>{
      'recommended_work_ids': instance.recommendedWorkIds,
      'methods':
          instance.methods.map((k, e) => MapEntry(k.toString(), e.toJson())),
    };
