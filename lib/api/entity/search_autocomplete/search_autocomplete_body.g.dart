// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_autocomplete_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchAutocompleteBody _$SearchAutocompleteBodyFromJson(
    Map<String, dynamic> json) {
  return SearchAutocompleteBody(
    (json['candidates'] as List<dynamic>)
        .map((e) => Candidate.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SearchAutocompleteBodyToJson(
        SearchAutocompleteBody instance) =>
    <String, dynamic>{
      'candidates': instance.candidates.map((e) => e.toJson()).toList(),
    };
