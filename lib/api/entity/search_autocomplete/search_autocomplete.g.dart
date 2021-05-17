// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_autocomplete.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchAutocomplete _$SearchAutocompleteFromJson(Map<String, dynamic> json) {
  return SearchAutocomplete(
    json['error'] as bool,
    json['message'] as String,
    json['body'] == null
        ? null
        : SearchAutocompleteBody.fromJson(json['body'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SearchAutocompleteToJson(SearchAutocomplete instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'body': instance.body?.toJson(),
    };
