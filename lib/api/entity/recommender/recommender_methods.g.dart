// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommender_methods.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommenderMethod _$RecommenderMethodFromJson(Map<String, dynamic> json) {
  return RecommenderMethod(
    (json['methods'] as List<dynamic>).map((e) => e as String).toList(),
    (json['score'] as num).toDouble(),
    (json['seed_illust_ids'] as List<dynamic>).map((e) => int.parse(e as String)).toList(),
  );
}

Map<String, dynamic> _$RecommenderMethodToJson(RecommenderMethod instance) =>
    <String, dynamic>{
      'methods': instance.methods,
      'score': instance.score,
      'seed_illust_ids': instance.seedIllustIds,
    };
